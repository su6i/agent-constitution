#!/bin/bash
# ─── Agent Constitution · bin/validate-prefixes.sh ────────────────────────────
# Validates the Identifier Prefixes table in rules/075-identifiers.md against
# the single source of truth in _memory/PREFIXES.tsv.

set -euo pipefail

SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

VAULT_DIR="${AGENT_MEMORY_DIR:-$HOME/.local/share/agent-projects/_memory}"
PREFIXES_TSV="$VAULT_DIR/PREFIXES.tsv"
TARGET_MD="$REPO_ROOT/rules/075-identifiers.md"

if [[ ! -f "$PREFIXES_TSV" ]]; then
    echo "✅ No vault / PREFIXES.tsv not found, skipping"
    exit 0
fi

EXPECTED="<!-- PREFIXES:BEGIN generated from _memory/PREFIXES.tsv -->
| Prefix | Name | Scope |
|--------|------|-------|"

while IFS=$'\t' read -r prefix name scope; do
    if [[ "$prefix" == "prefix" ]]; then continue; fi
    EXPECTED="$EXPECTED
| $prefix | $name | $scope |"
done < "$PREFIXES_TSV"

EXPECTED="$EXPECTED
<!-- PREFIXES:END -->"

CURRENT=$(awk '
    /<!-- PREFIXES:BEGIN generated from _memory\/PREFIXES.tsv -->/ { in_block=1; print; next }
    /<!-- PREFIXES:END -->/ { if(in_block) { print; in_block=0; exit } }
    in_block { print }
' "$TARGET_MD")

if [[ "$CURRENT" == "$EXPECTED" ]]; then
    echo "✅ Prefix table in 075-identifiers.md matches PREFIXES.tsv"
    exit 0
else
    echo "❌ Prefix table mismatch in rules/075-identifiers.md!"
    echo "Diff (Current vs Expected):"
    diff -u <(printf "%s\n" "$CURRENT") <(printf "%s\n" "$EXPECTED") || true
    exit 1
fi
