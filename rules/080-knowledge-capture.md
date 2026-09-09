---
title: Rule 080: Knowledge Capture & Transfer
description: Mandates the capture and structured transfer of agent judgment, strategies, and solutions into reusable skills or knowledge artifacts.
location: rules/080-knowledge-capture.md
agent_priority: CRITICAL
last_updated: 2026-09-09
---

Every session (especially MODERATE and CRITICAL complexity tasks) generates valuable judgment, problem-solving approaches, and strategic choices. This ephemeral knowledge must be captured and structured for reusability and transfer to other agents or future tasks. This rule complements `rules/000-core.md` §"No Knowledge Lost", defining the *how* and *when* of knowledge extraction.

<!-- digest:start -->

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

## 3b. Teaching Notes to the Owner (`agent-notes`)

Owner ruling 2026-07-23. Sections 1–3 capture knowledge for *agents*; this one
captures it for the *owner*. Whenever an agent explains something instructive
in chat — how a mechanism works, why an approach was chosen, a diagnosis worth
keeping — that explanation is also written to `~/Documents/agent-notes/`.

- Filename `YYYY-MM-DD-topic.md`, **English/ASCII** (the note body may be in
  any language).
- Header names the author agent, the repo, and the session id, so a note can
  be traced back to the work that produced it.
- The authoritative format lives in that folder's own `README.md`; follow it
  rather than re-inventing a layout here (rule 045: one home per piece of
  knowledge).

Chat scrolls away and sessions are cleared. An explanation that existed only
in a transcript will be asked for — and re-derived — a second time.

## 3c. Content Strategy Register (Owner Decree 2026-08-09)

Owner ruling 2026-08-09. Content-production strategy — broken down **by
platform** — is a standing knowledge asset, not a one-off chat answer: it
must be captured as a durable reference in the Obsidian vault so it can be
found again, reused across projects, and refined over time instead of being
re-derived from scratch each time the topic comes up.

- **Location:** `<vault>/idea/35-Content-Strategy/`, with one note per
  platform category (e.g. YouTube, LinkedIn) plus an index MOC —
  `35-Content-Strategy-MOC.md` — following the vault's existing `NN-Area/`
  convention (see `00-Home.md`).
- **What goes in:** validated strategies, not raw ideas — a rule of thumb
  with the reasoning behind it, e.g. *"test demand with several short-form
  videos in a topic before committing to a long-form one; this caps the
  cost/time sunk into a long video nobody watches."* Each entry names the
  platform, the rule, and the reasoning; a rule without its reasoning is not
  reusable when circumstances change.
- **Growth model:** append-only and refined over time — a new validated
  strategy is a new entry or an edit to an existing one, never a rewrite that
  drops prior reasoning. One note = one platform's strategy set, per the
  vault's own "one note = one idea" rule (`00-Home.md`).
- This is the vault-side complement to §3b: 3b captures explanations for the
  owner, this captures **operational content strategy** so it compounds
  instead of being re-explained on demand.

## 4. Fail-Closed Gate: Knowledge Capture Report

TRIVIAL sessions are exempt from this field. For MODERATE and CRITICAL sessions, the `SessionEnd` digest **MUST** include a `knowledge-capture:` field detailing:

- `status`: `COMPLETED` / `PARTIAL` / `N/A` (no reusable knowledge emerged).
- `summary`: A concise description of the captured knowledge.
- `artifacts`: A list of paths to updated or newly created skill files or documentation.
- `reason_for_partial/NA`: If status is `PARTIAL` or `N/A`.

Failure to include this field, or an incomplete report for MODERATE/CRITICAL sessions, will trigger a review gate failure and require remediation.
<!-- digest:end -->

## 5. Lesson Format (Machine-Parseable Capture)

Every completed WO of MODERATE or CRITICAL complexity produces exactly one lesson file, in addition to — not instead of — the artifacts required by §§1–4. This is the concrete schema §2 gestures at when it says "capture transferable judgment": without a fixed schema, capture stays free text and nothing downstream can parse it.

