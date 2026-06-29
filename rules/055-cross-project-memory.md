---
title: "055: Cross-Project Memory"
description: How to maintain a global memory index for work that spans multiple repositories.
location: rules/055-cross-project-memory.md
agent_priority: Medium
last_updated: 2026-06-08
---

# Cross-Project Memory

## The Problem

Project-specific memory (per-repo MEMORY.md) only loads when you are inside that project.
Work that spans multiple repos — like a git hygiene session, a global rule change, or a
cross-repo refactor — has no natural home and gets lost between sessions.

## Solution: Global Memory Index

Maintain a **global memory directory** outside any single project:

```
~/.claude/global-memory/
├── MEMORY.md          ← index only — loaded on-demand
├── sessions/          ← cross-repo session summaries
│   └── YYYY-MM-DD-topic.md
└── archive/           ← entries older than ~6 months
    └── YYYY.md
```

> **Personalization:** Adjust `~/.claude/global-memory/` to match your own config path.
> Add a reference to it in your global `CLAUDE.md` (see below).

## Load Rule (Non-Negotiable)

**Do NOT load global memory on every session** — it adds token cost to all projects.

Load `~/.claude/global-memory/MEMORY.md` only when:

- The task involves **2 or more repositories**
- The user asks about a decision or event that was cross-project
- The current task might conflict with something decided in a prior cross-repo session

For single-project work: ignore global memory entirely.

## What Belongs Here

| Belongs in global memory | Does NOT belong here |
| --- | --- |
| Rules applied to all repos (e.g. ban AI co-authorship) | Project-specific bugs or features |
| Cross-repo session summaries | Code patterns or architecture for one repo |
| Decisions that affect every future project | Ephemeral task state |
| Tool/environment decisions (e.g. always use `uv`) | Things already in project MEMORY.md |

## Size Management

- **MEMORY.md is an index only** — one line per entry, no content
- **Hard cap: 30 entries** — when full, move the oldest to `archive/YYYY.md`
- Each line format: `-`Title`— one-line hook (max 120 chars)`
- Individual session files: keep concise, use tables over prose

## CLAUDE.md Integration

Add this section to your global `~/.claude/CLAUDE.md`:

```markdown
## Cross-Project Memory
Global memory lives at `~/.claude/global-memory/MEMORY.md`.
Read it only when the task spans multiple repos or the user asks about a cross-project decision.
Each MEMORY.md entry is one line. Cap at 30 entries — archive when full.
```

## File Format for Session Summaries

```markdown
---
name: topic-YYYY-MM-DD
description: one-line summary for the index
metadata:
  type: project
  scope: cross-repo
  date: YYYY-MM-DD
  repos: [repo1, repo2, ...]
---

## Permanent Decisions
(rules or choices that remain valid long-term)

## Repo Status at Close
| Repo | Status |
|---|---|
| repo1 | ✅ done |
| repo2 | ⏳ pending — what exactly |

## Pending Items
1. Short description — command or action needed
```

## Why Not Just Use the Global CLAUDE.md?

`CLAUDE.md` is for **rules** (how the agent should behave).
Global memory is for **facts** (what happened, what was decided).
Mixing them makes `CLAUDE.md` grow unbounded and blurs the line between instructions and history.
