#!/bin/bash
# ─── Agent Constitution · bin/distill-lessons.sh ──────────────────────────
# Promotes a defect pattern seen N times across lesson files
# (_memory/lessons/*.md, schema: templates/lesson.md) into a hard rule in
# _memory/WORKER-RULES.md — the file already injected BY PATH into every
# delegate_worker/delegate_agent prompt (rules/000-core.md §Worker
# Delegation). See rules/080-knowledge-capture.md §6 for the mandate this
# script implements.
#
# WHY DEFAULT_N=3 (do not change this without updating rules/080-knowledge-
# capture.md §6 to match — the rule text and this script must never
# disagree):
#   N=1 is an anecdote — one lesson can be a one-off model quirk, a bad
#   prompt, or an unrelated environment glitch. Promoting on a single
#   sighting makes every future worker prompt longer for a pattern that may
#   never recur.
#   N=2 still fits coincidence — two lessons can share a pattern_id because
#   the same task was retried, not because the defect is a genuine
#   recurring class.
#   N=3 is the smallest count where three lessons from INDEPENDENT completed
#   WOs reporting the identical pattern_id stops being explainable as
#   coincidence — the same threshold this constitution already uses
#   elsewhere for "stop repeating the same fix, do something structural
#   instead" (rules/085-orchestration-topology.md caps review rounds at 2
#   before escalating: a third occurrence of the same failure is where a
#   standing rule becomes cheaper than living with a fourth).
#
# USAGE
#   bin/distill-lessons.sh [--n N] [--dry-run]
#
#   --n N       override the promotion threshold (default 3). Only ever use
#               this for testing the script itself — production runs use
#               the documented default.
#   --dry-run   report what WOULD be promoted, write nothing.
#
# READS   $AGENT_MEMORY_DIR/lessons/*.md   (default: ~/.local/share/agent-projects/_memory/lessons)
# WRITES  $AGENT_MEMORY_DIR/WORKER-RULES.md  (appends only; idempotent per pattern_id)
#
# Written for bash 3.2 (macOS default) — no mapfile / associative arrays.

set -euo pipefail

SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

VAULT_DIR="${AGENT_MEMORY_DIR:-$HOME/.local/share/agent-projects/_memory}"
LESSONS_DIR="$VAULT_DIR/lessons"
WORKER_RULES="$VAULT_DIR/WORKER-RULES.md"

DEFAULT_N=3
ENTRY_TMP="$(mktemp)"
trap 'rm -f "$ENTRY_TMP"' EXIT
N="$DEFAULT_N"
DRY_RUN=0

while [ $# -gt 0 ]; do
  case "$1" in
    --n)       N="${2:?--n needs an integer}"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

case "$N" in
  ''|*[!0-9]*) echo "--n must be a positive integer, got '$N'" >&2; exit 2 ;;
esac

if [ ! -d "$LESSONS_DIR" ]; then
  echo "✅ No vault / $LESSONS_DIR not found, nothing to distill"
  exit 0
fi

if [ ! -f "$WORKER_RULES" ]; then
  echo "❌ $WORKER_RULES not found — this file is the injection channel and must already exist" >&2
  exit 1
fi

# ── Extract one header field from one lesson file ─────────────────────────
# The header is everything before the first line that is exactly "---".
lesson_field() {
  # $1 = file, $2 = field name
  awk -v field="$2" '
    /^---[[:space:]]*$/ { exit }
    $0 ~ "^"field":" {
      sub("^"field":[[:space:]]*", "");
      print;
      exit
    }
  ' "$1"
}

# ── Collect distinct pattern_ids and count their lessons ──────────────────
PATTERN_IDS_FILE="$(mktemp)"
trap 'rm -f "$PATTERN_IDS_FILE"' EXIT

