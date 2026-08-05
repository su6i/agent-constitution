#!/usr/bin/env bash
# workdir-guard.sh — PreToolUse(Write|Edit) blast-radius gate.
# Rule: a repo agent may only write inside its OWN repo. A write targeting a
# DIFFERENT repo under the @-github root is denied — cross-repo work goes
# through the manager or a WO to that repo's architect, never a direct write.
# Always allowed: writes outside @-github (vault/SESSION.md, scratchpad,
# ~/.claude), and any write by the manager.
# Kill-switch: WORKDIR_GUARD=off. Manager: CLAUDE_AGENT_ROLE=manager.
GH_ROOT="${GH_ROOT:-$HOME/@-github}"
[ "$WORKDIR_GUARD" = "off" ] && exit 0

input=$(cat 2>/dev/null)
target=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
[ -z "$target" ] && exit 0
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null); [ -z "$cwd" ] && cwd="$PWD"

# Identity must come from where the session was LAUNCHED, not from the Bash
# tool's last `cd`. On 2026-07-27 the manager inspected ai-router mid-session;
# a dispatched agent-constitution architect was then read as "an ai-router
# agent writing cross-repo" and every one of its edits was denied. The first
# cwd in the transcript is the session's real home.
tp=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
if [ -f "$tp" ]; then
  first_cwd=$(jq -r 'select(.cwd != null) | .cwd' "$tp" 2>/dev/null | head -1)
  [ -n "$first_cwd" ] && cwd="$first_cwd"
fi

# ── WO/workspace leak guard (applies to EVERYONE incl. manager & architects) ──
# WOs, reports, and session artifacts live ONLY in the vault
# (~/.local/share/agent-projects/<repo>/workspace/), NEVER inside a repo working
# tree. This closes the hole the cross-repo check below misses: an architect
# writing a WO into ITS OWN repo (target_repo == cur_repo passes that check).
# Checked before the manager bypass on purpose — a repo must never hold a WO.
case "$target" in
  "$GH_ROOT"/*/workspace/* | "$GH_ROOT"/*/wo/wo-*.md | "$GH_ROOT"/wo/wo-*.md)
    reason="⛔ نشت WO/workspace: «$target» داخل working-tree ِ مخزن است. WOها، گزارش‌ها و فایل‌های workspace فقط در vault نوشته می‌شوند: $HOME/.local/share/agent-projects/<repo>/workspace/ (WO در …/workspace/wo/، task-note معمار در …/workspace/inbox/). این گیت برای همه فعال است — حتی مدیر و معمارِ همان مخزن. (کنارگذاشتن اضطراری: WORKDIR_GUARD=off)"
    jq -cn --arg r "$reason" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
    exit 0 ;;
esac

# Cross-repo blast-radius check below is manager-exempt.
[ "$CLAUDE_AGENT_ROLE" = "manager" ] && exit 0

# Manager also identified by operating from the @-github root itself.
[ "$cwd" = "$GH_ROOT" ] && exit 0

# Only police writes that land inside @-github/<repo>. Everything else is free.
case "$target" in
  "$GH_ROOT"/*) : ;;
  *) exit 0 ;;
esac

rel="${target#"$GH_ROOT"/}"; target_repo="${rel%%/*}"
cur_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
cur_repo="${cur_root#"$GH_ROOT"/}"; cur_repo="${cur_repo%%/*}"

if [ -n "$target_repo" ] && [ "$target_repo" != "$cur_repo" ]; then
  reason="⛔ گیت working-dir: این اجنت در مخزن «${cur_repo:-?}» است و اجازه‌ی نوشتن در مخزن «${target_repo}» را ندارد. کار cross-repo فقط از طریق مدیر یا یک WO به معمار آن مخزن انجام می‌شود (کنارگذاشتن: CLAUDE_AGENT_ROLE=manager)."
  jq -cn --arg r "$reason" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
fi
exit 0
