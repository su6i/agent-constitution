# Agent Constitution MCP Server

Exposes all 343 skills, workflows, and rules as callable tools to any MCP-compatible AI assistant.

Two server modes — same knowledge base, different transports:

| File | Transport | Use with |
| --- | --- | --- |
| `server.py` | stdio | Claude Code CLI |
| `server_http.py` | HTTP + SSE | Cursor, VS Code, Antigravity IDE, Gemini CLI |

---

## Quick Start

### 1. Start the HTTP server (one-time setup)

```bash
# Install as a macOS background service (auto-starts on login)
cp bin/mcp-server/com.agent-constitution.mcp.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.agent-constitution.mcp.plist

# Verify
curl http://localhost:8765/health
# → {"status": "ok", "skills": 343}
```

### 2. Connect your IDE (see below)

---

## IDE Setup

### Claude Code CLI

No setup needed — stdio is configured automatically via `.claude/settings.json`.

```bash
claude  # skills available immediately
```

---

### Cursor

Edit `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "agent-constitution": {
      "url": "http://localhost:8765/sse"
    }
  }
}
```

Restart Cursor → check **Settings → MCP** for a green status indicator.

---

### VS Code (via Continue.dev)

1. Install the [Continue](https://marketplace.visualstudio.com/items?itemName=Continue.continue) extension
2. Open `~/.continue/config.json` and add:

```json
{
  "mcpServers": [
    {
      "name": "agent-constitution",
      "transport": {
        "type": "sse",
        "url": "http://localhost:8765/sse"
      }
    }
  ]
}
```

1. Reload VS Code — skills appear in the Continue chat panel.

---

### Antigravity IDE (via Continue.dev)

Antigravity IDE is a VS Code fork — the setup is identical to VS Code.

1. Open Antigravity IDE → Extensions (`Cmd+Shift+X`)
2. Search for **Continue** → Install
3. Edit `~/.continue/config.json` (same file as VS Code — shared config):

```json
{
  "mcpServers": [
    {
      "name": "agent-constitution",
      "transport": {
        "type": "sse",
        "url": "http://localhost:8765/sse"
      }
    }
  ]
}
```

1. Reload Antigravity IDE → use Continue chat panel (`Cmd+L`).

---

### JetBrains IDEs (IntelliJ, PyCharm, GoLand, …)

1. Install the [Continue](https://plugins.jetbrains.com/plugin/22707-continue) plugin
2. Same `~/.continue/config.json` config as above
3. Restart IDE → Continue panel in the right sidebar.

---

### Gemini CLI

```bash
# One-time: add to ~/.gemini/settings.json
```

```json
{
  "mcpServers": {
    "agent-constitution": {
      "httpUrl": "http://localhost:8765/mcp"
    }
  }
}
```

Then in any Gemini CLI session:

```bash
gemini  # agent-constitution tools are available automatically
```

---

### Claude Desktop chat

> **Note:** Claude Desktop v2.1.x chat interface does not support local HTTP MCP servers.
> Use Claude Code CLI (stdio) instead — it has full MCP support.

---

## Available Tools

| Tool | Description |
| --- | --- |
| `list_skills` | List all 343 skill names (call this first to discover) |
| `get_skill` | Read a skill by name — e.g. `fastapi-best-practices` |
| `get_rules` | Get the global repository rules |
| `run_<workflow>` | Execute a workflow (init_project, documentation, quality_assurance, …) |

## Endpoints

| Endpoint | Transport | Purpose |
| --- | --- | --- |
| `GET /sse` | SSE | Cursor, VS Code/Antigravity (Continue), JetBrains |
| `POST /mcp` | Streamable HTTP | Gemini CLI, custom clients |
| `POST /message?sessionId=<id>` | SSE | SSE response channel |
| `GET /health` | HTTP | Status check |

---

## Manage the background service

```bash
# Stop
launchctl unload ~/Library/LaunchAgents/com.agent-constitution.mcp.plist

# Start
launchctl load ~/Library/LaunchAgents/com.agent-constitution.mcp.plist

# Live logs
tail -f /tmp/agent-constitution-mcp.log

# Restart
launchctl unload ~/Library/LaunchAgents/com.agent-constitution.mcp.plist && \
launchctl load ~/Library/LaunchAgents/com.agent-constitution.mcp.plist
```

---

## Protocol

Supports MCP `2025-11-25` and `2024-11-05` — version is negotiated at handshake.
No external dependencies — stdlib only (Python 3.10+).
