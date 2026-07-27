---
title: "070WorkOrders: Work Order Standard"
description: Mandatory structure, executor routing, handoff protocol, and post-execution review gate for work orders.
location: rules/070-work-orders.md
agent_priority: High
last_updated: 2026-07-27
---

# Work Order (WO) Rules

A work order is the contract between the architect (planner) and an executor
agent. A WO that violates the rules poisons every downstream agent — so the
Mandatory Reading (rule 000, `AGENTS.md`) applies to the WO **author** first.

WOs live in the project vault (`<vault>/workspace/wo/`), never in the repo
(rules 035/040). Naming: `wo-<project>-NNNN[-slug].md`; finished WOs move to
`wo/done/`. Cross-project WOs live in `_memory/wo/` (manager WOs are named
`wo-manager-NNNN[-slug].md`). The executor is NEVER in the filename, only in
the header.

## Mandatory Header (every WO — no exceptions)

<!-- digest:start -->
1. **Executor** — the exact agent/model that will run it, e.g. `gemini`
   (free), `deepseek-flash`, `deepseek-pro`, `minimax-3 (CodeWhale)`,
   `sonnet`, `fable/opus`. Routing ladder, cheapest first:
   gemini → deepseek-flash → deepseek-pro/minimax-3 → premium; which class of
   work goes to which executor is fixed by **§Executor Routing** below.
   If the executor is a premium model, a **`Why premium:`** line is
   mandatory — implementation work defaults to cheap models; premium is for
   design-critical logic only.
2. **Base rules** — explicit paths of the rule files the WO was written
   against (at minimum `rules/000-core.md` and `rules/040-git.md`), plus an
   order to the executor: read `rules/DIGEST.md` (or the listed files)
   **before writing anything**. A WO without rule references is invalid.
3. **Complexity** — TRIVIAL / MODERATE / CRITICAL (rule 000).
<!-- digest:end -->

## Executor Routing (which agent gets which work)

Sources: recorded owner rulings and executor run-logs — polycast 2026-07-11/12,
the ladder ruling of 2026-07-13, the Arix Sense chain 0001–0005, and
`ai-router/workspace/EXECUTOR-RUNLOG.md`. When the architect writes a WO it
fixes the executor from this table and records it in the header
(§Mandatory Header item 1). A WO whose executor contradicts this table without
a written justification is incomplete.

<!-- digest:start -->
**$0 first (owner ruling 2026-07-13).** The default channel for implementation
is a zero-cost one — agy Gemini 3.1 Pro (subscription, agentic) or the free
Gemini API through `delegate_worker`. DeepSeek (flash/pro) and MiniMax are
**paid fallback only**, used when a $0 channel fails review or hits quota.

| Class of work | Executor | Why / evidence |
|---|---|---|
| Audio/video, installing a TTS or model engine, anything environment-sensitive (disk, GPU, mounts) | **Gemini** ($0), else Sonnet | Owner ruling: you do not hand songwriting to a deaf man. On such a task DeepSeek filled the disk and reported the environment error as "no Metal / exFAT denies permission", never finding the reference already on disk. Gemini has a record of successful installs and listening evaluation. |
| Self-contained mechanical text/code work — patterned refactor, file moves, boilerplate, tests | **$0 worker first** (agy / gemini via `delegate_worker`); deepseek-flash or minimax-3 only as paid fallback | wo-polycast-0002 finished on the paid channel for $0.51 but still needed a review pass; the same class now runs at $0. The review pass (rule 075) is mandatory either way. |
| Live facts: does X exist, version / licence / API behaviour checks | **`delegate_research`** (grok) | A ~$0.003 call settles it — never answer from model memory, never spend premium context on it. A negative from one search model is not proof of non-existence (two real models were once reported "nonexistent"), so a negative needs a second channel. |
| Deep debugging, multi-system glue, quality-sensitive documents | **Sonnet** | flash-class models lose the thread in layered debugging (wo-0003); on Arix Sense 0005 a flash execution came back with 13 blocking defects that only independent review caught. |
| Constitution rule text, architecture, WO authoring, review and synthesis, path decisions | **the architect's premium model** (Opus/Fable) | Expensive — reserved for what the others cannot do. Cheap workers never edit rule text. |
<!-- digest:end -->

### Routing companion rules

<!-- digest:start -->
1. **Gemini creates files sloppily** (owner ruling): every Gemini task brief
   must spell out the exact absolute path of every input and every output, and
   repeat the permitted write scope (`experiments/<agent>/` plus the named
   allowed paths) — otherwise it scatters files across the repo.
2. A disk- or environment-heavy task carries a **sanity checklist as step 0 of
   the WO itself**: free disk space, mount present, destination writable.
3. **An executor report is a claim, not evidence.** The review gate below and
   rule 075 apply before any merge, and a claim of the form "the tool is
   broken" never enters the docs without independent verification.
4. **No conclusion from n=1.** This table changes only through a reproducible
   benchmark (the `ai-router` delegation ledger) or an explicit owner ruling.
<!-- digest:end -->

## Mandatory Body

<!-- digest:start -->
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
