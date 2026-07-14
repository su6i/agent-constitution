#!/bin/bash
# ─── Agent Constitution · bin/validate-wo.sh ──────────────────────────────
# Canonical source: agent-constitution/bin/validate-wo.sh
#
# PURPOSE
#   Pure-bash gate for work orders against rule 070 (WO standard) and rule
#   000 §Commands Given to the User. Reads the WO as plain text (no LLM),
#   runs six mechanical checks, and exits non-zero with a named diagnostic
#   for every failure so the architect can amend without guessing.
#
# USAGE
#   bin/validate-wo.sh /path/to/wo.md
#
# WHEN IT RUNS
#   - Architect: before handing the WO off to the executor.
#   - Executor:  first step of WO execution (a rejected WO is reported, not
#                run). Later wired into `amir wo run` and the CI gate.
#
# EXIT CODES
#   0  every check passed
#   1  one or more checks failed (diagnostics printed)
#   2  bad invocation (no path, file missing)
#
# CHECKS (see rules/070-work-orders.md Mandatory Header & Body)
#   1. "قوانین پایه" / "Base rules" section references rules/000-core.md AND
#      rules/040-git.md (the mandatory minimum).
#   2. "مجری" / "Executor" section is present and names an agent/model.
#   3. If the executor section's *primary* (first-named) model is premium
#      (Claude/Opus/Sonnet/Haiku/Fable), the WO must contain a "Why premium:"
#      / "چرا premium:" justification line — premium is forced to justify
#      itself, cheap is the default (rule 070 §Mandatory Header item 1).
#   4. "Definition of Done" / "تست" / "Test" section contains at least one
#      fenced ```bash block AND at least one "انتظار:" / "Expected:" line.
#   5. Commands inside fenced ```bash blocks of DoD/Test sections do not
#      use relative paths (anything not starting with "/" or "~") and do
#      not chain with `&&` (rule 000 §Commands Given to the User).
#   6. No `git push` / `git merge` instruction appears without an explicit
#      owner-approval phrase nearby (rule 040 — owner pushes, never agent).
#
# Written for bash 3.2 (macOS default) — no mapfile, no associative arrays,
# no GNU-awk-only features. Uses grep / awk / sed that exist on every BSD
# and GNU userland.

set -u

WO="${1:-}"
if [ -z "$WO" ]; then
    echo "usage: $0 <path-to-wo.md>" >&2
    exit 2
fi
if [ ! -f "$WO" ]; then
    echo "❌ WO file not found: $WO" >&2
    exit 2
fi

FAIL=0
FAILURES=()

# ── helpers ───────────────────────────────────────────────────────────────
# Record a failure with a stable check name and a diagnostic detail line.
fail() {
    FAIL=$((FAIL + 1))
    FAILURES+=("$1: $2")
}

# Extract the content of a section whose header matches `name` (substring,
# case-insensitive) from stdin (the WO). A "section start" is either:
#   - a markdown header line:           ^#{1,6}\s
#   - an inline bold-with-colon header: ^\*\*[^*]*:\*\*
# Section content runs from the matched header until the next section start
# (or EOF). For inline headers, the remainder of the header line itself is
# also captured so `**مجری:** model-x` yields `model-x` as section content.
extract_section() {
    awk -v name="$1" '
        BEGIN { in_section = 0 }
        # A section-start line (block or inline).
        /^#{1,6}[[:space:]]/ || /^([[:space:]]*[-*0-9.]+[[:space:]]+)?\*\*[^*]*:\*\*/ {
            if (in_section) exit
            hdr_lower = tolower($0)
            target    = tolower(name)
            if (index(hdr_lower, target) > 0) {
                in_section = 1
                # Inline headers carry content on the same line; capture it.
                if ($0 ~ /^([[:space:]]*[-*0-9.]+[[:space:]]+)?\*\*[^*]*:\*\*/) {
                    rest = $0
                    sub(/^([[:space:]]*[-*0-9.]+[[:space:]]+)?\*\*[^*]*:\*\*[[:space:]]*/, "", rest)
                    if (rest != "") print rest
                }
            }
            next
        }
        in_section { print }
    '
}

