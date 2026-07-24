---
title: "050: Session Start Protocol"
description: At the start of every session, read TODO.md and announce pending items before taking any action.
location: rules/050-session-start.md
agent_priority: High
last_updated: 2026-06-30
---

# Session Start Protocol

## Step 0 — Read Rules & Affirm (Non-Negotiable)

<!-- digest:start -->
Before ANY action in a new session:

1. Read `rules/000-core.md` and `rules/040-git.md` (plus any rule relevant to the task).
2. Post a short, free-form acknowledgement that you have read them and will comply — covering at least: branch-first (never `main`), no AI co-authorship, the pre-commit security scan, `--amend` for minor follow-ups, readable commands (no long `&&` chains), and the merge gate.
<!-- digest:end -->

Then continue with the steps below.

## Rule (Non-Negotiable)

<!-- digest:start -->
**At the start of every session — before any action — these steps are mandatory:**

1. Read the **single central TODO** at
   `${XDG_DATA_HOME:-~/.local/share}/agent-projects/_memory/TODO.md` — one file for
   ALL projects, with a `## <project>` section each (`<project>` = the vault slug,
   see `035-data-vault.md`). Read the **current project's section** plus the
   `## 🌐 Cross-project` section. There is no per-repo `TODO.md` any more — repo-root
   `TODO.md` is personal and would get committed by accident (e.g. through a merge,
   which the pre-commit hook does not scan).
2. Read the Mailbox (`<vault>/workspace/inbox/`) and announce any unread inbox items (e.g., manager↔architect notes).
3. If the central TODO exists: read it and announce all open items grouped by priority level.
4. Announce **open branches**: run `bin/open-branches.sh --here` (or `git branch --no-merged main`) and list any unmerged / stale (>14 days) branches so they get finished, merged, or deleted — half-done branches must not be forgotten.
5. Ask: "Where do we start?"
<!-- digest:end -->

## Announcement Format

```
📋 TODO — [N] open items:

Level 1 (incomplete / in-progress):
  • [item title]

Level 2 (high-impact features):
  • [item title]

Level 3 (long-term):
  • [item title]

Known bugs:
  • [bug title]

🌿 Open branches (unmerged into main):
  • feature/foo — 3 ahead, last 12 days ago  ⚠️ stale
  • fix/bar     — 1 ahead, last 2 days ago

Where do we start?
```

To scan **all** projects at once (catch branches in repos you have not opened
in weeks), run `bin/open-branches.sh` — it reports unmerged / stale branches
across every git repo under `~/@-github`.

## TODO Update Rule (Non-Negotiable)

<!-- digest:start -->
**All tasks — for every project — go in the one central TODO**
(`_memory/TODO.md`), under that project's `## <project>` section. Never create a
per-repo `TODO.md`. New task → add it under the right project section. This is how a
solo operator sees every project's work in one place and nothing is forgotten.

**After completing any TODO item — before committing — update the central TODO:**

- Mark the item as done: `- [x]` and add completion date
- Update the status if present

A task is not done until the central TODO reflects it.
<!-- digest:end -->

## Task Execution Pipeline (Every Task)

Follow this full lifecycle for every task — keep it in mind throughout, not only at session start:

1. **Branch first** — `git checkout -b feature/<task>`; never edit or commit on `main`/`master`.
2. **Work in small, reviewable steps.** Keep shell commands readable (no long `&&` chains) so the user can supervise each one.
3. **Update docs before staging** — `README.md` (usage / features / structure), technical docs under `docs/`, `CHANGELOG.md`, the local `SESSION.md` work log, and `TODO.md` (per the rule above).
4. **Security-scan** the staged diff (`git diff --cached`): no names, emails, phones, keys, or personal paths — and never describe the sensitive value in the commit message.
5. **Commit** with a conventional message. A minor follow-up to the previous commit is a `git commit --amend` (while unpushed), NOT a new commit.
6. **Merge gate** — stop after committing and get explicit user approval before merging to `main`.

