---
title: "045: Single Source of Truth for Design Docs"
description: Design content lives in exactly one file; everything else points to it. Committable design docs live in the repo; private working docs live in the vault (035) and never enter git (040) — if one was committed, purge it from history.
location: rules/045-single-source-docs.md
agent_priority: High
last_updated: 2026-07-02
---

# Single Source of Truth for Design Docs

## Why

The same decision was being written into session logs, the central TODO, and
repo docs. They drift: one gets updated, the others don't, and the next agent
finds contradictions and either stalls or picks the stale version. Separately,
private working docs (handoffs, playbooks, internal reviews) were being
committed to repos destined for GitHub — permanent history for files that were
never meant to be public.

This rule adds two things on top of `035-data-vault` (where uncommittable
files live) and `040-git` (which files never enter git): **one home per piece
of knowledge**, and **history purge** when a private file was committed anyway.

## Rule (Non-Negotiable)

Every piece of project knowledge has exactly one home:

| Content | Single home | Everything else holds |
| --- | --- | --- |
| Public design / architecture / ADRs | Repo docs (`ARCHITECTURE.md`, `docs/`) | a pointer |
| Private design, playbooks, internal reviews, work orders / handoff (`NEXT-SESSION.md`) | Vault: `<vault>/workspace/` (see `035-data-vault`) | a pointer |
| Tasks / status | The ONE central `_memory/TODO.md`, `## <project>` section (`050`) — never a repo file (`040`), never a per-project file | one-line pointers + dates |
| What happened when | `workspace/SESSION.md` (append-only log) | nothing — logs are not truth |

- **Public vs private is decided by one question:** would you publish this
  file on GitHub as-is? If not, it is vault material — per `035`'s golden
  rule it must not even sit inside the repo working tree.
- **Never copy design content into TODO/SESSION/memory.** Write one line:
  what changed + where the truth lives (path, commit).
- **On conflict, the single home wins.** Fix the pointer file in the same
  session you notice the conflict; do not "interpret around" it.
- **When a decision changes, edit its single home first**, then update
  pointers. A change that only lands in a log or a TODO is not a decision.

## History Purge (Non-Negotiable)

If a vault-class file (private doc, TODO/SESSION-class file per `040`) is
found **committed** in any repo:

1. Move the working copy to the vault (`035` — a filesystem move, not a
   commit).
2. Purge the file from **all git history** (`git filter-branch`/
   `git filter-repo` + reflog expire + gc). `git rm --cached` alone leaves it
   in history forever.
3. If the repo has a remote that already received it, treat it as a leak:
   force-push the rewrite and note it in the central TODO.

## Litmus Test

If deleting a file would lose information that exists nowhere else, it is a
source of truth — it must have exactly one such role. If deleting it loses
nothing, it is a pointer — it must contain no design content.
