#!/bin/bash
# open-branches.sh — report unmerged / stale git branches so half-done tasks
# don't get forgotten.
#
# Usage:
#   ./bin/open-branches.sh            # scan every git repo under ~/@-github
#   ./bin/open-branches.sh <root>     # scan every git repo under <root>
#   ./bin/open-branches.sh --here     # only the current repository
#
# Lists branches NOT merged into the repo's default branch (main/master), with
# how many commits they're ahead and when they were last touched. Branches with
# no commit in STALE_DAYS (default 14) are flagged ⚠️ stale.
#
# Written for bash 3.2 (macOS default) — no mapfile / associative arrays.

set -u
STALE_DAYS="${STALE_DAYS:-14}"

report_repo() {
    repo="$1"
    [ -z "$repo" ] && return 0

    def="main"
    git -C "$repo" show-ref --verify --quiet refs/heads/main || def="master"
    git -C "$repo" show-ref --verify --quiet "refs/heads/$def" || return 0

    branches="$(git -C "$repo" branch --no-merged "$def" --format='%(refname:short)' 2>/dev/null)"
    [ -z "$branches" ] && return 0

    printf '\n📁 %s\n' "$(basename "$repo")"
    now="$(date +%s)"
    while IFS= read -r b; do
        [ -z "$b" ] && continue
        ts="$(git -C "$repo" log -1 --format=%ct "$b" 2>/dev/null)"
        rel="$(git -C "$repo" log -1 --format=%cr "$b" 2>/dev/null)"
        ahead="$(git -C "$repo" rev-list --count "$def..$b" 2>/dev/null)"
        flag=""
        if [ -n "$ts" ]; then
            age=$(( (now - ts) / 86400 ))
            [ "$age" -ge "$STALE_DAYS" ] && flag="  ⚠️ stale (${age}d)"
        fi
        printf '   🌿 %-32s %s ahead, last %s%s\n' "$b" "${ahead:-?}" "$rel" "$flag"
    done <<EOF
$branches
EOF
}

case "${1:-}" in
    --here)
        report_repo "$(git rev-parse --show-toplevel 2>/dev/null)"
        exit 0
        ;;
esac

root="${1:-$HOME/@-github}"
found=0
for d in "$root"/*/; do
    if git -C "$d" rev-parse --git-dir >/dev/null 2>&1; then
        report_repo "${d%/}"
        found=1
    fi
done

if [ "$found" -eq 0 ]; then
    echo "No git repos found under $root"
fi
