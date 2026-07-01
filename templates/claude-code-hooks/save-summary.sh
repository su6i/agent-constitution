#!/usr/bin/env bash
# save-summary — on PostCompact, append the compaction SUMMARY to the project's
# vault SESSION.md as a readable session digest (complements the raw transcript backup).
input=$(cat)
summary=$(printf '%s' "$input" | jq -r '.summary // .compact_summary // .hookSpecificOutput.summary // empty' 2>/dev/null)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null); [ -z "$cwd" ] && cwd="$PWD"
[ -z "$summary" ] && exit 0
if url=$(git -C "$cwd" remote get-url origin 2>/dev/null); then slug="${url##*/}"; slug="${slug%.git}"
else slug=$(basename "$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null || echo "$cwd")"); fi
slug=$(printf '%s' "$slug" | tr '[:upper:]' '[:lower:]')
ws="$HOME/.local/share/agent-projects/$slug/workspace"; mkdir -p "$ws"
{ printf '\n## Session digest — %s (auto · PostCompact)\n\n' "$(date '+%Y-%m-%d %H:%M')"; printf '%s\n' "$summary"; } >> "$ws/SESSION.md"
printf '{"systemMessage": "📝 compaction summary appended → %s/workspace/SESSION.md"}\n' "$slug"
exit 0
