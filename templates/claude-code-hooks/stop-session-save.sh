#!/bin/bash
# stop-session-save.sh — Stop hook. Systemic safety net so a session's knowledge
# is never lost if the assistant forgets to curate SESSION.md before the owner
# clears a fat session (owner mandate 2026-07-20: "save at end of every task,
# systemically").
#
# SELF-SUPPRESSING: fires the $0 gemini digest generator ONLY when a git
# commit/merge happened this session (< 3h) AND SESSION.md is older than that
# commit (i.e. the curated save was skipped). Once SESSION.md is updated it goes
# quiet — so it never nags on turns that already saved or made no commit.
#
# Additive only; never blocks Stop. Mirrors the SessionEnd narrative wrapper.
input="$(cat 2>/dev/null)"
[ -z "$input" ] && exit 0

cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null); [ -z "$cwd" ] && cwd="$PWD"
root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || exit 0

last_commit=$(git -C "$cwd" log -1 --format=%ct 2>/dev/null || echo 0)
now=$(date +%s)
# Only relevant if a commit happened this session (< 3h ago).
[ "$last_commit" -eq 0 ] && exit 0
[ $(( now - last_commit )) -gt 10800 ] && exit 0

# slug: remote origin basename, else dir basename (same as check-session-saved.sh).
if url=$(git -C "$cwd" remote get-url origin 2>/dev/null); then slug="${url##*/}"; slug="${slug%.git}"
else slug=$(basename "$root"); fi
slug=$(printf '%s' "$slug" | tr '[:upper:]' '[:lower:]')
sess="$HOME/.local/share/agent-projects/$slug/workspace/SESSION.md"

sess_mtime=0; [ -f "$sess" ] && sess_mtime=$(stat -f %m "$sess" 2>/dev/null || echo 0)
# Already saved after the last commit → nothing to do, stay silent.
[ "$sess_mtime" -ge "$last_commit" ] && exit 0

# Curated save was skipped → generate the $0 backstop digest, backgrounded.
tmp="$(mktemp "${TMPDIR:-/tmp}/stop-save.XXXXXX.json")" || exit 0
printf '%s' "$input" > "$tmp"
nohup python3 "$HOME/.claude/hooks/session-narrative-end.py" "$tmp" \
  >> "$HOME/.claude/hooks/session-narrative-end.log" 2>&1 &
disown 2>/dev/null
exit 0
