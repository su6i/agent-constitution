#!/bin/sh
input=$(cat 2>/dev/null)
tp=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
sid=$(printf '%s' "$input" | jq -r '.session_id // "unknown"' 2>/dev/null | cut -c1-8)
ev=$(printf '%s' "$input" | jq -r '.hook_event_name // "hook"' 2>/dev/null)
memroot="$HOME/.local/share/agent-projects/_memory"
dest="$memroot/handoffs"
mkdir -p "$dest"
# guard: all handoff artifacts live in handoffs/. Sweep any stray HANDOFF-*
# left at the _memory root (old manual convention) into the folder. Runs
# before the transcript early-exit so it fires every session. Never
# overwrite (-n) so a same-named file is preserved for manual review.
for stray in "$memroot"/HANDOFF-*; do
  [ -f "$stray" ] && mv -n "$stray" "$dest/" 2>/dev/null
done
[ -z "$tp" ] || [ ! -f "$tp" ] && exit 0
ts=$(date +%Y%m%d-%H%M%S)
out="$dest/${ts}_${ev}_${sid}.jsonl"
cp "$tp" "$out" 2>/dev/null || exit 0
