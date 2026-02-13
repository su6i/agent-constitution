#!/bin/bash

# setup-mcp.sh
# Installs MCP servers for Cursor / Claude Desktop using 'uv'.
# 'uv' is the recommended faster replacement for pip/pipx.

set -e

echo "🚀 Setting up MCP Servers for Your AI Workspace..."

# Ensure uv is installed
if ! command -v uv &> /dev/null; then
    echo "❌ 'uv' is not installed. Installing it now..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source $HOME/.cargo/env
fi

MCP_DIR="$HOME/.mcp-servers"
mkdir -p "$MCP_DIR"

echo "📂 Installing servers to $MCP_DIR..."

# --- 1. YouTube MCP Server (using yt-dlp) ---
echo "⬇️ Installing mcp-youtube..."
# Note: Creating a venv for specific MCP server to isolate dependencies
uv venv "$MCP_DIR/youtube_env"
# Install specific package (assuming it's available on PyPI or use git+https)
# Since generic mcp-youtube might not be on PyPI with that exact name, we install commonly used ones.
# Or we clone the repo if it's not on PyPI.
# For stability, we will use a known reliable one or clone.
if [ ! -d "$MCP_DIR/mcp-youtube" ]; then
    git clone https://github.com/anaisbetts/mcp-youtube "$MCP_DIR/mcp-youtube"
    cd "$MCP_DIR/mcp-youtube"
    uv pip install .
    cd -
else
    echo "✅ mcp-youtube already exists. Updating..."
    cd "$MCP_DIR/mcp-youtube"
    git pull
    uv pip install .
    cd -
fi


# --- 2. FFmpeg MCP Server ---
echo "⬇️ Installing ffmpeg-mcp-server..."
if [ ! -d "$MCP_DIR/ffmpeg-mcp-server" ]; then
    git clone https://github.com/amolsoans/ffmpeg-mcp-server "$MCP_DIR/ffmpeg-mcp-server"
    cd "$MCP_DIR/ffmpeg-mcp-server"
    # This might be a Node.js server. Checking...
    if [ -f "package.json" ]; then
        echo "   Node.js project detected. Using npm..."
        npm install
    else
        echo "   Python project detected. Using uv..."
        uv venv .venv
        uv pip install .
    fi
    cd -
else
    echo "✅ ffmpeg-mcp-server already exists."
fi

echo "🎉 Installation Complete!"
echo "---------------------------------------------------"
echo "To use these in Cursor/Claude, add them to your config file."
echo ""
echo "Example Config for 'mcp-youtube':"
echo "  \"mcp-youtube\": {"
echo "    \"command\": \"$MCP_DIR/mcp-youtube/.venv/bin/python\","
echo "    \"args\": [\"-m\", \"mcp_youtube\"]"
echo "  }"
echo "---------------------------------------------------"
