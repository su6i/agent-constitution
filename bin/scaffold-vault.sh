#!/usr/bin/env bash
# scaffold-vault — create a project's standard personal-data vault dirs.
# Slug-safe (matches the 035-data-vault resolver), on-demand. Run from a repo,
# or pass a slug. Called by install.sh and usable by any agent.
#   scaffold-vault.sh [slug]
set -euo pipefail

slug="${1:-${AGENT_PROJECT_SLUG:-}}"
if [ -z "$slug" ]; then
  if url="$(git remote get-url origin 2>/dev/null)"; then
    slug="${url##*/}"; slug="${slug%.git}"          # repo name from remote (portable)
  else
    slug="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")"
  fi
fi
slug="$(printf '%s' "$slug" | tr '[:upper:]' '[:lower:]')"

base="${XDG_DATA_HOME:-$HOME/.local/share}/agent-projects/$slug"
mkdir -p "$base"/{data,shared,references,secrets,workspace}
chmod 700 "$base/secrets" 2>/dev/null || true
printf 'vault ready: %s\n  (data shared references secrets workspace)\n' "$base"
