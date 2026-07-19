---
title: "085OrchestrationTopology: Manager / Architect / Worker Topology"
description: Hub-and-spoke agent topology; repo agents stay in their own repo, only the manager crosses repos, enforced by the working-dir guard.
location: rules/085-orchestration-topology.md
agent_priority: High
last_updated: 2026-07-19
---

# Manager / Architect / Worker Topology

Orchestrator-worker topology. One human, one manager, per-repo architects,
per-repo workers, and independent reviewers ([[075-independent-review]]).

<!-- digest:start -->

## The Topology Law

```
owner ── talks to ──▶ MANAGER (watches @-github, cross-repo only)
                         │ assigns a task (a note / pointer, not code)
                         ▼
                     ARCHITECT (one per repo) ── writes the WO
                         │ delegates
                         ▼
                     WORKER (Gemini 3.1 Pro; $0-first) ── implements
                         │ delivers back
                         ▼
   REVIEWER-1 (independent) ─▶ fix+amend ─▶ REVIEWER-2 ─▶ architect sign-off
                         │
                         ▼
             owner gets test / merge / push command block
```

## Boundaries (blast radius)

- **A repo agent stays in its own repo.** It must NOT read, diagnose, or fix
  problems in another repo — even *noticing* another repo's bug burns tokens,
  pollutes its context, and it cannot fix it anyway (the fix re-delegates to
  that repo's agent, who re-derives everything). If it spots a cross-repo
  issue, it writes ONE pointer for the manager and stops.
- **Only the manager crosses repos**, and only by writing notes/pointers —
  never by implementing. But its hand is free: it may write in any repo.
- Enforced by `~/.claude/hooks/workdir-guard.sh` (PreToolUse Write|Edit):
  a write into a *different* `@-github/<repo>` is denied unless
  `CLAUDE_AGENT_ROLE=manager` (or cwd is the `@-github` root). Writes outside
  `@-github` (vault/SESSION.md, scratchpad, `~/.claude`) are always allowed.
  Kill-switch: `WORKDIR_GUARD=off`.

## The Manager (keep its context clean)

- **Metadata only.** The manager holds *which repo, which WO, what status* —
  never code, never transcripts. Content never enters its context.
- **State lives in files, not context.** Queue/status live in
  `~/.local/share/agent-projects/_memory/`; the manager re-reads them each
  turn. Architects report back ONE status line, not their work.
- **Lightweight / on-demand.** All premium sessions share one quota and run
  serially — the manager is not a heavy always-on session.

## Four corrections (owner, 2026-07-19)

1. Manager context stays metadata-only (above) — the top risk.
2. The manager is not a hard bottleneck: for deep single-repo work the owner
   may talk to that repo's architect directly. No "always only the manager".
3. Review loop is bounded: max 2 review rounds, then escalate to the owner —
   not an infinite reviewer-1 → fix → reviewer-2 chain.
4. Manager is light/metadata; heavy premium work stays with architects.

## Session accounting

Every session that commits must leave a SESSION.md summary before the owner
is told "safe to /clear" — enforced fail-closed by
`~/.claude/hooks/check-session-saved.sh` (PostToolUse commit + SessionEnd).

<!-- digest:end -->