for lesson in "$LESSONS_DIR"/*.md; do
  [ -f "$lesson" ] || continue
  pid="$(lesson_field "$lesson" "pattern_id")"
  [ -n "$pid" ] || continue
  echo "$pid"
done | sort -u > "$PATTERN_IDS_FILE"

if [ ! -s "$PATTERN_IDS_FILE" ]; then
  echo "✅ No lesson files with a pattern_id found under $LESSONS_DIR"
  exit 0
fi

PROMOTED=0
SKIPPED_ALREADY=0
SKIPPED_BELOW_N=0

while IFS= read -r pid; do
  [ -n "$pid" ] || continue

  # All lessons sharing this pattern_id.
  MATCHING="$(mktemp)"
  for lesson in "$LESSONS_DIR"/*.md; do
    [ -f "$lesson" ] || continue
    if [ "$(lesson_field "$lesson" "pattern_id")" = "$pid" ]; then
      echo "$lesson" >> "$MATCHING"
    fi
  done
  COUNT="$(wc -l < "$MATCHING" | tr -d ' ')"

  if [ "$COUNT" -lt "$N" ]; then
    echo "  pattern '$pid': $COUNT/$N lessons — not enough yet"
    SKIPPED_BELOW_N=$((SKIPPED_BELOW_N + 1))
    rm -f "$MATCHING"
    continue
  fi

  if grep -qF "<!-- distilled-pattern: $pid " "$WORKER_RULES" 2>/dev/null; then
    echo "  pattern '$pid': $COUNT/$N lessons — already promoted, skipping (idempotent)"
    SKIPPED_ALREADY=$((SKIPPED_ALREADY + 1))
    rm -f "$MATCHING"
    continue
  fi

  # Use the first matching lesson as the representative Symptom/Root-cause
  # text source; collect ids/mechanical/guard_check across all of them.
  FIRST_LESSON="$(head -n 1 "$MATCHING")"
  MECHANICAL="true"
  GUARD_CHECK=""
  LESSON_IDS=""
  while IFS= read -r lf; do
    lid="$(lesson_field "$lf" "lesson_id")"
    LESSON_IDS="${LESSON_IDS:+$LESSON_IDS,}$lid"
    m="$(lesson_field "$lf" "mechanical")"
    [ "$m" = "true" ] || MECHANICAL="false"
    gc="$(lesson_field "$lf" "guard_check")"
    [ -n "$GUARD_CHECK" ] || GUARD_CHECK="$gc"
  done < "$MATCHING"
  rm -f "$MATCHING"

  PROBLEM="$(awk '/^## Problem/{f=1;next}/^## /{f=0}f' "$FIRST_LESSON" | sed '/^$/d' | head -n 5)"
  SOLUTION="$(awk '/^## Solution/{f=1;next}/^## /{f=0}f' "$FIRST_LESSON" | sed '/^$/d' | head -n 5)"

  # The rule the worker must actually follow. WORKER-RULES.md is the ONLY file
  # injected into a delegation prompt — the lesson files are not — so an entry
  # that says "see the lesson" injects nothing. Prefer the lesson's explicit
  # `rule:` header field; fall back to its Solution section; never point the
  # reader at a file it cannot see.
  RULE_LINE="$(lesson_field "$FIRST_LESSON" "rule")"
  if [ -z "$RULE_LINE" ]; then
    RULE_LINE="$SOLUTION"
  fi
  if [ -z "$RULE_LINE" ]; then
    echo "  ⚠️  pattern '$pid': no 'rule:' field and no Solution section — refusing to promote an empty rule." >&2
    continue
  fi

  # Next number in "## Recorded defect patterns" — highest existing "N. " + 1.
  NEXT_NUM="$(grep -oE '^[0-9]+\.' "$WORKER_RULES" | tr -d '.' | sort -n | tail -n 1)"
  NEXT_NUM="${NEXT_NUM:-0}"
  NEXT_NUM=$((NEXT_NUM + 1))

  if [ "$MECHANICAL" = "true" ] && [ -n "$GUARD_CHECK" ] && [ "$GUARD_CHECK" != "n/a" ]; then
    TAG="[MECHANICAL]"
    GUARD_LINE="   Guard: \`scripts/wo_guard.sh --once $GUARD_CHECK\` — run this in the layer-2 --verify chain; the delegation FAILS if it does not pass."
  else
    TAG="[ADVISORY — not mechanically checkable]"
    GUARD_LINE="   Guard: none — this pattern requires a reviewer's judgment, not a script."
  fi

  {
    echo ""
    echo "$NEXT_NUM. $TAG Symptom: $PROBLEM"
    echo "   Root cause: distilled from $COUNT lessons (pattern_id=$pid): $SOLUTION"
    echo "   Rule: $RULE_LINE"
    echo "$GUARD_LINE"
    echo "   <!-- distilled-pattern: $pid n=$COUNT lessons=$LESSON_IDS date=$(date +%Y-%m-%d) -->"
  } > "$ENTRY_TMP"

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  pattern '$pid': $COUNT/$N lessons — WOULD promote as entry $NEXT_NUM $TAG (dry-run, nothing written)"
    rm -f "$ENTRY_TMP"
  else
    # Insert right before the "## How this file improves" section so the
    # entry lands inside "## Recorded defect patterns", matching that
    # section's own append convention.
    awk -v entryfile="$ENTRY_TMP" '
      /^## How this file improves/ && !done {
        while ((getline line < entryfile) > 0) print line
        print ""
        done = 1
      }
      { print }
    ' "$WORKER_RULES" > "$WORKER_RULES.distill-tmp"
    mv "$WORKER_RULES.distill-tmp" "$WORKER_RULES"
    rm -f "$ENTRY_TMP"
    echo "  pattern '$pid': $COUNT/$N lessons — PROMOTED as entry $NEXT_NUM $TAG"
    PROMOTED=$((PROMOTED + 1))
  fi
done < "$PATTERN_IDS_FILE"

echo ""
echo "===DISTILL-RECEIPT==="
echo "lessons_dir=$LESSONS_DIR"
echo "worker_rules=$WORKER_RULES"
echo "threshold_n=$N"
echo "patterns_promoted=$PROMOTED"
echo "patterns_already_promoted=$SKIPPED_ALREADY"
echo "patterns_below_threshold=$SKIPPED_BELOW_N"
echo "===END-DISTILL-RECEIPT==="
