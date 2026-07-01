#!/usr/bin/env bash
# save-handoff — back up the full session transcript before compact / clear / exit,
# so no session data is ever lost. Wired to PreCompact + SessionEnd in settings.json.
# Reads hook JSON on stdin (transcript_path, session_id, hook_event_name).
input=$(cat)
tp=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
sid=$(printf '%s' "$input" | jq -r '.session_id // "unknown"' 2>/dev/null | cut -c1-8)
ev=$(printf '%s' "$input" | jq -r '.hook_event_name // "hook"' 2>/dev/null)
[ -z "$tp" ] || [ ! -f "$tp" ] && exit 0
dest="$HOME/.local/share/agent-projects/_memory/handoffs"
mkdir -p "$dest"
ts=$(date +%Y%m%d-%H%M%S)
out="$dest/${ts}_${ev}_${sid}.jsonl"
cp "$tp" "$out" 2>/dev/null || exit 0
# keep only the 40 most-recent backups
ls -1t "$dest"/*.jsonl 2>/dev/null | tail -n +41 | while read -r f; do rm -f "$f"; done
printf '{"systemMessage": "💾 session backed up → handoffs/%s"}\n' "$(basename "$out")"
exit 0
