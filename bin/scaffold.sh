#!/bin/bash

# ==========================================
# Agent Constitution Scaffolder 🏗️
# ==========================================
# Usage: ./scaffold.sh [TARGET_DIR]
# Defaults to current directory if no argument is provided.

# 1. Determine Paths
# Resolve the true path of the script (handling symlinks)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SOURCE_ROOT="$( cd -P "$( dirname "$SOURCE" )/.." >/dev/null 2>&1 && pwd )"
TARGET_DIR="${1:-$(pwd)}"

echo "⚡ Initiating Agent Constitution Injection..."
echo "📍 Source Constitution: $SOURCE_ROOT"
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

safe_copy "$SOURCE_ROOT/.cursor/rules" "$TARGET_DIR/.cursor/rules"
mkdir -p "$TARGET_DIR/.cursor"
safe_copy "$SOURCE_ROOT/.cursor/workflows" "$TARGET_DIR/.cursor/workflows"
safe_copy "$SOURCE_ROOT/.cursor/prompts" "$TARGET_DIR/.cursor/prompts"

# 4. Scaffold Standard Directories
echo "🏗️  Creating standard directory structure..."
DIRS=(
    "src"
    "tests"
    "docs"
    "assets"
    "lib"
    ".storage/temp"
    ".storage/data"
)

for dir in "${DIRS[@]}"; do
    TARGET_PATH="$TARGET_DIR/$dir"
    if [ ! -d "$TARGET_PATH" ]; then
        mkdir -p "$TARGET_PATH"
        echo "   ➕ Created $dir/"
    else
        echo "   🔸 Exists $dir/"
    fi
done

# 5. Standardize .gitignore (Append if missing)
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

# 6. Git Add
if [ -d "$TARGET_DIR/.git" ]; then
    echo "💾 Staging changes..."
    cd "$TARGET_DIR" || exit
    git add .cursor/rules/ .cursor/workflows/ .cursor/prompts/ .gitignore
    echo "   ✅ Files flagged for commit."
else
    echo "ℹ️  Skipped git add (not a repo)."
fi

echo "🎉 Constitution Installed! This project is now Agent-Governed."
