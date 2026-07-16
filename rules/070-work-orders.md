---
title: "070WorkOrders: Work Order Standard"
description: Mandatory structure, executor routing, handoff protocol, and post-execution review gate for work orders.
location: rules/070-work-orders.md
agent_priority: High
last_updated: 2026-07-12
---

# Work Order (WO) Rules

A work order is the contract between the architect (planner) and an executor
agent. A WO that violates the rules poisons every downstream agent — so the
Mandatory Reading (rule 000, `AGENTS.md`) applies to the WO **author** first.

WOs live in the project vault (`<vault>/workspace/wo/`), never in the repo
(rules 035/040). Naming: `wo-<project>-NNNN.md`; finished WOs move to
`wo/done/`. Cross-project WOs live in `_memory/wo/`.

## Mandatory Header (every WO — no exceptions)

<!-- digest:start -->
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
<!-- digest:end -->

## Mandatory Body

<!-- digest:start -->
- Phases sized for one branch + one commit each (rule 040); executor stops
  for review between phases.
- **Script-first:** anything bash/python can do must be specified as a
  script, not as LLM work — scripts can be automated or handed to the
  cheapest executor.
- **Definition of Done** with copy-pasteable absolute-path commands, one per
  line, each with its expected result (rule 000 §Commands).
- Never an instruction to merge or push without explicit owner approval.
<!-- digest:end -->

## Handoff Protocol (architect side)

<!-- digest:start -->
Every round-trip to the architect re-sends the full premium context — so the
architect never leaves the owner without the next move. Every architect turn
that finishes a task, a review, or a WO **must end with the exact paste-ready
command or message for the next step** (e.g. the text the owner pastes into
the executor's session, or the single command to run). No "ask me when
ready" — the next action ships with the current answer.
<!-- digest:end -->

## Post-Execution Review Gate (before any merge)

<!-- digest:start -->
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
test commands with expected results, never just merge/push commands.
<!-- digest:end -->