# Cheap-model keywords (English + provider names rule 070 §Mandatory Header
# treats as cheap by default). Matched as substrings, case-insensitive.
cheap_keywords='gemini|deepseek|gpt-|grok|qwen|minimax|mistral|llama|codestral|phi'

# Premium-model keywords. If the *primary* model in the executor section
# matches one of these, the WO must carry a "Why premium:" justification.
premium_keywords='claude|opus|sonnet|haiku|fable'

WO_CONTENT="$(cat "$WO")"

# ── Check 1: base-rules section references 000-core AND 040-git ───────────
base_section="$(printf '%s\n' "$WO_CONTENT" | extract_section 'قوانین پایه')"
if [ -z "$base_section" ]; then
    base_section="$(printf '%s\n' "$WO_CONTENT" | extract_section 'Base rules')"
fi
if [ -z "$base_section" ]; then
    fail "check1_base_rules" \
        "section 'قوانین پایه' / 'Base rules' not found"
else
    if ! printf '%s\n' "$base_section" | grep -q 'rules/000-core\.md'; then
        fail "check1_base_rules" \
            "missing reference to rules/000-core.md"
    fi
    if ! printf '%s\n' "$base_section" | grep -q 'rules/040-git\.md'; then
        fail "check1_base_rules" \
            "missing reference to rules/040-git.md"
    fi
fi

# ── Check 2: executor section present and identifies a model ──────────────
exec_section="$(printf '%s\n' "$WO_CONTENT" | extract_section 'مجری')"
if [ -z "$exec_section" ]; then
    exec_section="$(printf '%s\n' "$WO_CONTENT" | extract_section 'Executor')"
fi
if [ -z "$exec_section" ]; then
    fail "check2_executor" \
        "section 'مجری' / 'Executor' not found"
else
    # A model is "identified" if any cheap or premium keyword appears. The
    # specific keyword is not validated here — only that the architect
    # wrote *some* model name (rule 070 §Mandatory Header item 1).
    if ! printf '%s\n' "$exec_section" \
            | grep -qiE "($cheap_keywords|$premium_keywords)"; then
        fail "check2_executor" \
            "no model identifier found in executor section"
    fi
fi

# ── Check 3: premium executor requires 'Why premium:' line ────────────────
# The PRIMARY model = the first cheap or premium keyword that appears in
# the executor section. If the first match is premium, the architect must
# have justified it. Cheap-first routing (ladder: gemini → deepseek → ...)
# passes because the first match is cheap.
primary_model=""
if [ -n "$exec_section" ]; then
    primary_model="$(printf '%s\n' "$exec_section" \
        | grep -ioE "($cheap_keywords|$premium_keywords)" \
        | head -n 1 \
        | tr '[:upper:]' '[:lower:]')"
fi
if [ -n "$primary_model" ] && echo "$primary_model" | grep -qiE "^($premium_keywords)"; then
    if ! printf '%s\n' "$WO_CONTENT" | grep -qiE '(why premium|چرا premium)'; then
        fail "check3_premium_justification" \
            "executor primary model is premium ('$primary_model') but no 'Why premium:' / 'چرا premium:' justification line found in the WO"
    fi
fi

# ── Check 4: DoD section contains fenced bash block AND Expected: line ─────
dod_section="$(printf '%s\n' "$WO_CONTENT" | extract_section 'Definition of Done')"
if [ -z "$dod_section" ]; then
    dod_section="$(printf '%s\n' "$WO_CONTENT" | extract_section 'تست')"
fi
if [ -z "$dod_section" ]; then
    dod_section="$(printf '%s\n' "$WO_CONTENT" | extract_section 'Test')"
fi
if [ -z "$dod_section" ]; then
    fail "check4_dod" \
        "section 'Definition of Done' / 'تست' / 'Test' not found"
else
    # At least one fenced ```bash block opening (with or without indent).
    if ! printf '%s\n' "$dod_section" | grep -qE '^[[:space:]]*```bash'; then
        fail "check4_dod" \
            "no fenced \`\`\`bash block in DoD/Test section"
    fi
    # At least one "انتظار:" (Persian) or "Expected:" (English) line.
    if ! printf '%s\n' "$dod_section" \
            | grep -qiE '(انتظار|Expected)[[:space:]]*:'; then
        fail "check4_dod" \
            "no 'انتظار:' / 'Expected:' line in DoD/Test section"
    fi