## Session Lifecycle & Context Hygiene (Non-Negotiable)

<!-- digest:start -->
State that must survive a session lives in **durable files** — `SESSION.md`
(vault `workspace/`), the central `_memory/TODO.md`, and memory — never only in a
long live context window. A raw transcript backup is written **automatically** on
session end (`_memory/handoffs/*.jsonl`), so nothing is ever truly lost; but the
curated, readable `SESSION.md` is the **agent's** job — update it proactively when
the owner signals wrap-up, before any `/clear`.

- **Never `/clear` mid-task.** Finish the step, update `SESSION.md`, then clear.
- **Between tasks:** write `SESSION.md`, then `/clear` (or `/compact` above
  ~100k context). The state is externalised, so clearing loses nothing.
- **Task Done / Ready to test:** The update-`SESSION.md` gate is **"Ready to test" and "task done"**, NOT "session end". Any merge-ready delivery must have `SESSION.md` updated (branch tip, change summary, waiting status) **before/with** the message announcing it — the loss window is precisely between "Ready to test" and the owner's `/clear`.
- **Architect sessions** (design/review, premium model): one task per session;
  reference earlier work by re-reading `SESSION.md`/`TODO.md`, **not** by keeping
  a fat context alive — >150k context is where subscription quota burns.
- **Worker sessions** (cheap models): `/clear` freely; their state is the WO file
  plus the git branch, both external.

The rule is: **externalise the useful part, then context is cheap to reload and
`/clear` costs nothing.** Preserving raw context in the window instead is the
expensive anti-pattern.
<!-- digest:end -->

## Closeout-Agent Architecture

<!-- digest:start -->
**Problem:** Saving the session by the architect in a fat context is the most expensive state.
**Solution:**

- The architect makes all decisions but leaves only a short "closeout note" (decisions/open status, a few lines) at the end of the task.
- A cheap sub-agent (e.g., `Haiku`, `Sonnet`, or `agy $0`) is invoked to do the mechanical writing: update `SESSION.md`, `README`, `CHANGELOG`, `docs`, stage the changes, and run `git commit --amend` per rule 040.
- **Hybrid Timing (Main + Fallback):**
  - **Main Path:** A `SessionEnd` hook invokes the cheap agent with the architect's closeout note to write the digest immediately at the end of the session.
  - **Safety Net:** `SessionStart` checks if a digest was created for the previous session's `jsonl`. If not (e.g., due to a crash where the hook didn't fire), it runs the cheap agent on the raw backup before proceeding.
- **Prune step (last, after the digest is written):** the closeout agent runs
  `bin/rotate-sessions.sh --keep 4` on the project's `SESSION.md`. The raw
  `.jsonl` handoff (`_memory/handoffs/`) is the append-only backup — nothing
  is ever truly lost — so `SESSION.md` only needs to stay a **curated, living
  doc**: current state, live decisions, open work. Sessions beyond the last 4
  are replaced in place by a one-line pointer and their full text is moved to
  `<workspace>/archive/SESSION-<YYYY>.md`. Idempotent — safe to run every
  closeout even if nothing is due for archiving.
- **Merge is always done by the architect/owner** (to avoid branch-rename incidents).
<!-- digest:end -->

## Notes

- If the central `_memory/TODO.md` has no section for this project yet: create one (`## <project>`)
- `SESSION.md` (per-project work log) lives in `<vault>/workspace/`; the TODO is the one central `_memory/TODO.md` — neither is in the repo, so neither can be committed by accident (see `035-data-vault.md`)
- If the project has no `TODO.md`, check for `ROADMAP.md` or `TASKS.md` in the same workspace

## Why This Rule Exists

Without a session-start announcement, context from previous sessions is lost and the agent
starts cold — repeating work, missing in-progress items, or asking the user to re-explain
what was already decided. This rule ensures continuity across sessions.
