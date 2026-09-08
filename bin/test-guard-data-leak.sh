#!/bin/bash
# ─── Agent Constitution · bin/test-guard-data-leak.sh ─────────────────────────
# Regression test for templates/hooks/guard-data-leak (WO-constitution-0016):
#   1. SSH remote URLs (git@github.com:owner/repo.git) must NOT be treated as
#      a real email address (the false positive that blocked every push
#      whose diff mentioned a plain scp-style clone URL).
#   2. A real email address at a NON-forge host must still be blocked, with
#      the actual file name attached to the BLOCKED line — not the
#      untraceable generic "staged additions".
#   3. In `range` mode (pre-push), only the actually polluted file must be
#      named — an unrelated file in the same range must not show up.
#   4. Pre-existing regressions (`.env` staged) must still block.
#
# Every fixture repo commit below uses `--no-verify`: this machine may have
# `core.hooksPath` pointed at this very hook (or a copy of it) globally, and
# letting it run recursively while we're staging our own test fixtures would
# make fixture commits fail and silently corrupt the test.
#
# Written for bash 3.2 (macOS) as well as the GNU bash on GitHub Actions
# runners — no mapfile, no associative arrays. `set -e` is intentionally
# NOT used: several scenarios below expect the hook to exit 1, which is a
# normal, checked outcome here, not a script error.
set -uo pipefail

SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOK="$REPO_ROOT/templates/hooks/guard-data-leak"

pass_count=0
fail_count=0

pass() { printf '✅ %s\n' "$1"; pass_count=$((pass_count + 1)); }
fail() { printf '❌ %s\n' "$1"; fail_count=$((fail_count + 1)); }

new_repo() {
    local dir
    dir="$(mktemp -d)"
    (
        cd "$dir" || exit 1
        git init -q
        git config user.email "test@example.com"
        git config user.name "test"
        git commit -q --allow-empty --no-verify -m "init"
    )
    printf '%s' "$dir"
}

# The two addresses that MUST be blocked are assembled from parts at runtime.
# Spelled out in full, they would trip the very scanner this script tests and
# make the file uncommittable — the same trap WO-constitution-0016 was opened
# for. The forge URLs below are safe to write literally: exempting them is the
# behaviour under test.
blocked_person="ali@$(printf 'mailhost.fr')"
blocked_git="git@$(printf 'internal-mail.com')"

# ── a. SSH remote URL only — must PASS (exit 0), no false positive ─────────
repo="$(new_repo)"
(
    cd "$repo" || exit 1
    printf 'git clone git@github.com:su6i/x.git\n' > ssh_only.txt
    git add ssh_only.txt
    bash "$HOOK" staged > /tmp/out.$$ 2>&1
    echo "$?" > /tmp/rc.$$
)
rc="$(cat /tmp/rc.$$)"; out="$(cat /tmp/out.$$)"; rm -f /tmp/rc.$$ /tmp/out.$$
if [ "$rc" = "0" ]; then
    pass "a. SSH remote URL (git@github.com:...) does not false-positive as an email"
else
    fail "a. SSH remote URL wrongly blocked (exit $rc): $out"
fi
rm -rf "$repo"

# ── b. real email at a non-forge host — must BLOCK, naming the real file ───
repo="$(new_repo)"
(
    cd "$repo" || exit 1
    printf 'contact %s for details\n' "$blocked_person" > real_email.txt
    git add real_email.txt
    bash "$HOOK" staged > /tmp/out.$$ 2>&1
    echo "$?" > /tmp/rc.$$
)
rc="$(cat /tmp/rc.$$)"; out="$(cat /tmp/out.$$)"; rm -f /tmp/rc.$$ /tmp/out.$$
if [ "$rc" = "1" ] && printf '%s' "$out" | grep -q "real_email.txt"; then
    pass "b. real email at non-forge host is blocked and names real_email.txt"
else
    fail "b. expected block naming real_email.txt (exit $rc): $out"
fi
rm -rf "$repo"

# ── c. git@ at a non-forge host — the allowlist must NOT swallow it ──────
repo="$(new_repo)"
(
    cd "$repo" || exit 1
    printf 'admin %s is the owner\n' "$blocked_git" > internal.txt
    git add internal.txt
    bash "$HOOK" staged > /tmp/out.$$ 2>&1
    echo "$?" > /tmp/rc.$$
)
rc="$(cat /tmp/rc.$$)"; out="$(cat /tmp/out.$$)"; rm -f /tmp/rc.$$ /tmp/out.$$
if [ "$rc" = "1" ] && printf '%s' "$out" | grep -q "internal.txt"; then
    pass "c. git@ at a non-forge host is still blocked"
else
    fail "c. expected block naming internal.txt (exit $rc): $out"
fi
rm -rf "$repo"

# ── d. range mode, 2 files, only the second polluted — only it is named ────
repo="$(new_repo)"
(
    cd "$repo" || exit 1
    printf 'clean file\n' > clean.txt
    git add clean.txt
    git commit -q --no-verify -m "clean commit"
    base="$(git rev-parse HEAD)"
    printf 'still clean\n' > clean.txt
    printf 'leak: %s\n' "$blocked_person" > dirty.txt
    git add clean.txt dirty.txt
    git commit -q --no-verify -m "dirty commit"
    head_sha="$(git rev-parse HEAD)"
    bash "$HOOK" range "$base" "$head_sha" > /tmp/out.$$ 2>&1
    echo "$?" > /tmp/rc.$$
)
rc="$(cat /tmp/rc.$$)"; out="$(cat /tmp/out.$$)"; rm -f /tmp/rc.$$ /tmp/out.$$
blocked_lines="$(printf '%s\n' "$out" | grep '^BLOCKED' || true)"
if [ "$rc" = "1" ] \
    && printf '%s' "$blocked_lines" | grep -q "dirty.txt" \
    && ! printf '%s' "$blocked_lines" | grep -q "clean.txt"; then
    pass "d. range mode names only the polluted file (dirty.txt), not clean.txt"
else
    fail "d. expected BLOCKED on dirty.txt only (exit $rc): $out"
fi
rm -rf "$repo"

# ── e. .env staged — pre-existing regression (rule 035) must still block ───
repo="$(new_repo)"
(
    cd "$repo" || exit 1
    printf 'SECRET=1\n' > .env
    git add .env
    bash "$HOOK" staged > /tmp/out.$$ 2>&1
    echo "$?" > /tmp/rc.$$
)
rc="$(cat /tmp/rc.$$)"; out="$(cat /tmp/out.$$)"; rm -f /tmp/rc.$$ /tmp/out.$$
if [ "$rc" = "1" ] && printf '%s' "$out" | grep -q "\.env"; then
    pass "e. .env staged still blocks (rule 035 regression check)"
else
    fail "e. expected .env to still block (exit $rc): $out"
fi
rm -rf "$repo"

echo ""
echo "── $pass_count passed, $fail_count failed ──"
if [ "$fail_count" -gt 0 ]; then
    exit 1
fi
exit 0
