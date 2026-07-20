#!/usr/bin/env bash
# rotate-sessions.sh — Rotate SESSION.md by archiving older sessions.
#
# Keep the last N sessions (default N=4) in SESSION.md; move each older
# session's full text to <workspace>/archive/SESSION-<YYYY>.md (append,
# grouped by the session's own year). Leave a one-line pointer in SESSION.md
# in its place: "YYYY-MM-DD <tag> ✅ — <=10-word summary".
#
# Flags:
#   --file <path>  (default: this project's workspace/SESSION.md, resolved
#                   the same way as rules/035-data-vault.md §Resolver)
#   --keep N       (default N=4)
#   --dry-run      (report what would be archived, write nothing)
#
# Session Boundary Detection:
#   A session is any Markdown level-2 heading (`^## `) — this covers BOTH
#   the auto `## Session digest — ...` blocks written by the SessionEnd hook
#   AND free-form architect headings like `## 2026-07-19 (Opus) — title`.
#   (The original script only matched the literal "## Session digest —"
#   prefix, which most real SESSION.md files never use — that was the bug:
#   --dry-run silently found ~0 sessions and printed nothing.)
#   Content before the first `## ` heading (title, preamble) is never
#   touched. Lines that are NOT `## ` headings are never session starts,
#   including pointer lines left by a previous rotation.
#
# Keep/Archive selection:
#   Each heading's date is parsed (first YYYY-MM-DD found in the heading
#   text). Sessions are ranked by (date desc, file position desc) — this
#   is robust to SESSION.md files that are not strictly append-only (some
#   architects prepend the latest entry instead of appending). The newest
#   N are kept in place; the rest are archived.
#
# Idempotency:
#   Archiving REPLACES a session's heading + body with a single pointer
#   line (no heading marker). A pointer line is never a `## ` heading, so a
#   second run can never re-select or re-archive it — no bookkeeping file
#   needed. The archive file is only ever appended to, never rewritten.
#
# Never deletes irreversibly: content is only moved to archive.
#
# This script is pure bash 3.2 (macOS compatible) and uses only awk/grep/
# sort/mv from coreutils — no associative arrays, no mapfile.

set -u

# ── Resolve this script's own repo (never the caller's cwd) ───────────────
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || dirname "$SCRIPT_DIR")"

# ── Args ────────────────────────────────────────────────────────────────
FILE=""
KEEP=4
DRY_RUN=0

while [ $# -gt 0 ]; do
  case "$1" in
    --file)
      FILE="${2:-}"; shift 2 ;;
    --keep)
      KEEP="${2:-}"; shift 2 ;;
    --dry-run)
      DRY_RUN=1; shift ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^#//'; exit 0 ;;
    *)
      echo "usage: $0 [--file <path>] [--keep N] [--dry-run]" >&2
      exit 2 ;;
  esac
done

case "$KEEP" in
  ''|*[!0-9]*)
    echo "❌ --keep must be a non-negative integer, got: '$KEEP'" >&2
    exit 2 ;;
esac

# ── Resolve default --file (rules/035-data-vault.md §Resolver) ────────────
if [ -z "$FILE" ]; then
  slug="${AGENT_PROJECT_SLUG:-}"
  if [ -z "$slug" ]; then
    remote_url="$(git -C "$REPO_ROOT" remote get-url origin 2>/dev/null || true)"
    if [ -n "$remote_url" ]; then
      slug="$(basename "$remote_url" .git)"
    else
      slug="$(basename "$REPO_ROOT")"
    fi
  fi
  slug_lc="$(printf '%s' "$slug" | tr '[:upper:]' '[:lower:]')"

  slug_env_name="$(printf '%s' "${slug_lc}_DATA_DIR" | tr '[:lower:]-' '[:upper:]_')"
  eval "override_dir=\"\${${slug_env_name}:-}\""

  if [ -n "$override_dir" ]; then
    vault_root="$override_dir"
  else
    vault_root="${XDG_DATA_HOME:-$HOME/.local/share}/agent-projects/$slug_lc"
  fi
  FILE="$vault_root/workspace/SESSION.md"
fi

if [ ! -f "$FILE" ]; then
  echo "ℹ️  No SESSION.md at $FILE — nothing to rotate."
  exit 0
fi

WORKSPACE_DIR="$(dirname "$FILE")"
ARCHIVE_DIR="$WORKSPACE_DIR/archive"

# ── Find all `## ` heading line numbers ────────────────────────────────────
heading_lines="$(grep -n '^## ' "$FILE" | cut -d: -f1)"

if [ -z "$heading_lines" ]; then
  echo "ℹ️  No '## ' session headings found in $FILE — nothing to rotate."
  exit 0
fi

total_sessions="$(printf '%s\n' "$heading_lines" | wc -l | tr -d ' ')"

# ── Build "date|linenum" ranking key per heading (date desc, line desc) ───
rank_input=""
while IFS= read -r ln; do
  [ -z "$ln" ] && continue
  heading_text="$(sed -n "${ln}p" "$FILE")"
  date_part="$(printf '%s' "$heading_text" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)"
  [ -z "$date_part" ] && date_part="0000-00-00"
  rank_input="${rank_input}${date_part}|$(printf '%06d' "$ln")|${ln}"$'\n'
done <<EOF
$heading_lines
EOF

# Sort by date desc, then line number desc (newest/most-recent first).
ordered_lines="$(printf '%s' "$rank_input" | sed '/^$/d' | sort -t'|' -k1,1r -k2,2r | cut -d'|' -f3)"

