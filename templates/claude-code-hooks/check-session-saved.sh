#!/usr/bin/env bash
# check-session-saved.sh — fail-closed gate against telling the owner "safe to
# /clear" on an unsaved session. Fires on two events:
#   PostToolUse (git commit|push): replaces the old blind "clear now" nudge.
#   SessionEnd:                    last-chance check before the session closes.
# Rule: if the repo has a fresh commit but SESSION.md is older than it, the
# semantic session summary was never written — warn instead of clearing.
input=$(cat 2>/dev/null)
ev=$(printf '%s' "$input" | jq -r '.hook_event_name // empty' 2>/dev/null)

# On PostToolUse, only act after a git commit/push; ignore every other command.
if [ "$ev" = "PostToolUse" ]; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""' 2>/dev/null)
  printf '%s' "$cmd" | grep -qE 'git .*(commit|push)' || exit 0
fi

# The payload cwd follows the Bash tool's LAST `cd`, which can point at any
# repo the session happened to inspect. On 2026-07-27 this told the manager to
# append its digest to ai-router's SESSION.md, and the same cwd-as-identity bug
# in workdir-guard.sh blocked a dispatched architect. The directory the session
# was LAUNCHED in is the first cwd recorded in the transcript — that is the
# session's identity. (session-narrative-end.py fixed this in July; the fix was
# never carried across to this script.)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null); [ -z "$cwd" ] && cwd="$PWD"
tp_early=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
if [ -f "$tp_early" ]; then
  first_cwd=$(jq -r 'select(.cwd != null) | .cwd' "$tp_early" 2>/dev/null | head -1)
  [ -n "$first_cwd" ] && cwd="$first_cwd"
fi

VAULT="$HOME/.local/share/agent-projects"
case "$cwd" in
  "$VAULT"/*)
    # A cwd inside the vault names its project directly.
    rel="${cwd#"$VAULT"/}"; slug="${rel%%/*}" ;;
  *)
    root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || root="$cwd"
    if url=$(git -C "$cwd" remote get-url origin 2>/dev/null); then slug="${url##*/}"; slug="${slug%.git}"
    else slug=$(basename "$root"); fi ;;
esac
slug=$(printf '%s' "$slug" | tr '[:upper:]' '[:lower:]')
sess="$HOME/.local/share/agent-projects/$slug/workspace/SESSION.md"

# Stop: the only event where the model is still alive and can be FORCED to act.
# On a heavy session (transcript > 200KB) whose SESSION.md was never touched
# since the transcript began, block the final stop once so the curated summary
# gets written. stop_hook_active guards against an infinite block loop.
if [ "$ev" = "Stop" ]; then
  [ "$(printf '%s' "$input" | jq -r '.stop_hook_active // false' 2>/dev/null)" = "true" ] && exit 0
  tp=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
  [ -f "$tp" ] || exit 0
  tsize=$(stat -f %z "$tp" 2>/dev/null || echo 0)
  [ "$tsize" -lt 200000 ] && exit 0
  tbirth=$(stat -f %B "$tp" 2>/dev/null || echo 0)
  smt=0; [ -f "$sess" ] && smt=$(stat -f %m "$sess" 2>/dev/null || echo 0)
  # Owner ruling 2026-07-27: architect-memory.md is part of the closeout
  # pipeline, alongside README / ARCHITECTURE / CHANGELOG / SESSION. All seven
  # architect-memory files were created 07-21 and never touched again, because
  # the briefing asked for them but nothing enforced it.
  amem="$HOME/.local/share/agent-projects/$slug/workspace/architect-memory.md"
  amt=0; [ -f "$amem" ] && amt=$(stat -f %m "$amem" 2>/dev/null || echo 0)
  need=""

  # "Was SESSION.md ever touched this session?" is a ONE-SHOT gate: after the
  # first save, smt > tbirth forever, so the agent can talk for another 100k
  # tokens and never be blocked again. Owner caught exactly this on 2026-07-27.
  # The gate must instead ask "is SESSION.md current with the work done since".
  # Proxy for that: bytes appended to the transcript since SESSION.md was last
  # written. Past the threshold, block again.
  # Sidecar records the transcript size at the moment the gate last passed, so
  # "how much work happened since the last save" is an exact byte count rather
  # than an mtime guess.
  RESAVE_BYTES=${SESSION_RESAVE_BYTES:-120000}
  mark="$HOME/.claude/hooks/.session-saved-sizes"
  mkdir -p "$mark" 2>/dev/null
  key=$(printf '%s' "$tp" | shasum | cut -d' ' -f1)
  kmt=0; [ -f "$mark/$key" ] && kmt=$(stat -f %m "$mark/$key" 2>/dev/null || echo 0)
  if [ -f "$mark/$key" ] && [ "$smt" -le "$kmt" ]; then
    seen=$(cat "$mark/$key" 2>/dev/null || echo 0)
  else
    # SESSION.md was written more recently than the baseline (or there is no
    # baseline): that save is the new reference point. Without this the gate
    # stays blocked forever once tripped — saving again would never clear it.
    # No sidecar yet. If SESSION.md is already fresh, the save that just
    # happened covers the transcript so far — seed the baseline at the current
    # size instead of treating the whole file as unsaved work (which would
    # block every single time and train the agent to ignore the gate).
    seen=$tsize
  fi

  if [ "$smt" -lt "$tbirth" ]; then
    need="$sess"
  elif [ $(( tsize - seen )) -gt "$RESAVE_BYTES" ]; then
    need="$sess — از آخرین ذخیره $(( (tsize - seen) / 1000 ))KB کارِ تازه انجام شده"
  fi
  if [ -f "$amem" ] && [ "$amt" -lt "$tbirth" ]; then
    [ -n "$need" ] && need="$need + $amem" || need="$amem"
  fi
  if [ -n "$need" ]; then
    jq -cn --arg s "$need" \
      '{decision:"block",reason:("قانون صفر: سشن سنگین است ولی این فایل(ها) از شروع سشن آپدیت نشده‌اند: " + $s + ". قبل از پیام پایانی به‌روزشان کن (SESSION.md = خلاصه‌ی curated؛ architect-memory.md = تصمیم‌ها/گیت‌ها/وضعیت WOها)، بعد تمام کن. اگر README/ARCHITECTURE/CHANGELOG هم تغییر رفتاری دارند، همان‌جا ببند.")}'
    exit 0
  fi
  # Gate passed: remember how big the transcript was, so the next block fires
  # only after another RESAVE_BYTES of genuinely new work.
  printf '%s' "$tsize" > "$mark/$key" 2>/dev/null
  exit 0
fi

last_commit=$(git -C "$cwd" log -1 --format=%ct 2>/dev/null || echo 0)
now=$(date +%s)
# Only relevant if a commit happened this session (< 3h ago); else stay quiet.
[ $(( now - last_commit )) -gt 10800 ] && exit 0

sess_mtime=0; [ -f "$sess" ] && sess_mtime=$(stat -f %m "$sess" 2>/dev/null || echo 0)
if [ "$sess_mtime" -lt "$last_commit" ]; then
  printf '{"systemMessage":"⚠️ Code was committed but SESSION.md (%s) was NOT updated — before telling the owner it is safe to /clear, write this session summary into it, or its knowledge is lost."}\n' "$slug"
else
  printf '{"systemMessage":"✅ SESSION.md (%s) is up to date — /clear is safe."}\n' "$slug"
fi
exit 0
