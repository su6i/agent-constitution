#!/bin/bash
# session-narrative-end.sh — wo-6: SessionEnd hook, additive only.
# Never touches the two existing SessionEnd hooks. Reads the payload now (stdin
# is only available while this process is alive), then hands off to a
# backgrounded python process so a slow/failed model call never delays or
# blocks session end.
input="$(cat 2>/dev/null)"
[ -z "$input" ] && exit 0

tmp="$(mktemp "${TMPDIR:-/tmp}/wo6-payload.XXXXXX.json")" || exit 0
printf '%s' "$input" > "$tmp"

nohup python3 "$HOME/.claude/hooks/session-narrative-end.py" "$tmp" \
  >> "$HOME/.claude/hooks/session-narrative-end.log" 2>&1 &
disown 2>/dev/null

exit 0
