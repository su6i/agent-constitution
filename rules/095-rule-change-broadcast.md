---
title: "095RuleChangeBroadcast: Announcing a Rule Change"
description: Every merge that changes rules/ is announced — CHANGELOG entry, a note to every active architect's inbox, and an RAG re-index. Owner of the index is the ai-router architect; the manager audits weekly.
location: rules/095-rule-change-broadcast.md
agent_priority: High
last_updated: 2026-07-28
---

# Announcing a Rule Change

## Why

A rule that reaches `main` is not yet a rule that anyone follows. Three
different populations read the rules, and only one of them updates itself:

| Reader | Updates on merge? |
| --- | --- |
| A **new** session | Yes — it reads `rules/` from disk at start (rule 050), so it is current by construction. Nothing to do. |
| An **already-open** session | No. It holds the text it read at start and will keep applying the old rule for the rest of its life. |
| The **RAG knowledge service** | No. The index is built, not live; without a re-index it serves the superseded text to every agent that queries it — the failure mode that outlives the session. |

The broadcast exists for the second and third rows. It is not paperwork about
the first.

## Rule (Non-Negotiable)

<!-- digest:start -->
Any merge into `main` that adds, deletes, or edits a file under `rules/` is a
**rule change** and triggers all three of the following. Partial compliance is
non-compliance — an un-re-indexed change is invisible to every agent that asks
the knowledge service instead of reading the file.

1. **CHANGELOG entry** in the constitution repo, naming the rule file and what
   changed in it — not "updated rules". This is the durable record; the other
   two steps are delivery.
2. **Broadcast note** to the inbox of every active architect, sent through the
   ai-router note channel (`send_note`), addressed per rule 085 §Message
   addresses. Content: rule number, one line on what changed, the absolute path
   of the file — pointer only, never the rule text (rule 045: one home per
   piece of knowledge). Open sessions are reached by the note landing in the
   inbox they triage at their next task boundary (rule 050).
3. **RAG re-index** triggered for the rules corpus.

Ownership, so that none of the three is nobody's job:

- The **architect who merged the change** sends the note and triggers the
  re-index. It is part of the merge, not a follow-up task.
- The **ai-router architect owns the RAG index** — its build, its freshness,
  and the trigger endpoint. Other architects call the trigger; they never
  reach into the index.
- The **manager audits weekly**: for each rule-touching CHANGELOG entry of the
  past week, was a note sent and was the index re-indexed after it. A miss is
  reported to the owner, not silently repaired.

**Constitution-side changes ripple by symlink** (`.agent/constitution ->`
the repo, rule 085): consuming repos need no pull, which is exactly why the
change is silent and needs announcing.
<!-- digest:end -->

## Not covered

- Changes to `skills/`, `templates/`, `bin/`, or docs — a skill is read on
  demand at use time, so a stale open session picks up the new version at its
  next read. Announce only if a skill's *contract* changed (renamed, removed,
  or its meaning inverted).
- Regenerating `rules/DIGEST.md` alongside a rule edit is part of that same
  change, not a second one.