keep_lines="$(printf '%s\n' "$ordered_lines" | head -n "$KEEP")"
archive_lines="$(printf '%s\n' "$ordered_lines" | tail -n "+$((KEEP + 1))")"

if [ -z "$archive_lines" ]; then
  echo "✅ $total_sessions session(s) found, keep=$KEEP — nothing to archive."
  exit 0
fi

archive_count="$(printf '%s\n' "$archive_lines" | sed '/^$/d' | wc -l | tr -d ' ')"

# ── Compute each heading's end line (next heading's line - 1, or EOF) ─────
all_lines_sorted="$(printf '%s\n' "$heading_lines" | sort -n)"
total_file_lines="$(wc -l < "$FILE" | tr -d ' ')"

end_line_for() {
  # $1 = start line; prints the line before the next heading, or EOF.
  local start="$1" next=""
  next="$(printf '%s\n' "$all_lines_sorted" | awk -v s="$start" '$1 > s { print $1; exit }')"
  if [ -n "$next" ]; then
    echo $((next - 1))
  else
    echo "$total_file_lines"
  fi
}

summarize() {
  # $1 = start line, $2 = end line -> "date|tag|summary"
  local start="$1" end="$2" heading date tag body summary
  heading="$(sed -n "${start}p" "$FILE")"
  date="$(printf '%s' "$heading" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)"
  [ -z "$date" ] && date="unknown-date"
  tag="$(printf '%s' "$heading" | grep -oE '\([^)]*\)' | head -1 | tr -d '()')"
  [ -z "$tag" ] && tag="session"
  # Prefer the text after the last em-dash in the heading — UNLESS the
  # heading is an auto "Session digest —" stub (title = timestamp only,
  # no descriptive text), in which case use the first non-empty body line.
  if printf '%s' "$heading" | grep -q '—' && ! printf '%s' "$heading" | grep -q '^## Session digest'; then
    summary="$(printf '%s' "$heading" | awk -F'—' '{print $NF}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  else
    summary="$(sed -n "$((start + 1)),${end}p" "$FILE" | grep -v '^[[:space:]]*<!--.*-->[[:space:]]*$' | grep -m1 '[^[:space:]]' | sed -e 's/^[[:space:]#*-]*//' -e 's/[[:space:]]*$//')"
  fi
  # Truncate to 10 words.
  summary="$(printf '%s' "$summary" | awk '{ n = (NF > 10 ? 10 : NF); out=""; for (i=1;i<=n;i++) out = out (i==1?"":" ") $i; print out (NF>10 ? " …" : "") }')"
  printf '%s|%s|%s' "$date" "$tag" "$summary"
}

# ── Dry run: report only ───────────────────────────────────────────────────
if [ "$DRY_RUN" = "1" ]; then
  echo "🔍 $FILE — $total_sessions session(s) found, keep=$KEEP, would archive: $archive_count"
  for ln in $(printf '%s\n' "$archive_lines" | sed '/^$/d' | sort -n); do
    end="$(end_line_for "$ln")"
    info="$(summarize "$ln" "$end")"
    date="$(printf '%s' "$info" | cut -d'|' -f1)"
    tag="$(printf '%s' "$info" | cut -d'|' -f2)"
    summary="$(printf '%s' "$info" | cut -d'|' -f3-)"
    year="${date%%-*}"
    [ "$year" = "unknown-date" ] && year="unknown"
    echo "  - line $ln-$end → $ARCHIVE_DIR/SESSION-$year.md :: pointer \"$date $tag ✅ — $summary\""
  done
  echo "(dry run — no files changed)"
  exit 0
fi

# ── Real run: rewrite SESSION.md, append full blocks to yearly archives ──
mkdir -p "$ARCHIVE_DIR"

tmp_session="$(mktemp "${TMPDIR:-/tmp}/rotate-sessions.XXXXXX")"
trap 'rm -f "$tmp_session"' EXIT

archive_set=" $(printf '%s ' $archive_lines) "

current_line=1
for ln in $(printf '%s\n' "$heading_lines" | sort -n); do
  # Emit any preamble / already-kept content strictly before this heading.
  if [ "$current_line" -le "$((ln - 1))" ]; then
    sed -n "${current_line},$((ln - 1))p" "$FILE" >> "$tmp_session"
  fi

  end="$(end_line_for "$ln")"

  case "$archive_set" in
    *" $ln "*)
      info="$(summarize "$ln" "$end")"
      date="$(printf '%s' "$info" | cut -d'|' -f1)"
      tag="$(printf '%s' "$info" | cut -d'|' -f2)"
      summary="$(printf '%s' "$info" | cut -d'|' -f3-)"
      year="${date%%-*}"
      [ "$year" = "unknown-date" ] && year="unknown"
      archive_file="$ARCHIVE_DIR/SESSION-$year.md"
      {
        sed -n "${ln},${end}p" "$FILE"
        echo ""
      } >> "$archive_file"
      echo "$date $tag ✅ — $summary" >> "$tmp_session"
      ;;
    *)
      sed -n "${ln},${end}p" "$FILE" >> "$tmp_session"
      ;;
  esac

  current_line="$((end + 1))"
done

# Trailing content after the last heading (should be none, but be safe).
if [ "$current_line" -le "$total_file_lines" ]; then
  sed -n "${current_line},${total_file_lines}p" "$FILE" >> "$tmp_session"
fi

mv "$tmp_session" "$FILE"
trap - EXIT

echo "✅ archived $archive_count session(s) from $FILE (kept $KEEP), pointers left in place"
echo "   archive dir: $ARCHIVE_DIR"
