#!/usr/bin/env python3
"""
Agent Constitution MCP Server

A local MCP (Model Context Protocol) server that exposes:
- Skills as resources
- Workflows as tools
- Rules as system context

Usage:
    python server.py

Connect to this server in Claude Desktop or Cursor by adding to your MCP config.
"""

import json
import os
import sys
from pathlib import Path
from typing import Any

# MCP Protocol Constants
JSONRPC_VERSION = "2.0"

# Resolve paths
SCRIPT_DIR = Path(__file__).parent.resolve()
REPO_ROOT = SCRIPT_DIR.parent.parent
SKILLS_DIR = REPO_ROOT / ".cursor" / "skills"
WORKFLOWS_DIR = REPO_ROOT / ".cursor" / "workflows"
RULES_DIR = REPO_ROOT / ".cursor" / "rules"


def read_file(path: Path) -> str:
    """Read file content with error handling."""
    try:
        return path.read_text(encoding="utf-8")
    except Exception as e:
        return f"Error reading file: {e}"


def list_skills() -> list[dict[str, str]]:
    """List all available skills."""
    skills = []
    if SKILLS_DIR.exists():
        for skill_file in sorted(SKILLS_DIR.glob("*.md")):
            skills.append({
                "name": skill_file.stem,
                "uri": f"skill://{skill_file.stem}",
                "description": f"Technical skill: {skill_file.stem.replace('-', ' ').title()}"
            })
    return skills


def list_workflows() -> list[dict[str, str]]:
    """List all available workflows."""
    workflows = []
    if WORKFLOWS_DIR.exists():
        for wf_file in sorted(WORKFLOWS_DIR.glob("*.md")):
            workflows.append({
                "name": wf_file.stem,
                "description": f"Workflow: {wf_file.stem.replace('-', ' ').title()}"
            })
    return workflows


def get_skill_content(skill_name: str) -> str:
    """Get content of a specific skill."""
    skill_path = SKILLS_DIR / f"{skill_name}.md"
    if skill_path.exists():
        return read_file(skill_path)
    return f"Skill '{skill_name}' not found."


def get_workflow_content(workflow_name: str) -> str:
    """Get content of a specific workflow."""
    wf_path = WORKFLOWS_DIR / f"{workflow_name}.md"
    if wf_path.exists():
        return read_file(wf_path)
    return f"Workflow '{workflow_name}' not found."


def get_rules_content() -> str:
    """Get the global rules content."""
    rules_file = RULES_DIR / "global.mdc.md"
    if rules_file.exists():
        return read_file(rules_file)
    return "Global rules not found."


def handle_request(request: dict[str, Any]) -> dict[str, Any]:
    """Handle incoming MCP requests."""
    method = request.get("method", "")
    params = request.get("params", {})
    request_id = request.get("id")
    
    result = None
    error = None
    
    # Initialize
    if method == "initialize":
        result = {
            "protocolVersion": "2024-11-05",
            "capabilities": {
                "resources": {"subscribe": False, "listChanged": False},
                "tools": {},
                "prompts": {}
            },
            "serverInfo": {
                "name": "agent-constitution",
                "version": "1.0.0"
            }
        }
    
    # List resources (skills)
    elif method == "resources/list":
        skills = list_skills()
        result = {
            "resources": [
                {
                    "uri": s["uri"],
                    "name": s["name"],
                    "description": s["description"],
                    "mimeType": "text/markdown"
                }
                for s in skills
            ]
        }
    
    # Read resource
    elif method == "resources/read":
        uri = params.get("uri", "")
        if uri.startswith("skill://"):
            skill_name = uri.replace("skill://", "")
            content = get_skill_content(skill_name)
            result = {
                "contents": [{
                    "uri": uri,
                    "mimeType": "text/markdown",
                    "text": content
                }]
            }
        else:
            error = {"code": -32602, "message": f"Unknown resource URI: {uri}"}
    
    # List tools (workflows)
    elif method == "tools/list":
        workflows = list_workflows()
        result = {
            "tools": [
                {
                    "name": f"run_{wf['name'].replace('-', '_')}",
                    "description": f"Execute the {wf['description']}",
                    "inputSchema": {
                        "type": "object",
                        "properties": {},
                        "required": []
                    }
                }
                for wf in workflows
            ] + [{
                "name": "get_rules",
                "description": "Get the global rules for this repository",
                "inputSchema": {"type": "object", "properties": {}, "required": []}
            }]
        }
    
    # Call tool
    elif method == "tools/call":
        tool_name = params.get("name", "")
        if tool_name == "get_rules":
            result = {"content": [{"type": "text", "text": get_rules_content()}]}
        elif tool_name.startswith("run_"):
            wf_name = tool_name[4:].replace("_", "-")
            content = get_workflow_content(wf_name)
            result = {"content": [{"type": "text", "text": content}]}
        else:
            error = {"code": -32601, "message": f"Unknown tool: {tool_name}"}
    
    # Unknown method
    else:
        error = {"code": -32601, "message": f"Unknown method: {method}"}
    
    response = {"jsonrpc": JSONRPC_VERSION, "id": request_id}
    if error:
        response["error"] = error
    else:
        response["result"] = result
    
    return response


def main():
    """Main server loop using stdio."""
    sys.stderr.write("Agent Constitution MCP Server started.\n")
    sys.stderr.flush()
    
    while True:
        try:
            line = sys.stdin.readline()
            if not line:
                break
            
            request = json.loads(line)
            response = handle_request(request)
            
            response_str = json.dumps(response) + "\n"
            sys.stdout.write(response_str)
            sys.stdout.flush()
            
        except json.JSONDecodeError as e:
            sys.stderr.write(f"JSON decode error: {e}\n")
            sys.stderr.flush()
        except Exception as e:
            sys.stderr.write(f"Error: {e}\n")
            sys.stderr.flush()


if __name__ == "__main__":
    main()
