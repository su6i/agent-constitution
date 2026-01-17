#!/bin/bash

# ==========================================
# Agent Constitution Scaffolder 🏗️
# ==========================================
# Usage: ./scaffold.sh [TARGET_DIR]
# Defaults to current directory if no argument is provided.

# 1. Determine Paths
SOURCE_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="${1:-$(pwd)}"

echo "⚡ Initiating Agent Constitution Injection..."
echo "📍 Source: $SOURCE_ROOT"
echo "🎯 Target: $TARGET_DIR"

# 2. Safety Checks
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Target directory does not exist."
    exit 1
fi

if [ ! -d "$TARGET_DIR/.git" ]; then
    echo "⚠️  Warning: Target is not a git repository. Proceeding anyway..."
fi

# 3. Copy Protocol Artifacts
echo "📂 Copying protocols..."

# Function to copy with backup
safe_copy() {
    local src="$1"
    local dst="$2"
    if [ -e "$dst" ]; then
        echo "   🔸 Backing up existing $dst..."
        mv "$dst" "$dst.bak"
    fi
    cp -R "$src" "$dst"
    echo "   ✅ Installed $(basename "$src")"
}

safe_copy "$SOURCE_ROOT/.cursorrules" "$TARGET_DIR/.cursorrules"
mkdir -p "$TARGET_DIR/.cursor"
safe_copy "$SOURCE_ROOT/workflows" "$TARGET_DIR/.cursor/workflows"
safe_copy "$SOURCE_ROOT/prompts" "$TARGET_DIR/prompts"

# 4. Standardize .gitignore (Append if missing)
GITIGNORE="$TARGET_DIR/.gitignore"
if [ ! -f "$GITIGNORE" ]; then
    touch "$GITIGNORE"
fi

# Minimal critical ignores
IGNORES=(
    ".storage/"
    "prompts/gen_*.txt"
    "prompts/task_*.txt"
)

echo "🛡️  updating .gitignore..."
for rule in "${IGNORES[@]}"; do
    if ! grep -qF "$rule" "$GITIGNORE"; then
        echo "$rule" >> "$GITIGNORE"
        echo "   ➕ Added $rule"
    fi
done

# 5. Git Add
if [ -d "$TARGET_DIR/.git" ]; then
    echo "💾 Staging changes..."
    cd "$TARGET_DIR" || exit
    git add .cursorrules workflows/ prompts/ .gitignore
    echo "   ✅ Files flagged for commit."
else
    echo "ℹ️  Skipped git add (not a repo)."
fi

echo "🎉 Constitution Installed! This project is now Agent-Governed."
