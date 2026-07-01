---
name: session-protection
description: Never lose Claude Code session data across /compact, /clear, or exit. Wire PreCompact/PostCompact/SessionStart/SessionEnd hooks that back up the raw transcript, append a readable digest to the vault SESSION.md, and inject a resume pointer. Use when setting up a machine, auditing why context/history was lost, or configuring auto-compact safely.
origin: ECC
version: 1.0.0
updated: 2026-07-01
---

# Session protection (Claude Code hooks)

Claude Code discards in-context conversation on `/compact` (summarized) and `/clear`
(wiped). Durable work (commits, files, memory) survives, but the **conversation** is
lost unless a hook saves it first. These are **Claude Code hooks** (settings.json),
not git hooks.

## The four hooks

| Event | Script | Guarantee |
|---|---|---|
| **PreCompact** | `save-handoff.sh` | Copies the full raw transcript → `_memory/handoffs/<ts>_<event>_<sid>.jsonl` **before** compaction (manual or auto). Keeps the 40 most recent. |
| **PostCompact** | `save-summary.sh` | Appends the compaction summary → `<vault>/workspace/SESSION.md` as a readable digest. |
| **SessionStart** | `session-resume.sh` | Injects `additionalContext`: the project's central-TODO section + latest backup, so the agent resumes per rule `050-session-start` without guessing. |
| **SessionEnd** | `save-handoff.sh` | Same raw backup on `/clear` and exit. |

Canonical scripts + a `settings.snippet.json` live in
`templates/claude-code-hooks/`. Slug resolution matches `035-data-vault` (git remote
basename, lowercased). Requires `jq`.

## Install

```bash
cp templates/claude-code-hooks/*.sh ~/.claude/hooks/ && chmod +x ~/.claude/hooks/*.sh
# merge templates/claude-code-hooks/settings.snippet.json into ~/.claude/settings.json
#   — MERGE the hooks arrays; never replace existing hooks (e.g. session-snapshot, herdr)
# then open /hooks once (or restart) so Claude Code reloads config
```

## Why the events, not memory

Automated "before/after an event" behavior can only come from a hook — the harness
runs hooks, not the model. A rule that says "save before clearing" is unreliable
because the model may never get the turn. PreCompact/SessionEnd are the only
deterministic save points.

## `autoCompactWindow`

Set `"autoCompactWindow": 200000` to auto-trim old context. Safe **only because**
PreCompact backs up first — otherwise auto-compaction silently drops history. Raise
the value to retain more context per turn (higher cost), lower it to stay lean.

## Related skills (this skill is one layer of three)

- [[strategic-compact]] — *when* to compact: manual `/compact` at logical task
  boundaries for a cleaner summary. This skill makes compaction **safe** (backs up
  first); strategic-compact makes it **well-timed**. `autoCompactWindow` is a ceiling,
  not a substitute for compacting at boundaries.
- [[ck]] — structured per-project memory (context.json / CONTEXT.md) loaded on
  SessionStart. **Complementary layer**: ck curates project context; these hooks back
  up the raw transcript and point to it. If you run ck, `session-resume` just adds the
  central-TODO section + latest-backup pointer on top.
- [[context-budget]] — audit what fills the window (skills / MCP / rules bloat) so you
  compact less often in the first place.

## Gotchas

- Backups are raw `.jsonl` (complete, restorable) — not human summaries. The readable
  digest is the PostCompact → SESSION.md path.
- TODO status is **not** auto-updated by a hook (needs judgment); the agent maintains
  it per `050-session-start`. See [[035-data-vault]] for where SESSION.md lives.
- Merge hooks; don't clobber pre-existing SessionEnd/SessionStart hooks.
