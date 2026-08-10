---
title: "085OrchestrationTopology: Manager / Architect / Worker Topology"
description: Hub-and-spoke agent topology; repo agents stay in their own repo, only the manager crosses repos, enforced by the working-dir guard.
location: rules/085-orchestration-topology.md
agent_priority: High
last_updated: 2026-08-10
---

# Manager / Architect / Worker Topology

Orchestrator-worker topology. One human, one manager, per-repo architects,
per-repo workers, and independent reviewers ([[076-independent-review]]).

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

**The manager's own WOs live in `_memory/wo/`, never in
`agent-projects/@-github/workspace/wo/`.** `@-github` is the manager's
umbrella, not a repo with its own code — any WO the manager writes is
cross-project by construction, so rule 070's single-repo path
(`agent-projects/<repo>/workspace/wo/`) never applies to it, no matter how
natural that path looks by analogy with the manager's own inbox
(`agent-projects/@-github/workspace/inbox/`, above). See rule 070 §WO
location for the full split and D-029 (2026-08-09) for the incident this
closes; a PreToolUse guard (`templates/claude-code-hooks/workdir-guard.sh`)
denies the wrong path mechanically.

## Idea-to-WO Immediacy (Owner Decree 2026-08-09)

**Every topic or idea handed to the manager immediately calls a warm
architect to write a WO and place it in the queue — no exceptions, nothing
deferred.** An idea that is only "noted" in a chat reply is a lost idea: chat
scrolls away, sessions get `/clear`ed, and a note that never became a WO
never enters `_memory/QUEUE.md`, so it is invisible to every future session
(§Manager Charter above). Taking a note in the chat response is not a
substitute for writing the WO — it is, at most, the raw material for one.

Concretely: the owner names a topic → the manager spawns (or resumes) that
repo's architect in the same turn → the architect writes the WO (rule 070
format, in the correct location per §Manager Charter above) → the WO is
added to `_memory/QUEUE.md` with a tier and gate, even if the gate is "needs
owner decision" or "blocked on X". A topic without a WO-in-the-queue does not
count as handled, regardless of how much was said about it in chat.

## End-to-End Management Workflow

1. **owner** → manager (message)
2. **manager** → writes task-note to repo architect's inbox (metadata + pointers only)
3. **architect** → writes WO in `<repo>/workspace/wo/` (rule 070 format) —
   this step is for a repo architect's own repo only; the manager's own
   cross-project WOs follow §Manager Charter above, never this path
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

## Three-Layer Delegation

Steps 4–7 above have a fixed shape for implementation WOs. The owner approved
it on 2026-07-21; it stayed a proposal and sessions therefore ignored it. It is
a rule from 2026-07-28.

Default for an implementation WO of roughly 200–500 lines (code + tests +
docs). Each layer does only what the layer below cannot:

| Layer | Agent | Does | Must not |
|---|---|---|---|
| 3 — architect | premium (Opus/Fable) | writes the WO, dispatches layer 2, runs a short independent final check (git log + tests + lint) | read the full diff, implement |
| 2 — dispatcher/reviewer | Sonnet subagent | dispatches the WO to the worker, reviews architect-style (tests from a neutral CWD, DoD checked live, executor claims distrusted), repairs and amends on the branch, hands up **only with green tests** | author the WO it reviews |
| 1 — worker | agy / Gemini 3.1 Pro (`$0`) | executes the whole WO on the branch under the injected runlog gates | merge, push, decide scope |

Binding clauses:

1. **The default code channel is agy, not flash** — the `$0` ladder of rule 070
   §Executor Routing decides the executor; the layers decide who talks to whom.
2. **The worker stays warm.** The first verify failure goes back to the *same*
   worker session, which still holds the context. The reviewer layer enters
   from the second failure onward — a cold reviewer re-deriving what the worker
   already knows is the expensive path. See rule 076 §The defect→prompt loop
   items 5–6 (owner ruling 2026-08-10) for the same discipline applied to a
   report that is merely thin rather than gate-failing, the screenshot-evidence
   extension for browsing/verification tasks, and the "suspect your prompt
   first" corollary.
3. **The architect's final check is not removable.** Layer 2 can overclaim as
   easily as layer 1; the check is a few commands, not a re-read of the diff.
4. **Usage per run goes to the manager** (which layer, how long, what it cost)
   so the executor benchmark accumulates evidence instead of anecdote.

Exempt from the three layers — the architect writes directly:

- a change under ~40 lines, or a small fix to worker output after a failed verify;
- secrets and config wiring;
- design-critical logic where correctness *is* the task (algorithm, security,
  protocol);
- **constitution rule text** (rule 070 §Executor Routing: cheap workers never
  edit rule text).

Delegating is still not optional outside those exemptions: an architect that
implements a routine 300-line WO itself has burned premium quota on `$0` work.

Evidence base: `_memory`-side note `NOTE-2026-07-21-three-layer-delegation-proposal.md`
— three consecutive merge-ready deliveries (`wo-0021`, `wo-0017`, `wo-0018`),
worker cost `$0`, real blocking defects caught in layer 2, premium involvement
compressed to "write the WO, dispatch, final check".

<!-- digest:start -->

## Maximum Low-Risk Parallelization (Owner Mandate 2026-08-10)

Owner ruling 2026-08-10 — a **mandate, not permission**:

> برای موازی‌سازی همیشه حداکثر موازی‌سازی کم‌ریسک رو انجام بده بدون پرسش

If a hundred tasks could run in parallel with low risk and zero interference,
the agent is **authorized to run all hundred without asking** — this
explicitly covers dispatching WOs across different repos, and several WOs
within the same repo when they do not touch the same files. Asking "should I
parallelize these?" when the test below already answers yes is itself the
failure mode this rule forbids.

**The operative test:** parallelize whenever the tasks touch disjoint
files/branches/repos AND none of them is a gate/blocker for another.
Serialize only on a genuine conflict — the same file, the same branch, or a
real dependency edge where one task's output is another's input.

**Reconciling with context hygiene** (rule 050 §Session Lifecycle: "premium
sessions run serially... all Claude sessions share one quota"): the two rules
are not in tension once the layer is named. **Parallelism belongs to the
workers** — agy/Gemini/DeepSeek run outside the shared premium quota, so
fanning out a hundred worker dispatches costs nothing to run side by side.
Premium architect/manager sessions still queue serially, one task each,
because they share one metered quota. So: fan out worker dispatches
aggressively and by default (this section); keep premium sessions to one
active task at a time (§The Manager below).

<!-- digest:end -->

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
  serially — the manager is not a heavy always-on session. Resting footprint
  is zero tokens. (This is about premium sessions specifically, not about
  worker dispatch — see §Maximum Low-Risk Parallelization above, which fans
  workers out aggressively.)
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
