# Agent Constitution MCP Server

A local MCP (Model Context Protocol) server that exposes the Agent Constitution's knowledge base to AI assistants.

## Features

- **Skills as Tools:** All 343 technical skills accessible via `list_skills` and `get_skill` tools — Claude calls them proactively.
- **Workflows as Tools:** Execute workflows directly from your AI assistant.
- **Rules as Context:** Access global rules for system prompt injection.

## Installation

### Prerequisites
- Python 3.10+  — no external dependencies (stdlib only)

### stdio (Claude Code CLI)
```bash
chmod +x server.py
# Claude Code picks this up automatically via .claude/settings.json
```

### HTTP (Claude Desktop chat / Cursor / Gemini)
```bash
# Install as a background service (auto-starts on login)
cp com.agent-constitution.mcp.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.agent-constitution.mcp.plist

# Verify
curl http://localhost:8765/health
```

Then add to `~/Library/Application Support/Claude/claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "agent-constitution-http": {
      "url": "http://localhost:8765/sse"
    }
  }
}
```

## Connection

### Claude Desktop
Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "agent-constitution": {
      "command": "python3",
      "args": ["/path/to/agent-constitution/bin/mcp-server/server.py"]
    }
  }
}
```

### Cursor IDE
Add to your Cursor MCP configuration:

```json
{
  "servers": {
    "agent-constitution": {
      "command": "python3",
      "args": ["./bin/mcp-server/server.py"],
      "cwd": "/path/to/agent-constitution"
    }
  }
}
```

## Available Resources

### Skills (77 total)
Access any skill with URI: `skill://<skill-name>`

Example: `skill://python-core-standards`

### Tools

| Tool Name | Description |
| :--- | :--- |
| `list_skills` | List all 343 available skills by name |
| `get_skill` | Read full content of a skill (`name` parameter required) |
| `get_rules` | Get global repository rules |
| `run_init_project` | Execute project initialization workflow |
| `run_documentation` | Execute documentation workflow |
| `run_quality_assurance` | Execute QA workflow |
| `run_social_media_showcase` | Execute marketing workflow |

## Protocol Details

This server supports MCP `2025-11-25` and `2024-11-05` (version negotiated at handshake) with:
- `tools/list` - List all tools (skills + workflows + rules)
- `tools/call` - Call a tool
- `resources/list` - Returns empty list (skills are tools now)
- `prompts/list` - Returns empty list

## Troubleshooting

### Server not responding
Check stderr output for errors:
```bash
python3 server.py 2>&1 | head -20
```

### Resource not found
Ensure the skill name matches exactly (use kebab-case).
