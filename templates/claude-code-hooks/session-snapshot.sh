#!/bin/bash
# session-snapshot.sh — run by the Claude Code SessionEnd hook.
# Deterministically records a mechanical snapshot of the current repo at session
# end, so session logging never depends on the model remembering to do it.
# Reads the hook's JSON payload on stdin.

input="$(cat 2>/dev/null)"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)"
[ -z "$cwd" ] && cwd="$PWD"
sid="$(printf '%s' "$input" | jq -r '.session_id // "unknown"' 2>/dev/null)"
ts="$(date '+%Y-%m-%d %H:%M:%S')"
day="$(date '+%Y-%m-%d')"

root=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    root="$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)"
    name="$(basename "$root")"
    branch="$(git -C "$cwd" symbolic-ref --short -q HEAD 2>/dev/null || echo detached)"
    last="$(git -C "$cwd" log --oneline -1 2>/dev/null)"
    dirty="$(git -C "$cwd" status --porcelain 2>/dev/null | grep -c . | tr -d ' ')"
    ahead="$(git -C "$cwd" rev-list --count '@{u}'..HEAD 2>/dev/null || echo '-')"
    behind="$(git -C "$cwd" rev-list --count HEAD..'@{u}' 2>/dev/null || echo '-')"
    block="- **${ts}** · ${name} · branch \`${branch}\` · dirty:${dirty} · ahead:${ahead} behind:${behind}
  - last: ${last}
  - session: ${sid}"
else
    name="(no-git)"
    block="- **${ts}** · cwd \`${cwd}\` (not a git repo) · session: ${sid}"
fi

# 1) Always: append to a dated global snapshot file (never lost, cross-repo).
mkdir -p "$HOME/.claude/session-data"
gf="$HOME/.claude/session-data/${day}-auto-snapshots.md"
[ -f "$gf" ] || printf '# Auto session snapshots — %s\n\n_Mechanical, written by the SessionEnd hook. Rich narrative lives elsewhere._\n\n' "$day" > "$gf"
printf '%s\n\n' "$block" >> "$gf"

# 2) Append the snapshot to the VAULT SESSION.md — never the repo root.
#    SESSION artifacts live only in the vault (rule 085 / workdir-guard).
if [ -n "$root" ]; then
    if url=$(git -C "$cwd" remote get-url origin 2>/dev/null); then slug="${url##*/}"; slug="${slug%.git}"
    else slug="$name"; fi
    slug=$(printf '%s' "$slug" | tr '[:upper:]' '[:lower:]')

    # Gate the vault write (rule 035 §Vault Top Level). A hook that runs
    # `mkdir -p` on whatever cwd it happens to see manufactures vaults for
    # benchmark runs and scratch clones, and a fabricated vault is
    # indistinguishable from a real one a week later.
    # Two accepted proofs that the slug is a real project:
    #   (a) it is a row in _memory/REGISTRY.md — compared LITERALLY against the
    #       row's first table cell. Not a regex: a slug is a repo name and may
    #       contain regex metacharacters (`c++`, `foo.bar`), which would make a
    #       pattern match error out or over-match. Not a substring either: that
    #       hits any prose or path merely containing the word. Case-insensitive,
    #       because the slug is lowercased above while the registry keeps the
    #       repo's own casing (ApplyForge, Arix, LinguaFlash);
    #   (b) the repo lives under the owner's repository directory.
    # A missing REGISTRY.md means "unverified", not "empty" — never create it.
    vault_base="${XDG_DATA_HOME:-$HOME/.local/share}/agent-projects"
    registry="$vault_base/_memory/REGISTRY.md"
    write_vault=0

    if [ -f "$registry" ] && awk -F'|' -v s="$slug" '
            NF > 2 {
                cell = $2
                gsub(/^[ \t]+|[ \t]+$/, "", cell)
                if (tolower(cell) == s) { found = 1; exit }
            }
            END { exit !found }
        ' "$registry"; then
        write_vault=1
    else
        case "$root" in
            "$HOME/@-github/"*) write_vault=1 ;;
        esac
    fi

    if [ "$write_vault" -eq 1 ]; then
        ws="$vault_base/$slug/workspace"
        mkdir -p "$ws"
        printf '%s\n\n' "$block" >> "$ws/SESSION.md"
    fi
fi

exit 0
