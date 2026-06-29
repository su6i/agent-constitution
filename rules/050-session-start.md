---
title: "050: Session Start Protocol"
description: At the start of every session, read TODO.md and announce pending items before taking any action.
location: rules/050-session-start.md
agent_priority: High
last_updated: 2026-06-30
---

# Session Start Protocol

## Step 0 — Read Rules & Affirm (Non-Negotiable)

Before ANY action in a new session:

1. Read `rules/000-core.md` and `rules/040-git.md` (plus any rule relevant to the task).
2. Post a short, free-form acknowledgement that you have read them and will comply — covering at least: branch-first (never `main`), no AI co-authorship, the pre-commit security scan, `--amend` for minor follow-ups, readable commands (no long `&&` chains), and the merge gate.

Then continue with the steps below.

## Rule (Non-Negotiable)

**At the start of every session — before any action — these steps are mandatory:**

1. Look for `TODO.md` in the project root
2. If it exists: read it and announce all open items grouped by priority level
3. Ask: "Where do we start?"

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

Where do we start?
```

## TODO Update Rule (Non-Negotiable)

**After completing any TODO item — before committing — update `TODO.md`:**

- Mark the item as done: `- [x]` and add completion date
- Move it to a `## Completed` section at the bottom
- Update the status table if present

This is part of the commit. A task is not done until `TODO.md` reflects it.

## Task Execution Pipeline (Every Task)

Follow this full lifecycle for every task — keep it in mind throughout, not only at session start:

1. **Branch first** — `git checkout -b feature/<task>`; never edit or commit on `main`/`master`.
2. **Work in small, reviewable steps.** Keep shell commands readable (no long `&&` chains) so the user can supervise each one.
3. **Update docs before staging** — `README.md` (usage / features / structure), technical docs under `docs/`, `CHANGELOG.md`, the local `SESSION.md` work log, and `TODO.md` (per the rule above).
4. **Security-scan** the staged diff (`git diff --cached`): no names, emails, phones, keys, or personal paths — and never describe the sensitive value in the commit message.
5. **Commit** with a conventional message. A minor follow-up to the previous commit is a `git commit --amend` (while unpushed), NOT a new commit.
6. **Merge gate** — stop after committing and get explicit user approval before merging to `main`.

## Notes

- If `TODO.md` does not exist: inform the user and offer to create it
- `TODO.md` should be in `.gitignore` — it is a local workspace file, not tracked
- If the project has no `TODO.md`, check for `ROADMAP.md` or `TASKS.md` as alternatives

## Why This Rule Exists

Without a session-start announcement, context from previous sessions is lost and the agent
starts cold — repeating work, missing in-progress items, or asking the user to re-explain
what was already decided. This rule ensures continuity across sessions.
