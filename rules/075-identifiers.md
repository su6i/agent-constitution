---
title: "075Identifiers: Stable Identifiers Registry (REGISTRY-IDS)"
description: Canonical rule for stable, persistent IDs across branches, tasks, owner decisions, and inbox notes. Every reply with pending owner items must close with an id-keyed decision list.
location: rules/075-identifiers.md
agent_priority: High
last_updated: 2026-08-10
---

# Stable Identifiers Registry (REGISTRY-IDS)

To prevent ambiguous references across chat sessions, context resets (`/clear`), and agent dispatches, all identifiers used in communication with the owner, tasks, branches, decisions, and inbox notes must be globally unique and persistent.

## Single Source of Truth

<!-- digest:start -->
**`_memory/REGISTRY-IDS.md` is the single source of truth for all system identifiers.**

Identifiers must live outside session context so they remain valid across `/clear` resets and cross-session handoffs.
<!-- digest:end -->

## Identifier Prefixes

<!-- digest:start -->
Only the following official prefixes are permitted:

- **`B-`**: Branch (`B-001`)
- **`T-`**: Task (`T-001`)
- **`D-`**: Owner Decision (`D-001`)
- **`N-`**: Inbox Note (`N-001`)

A new prefix may be introduced **only** by an explicit owner decision. Ad-hoc or per-message local numbering (e.g. referencing items as "1", "2", "3" in chat) is strictly forbidden.
<!-- digest:end -->

## Permanent Locking

<!-- digest:start -->
**Permanent Lock:** Every assigned ID is permanently bound to its single topic.
Once assigned, an ID is never freed, reassigned, or reused — even after the item is completed, closed, or cancelled. Closed items must be moved to the "Closed" section of `_memory/REGISTRY-IDS.md`.
<!-- digest:end -->

## Numbering & Overflow Scheme

<!-- digest:start -->
1. **Sequential Allocation:** Next ID number = `max(existing numbers for prefix) + 1`.
2. **Standard Format:** 3-digit zero-padded string (e.g., `T-007`, `B-012`).
3. **Overflow Rule:** When a prefix reaches `900`, that prefix transitions to 4-digit formatting for subsequent allocations (e.g., `T-0900`, `T-0901`).
4. **No Historical Rewriting:** Existing 3-digit IDs (e.g., `T-007`) are never retroactively rewritten when overflow occurs; they remain permanently valid.
<!-- digest:end -->

## Agent Obligations

<!-- digest:start -->
1. **Communication Requirement (tightened 2026-08-10):** Any response or
   report to the owner that references numbered items must draw its numbers
   directly from `_memory/REGISTRY-IDS.md`. Local in-message numbering is
   prohibited. **Every reply that leaves anything pending on the owner's
   side must end with a numbered decision/action list, and every line of
   that list carries the item's stable id** (`B-`/`T-`/`D-`/`N-`). The owner
   has flagged the gap twice — "چرا بازم منتظر تصمیم/اقدام مالک رو با
   registry-ids ندادی؟" — a closing list without ids is not a lesser
   violation than bare `1/2/3` numbering, it is the *same* violation moved to
   the end of the message, and a reply missing it is incomplete.
2. **Session End Registration:** Every architect is obligated to register any newly generated items in `_memory/REGISTRY-IDS.md` before session end (enforced mechanically via the `SessionEnd` hook backstop).
<!-- digest:end -->

Enforced mechanically by the `Stop` hook
`templates/claude-code-hooks/enforce-identifiers.py`: it blocks bare numbered
lists lacking an id (original check) **and**, per the 2026-08-10 tightening
above, also blocks a message that contains an "awaiting owner decision/action"
heading with no id anywhere after it — the exact failure mode the owner
reported, where the heading exists but the ids under it don't. See the hook's
own header comment for the literal patterns it matches.
