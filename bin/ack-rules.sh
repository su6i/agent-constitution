#!/bin/bash
set -u

# Resolve the repo from the SCRIPT's location, never from the caller's cwd —
# the script must behave identically when invoked from an external directory
# (same fix as bin/generate-digest.sh).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || dirname "$SCRIPT_DIR")"
DIGEST="$REPO_ROOT/rules/DIGEST.md"
ACK_FILE="$REPO_ROOT/.rules-ack"

if [ ! -f "$DIGEST" ]; then
    echo "❌ DIGEST.md not found. Run bin/generate-digest.sh first." >&2
    exit 1
fi

# Print DIGEST to stdout so it enters the agent's context
cat "$DIGEST"

digest_hash="$(awk '/<!-- digest-hash:/ {print $3}' "$DIGEST")"

if [ -z "$digest_hash" ]; then
    echo "❌ Could not find digest-hash in DIGEST.md" >&2
    exit 1
fi

iso_timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
branch="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD)"

echo "$digest_hash $iso_timestamp $branch" > "$ACK_FILE"
echo "✅ Acknowledged rules. Wrote .rules-ack." >&2