fi

# ── Check 5: commands in DoD don't use relative paths or `&&` chains ───────
# Only inspected inside fenced ```bash code blocks within DoD/Test sections.
# Reported with the offending line so the architect can fix it directly.
if [ -n "$dod_section" ]; then
    bad_lines="$(printf '%s\n' "$dod_section" | awk '
        BEGIN { in_code = 0 }
        # Fence toggle: any ``` line (with or without language tag) opens or
        # closes a code block. This intentionally matches the markdown spec
        # the WO author is expected to follow.
        /^[[:space:]]*```/ {
            if (in_code) { in_code = 0; next }
            in_code = 1
            next
        }
        in_code {
            line = $0
            sub(/^[[:space:]]+/, "", line)
            # Skip blanks and comments inside the code block.
            if (line == "" || line ~ /^#/) next
            # Rule 000 §Commands: no && chains.
            if (line ~ /&&/) { print "AND_CHAIN|" line; next }
            # Rule 000 §Commands: absolute paths only. A "relative path" is
            # any whitespace-delimited token that contains "/" but does NOT
            # begin with "/" or "~" (e.g. ./foo, ../foo, bin/foo.sh).
            n = split(line, words, /[[:space:]]/)
            for (i = 1; i <= n; i++) {
                w = words[i]
                # Skip flag-style options.
                if (w ~ /^-/) continue
                # Skip KEY=value env prefixes.
                if (w ~ /^[A-Z_][A-Z0-9_]*=/) continue
                if ((w ~ /\//) && (w !~ /^\//) && (w !~ /^~/)) {
                    print "RELATIVE_PATH|" line
                    break
                }
            }
        }
    ')"
    if [ -n "$bad_lines" ]; then
        while IFS= read -r bl; do
            [ -z "$bl" ] && continue
            kind="${bl%%|*}"
            rest="${bl#*|}"
            case "$kind" in
                AND_CHAIN)
                    fail "check5_command_format" \
                        "command uses && chain (rule 000 §Commands Given to the User): $rest"
                    ;;
                RELATIVE_PATH)
                    fail "check5_command_format" \
                        "command uses relative path (rule 000 §Commands Given to the User): $rest"
                    ;;
            esac
        done <<< "$bad_lines"
    fi
fi

# ── Check 6: no git push / git merge without owner-approval phrase ─────────
# Approval phrases include Persian ("پس از تأیید مالک", "تأیید مالک",
# "با مالک") and English ("after owner approves", "owner approval"). Each
# `git push` or `git merge` instruction must be paired with such a phrase
# on the same line or within the next three lines (rule 040 — owner pushes,
# agent never does).
bad_push="$(printf '%s\n' "$WO_CONTENT" | awk '
    # Buffer every line, then scan so we can look-ahead 3 lines for an
    # approval phrase at the same time as we find the offending verb.
    { lines[NR] = $0 }
    END {
        approval = "(after owner approves|owner approval|owner approves|پس از تأیید مالک|پس از تأیید|تأیید مالک|با تأیید|با مالک|with the owner|with owner)"
        trigger  = "(git push|git merge)"
        for (i = 1; i <= NR; i++) {
            if (lines[i] !~ trigger) continue
            ok = 0
            # Search this line and the next three.
            for (j = i; j <= i + 3 && j <= NR; j++) {
                if (lines[j] ~ approval) { ok = 1; break }
            }
            if (!ok) {
                printf("NEEDS_APPROVAL|line %d: %s\n", i, lines[i])
            }
        }
    }
')"
if [ -n "$bad_push" ]; then
    while IFS= read -r bl; do
        [ -z "$bl" ] && continue
        kind="${bl%%|*}"
        rest="${bl#*|}"
        if [ "$kind" = "NEEDS_APPROVAL" ]; then
            fail "check6_push_needs_approval" \
                "git push/merge instruction without owner-approval phrase: $rest"
        fi
    done <<< "$bad_push"
fi

# ── report ────────────────────────────────────────────────────────────────
if [ "$FAIL" -eq 0 ]; then
    echo "✅ WO passes all 6 checks: $WO"
    exit 0
fi

echo "❌ WO fails $FAIL check(s): $WO"
for f in "${FAILURES[@]}"; do
    echo "   - $f"
done
exit 1