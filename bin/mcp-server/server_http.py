#!/usr/bin/env python3
"""
Agent Constitution MCP HTTP Server
Supports:
  - SSE transport:          GET  /sse  +  POST /message?sessionId=<id>
  - Streamable HTTP:        POST /mcp
Run: python3 server_http.py [--port 8765]
"""

import json
import sys
import uuid
import threading
import queue
import argparse
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
from pathlib import Path
from typing import Any

PORT = 8765

SCRIPT_DIR = Path(__file__).parent.resolve()
REPO_ROOT = SCRIPT_DIR.parent.parent
SKILLS_DIR = REPO_ROOT / ".agent" / "skills"
WORKFLOWS_DIR = REPO_ROOT / ".agent" / "workflows"
RULES_DIR = REPO_ROOT / ".agent" / "rules"

JSONRPC_VERSION = "2.0"

# ── shared MCP helpers ────────────────────────────────────────────────────────

def read_file(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except Exception as e:
        return f"Error reading file: {e}"

def list_skills() -> list[dict[str, str]]:
    if not SKILLS_DIR.exists():
        return []
    return [
        {"name": f.stem, "uri": f"skill://{f.stem}"}
        for f in sorted(SKILLS_DIR.glob("*.md"))
    ]

def get_skill_content(name: str) -> str:
    path = SKILLS_DIR / f"{name}.md"
    return read_file(path) if path.exists() else f"Skill '{name}' not found."

def list_workflows() -> list[dict[str, str]]:
    if not WORKFLOWS_DIR.exists():
        return []
    return [{"name": f.stem} for f in sorted(WORKFLOWS_DIR.glob("*.md"))]

def get_workflow_content(name: str) -> str:
    path = WORKFLOWS_DIR / f"{name}.md"
    return read_file(path) if path.exists() else f"Workflow '{name}' not found."

def get_rules_content() -> str:
    path = RULES_DIR / "global.mdc.md"
    return read_file(path) if path.exists() else "Global rules not found."

def handle_request(request: dict[str, Any]) -> dict[str, Any] | None:
    method = request.get("method", "")
    params = request.get("params", {})
    request_id = request.get("id")

    if request_id is None:
        return None  # notification — no response

    result = error = None

    if method == "initialize":
        client_version = params.get("protocolVersion", "2024-11-05")
        supported = ["2025-11-25", "2024-11-05"]
        proto = client_version if client_version in supported else "2024-11-05"
        result = {
            "protocolVersion": proto,
            "capabilities": {"resources": {"subscribe": False, "listChanged": False}, "tools": {}, "prompts": {}},
            "serverInfo": {"name": "agent-constitution", "version": "1.0.0"},
        }

    elif method == "resources/list":
        result = {"resources": []}

    elif method == "resources/read":
        uri = params.get("uri", "")
        if uri.startswith("skill://"):
            content = get_skill_content(uri.replace("skill://", ""))
            result = {"contents": [{"uri": uri, "mimeType": "text/markdown", "text": content}]}
        else:
            error = {"code": -32602, "message": f"Unknown resource URI: {uri}"}

    elif method == "tools/list":
        workflows = list_workflows()
        result = {
            "tools": [
                {
                    "name": f"run_{wf['name'].replace('-', '_')}",
                    "description": f"Execute workflow: {wf['name'].replace('-', ' ').title()}",
                    "inputSchema": {"type": "object", "properties": {}, "required": []},
                }
                for wf in workflows
            ] + [
                {
                    "name": "get_rules",
                    "description": "Get global repository rules",
                    "inputSchema": {"type": "object", "properties": {}, "required": []},
                },
                {
                    "name": "list_skills",
                    "description": "List all 343 available technical skills",
                    "inputSchema": {"type": "object", "properties": {}, "required": []},
                },
                {
                    "name": "get_skill",
                    "description": "Read a skill by name (e.g. 'fastapi-best-practices')",
                    "inputSchema": {
                        "type": "object",
                        "properties": {"name": {"type": "string"}},
                        "required": ["name"],
                    },
                },
            ]
        }

    elif method == "tools/call":
        tool = params.get("name", "")
        args = params.get("arguments", {})
        if tool == "get_rules":
            result = {"content": [{"type": "text", "text": get_rules_content()}]}
        elif tool == "list_skills":
            skills = list_skills()
            text = f"{len(skills)} skills available:\n" + "\n".join(f"- {s['name']}" for s in skills)
            result = {"content": [{"type": "text", "text": text}]}
        elif tool == "get_skill":
            result = {"content": [{"type": "text", "text": get_skill_content(args.get("name", ""))}]}
        elif tool.startswith("run_"):
            content = get_workflow_content(tool[4:].replace("_", "-"))
            result = {"content": [{"type": "text", "text": content}]}
        else:
            error = {"code": -32601, "message": f"Unknown tool: {tool}"}

    elif method == "prompts/list":
        result = {"prompts": []}

    else:
        error = {"code": -32601, "message": f"Unknown method: {method}"}

    resp = {"jsonrpc": JSONRPC_VERSION, "id": request_id}
    resp["error" if error else "result"] = error if error else result
    return resp


# ── session registry (SSE transport) ─────────────────────────────────────────

_sessions: dict[str, queue.Queue] = {}
_sessions_lock = threading.Lock()


# ── HTTP handler ──────────────────────────────────────────────────────────────

class MCPHandler(BaseHTTPRequestHandler):

    def do_OPTIONS(self):
        self._cors(200)
        self.end_headers()

    def do_GET(self):
        if self.path.startswith("/sse"):
            self._handle_sse()
        elif self.path == "/health":
            self._json(200, {"status": "ok", "skills": len(list_skills())})
        else:
            self.send_error(404)

    def do_POST(self):
        if self.path.startswith("/message"):
            self._handle_message()
        elif self.path == "/mcp":
            self._handle_streamable()
        else:
            self.send_error(404)

    # ── SSE transport ─────────────────────────────────────────────────────────

    def _handle_sse(self):
        sid = str(uuid.uuid4())
        q: queue.Queue = queue.Queue()
        with _sessions_lock:
            _sessions[sid] = q

        self._cors(200)
        self.send_header("Content-Type", "text/event-stream")
        self.send_header("Cache-Control", "no-cache")
        self.send_header("Connection", "keep-alive")
        self.end_headers()

        endpoint = f"http://localhost:{PORT}/message?sessionId={sid}"
        self._sse_write(f"event: endpoint\ndata: {json.dumps(endpoint)}\n\n")

        try:
            while True:
                try:
                    msg = q.get(timeout=25)
                    if msg is None:
                        break
                    self._sse_write(f"event: message\ndata: {json.dumps(msg)}\n\n")
                except queue.Empty:
                    self._sse_write(": keepalive\n\n")
        except (BrokenPipeError, ConnectionResetError):
            pass
        finally:
            with _sessions_lock:
                _sessions.pop(sid, None)

    def _handle_message(self):
        sid = parse_qs(urlparse(self.path).query).get("sessionId", [None])[0]
        with _sessions_lock:
            q = _sessions.get(sid)
        if not q:
            self.send_error(404, "Session not found")
            return

        body = self.rfile.read(int(self.headers.get("Content-Length", 0)))
        self._cors(202)
        self.end_headers()

        def process():
            try:
                resp = handle_request(json.loads(body))
                if resp is not None:
                    q.put(resp)
            except Exception as e:
                sys.stderr.write(f"[ERROR] {e}\n")

        threading.Thread(target=process, daemon=True).start()

    # ── Streamable HTTP transport ─────────────────────────────────────────────

    def _handle_streamable(self):
        body = self.rfile.read(int(self.headers.get("Content-Length", 0)))
        try:
            request = json.loads(body)
        except json.JSONDecodeError:
            self.send_error(400, "Invalid JSON")
            return

        resp = handle_request(request)
        if resp is None:
            self._cors(202)
            self.end_headers()
            return
        self._json(200, resp)

    # ── helpers ───────────────────────────────────────────────────────────────

    def _cors(self, code: int):
        self.send_response(code)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type, Accept")

    def _json(self, code: int, data: Any):
        body = json.dumps(data).encode()
        self._cors(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _sse_write(self, text: str):
        self.wfile.write(text.encode())
        self.wfile.flush()

    def log_message(self, fmt, *args):
        sys.stderr.write(f"[HTTP] {fmt % args}\n")


# ── entry point ───────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=PORT)
    args = parser.parse_args()

    server = HTTPServer(("localhost", args.port), MCPHandler)
    sys.stderr.write(
        f"Agent Constitution MCP HTTP Server\n"
        f"  SSE:              http://localhost:{args.port}/sse\n"
        f"  Streamable HTTP:  http://localhost:{args.port}/mcp\n"
        f"  Health:           http://localhost:{args.port}/health\n"
    )
    sys.stderr.flush()
    server.serve_forever()


if __name__ == "__main__":
    main()
