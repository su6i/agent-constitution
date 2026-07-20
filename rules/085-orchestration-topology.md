---
title: "085OrchestrationTopology: Manager / Architect / Worker Topology"
description: Hub-and-spoke agent topology; repo agents stay in their own repo, only the manager crosses repos, enforced by the working-dir guard.
location: rules/085-orchestration-topology.md
agent_priority: High
last_updated: 2026-07-20
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

## Message addresses

- `<agent inbox> = /Users/su6i/.local/share/agent-projects/<project>/workspace/inbox/`
- Manager inbox: `/Users/su6i/.local/share/agent-projects/@-github/workspace/inbox/`

Inboxes live in the vault, never inside a git repo. No agent may invent a mailbox path.

## Manager Charter: The Queue

The manager maintains ONE cross-project queue (`_memory/QUEUE.md`) that sequences every task across every repo. Every WO must appear in the queue with a tier + gate; a WO not in the queue is invisible and won't run.

## End-to-End Management Workflow

1. **owner** → manager (message)
2. **manager** → writes task-note to repo architect's inbox (metadata + pointers only)
3. **architect** → writes WO in `<repo>/workspace/wo/` (rule 070 format)
4. **architect** → calls worker (agy $0 default) to implement
5. **worker** → implements on a feature branch
6. **reviewer** (headless architect, fresh context) → code review, verdict only
   - Max 2 review rounds. Reviewer must label each finding **blocking** vs **cosmetic**; a round is triggered only by blocking findings.
   - If still failing after 2 rounds, escalate to owner with the option to "authorize one more round", do not silently merge.
7. **architect** → commit/amend on branch
8. **owner** → approves merge (owner-only per rule 040)
9. **architect** → reports ONE status line to manager
10. **manager** → reports outcome to owner

*Data flow constraint*: Metadata up, never code/diffs to manager.

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
  serially — the manager is not a heavy always-on session. Resting footprint is zero tokens.
- **Not a hard bottleneck**: For deep single-repo work, the owner may talk to that repo's architect directly. If the work has cross-repo impact, the architect drops a one-line note in the manager's inbox.

## No Submodules & Knowledge Service

- **No submodules**: The ONLY way a repo consumes the constitution is a symlink: `.agent/constitution -> /Users/su6i/@-github/agent-constitution`. No git submodule (no `.gitmodules`, no gitlink). Repo-local skills/rules are forbidden unless extracted upstream first.
- **RAG Knowledge Service**: Rules, skills, and sessions are served via the knowledge service once live. Agents query rather than fork.

## No Unauthorized Folder Creation

Agents may NOT create a new directory — in a repo OR the vault — without manager permission. Standard folders (`workspace/`, `workspace/inbox/`, `workspace/wo/`) are pre-authorized.

## Session accounting

Every session that commits must leave a SESSION.md summary before the owner
is told "safe to /clear" — enforced fail-closed by
`~/.claude/hooks/check-session-saved.sh` (PostToolUse commit + SessionEnd).

<!-- digest:end -->
