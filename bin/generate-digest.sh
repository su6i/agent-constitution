#!/bin/bash
# ─── Agent Constitution · bin/generate-digest.sh ──────────────────────────
# Canonical source: agent-constitution/bin/generate-digest.sh
#
# PURPOSE
#   The full rules/ tree is long; cheap models skip it and write work/code
#   that violates it. Solution: extract only the non-negotiable sections
#   (marked with `<!-- digest:start -->` … `<!-- digest:end -->` HTML
#   comments) into a short `rules/DIGEST.md` every cheap model can actually
#   finish reading.
#
# MECHANISM
#   - In every rules/*.md file, non-negotiable sections are wrapped with
#     HTML comments: <!-- digest:start --> … <!-- digest:end -->. (Single-line
#     form `<!-- digest -->` is also accepted — the line itself is emitted
#     if non-empty.)
#   - This script concatenates those sections in alphabetical file order,
#     prepends a generated header, and appends a SHA-256 of rules/*.md as
#     the freshness signal.
#   - The last line `<!-- digest-hash: <sha256> -->` is what downstream
#     tooling compares to detect a stale digest.
#
# USAGE
#   bin/generate-digest.sh           # write to rules/DIGEST.md
#   bin/generate-digest.sh --check   # exit 1 if committed digest is stale
#   bin/generate-digest.sh --print   # print to stdout only (no write)
#
# EXIT CODES
#   0  success / digest is fresh
#   1  --check: digest is stale or missing
#   2  invalid argument
#
# Written for bash 3.2 (macOS default) — no mapfile / associative arrays.

set -u

# Resolve from the script's own location, never the caller's cwd — this
# script always targets the constitution repo it lives in (rule 000:
# commands must be runnable from any directory).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || dirname "$SCRIPT_DIR")"
RULES_DIR="$REPO_ROOT/rules"
DIGEST="$RULES_DIR/DIGEST.md"

check_only=0
print_only=0
case "${1:-}" in
    --check) check_only=1 ;;
    --print) print_only=1 ;;
    "")      ;;
    *) echo "usage: $0 [--check|--print]" >&2; exit 2 ;;
esac

# ── Collect rules/*.md files (alphabetical, deterministic) ────────────────
files=()
for f in "$RULES_DIR"/*.md; do
    [ -f "$f" ] || continue
    base="$(basename "$f")"
    [ "$base" = "DIGEST.md" ] && continue
    files+=("$f")
done
# Sort (bash 3.2-safe).
IFS=$'\n'
files=( $(printf '%s\n' ${files[@]+"${files[@]}"} | sort) )
unset IFS

# ── SHA-256 of concatenated rules/*.md content ────────────────────────────
# Note: filenames deliberately excluded — only content matters. Two CLIs that
# rename a rule file should not invalidate the digest; renames do not change
# what the rules say.
hash_input=""
for f in ${files[@]+"${files[@]}"}; do
    hash_input+="$(cat "$f")"
    hash_input+=$'\n'
done
digest_hash="$(printf '%s' "$hash_input" | shasum -a 256 | awk '{print $1}')"

# ── Extract digest blocks from each file ──────────────────────────────────
# Accepts BOTH:
#   • block markers: <!-- digest:start --> ... <!-- digest:end -->
#   • single-line:   <!-- digest --> (the line itself is emitted if non-empty)
extract() {
    awk '
        /<!-- digest:start -->/ { in_block = 1; next }
        /<!-- digest:end -->/   { in_block = 0; next }
        /<!-- digest -->/        { sub(/<!-- digest -->/, ""); if (NF > 0) print; next }
        in_block                { print }
    ' "$1"
}

# ── Compose body ──────────────────────────────────────────────────────────
# No timestamp in the digest: the freshness signal is the content-based
# digest-hash line, and any date would make `--check` fail on every day after
# the commit day (date drift) even with no rule change. Git records when the
# file was generated.
# Header ends with a single newline — no trailing blank line, otherwise
# markdownlint MD012 fires on the gap before the first `## From X.md`.
header="# Rules Digest — Non-Negotiables (auto-generated)

<!-- DO NOT EDIT. Re-run \`bin/generate-digest.sh\` to regenerate. -->
<!-- Source: rules/*.md  ·  Mechanism: rules/045 §Digest Mechanism  -->
"

# Body starts with `## From X.md` directly — no leading blank line. Each
# section contributes `## From X\n\n<content>`; the previous section's
# last newline gives exactly one blank line between sections.
body=""
for f in ${files[@]+"${files[@]}"}; do
    bn="$(basename "$f")"
    block="$(extract "$f")"
    if [ -n "$block" ]; then
        # Strip digest markers from the extracted block and collapse multiple
        # blank lines to a single one — keeps the digest compact and readable.
        joined="$(printf '%s\n' "$block" | awk '
            /^<!-- digest:start -->$/ { next }
            /^<!-- digest:end -->$/   { next }
            NF==0 && prev_blank        { next }
            { print; prev_blank = (NF==0) }
        ')"
        body+="## From $bn"$'\n\n'"$joined"
    fi
done

footer=$'\n<!-- digest-hash: '"$digest_hash"' -->'
content="$header$body$footer"

# ── --check: exit 1 if committed digest would differ ──────────────────────
if [ "$check_only" = "1" ]; then
    if [ ! -f "$DIGEST" ]; then
        echo "❌ digest missing: $DIGEST does not exist." >&2
        echo "   Run: bin/generate-digest.sh" >&2
        exit 1
    fi
    if [ "$(cat "$DIGEST")" != "$content" ]; then
        echo "❌ digest is stale: $DIGEST does not match rules/*.md." >&2
        echo "   Run: bin/generate-digest.sh" >&2
        exit 1
    fi
    exit 0
fi

# ── --print or default ────────────────────────────────────────────────────
if [ "$print_only" = "1" ]; then
    printf '%s\n' "$content"
else
    printf '%s\n' "$content" > "$DIGEST"
    lines="$(wc -l < "$DIGEST" | tr -d ' ')"
    echo "✅ wrote $DIGEST ($lines lines, hash $digest_hash)"
fi