<!-- digest:start -->
- **Location:** `_memory/lessons/<YYYY-MM-DD>-<slug>.md`, copied from `templates/lesson.md` (cross-repo, manager-owned — see §6c "Home").
- **Trigger:** written as part of closing the WO, not optionally and not deferred — the same "before `SessionEnd`" gate as §1.
- **Schema:** a machine-parseable header (`lesson_id`, `date`, `repo`, `wo`, `pattern_id`, `mechanical`, `guard_check`) terminated by a bare `---` line, followed by nine fixed body sections: Problem, Investigation, Solution, Why This Works, Common Mistakes, Alternative Solutions, Before vs After, Commands Used, Files Modified.
- **Provenance:** adapted from hermes-academy's `Lesson` format (MIT; `_memory/REFERENCE-REPOS.md` files it HARVEST-IDEAS, not adopt — we take the shape of the file, not the Rust binary that generates it). Every field that exists only for a human learner — XP, streak, quiz, progress tracking — is dropped. The reader of a lesson file is the next agent, never a person leveling up.
- **Retrieval:** lesson files are ingested by the existing RAG `sessions` collection (`_memory/rag/`) like every other session artifact. Do not build a second index over `_memory/lessons/` — one retrieval layer per corpus is the point of `045-single-source-docs.md`.
<!-- digest:end -->

## 6. Back-End Injection: Distillation into WORKER-RULES.md

Hermes-academy's loop closes only at the front — a skill forces a lesson after every completed action, and its consumer is a human who reads lessons at their own pace. Ours must close at the **back** too: nothing is captured knowledge until it changes what the next dispatch receives. `_memory/WORKER-RULES.md` is already the channel — it is injected **by path** into every `delegate_worker`/`delegate_agent` prompt (`000-core.md` §Worker Delegation) — so promoting a lesson into that file is the injection mechanism; no new channel is needed.

<!-- digest:start -->
- **The distiller** (`bin/distill-lessons.sh`) scans `_memory/lessons/*.md`, groups lesson files by `pattern_id`, and promotes any pattern seen in **N = 3** distinct lessons into a new numbered entry in `WORKER-RULES.md` §"Recorded defect patterns", in the same Symptom / Root cause / Rule shape that file already uses.
- **Why N = 3, fixed, and documented — not a silent tunable:**
  - N = 1 is an anecdote: one lesson can be a one-off model quirk, a bad prompt, or an unrelated environment glitch. Promoting on a single sighting makes every future worker prompt longer for a pattern that may never recur.
  - N = 2 still fits coincidence: two lessons can share a `pattern_id` because the same task was retried, not because the defect is a genuine recurring class.
  - N = 3 is the smallest count where three lessons from **independent** completed WOs reporting the identical `pattern_id` stops being explainable as coincidence. This mirrors the threshold already used elsewhere in this constitution for "stop repeating the same fix, do something structural instead" — `085-orchestration-topology.md` caps review rounds at 2 before escalating, i.e. a third occurrence of the same kind of failure is where a standing rule becomes cheaper than living with the failure a fourth time.
  - The default lives in `bin/distill-lessons.sh` as a named, commented constant (`DEFAULT_N=3`), so the script and this rule text can never silently disagree.
- **Idempotent:** a pattern already promoted (marked by an HTML comment carrying its `pattern_id`, `N`, and the contributing lesson ids) is never promoted twice, even as the lesson store keeps growing.
<!-- digest:end -->

## 6b. Mechanical Rules vs Advisory Rules (Law vs Advice)

Every promoted entry is labelled, so a worker can tell which is which at a glance:

<!-- digest:start -->
- **`[MECHANICAL]`** — the contributing lessons' `mechanical: true` field and their `guard_check` spec let the pattern be checked by a script, not a judgment call. The promoted entry carries the literal `scripts/wo_guard.sh --once <file>:<regex>:<n>` line the layer-2 reviewer's `--verify` chain must run. A rule that can fail a build and is left as prose instead is precisely the failure mode this section exists to close.
- **`[ADVISORY]`** — the pattern has no `guard_check` (the contributing lessons recorded `mechanical: false`) because deciding whether it recurred requires reading the work, not grepping a file. These stay as prose, explicitly labelled, so nobody mistakes "nobody wrote the check yet" for "this cannot be checked."
<!-- digest:end -->

## 6c. Home

- **Mandate:** this rule (`rules/080-knowledge-capture.md`) — front-end capture in §§1–5, back-end injection in §6–6b.
- **Lesson store:** `_memory/lessons/` — cross-repo, manager-owned, alongside `_memory/WORKER-RULES.md` and the per-repo `agent-projects/<repo>/workspace/EXECUTOR-RUNLOG.md` evidence log (`WORKER-RULES.md`'s own "How this file improves" note: the runlog holds the evidence, `WORKER-RULES.md` holds only the distilled rule).
- **Distiller:** `bin/distill-lessons.sh` in this repo — versioned and reviewable like every other guard script, even though it reads and writes vault paths at run time (the same pattern `bin/validate-prefixes.sh` already uses for `_memory/PREFIXES.tsv`).
