#!/usr/bin/env bash
# Agent Constitution — Global Installer
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/su6i/agent-constitution/main/install.sh)

set -euo pipefail

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="https://github.com/su6i/agent-constitution.git"
INSTALL_DIR="${HOME}/.claude/agent-constitution"
CLAUDE_DIR="${HOME}/.claude"
SKILLS_LINK="${CLAUDE_DIR}/skills"
VAULT_DIR="${HOME}/.local/share/agent-projects"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; exit 1; }

echo ""
echo "  Agent Constitution Installer"
if [ "$DRY_RUN" -eq 1 ]; then
  echo "  ────────────────────────────────────── [DRY-RUN MODE]"
else
  echo "  ──────────────────────────────────────"
fi
echo ""

# 1. Prerequisites
command -v git >/dev/null 2>&1 || fail "git is required"
command -v python3 >/dev/null 2>&1 || fail "python3 is required"

# Determine source directory for templates and skills
if [ -d "$SCRIPT_DIR/templates/claude-code-hooks" ]; then
  SOURCE_DIR="$SCRIPT_DIR"
elif [ -d "$INSTALL_DIR/templates/claude-code-hooks" ]; then
  SOURCE_DIR="$INSTALL_DIR"
else
  SOURCE_DIR=""
fi

# 2. Clone or update (if not running from local repo)
if [ -z "$SOURCE_DIR" ]; then
  if [ -d "$INSTALL_DIR/.git" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
      ok "[dry-run] Would update existing install at $INSTALL_DIR"
    else
      warn "Existing install found — updating..."
      git -C "$INSTALL_DIR" pull --ff-only --quiet
      ok "Updated to latest"
    fi
  else
    if [ "$DRY_RUN" -eq 1 ]; then
      ok "[dry-run] Would clone $REPO to $INSTALL_DIR"
    else
      echo "  Cloning repository..."
      git clone --depth=1 --quiet "$REPO" "$INSTALL_DIR"
      ok "Cloned to $INSTALL_DIR"
    fi
  fi
  SOURCE_DIR="$INSTALL_DIR"
fi

# 3. Skills symlink → ~/.claude/skills
if [ "$DRY_RUN" -eq 1 ]; then
  ok "[dry-run] Skills link check: ~/.claude/skills → $SOURCE_DIR/skills"
else
  if [ -L "$SKILLS_LINK" ]; then
    warn "Skill symlink already exists — relinking"
    rm "$SKILLS_LINK"
  elif [ -d "$SKILLS_LINK" ] && [ ! -L "$SKILLS_LINK" ]; then
    warn "~/.claude/skills is a real directory — skipping symlink (manual merge needed)"
    SKILLS_LINK=""
  fi

  if [ -n "$SKILLS_LINK" ]; then
    mkdir -p "$CLAUDE_DIR"
    ln -s "$SOURCE_DIR/skills" "$SKILLS_LINK"
    ok "Skills linked: ~/.claude/skills → $SOURCE_DIR/skills"
  fi
fi

# 4. Merge CLAUDE.md skill discovery note into ~/.claude/CLAUDE.md
GLOBAL_CLAUDE="${CLAUDE_DIR}/CLAUDE.md"
MARKER="# BEGIN agent-constitution"
if [ -f "$GLOBAL_CLAUDE" ] && grep -q "$MARKER" "$GLOBAL_CLAUDE" 2>/dev/null; then
  warn "CLAUDE.md already patched — skipping"
else
  if [ "$DRY_RUN" -eq 1 ]; then
    ok "[dry-run] Would patch ~/.claude/CLAUDE.md with skill discovery protocol"
  else
    mkdir -p "$CLAUDE_DIR"
    cat >> "$GLOBAL_CLAUDE" << 'CLAUDEBLOCK'

# BEGIN agent-constitution
## Skill Catalog (368 skills)
Skills live in ~/.claude/skills/. Before implementing anything domain-specific,
check the skill catalog first:
  - List all: ls ~/.claude/skills/
  - Read one: cat ~/.claude/skills/<name>.md
  - If not found locally, check: https://github.com/affaan-m/ECC (upstream, 271 skills)

## Skill Discovery Order
1. ~/.claude/skills/ (this repo — 368 skills)
2. github.com/affaan-m/ECC (upstream open-source harness)
3. Write from scratch only if neither has it
# END agent-constitution
CLAUDEBLOCK
    ok "Patched ~/.claude/CLAUDE.md with skill discovery protocol"
  fi
fi

# 5. Install Claude Code hooks & merge settings.json
install_claude_hooks() {
  local templates_dir="$SOURCE_DIR/templates/claude-code-hooks"
  local target_hooks_dir="$CLAUDE_DIR/hooks"
  local target_settings="$CLAUDE_DIR/settings.json"
  local snippet_settings="$templates_dir/settings.snippet.json"
  local backup_dir="$VAULT_DIR/_memory/backups"
  local ts
  ts=$(date +%Y%m%d-%H%M%S)

  if [ ! -d "$templates_dir" ]; then
    warn "No templates directory found at $templates_dir — skipping hook installation"
    return 0
  fi

  if [ "$DRY_RUN" -eq 0 ]; then
    mkdir -p "$target_hooks_dir"
  fi

  # Copy hook scripts with backup
  for src in "$templates_dir"/*; do
    [ -f "$src" ] || continue
    local fname
    fname=$(basename "$src")
    [ "$fname" = "README.md" ] && continue
    [ "$fname" = "settings.snippet.json" ] && continue

    local dst="$target_hooks_dir/$fname"

    if [ -f "$dst" ]; then
      if cmp -s "$src" "$dst"; then
        ok "Hook $fname (unchanged)"
      else
        local bak="$dst.bak-$ts"
        if [ "$DRY_RUN" -eq 1 ]; then
          ok "[dry-run] Would backup $dst → $(basename "$bak") and update"
        else
          cp "$dst" "$bak"
          cp "$src" "$dst"
          [ "${fname%.sh}" != "$fname" ] || [ "${fname%.py}" != "$fname" ] && chmod +x "$dst"
          ok "Updated hook $fname (backed up existing → $(basename "$bak"))"
        fi
      fi
    else
      if [ "$DRY_RUN" -eq 1 ]; then
        ok "[dry-run] Would install hook $fname"
      else
        cp "$src" "$dst"
        [ "${fname%.sh}" != "$fname" ] || [ "${fname%.py}" != "$fname" ] && chmod +x "$dst"
        ok "Installed hook $fname"
      fi
    fi
  done

  # Merge settings.snippet.json into settings.json
  if [ -f "$snippet_settings" ]; then
    if [ -f "$target_settings" ]; then
      if [ "$DRY_RUN" -eq 0 ]; then
        mkdir -p "$backup_dir"
        cp "$target_settings" "$backup_dir/settings.json.bak-$ts"
        ok "Backed up settings.json → $backup_dir/settings.json.bak-$ts"
      else
        ok "[dry-run] Would backup settings.json → $backup_dir/settings.json.bak-$ts"
      fi
    fi

    local python_cmd
    python_cmd=$(cat << 'PYEOF'
import json, sys

target_path = sys.argv[1]
snippet_path = sys.argv[2]
dry_run = sys.argv[3] == "1"

target = {}
if sys.argv[4] == "exists":
    try:
        with open(target_path, "r", encoding="utf-8") as f:
            target = json.load(f)
    except Exception:
        target = {}

with open(snippet_path, "r", encoding="utf-8") as f:
    snippet = json.load(f)

if "hooks" not in target:
    target["hooks"] = {}

added_hooks = []
snippet_hooks = snippet.get("hooks", {})

for event, s_matchers in snippet_hooks.items():
    if event not in target["hooks"]:
        if not dry_run:
            target["hooks"][event] = s_matchers
        for group in s_matchers:
            for h in group.get("hooks", []):
                cmd_str = h.get("command")
                added_hooks.append(f"{event}: {cmd_str}")
    else:
        for s_group in s_matchers:
            s_matcher = s_group.get("matcher")
            for s_hook in s_group.get("hooks", []):
                cmd = s_hook.get("command")
                exists = any(
                    h.get("command") == cmd
                    for t_group in target["hooks"][event]
                    for h in t_group.get("hooks", [])
                )
                if not exists:
                    added_hooks.append(f"{event}: {cmd}")
                    if not dry_run:
                        t_group = next((g for g in target["hooks"][event] if g.get("matcher") == s_matcher), None)
                        if t_group is None:
                            new_g = {"hooks": [s_hook]}
                            if s_matcher is not None:
                                new_g["matcher"] = s_matcher
                            target["hooks"][event].append(new_g)
                        else:
                            t_group.setdefault("hooks", []).append(s_hook)

if "autoCompactWindow" in snippet and "autoCompactWindow" not in target:
    if not dry_run:
        target["autoCompactWindow"] = snippet["autoCompactWindow"]

if dry_run:
    print(f"[dry-run] Would merge settings.snippet.json into settings.json ({len(added_hooks)} new hooks)")
    for a in added_hooks:
        print(f"  + {a}")
else:
    with open(target_path, "w", encoding="utf-8") as f:
        json.dump(target, f, ensure_ascii=False, indent=2)
        f.write("\n")
    print(f"✓ Merged settings.snippet.json into {target_path} ({len(added_hooks)} new hooks)")
PYEOF
)

    local target_exists="no"
    [ -f "$target_settings" ] && target_exists="exists"

    python3 -c "$python_cmd" "$target_settings" "$snippet_settings" "$DRY_RUN" "$target_exists"
  fi
}

install_claude_hooks

# 6. Summary
SKILL_COUNT=0
if [ -d "$SOURCE_DIR/skills/" ]; then
  SKILL_COUNT=$(ls "$SOURCE_DIR/skills/" | wc -l | tr -d ' ')
fi

echo ""
echo "  ──────────────────────────────────────"
if [ "$DRY_RUN" -eq 1 ]; then
  ok "Dry run complete — no files were modified"
else
  ok "Installation complete"
fi
echo "     Skills available: ${SKILL_COUNT}"
echo "     Location:         ${SOURCE_DIR}"
echo "     Skills symlink:   ~/.claude/skills/"
echo "     Hooks installed:  ~/.claude/hooks/"
echo ""
