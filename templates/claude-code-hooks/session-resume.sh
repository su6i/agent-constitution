#!/usr/bin/env bash
# session-resume — on SessionStart, inject a continuity pointer so the agent resumes
# from the central TODO + latest backup without guessing (belt-and-suspenders for rule 050).
input=$(cat)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null); [ -z "$cwd" ] && cwd="$PWD"
if url=$(git -C "$cwd" remote get-url origin 2>/dev/null); then slug="${url##*/}"; slug="${slug%.git}"
else slug=$(basename "$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null || echo "$cwd")"); fi
slug=$(printf '%s' "$slug" | tr '[:upper:]' '[:lower:]')
todo="$HOME/.local/share/agent-projects/_memory/TODO.md"
hd="$HOME/.local/share/agent-projects/$slug/workspace/SESSION.md"
last=$(ls -1t "$HOME/.local/share/agent-projects/_memory/handoffs"/*.jsonl 2>/dev/null | head -1)
ctx="Session continuity (rule 050): before starting, read your project section (## ${slug}) and the ## Cross-project section in ${todo}, and this project's log ${hd}. Announce open items. Latest raw backup: ${last:-none}."
jq -cn --arg c "$ctx" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$c}}'
exit 0
