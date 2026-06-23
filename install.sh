#!/usr/bin/env bash
# Agent Constitution — Global Installer
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/su6i/agent-constitution/main/install.sh)

set -euo pipefail

REPO="https://github.com/su6i/agent-constitution.git"
INSTALL_DIR="${HOME}/.claude/agent-constitution"
CLAUDE_DIR="${HOME}/.claude"
SKILLS_LINK="${CLAUDE_DIR}/skills"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; exit 1; }

echo ""
echo "  Agent Constitution Installer"
echo "  ──────────────────────────────────────"
echo ""

# 1. Prerequisites
command -v git >/dev/null 2>&1 || fail "git is required"

# 2. Clone or update
if [ -d "$INSTALL_DIR/.git" ]; then
  warn "Existing install found — updating..."
  git -C "$INSTALL_DIR" pull --ff-only --quiet
  ok "Updated to latest"
else
  echo "  Cloning repository..."
  git clone --depth=1 --quiet "$REPO" "$INSTALL_DIR"
  ok "Cloned to $INSTALL_DIR"
fi

# 3. Skills symlink → ~/.claude/skills
if [ -L "$SKILLS_LINK" ]; then
  warn "Skill symlink already exists — relinking"
  rm "$SKILLS_LINK"
elif [ -d "$SKILLS_LINK" ] && [ ! -L "$SKILLS_LINK" ]; then
  warn "~/.claude/skills is a real directory — skipping symlink (manual merge needed)"
  SKILLS_LINK=""
fi

if [ -n "$SKILLS_LINK" ]; then
  ln -s "$INSTALL_DIR/skills" "$SKILLS_LINK"
  ok "Skills linked: ~/.claude/skills → $INSTALL_DIR/skills"
fi

# 4. Merge CLAUDE.md skill discovery note into ~/.claude/CLAUDE.md
GLOBAL_CLAUDE="${CLAUDE_DIR}/CLAUDE.md"
MARKER="# BEGIN agent-constitution"
if [ -f "$GLOBAL_CLAUDE" ] && grep -q "$MARKER" "$GLOBAL_CLAUDE" 2>/dev/null; then
  warn "CLAUDE.md already patched — skipping"
else
  cat >> "$GLOBAL_CLAUDE" << 'CLAUDEBLOCK'

# BEGIN agent-constitution
## Skill Catalog (367 skills)
Skills live in ~/.claude/skills/. Before implementing anything domain-specific,
check the skill catalog first:
  - List all: ls ~/.claude/skills/
  - Read one: cat ~/.claude/skills/<name>.md
  - If not found locally, check: https://github.com/affaan-m/ECC (upstream, 271 skills)

## Skill Discovery Order
1. ~/.claude/skills/ (this repo — 367 skills)
2. github.com/affaan-m/ECC (upstream open-source harness)
3. Write from scratch only if neither has it
# END agent-constitution
CLAUDEBLOCK
  ok "Patched ~/.claude/CLAUDE.md with skill discovery protocol"
fi

# 5. Summary
SKILL_COUNT=$(ls "$INSTALL_DIR/skills/" | wc -l | tr -d ' ')
echo ""
echo "  ──────────────────────────────────────"
ok "Installation complete"
echo "     Skills available: ${SKILL_COUNT}"
echo "     Location:         ${INSTALL_DIR}"
echo "     Skills symlink:   ~/.claude/skills/"
echo ""
echo "  To update later:   git -C ~/.claude/agent-constitution pull"
echo "  To use a skill:    cat ~/.claude/skills/<name>.md"
echo ""
