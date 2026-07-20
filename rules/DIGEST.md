# Rules Digest — Non-Negotiables (auto-generated)

<!-- DO NOT EDIT. Re-run `bin/generate-digest.sh` to regenerate. -->
<!-- Source: rules/*.md  ·  Mechanism: rules/045 §Digest Mechanism  -->
## From 000-core.md

Agents SHOULD route **all** worker-model calls (Gemini/agy, DeepSeek, MiniMax)
through the ai-router door — `delegate_worker` / `delegate_agent` — and never
launch a worker CLI directly. The router provides the cost ledger, budget caps,
and the context-discipline pack; a direct CLI call bypasses all three. The
architect calls the worker channel itself (one tool-call + a short summary),
rather than asking the owner to run it and paste the output back — relaying
costs the same tokens twice plus a round-trip. **Exception:** hours-long
interactive tasks (training/benchmark grids) go to a separate owner-started
session. This becomes a MUST once ai-router `wo-0014`'s enforcement hook lands.
Any command the agent asks the human to run must be runnable **as-is in a
brand-new terminal**:

- **Absolute paths only** — never assume a working directory, never use
  relative paths.
- **One complete command per line** — no `&&`/`;` chains, no multi-step
  one-liners. Readability beats cleverness.
- Nothing left for the human to fill in, unless a placeholder is explicitly
  marked (e.g. `<PASTE-TOKEN-HERE>`).
- If a step needs more than one command, give a numbered list — one
  copy-pasteable line per step.
All repository content is English only — code, comments, identifiers,
print/log strings, commit messages, documentation, and config files. The whole
world reads this code. This applies to **every** project, not just this repo.

Persian (or any other language) is allowed ONLY as project documentation
translations, and ONLY under **`docs/fa/`** (sub-folders under it are fine when
a document needs them). The repo root must stay clean: **no Persian file at the
root** — not even `README.fa.md` (put it at `docs/fa/README.md`).

The single allowed exception outside `docs/fa/`: one linking word/phrase inside
the English `README.md` pointing to the Persian docs.

Enforcement is mechanical, not prose: the pre-commit hook and CI scan staged
added lines for Arabic-script characters (U+0600–U+06FF) outside the allowed
paths and block the commit; a periodic sweep tool cleans up pre-existing
content.
Every error you observe — lint, type, test, build, LaTeX, runtime, deprecation
warning — must be either **fixed now** or **recorded in the central
`_memory/TODO.md`** (the project's `## <project>` section — rule 050) for later.
Seeing an error and moving on without doing one of those two is forbidden.

- "It was already there" / "not caused by my change" is **not** a reason to
  ignore it — record it.
- When you defer a fix (e.g. to keep a commit's scope clean), immediately add an
  item under the project's section in the central `_memory/TODO.md` with the
  exact `file:line` and the error message.
- Applies to errors surfaced by any tool you run, not only the files you edited.
Every piece of knowledge acquired by any agent (architect or worker) during any task must be **recorded** — we pay for every token.
- **Mandatory Extraction:** Before archiving, deleting, or closing any repository or session, extracting and recording its knowledge is mandatory and obvious (do not ask for permission).
- This requirement underscores the necessity of a knowledge-service (RAG) in the AI router to ensure all acquired knowledge is properly logged and centrally maintained instead of being scattered or lost.## From 035-data-vault.md

**If a file must never be committed, it must not live inside the repo.**

`.gitignore` alone is not enough — a personal file inside the working tree is one
accident away from a commit (e.g. it can enter through a **merge**, which the
`pre-commit` hook does not run on). The only safe place for uncommittable data is
**outside the repo**, in the central vault.
A committed `CLAUDE.md` (and every harness bootloader — `GEMINI.md`, `GROK.md`,
`QWEN.md`, `MINIMAX.md`, `.cursorrules`, `.windsurfrules`,
`.github/copilot-instructions.md`) is **public**. It must be **generic, English,
security-vetted, and byte-identical to the canonical `templates/CLAUDE.md`** — a
thin bootloader that only routes the agent to `rules/DIGEST.md` → `AGENTS.md` →
`rules/`. It must contain **zero** project-specific, personal, or session data:
no names, emails, personal paths (`$HOME/@-...`), session decision logs, other
projects' details, or third-party contact info.

Project-specific agent guidance goes in **`CLAUDE.local.md`** — gitignored, never
committed (rule 040 blocks `*.local.md`) — which may symlink to
`<vault>/workspace/CLAUDE.local.md`. Claude Code auto-loads it locally without it
ever entering git.

Enforcement is mechanical: the pre-commit hook blocks a `CLAUDE.md` whose content
does not match `templates/CLAUDE.md` (hash), and the PII scan blocks personal
data in any bootloader. History that already leaked such data is a
rule-035/040 incident — scrub it (`git filter-repo`) and force-push.## From 036-skill-versioning.md

**Every skill file must carry `version:` and `updated:` in its frontmatter:**

```yaml
---
name: my-skill
description: ...
version: 1.2.0      # semver
updated: 2026-06-30 # ISO date of the last change
---
```

**After ANY change to a skill — before committing — you MUST:**

1. Bump `version:` using semver:
   - **patch** (`1.2.0 → 1.2.1`) — typo, clarification, small fix
   - **minor** (`1.2.0 → 1.3.0`) — new section, new capability, additive
   - **major** (`1.2.0 → 2.0.0`) — rewrite or breaking change to guidance
2. Set `updated:` to today's date.

A skill edit without a version+date bump is an **incomplete change** — the same
status as code changed without updating docs (`040-git`). Do not commit it.## From 040-git.md

The per-commit scan only sees **added** lines — a leak already sitting in a
tracked file is never re-flagged (this is how a public `CLAUDE.md` leaked names,
personal paths, and a third party's email for weeks). Therefore, **before merging
any branch into `main`, and on a periodic audit, scan the entire tracked tree —
not just the diff** — for secrets / personal data (`bin/security-audit.sh`). A
finding blocks the merge until the file is scrubbed (moved to the vault per 035)
or explicitly allow-listed. A leak found in history is a rule-035/040 incident:
purge with `git filter-repo` and force-push (owner only).
When a commit fixes or touches a security/privacy issue, the commit message must
**never describe the issue or reveal the sensitive data**. Forbidden examples:

- `remove phone number 0775XXXXXX from config`
- `scrub email / API key from <file>`
- `remove the candidate's name from a comment`

Why: commit messages are permanent and searchable in git history. Naming the
change is a signpost pointing an attacker straight at the sensitive data — and
the message persists even after the data itself is removed.

Rules:

- Describe **only** the neutral functional change (the *what*, not the *leak*).
- If a privacy hardening must be noted, keep it generic and location-free
  (e.g. `harden config handling`), never the specific value, field, or file.
- Applies to the subject, body, and any trailer.
- The same principle applies to hook/CI output: report the file and the *type*
  of finding, never the matched value.
**Author email:** Every commit must be signed with `<your-git-email>`.
Before committing, verify: `git config user.email` returns `<your-git-email>`.
If not, set it: `git config user.email "<your-git-email>"`.

**No AI co-authorship — ever.**
No agent, assistant, or AI tool may add itself as a contributor to any commit.
Forbidden in all forms:

- `Co-Authored-By: Claude ...`
- `Co-Authored-By: GitHub Copilot ...`
- `Co-Authored-By: <any-ai>@<any-domain>`
- Any variation of AI attribution in the commit message, body, or trailer

Commit messages document the *change*, not *who or what* produced it.
The human author is the sole credited contributor.
The full lifecycle of every change, in order:

1. **Agent commits** on the feature branch (one task = one commit).
2. **Agent informs** the user — and a bare "Ready to test" is **forbidden**.
   With that same message the executor hands the **full command block** (owner
   decision 2026-07-14 — this removes the round-trip where the owner relays the
   result to an architect just to get commands). All three, per `000-core`
   "Commands Given to the User" (absolute path, one command per line, runnable
   from any directory in a fresh terminal):
   - **(1) the test command(s)** with the expected result of each (what PASS
     looks like, what means FAIL). Test commands must be cwd-independent — for
     `uv` repos use `uv run --directory <abs-repo> pytest -q`, never a bare
     `--project` (pytest collects from the CWD);
   - **(2) the merge + branch-delete commands**, to run after approval;
   - **(3) the push command**;
   - any cleanup command if the test creates artifacts.
   The owner runs merge/push themselves, or tells the executor to merge — but
   **the agent never pushes** (`Remote Repo Access`, `global`).
3. **User reviews** and reports any issue.
4. **Agent amends** — fixes belonging to the same task go in with
   `git commit --amend`, **never** as a new commit. The branch keeps exactly
   one commit per task.
5. **Only after explicit approval:** agent runs `git merge` + `git branch -d`.
6. **The user pushes — never the agent.** After merging, the agent hands over
   the push command per `000-core` "Commands Given to the User": complete,
   absolute path, one line, copy-pasteable into any fresh terminal, e.g.:

   ```bash
   git -C /Users/<you>/@-github/<project> push origin main
   ```

Merging before approval removes the user's ability to reject broken changes
without a revert. Pushing by the agent removes the user's last checkpoint
before anything becomes public — both are forbidden.
Files used only for our own notes and session memory — `TODO.md`, `SESSION.md`,
`TASKS.md`, `ROADMAP.md`, `*.session.md`, `*.local.md` — must **never** be
committed or pushed to GitHub, in this repo or any project repo.

- They must always be listed in `.gitignore`.
- The pre-commit hook (`templates/hooks/pre-commit`, Rule 3) blocks them at
  the git level even if someone force-adds with `git add -f`.
- If one of these files is already tracked in a repo, remove it with
  `git rm --cached <file>` and add it to `.gitignore` — do not just edit it.## From 045-single-source-docs.md

Every piece of project knowledge has exactly one home:

| Content | Single home | Everything else holds |
| --- | --- | --- |
| Public design / architecture / ADRs | Repo docs — the single technical doc is exactly `docs/ARCHITECTURE.md` (English), no `TECHNICAL.md`/`DESIGN.md` variants (see `workflows/documentation.md`) | a pointer |
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
If a vault-class file (private doc, TODO/SESSION-class file per `040`) is
found **committed** in any repo:

1. Move the working copy to the vault (`035` — a filesystem move, not a
   commit).
2. Purge the file from **all git history** (`git filter-branch`/
   `git filter-repo` + reflog expire + gc). `git rm --cached` alone leaves it
   in history forever.
3. If the repo has a remote that already received it, treat it as a leak:
   force-push the rewrite and note it in the central TODO.## From 050-session-start.md

Before ANY action in a new session:

1. Read `rules/000-core.md` and `rules/040-git.md` (plus any rule relevant to the task).
2. Post a short, free-form acknowledgement that you have read them and will comply — covering at least: branch-first (never `main`), no AI co-authorship, the pre-commit security scan, `--amend` for minor follow-ups, readable commands (no long `&&` chains), and the merge gate.
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
**All tasks — for every project — go in the one central TODO**
(`_memory/TODO.md`), under that project's `## <project>` section. Never create a
per-repo `TODO.md`. New task → add it under the right project section. This is how a
solo operator sees every project's work in one place and nothing is forgotten.

**After completing any TODO item — before committing — update the central TODO:**

- Mark the item as done: `- [x]` and add completion date
- Update the status if present

A task is not done until the central TODO reflects it.
State that must survive a session lives in **durable files** — `SESSION.md`
(vault `workspace/`), the central `_memory/TODO.md`, and memory — never only in a
long live context window. A raw transcript backup is written **automatically** on
session end (`_memory/handoffs/*.jsonl`), so nothing is ever truly lost; but the
curated, readable `SESSION.md` is the **agent's** job — update it proactively when
the owner signals wrap-up, before any `/clear`.

- **Never `/clear` mid-task.** Finish the step, update `SESSION.md`, then clear.
- **Between tasks:** write `SESSION.md`, then `/clear` (or `/compact` above
  ~100k context). The state is externalised, so clearing loses nothing.
- **Architect sessions** (design/review, premium model): one task per session;
  reference earlier work by re-reading `SESSION.md`/`TODO.md`, **not** by keeping
  a fat context alive — >150k context is where subscription quota burns.
- **Worker sessions** (cheap models): `/clear` freely; their state is the WO file
  plus the git branch, both external.

The rule is: **externalise the useful part, then context is cheap to reload and
`/clear` costs nothing.** Preserving raw context in the window instead is the
expensive anti-pattern.
**Problem:** Saving the session by the architect in a fat context is the most expensive state.
**Solution:**
- The architect makes all decisions but leaves only a short "closeout note" (decisions/open status, a few lines) at the end of the task.
- A cheap sub-agent (e.g., `Haiku`, `Sonnet`, or `agy $0`) is invoked to do the mechanical writing: update `SESSION.md`, `README`, `CHANGELOG`, `docs`, stage the changes, and run `git commit --amend` per rule 040.
- **Hybrid Timing (Main + Fallback):**
  - **Main Path:** A `SessionEnd` hook invokes the cheap agent with the architect's closeout note to write the digest immediately at the end of the session.
  - **Safety Net:** `SessionStart` checks if a digest was created for the previous session's `jsonl`. If not (e.g., due to a crash where the hook didn't fire), it runs the cheap agent on the raw backup before proceeding.
- **Merge is always done by the architect/owner** (to avoid branch-rename incidents).## From 070-work-orders.md

1. **Executor** — the exact agent/model that will run it, e.g. `gemini`
   (free), `deepseek-flash`, `deepseek-pro`, `minimax-3 (CodeWhale)`,
   `sonnet`, `fable/opus`. Routing ladder, cheapest first:
   gemini → deepseek-flash → deepseek-pro/minimax-3 → premium.
   If the executor is a premium model, a **`Why premium:`** line is
   mandatory — implementation work defaults to cheap models; premium is for
   design-critical logic only.
2. **Base rules** — explicit paths of the rule files the WO was written
   against (at minimum `rules/000-core.md` and `rules/040-git.md`), plus an
   order to the executor: read `rules/DIGEST.md` (or the listed files)
   **before writing anything**. A WO without rule references is invalid.
3. **Complexity** — TRIVIAL / MODERATE / CRITICAL (rule 000).
- Phases sized for one branch + one commit each (rule 040); executor stops
  for review between phases.
- **Script-first:** anything bash/python can do must be specified as a
  script, not as LLM work — scripts can be automated or handed to the
  cheapest executor.
- **Cross-project impact:** Mandatory section in every WO. Source of truth is the
  ripple column of `_memory/REGISTRY.md`. Even if no impact, explicitly state
  "None".
- **Definition of Done** with copy-pasteable absolute-path commands, one per
  line, each with its expected result (rule 000 §Commands).
- Never an instruction to merge or push without explicit owner approval.
Every round-trip to the architect re-sends the full premium context — so the
architect never leaves the owner without the next move. Every architect turn
that finishes a task, a review, or a WO **must end with the exact paste-ready
command or message for the next step** (e.g. the text the owner pastes into
the executor's session, or the single command to run). No "ask me when
ready" — the next action ships with the current answer.
Executor output is never merged on trust. In order:

1. **Mechanical** (script — `bin/review-gate.sh`): working tree clean;
   changed files within the WO's declared scope; no junk artifacts
   (`*.tmp`, `.DS_Store`, `__pycache__/`, `node_modules/`, build output,
   scratch/debug files); lint passes; staged/committed-diff secret & PII
   scan; commit count and message format per rule 040.
2. **Reviewer** (architect or reviewer agent — **never the author**; who
   may review, the reviewer ladder, and the review-and-repair pipeline are
   defined in rule 075): read the diff against the WO — scope creep,
   content deleted without being ordered, tests faked or skipped, docs not
   updated. Verdict recorded in the WO file under a `## Review` appendix
   (date, reviewing agent, verdict, findings).
3. Only then does the owner approve, and the merge happens (rule 040).

An execution report without the review verdict is not mergeable. The
executor's "ready to test" message must itself follow rule 040 §Review —
test commands with expected results, never just merge/push commands.## From 075-independent-review.md

**Whoever writes or modifies code never approves it.** This applies
recursively:

1. An executor's output is reviewed by a **different** agent (rule 070
   gate). Self-review, however thorough, satisfies nothing.
2. **Repairs are authored code.** If the reviewer fixes defects directly
   (review-and-repair), those fixes must be verified by an agent **other
   than the one who wrote them** — e.g. Sonnet repairs Gemini's output →
   Gemini, Haiku, or Opus (proportional to difficulty, see ladder) verifies
   Sonnet's repairs. Never the repairer itself.
3. **No independent review recorded → DoD is NOT met.** An execution
   report without a reviewer verdict (in the WO `## Review` appendix) is
   not mergeable, no exceptions.
4. **Architect signs last, cheaply.** The architect's final signature is a
   gate check, not a re-review: confirm the mechanical gate passed, read
   the reviewer verdict(s), spot-check the diff hotspots the reviewer
   flagged, run the DoD proof commands. The architect does NOT re-read the
   whole diff — burning premium context on work two agents already
   verified is the anti-pattern this rule exists to prevent.
Match the verifier to the stakes — accuracy without waste (capability-based, not cost-based):

| Work under review | Minimum independent reviewer |
|---|---|
| TRIVIAL (docs, config, mechanical edits) | any basic agent ≠ author (e.g. deepseek-flash/haiku) |
| MODERATE (features, refactors) | sonnet-class or Gemini 3.1 Pro ≠ author. **Gemini 3.1 Pro is the preferred reviewer here** because it is $0 for the owner while possessing frontier-class reasoning and an agentic harness that can run tests/shell during review (it verifies, not just reads). |
| CRITICAL (security, money, algorithms, protocol) | opus-class or architect line-by-line ≠ author |
| Repairs made BY a reviewer | one tier may drop (repairs are narrower than the original diff), but never below "basic agent ≠ repairer" |

The reviewer's model/agent name and verdict date are recorded in the WO
`## Review` appendix — "reviewed" without *who* is not reviewed.
For WO execution, the default pipeline is **review-and-repair** — the
reviewer fixes what it finds instead of bouncing rounds back to the
executor (each bounce costs a full context reload + a re-review anyway):

1. **Architect** writes the WO (design decisions fixed, scope closed).
2. **Cheap executor** implements on the WO branch ($0 ladder per 070).
3. **Reviewer agent** (≠ executor) reads the diff against the WO,
   red-teams it, and **amends fixes directly on the branch** (rule 040:
   same task = amend, not new commits). Every finding is listed in the
   verdict as BLOCKING/MINOR with file:line.
4. **Mechanical gate re-runs** after repairs (`bin/review-gate.sh`,
   full test suite, lint) — repairs that break the gate go back to step 3.
5. **Repair verification** by a third agent per the ladder above —
   scope: only the repair hunks and their blast radius.
6. **Architect sign-off** (cheap, per Independence Law §4) → owner
   approval → merge (rule 040).

Why this shape: defects caught pre-merge cost one amend; defects caught
post-merge cost a bug hunt, a new WO, and a re-review — always route the
tokens to the pre-merge side.## From 080-knowledge-capture.md


## 1. When to Capture

Knowledge capture is mandatory **before `SessionEnd`** for any session involving MODERATE or CRITICAL complexity tasks, or whenever a new, non-trivial problem-solving approach or strategic decision is developed. TRIVIAL tasks only require capture if a novel reusable pattern emerges.

## 2. What to Capture

Capture transferable judgment, decision trees, and a menu of approaches with their trade-offs, including a recommended default for our project profile. Focus on patterns related to:

- **Financial Data Analysis:** Strategies for market analysis, risk assessment, portfolio optimization, and data integration.
- **Content Automation:** Effective pipelines for generating and distributing content across platforms like YouTube, Telegram, and LinkedIn.
- **Multi-Agent Analytical Pipelines:** Architectures and coordination mechanisms for complex problem-solving involving multiple agents.
- **Reinforcement Learning (RL) for Finance:** Best practices, model selection, and deployment strategies for RL applications in financial contexts.
- **Dev/ML/LLM/AIOps Workflows:** Reusable patterns for development, machine learning, large language model integration, and AI-driven operations.

The capture should explain *why* certain approaches were chosen over others, detailing the decision criteria and observed outcomes.

## 3. Where to Capture (Skill Discovery Order)

Knowledge must be captured in the most reusable and discoverable format possible, following this order:

- **Existing Skill Enhancement:** If an existing skill (in `skills/`) partially addresses the knowledge, update and refine that skill.
- **Upstream Catalogs:** If no local skill fits, consult `.claude/skill-sources.md` for an upstream skill to adopt before authoring anything new.
- **New Skill Creation:** If the knowledge represents a novel, self-contained, and reusable capability, create a new skill file (`skills/<skill-name>.md`, flat layout) adhering to `rules/036-skill-versioning.md`.
- **Architecture Docs:** For broader strategic insights, architectural patterns, or complex decision flows that don't fit a single skill, document them in `docs/INFORMATION-ARCHITECTURE.md` or a new, appropriately named document under `docs/`.

## 4. Fail-Closed Gate: Knowledge Capture Report

TRIVIAL sessions are exempt from this field. For MODERATE and CRITICAL sessions, the `SessionEnd` digest **MUST** include a `knowledge-capture:` field detailing:

- `status`: `COMPLETED` / `PARTIAL` / `N/A` (no reusable knowledge emerged).
- `summary`: A concise description of the captured knowledge.
- `artifacts`: A list of paths to updated or newly created skill files or documentation.
- `reason_for_partial/NA`: If status is `PARTIAL` or `N/A`.

Failure to include this field, or an incomplete report for MODERATE/CRITICAL sessions, will trigger a review gate failure and require remediation.## From 085-orchestration-topology.md


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
<!-- digest-hash: dec781b4aeb59806b6692a466e76e241eecce9752a616db55f8cb870b52306e7 -->
