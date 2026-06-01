#!/usr/bin/env bash
# sync-projects.sh — push all projects + populate constitution submodule
# Usage: bash sync-projects.sh [--push-only | --init-only | --all]

set -e

BASE="/Users/su6i/@-github"
CONSTITUTION_REMOTE="git@github.com:su6i/agent-constitution.git"

PROJECTS=(
  ApplyForge
  Multi_Agent_Job_Applier
  amir-cli
  multi-agent_financial_markets_analyser
  research_toolkit
  subtitle
  telegram-video-automation
  youtube_toolkit
)

MODE="${1:---all}"

# ── helpers ────────────────────────────────────────────────────────────────
green()  { printf "\033[32m✅ %s\033[0m\n" "$*"; }
yellow() { printf "\033[33m⚠️  %s\033[0m\n" "$*"; }
red()    { printf "\033[31m❌ %s\033[0m\n" "$*"; }

push_project() {
  local proj="$1"
  local dir="$BASE/$proj"
  local branch

  branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null) || { yellow "$proj: not a git repo"; return; }

  if [[ "$branch" == "main" || "$branch" == "master" ]]; then
    yellow "$proj: on $branch — skipping push (merge feature branch first)"
    return
  fi

  if git -C "$dir" push -u origin "$branch" 2>&1; then
    green "$proj → pushed ($branch)"
  else
    red "$proj: push failed"
  fi
}

init_submodule() {
  local proj="$1"
  local dir="$BASE/$proj"
  local constitution_dir="$dir/.agent/constitution"

  if [ ! -f "$dir/.gitmodules" ]; then
    yellow "$proj: no .gitmodules — skipping submodule init"
    return
  fi

  git -C "$dir" submodule update --init .agent/constitution 2>&1 && \
    green "$proj → submodule populated ($(ls $constitution_dir/rules/ | wc -l | tr -d ' ') rules)" || \
    red "$proj: submodule init failed"
}

# ── push agent-constitution first ──────────────────────────────────────────
push_constitution() {
  local dir="$BASE/agent-constitution"
  local branch
  branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
  git -C "$dir" push -u origin "$branch" 2>&1 && \
    green "agent-constitution → pushed ($branch)" || \
    red "agent-constitution: push failed"
}

# ── main ───────────────────────────────────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " sync-projects.sh — mode: $MODE"
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
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Done."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
