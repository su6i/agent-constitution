#!/bin/bash
# ─── Agent Constitution · bin/sync-repo-hooks.sh ──────────────────────────
# Canonical source: agent-constitution/bin/sync-repo-hooks.sh
#
# PURPOSE
#   Re-sync the per-repo git hooks that repos vendor into their own
#   .git/hooks/ from this repo's templates/hooks/. Those copies drift: a fix
#   landed here reaches a repo only when someone copies it over, and
#   bin/sync-projects.sh does not touch hooks at all. WO-constitution-0016
#   found all 20 repos on the owner's machine carrying a pre-commit older
#   than the template, every one of them still blocking commits on the
#   git@github.com false positive fixed here.
#
#   Distinct from install.sh's install_global_git_hooks(), which installs the
#   machine-global core.hooksPath layer (_dispatch + the guards). This script
#   only refreshes the per-repo copies described in README's "Git Hooks".
#
# USAGE
#   bin/sync-repo-hooks.sh                 # dry run over ~/@-github/*
#   bin/sync-repo-hooks.sh --apply         # actually copy
#   bin/sync-repo-hooks.sh --apply <repo>… # only the named repo paths
#
# Dry run is the default on purpose: these files are commit-time gates, and
# overwriting one in 20 repos unattended is not something to do by accident.
#
# EXIT CODES
#   0  nothing drifted, or the copies were applied
#   1  drift found while in dry-run mode (so CI can gate on it)
#   2  bad invocation

set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
templates="${here}/templates/hooks"
apply=0
hooks="pre-commit pre-merge-commit commit-msg"

[ -d "${templates}" ] || { echo "no templates/hooks at ${templates}" >&2; exit 2; }

targets=""
for arg in "$@"; do
    case "${arg}" in
        --apply) apply=1 ;;
        -h|--help) sed -n '2,28p' "${BASH_SOURCE[0]}"; exit 0 ;;
        -*) echo "unknown flag: ${arg}" >&2; exit 2 ;;
        *)  targets="${targets} ${arg}" ;;
    esac
done
[ -n "${targets}" ] || targets="$(echo "${HOME}"/@-github/*)"

drift=0
synced=0
for repo in ${targets}; do
    [ -d "${repo}/.git" ] || continue
    for hook in ${hooks}; do
        src="${templates}/${hook}"
        dst="${repo}/.git/hooks/${hook}"
        [ -f "${src}" ] || continue
        [ -f "${dst}" ] || continue          # repo never installed it — not ours to add
        cmp -s "${src}" "${dst}" && continue
        drift=$((drift + 1))
        if [ "${apply}" = "1" ]; then
            cp "${src}" "${dst}"
            chmod 755 "${dst}"
            synced=$((synced + 1))
            echo "synced   ${repo#"${HOME}"/}/.git/hooks/${hook}"
        else
            echo "drifted  ${repo#"${HOME}"/}/.git/hooks/${hook}"
        fi
    done
done

if [ "${apply}" = "1" ]; then
    echo "── ${synced} hook(s) synced ──"
    exit 0
fi
if [ "${drift}" -gt 0 ]; then
    echo "── ${drift} drifted hook(s); re-run with --apply to copy ──"
    exit 1
fi
echo "── all vendored hooks match templates/hooks/ ──"
exit 0
