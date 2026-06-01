#!/usr/bin/env bash
# sync-projects.sh — push all sibling projects + populate constitution submodule
#
# Usage:
#   bash sync-projects.sh [--push-only | --init-only | --all]
#
# Config (optional):
#   Create .sync-projects in the same directory as this script listing
#   one project folder name per line. If absent, all sibling git repos are used.
#
# Example .sync-projects:
#   my-app
#   backend-api
#   mobile-client

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE="$(cd "$SCRIPT_DIR/../.." && pwd)"   # parent of agent-constitution
MODE="${1:---all}"

# ── load project list ──────────────────────────────────────────────────────
CONFIG="$SCRIPT_DIR/.sync-projects"

if [ -f "$CONFIG" ]; then
  mapfile -t PROJECTS < <(grep -v '^\s*#' "$CONFIG" | grep -v '^\s*$')
else
  # auto-discover: all sibling git repos (except agent-constitution itself)
  PROJECTS=()
  for dir in "$BASE"/*/; do
    name="$(basename "$dir")"
    [[ "$name" == "agent-constitution" ]] && continue
    [ -d "$dir/.git" ] && PROJECTS+=("$name")
  done
fi

# ── helpers ────────────────────────────────────────────────────────────────
green()  { printf "\033[32m✅ %s\033[0m\n" "$*"; }
yellow() { printf "\033[33m⚠️  %s\033[0m\n" "$*"; }
red()    { printf "\033[31m❌ %s\033[0m\n" "$*"; }

push_project() {
  local proj="$1"
  local dir="$BASE/$proj"
  local branch

  [ -d "$dir" ] || { yellow "$proj: directory not found at $dir"; return; }
  branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null) || { yellow "$proj: not a git repo"; return; }

  if [[ "$branch" == "main" || "$branch" == "master" ]]; then
    yellow "$proj: on $branch — skipping (merge feature branch first)"
    return
  fi

  git -C "$dir" push -u origin "$branch" 2>&1 && \
    green "$proj → pushed ($branch)" || \
    red "$proj: push failed"
}

init_submodule() {
  local proj="$1"
  local dir="$BASE/$proj"

  [ -f "$dir/.gitmodules" ] || { yellow "$proj: no .gitmodules — skipping"; return; }

  git -C "$dir" submodule update --init .agent/constitution 2>&1 && \
    green "$proj → constitution populated" || \
    red "$proj: submodule init failed"
}

push_constitution() {
  local dir="$SCRIPT_DIR/.."
  local branch
  branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
  git -C "$dir" push -u origin "$branch" 2>&1 && \
    green "agent-constitution → pushed ($branch)" || \
    red "agent-constitution: push failed"
}

# ── main ───────────────────────────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " sync-projects  base: $BASE  mode: $MODE"
echo " projects: ${#PROJECTS[@]} found"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ "$MODE" == "--all" || "$MODE" == "--push-only" ]]; then
  echo ""
  echo "▶ Pushing agent-constitution..."
  push_constitution

  echo ""
  echo "▶ Pushing projects..."
  for proj in "${PROJECTS[@]}"; do
    push_project "$proj"
  done
fi

if [[ "$MODE" == "--all" || "$MODE" == "--init-only" ]]; then
  echo ""
  echo "▶ Populating submodules..."
  for proj in "${PROJECTS[@]}"; do
    init_submodule "$proj"
  done
fi

echo ""
echo "Done."
