#!/bin/sh
input=$(cat 2>/dev/null)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null); [ -z "$cwd" ] && cwd="$PWD"
root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || root="$cwd"
if url=$(git -C "$cwd" remote get-url origin 2>/dev/null); then slug="${url##*/}"; slug="${slug%.git}"
else slug=$(basename "$root"); fi
slug=$(printf '%s' "$slug" | tr '[:upper:]' '[:lower:]')
todo="$HOME/.local/share/agent-projects/_memory/TODO.md"
hd="$HOME/.local/share/agent-projects/$slug/workspace/SESSION.md"
last=$(ls -1t "$HOME/.local/share/agent-projects/_memory/handoffs"/*.jsonl 2>/dev/null | head -1)
ctx="Session continuity (rule 050): before starting, read your project section (## ${slug}) and the ## Cross-project section in ${todo}, and this project's log ${hd}. Announce open items. Latest raw backup: ${last:-none}."
# Inbox visibility: notes dropped in the project's vault inbox must be triaged,
# not silently ignored (owner complaint 2026-07-21).
inbox_dir="$HOME/.local/share/agent-projects/$slug/workspace/inbox"
inbox_list=$(ls -1 "$inbox_dir" 2>/dev/null | head -10 | tr '\n' ' ')
[ -n "$inbox_list" ] && ctx="$ctx Inbox ($inbox_dir): $inbox_list— announce these notes and triage/answer them this session, or state why not."
# Manager session (@-github) starts from the ready-made weekly scan + registry
# instead of re-surveying repos (wo-manager-0001 deliverable 4).
if [ "$slug" = "@-github" ]; then
  ctx="$ctx Manager extras: read $HOME/.local/share/agent-projects/_memory/QUEUE.md (the single prioritized cross-project task queue — the manager's core artifact; sequence work from it), $HOME/.local/share/agent-projects/_memory/reports/latest.md (weekly repo scan) and $HOME/.local/share/agent-projects/_memory/REGISTRY.md (repo status + ripple map) before any repo survey — never re-survey manually. Manager duties (owner 2026-07-20): maintain the QUEUE, drive RAG, run the e2e workflow; keep context lean, save+clear early."
fi
jq -cn --arg c "$ctx" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$c}}'
exit 0
