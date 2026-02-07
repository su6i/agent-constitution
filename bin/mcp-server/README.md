# Agent Constitution MCP Server

A local MCP (Model Context Protocol) server that exposes the Agent Constitution's knowledge base to AI assistants.

## Features

- **Skills as Resources:** All 58 technical skills are exposed as readable resources.
- **Workflows as Tools:** Execute workflows directly from your AI assistant.
- **Rules as Context:** Access global rules for system prompt injection.

## Installation

### Prerequisites
- Python 3.10+

### Setup
```bash
# No external dependencies required - uses only Python stdlib
chmod +x server.py
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

### Skills (58 total)
Access any skill with URI: `skill://<skill-name>`

Example: `skill://python-core-standards`

### Tools

| Tool Name | Description |
| :--- | :--- |
| `run_init_project` | Execute project initialization workflow |
| `run_documentation` | Execute documentation workflow |
| `run_quality_assurance` | Execute QA workflow |
| `run_social_media_showcase` | Execute marketing workflow |
| `get_rules` | Get global repository rules |

## Protocol Details

This server implements MCP 2024-11-05 with:
- `resources/list` - List all available skills
- `resources/read` - Read skill content
- `tools/list` - List all available workflows
- `tools/call` - Execute a workflow

## Troubleshooting

### Server not responding
Check stderr output for errors:
```bash
python3 server.py 2>&1 | head -20
```

### Resource not found
Ensure the skill name matches exactly (use kebab-case).
