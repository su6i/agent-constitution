---
title: "075IndependentReview: Independent Review & Repair"
description: No agent approves its own work; review-and-repair pipeline with proportional verification and a cheap architect sign-off.
location: rules/075-independent-review.md
agent_priority: High
last_updated: 2026-07-16
---

# Independent Review & Repair

Rule 070 defines *when* a review gate runs. This rule defines **who** may
review, and the token-economics of the pipeline: reviews must be cheap
enough to always happen and independent enough to actually catch defects.
Evidence base: the Arix Sense chain (wo-sense-0004/0005, 2026-07-16) —
an independent reviewer found and fixed 13 blocking defects that the
author's own green tests could not see.

## The Independence Law

<!-- digest:start -->
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
<!-- digest:end -->

## Reviewer ladder (proportional to task difficulty)

<!-- digest:start -->
Match the verifier to the stakes — accuracy without waste:

| Work under review | Minimum independent reviewer |
|---|---|
| TRIVIAL (docs, config, mechanical edits) | any cheap agent ≠ author (gemini/deepseek-flash/haiku) |
| MODERATE (features, refactors) | sonnet-class ≠ author |
| CRITICAL (security, money, algorithms, protocol) | opus-class or architect line-by-line ≠ author |
| Repairs made BY a reviewer | one tier may drop (repairs are narrower than the original diff), but never below "cheap agent ≠ repairer" |

The reviewer's model/agent name and verdict date are recorded in the WO
`## Review` appendix — "reviewed" without *who* is not reviewed.
<!-- digest:end -->

## Review-and-Repair pipeline (the economical default)

<!-- digest:start -->
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
tokens to the pre-merge side.
<!-- digest:end -->

## DRAFT: Headless Architect Review (Architecture Proposal 1)

<!-- digest:start -->
> **DRAFT.** Proposed architecture based on the portfolio pilot (2026-07-19).

To preserve premium context for review without context bloat:
- The cheap worker ($0) executes the implementation.
- **The repo architect is spawned headlessly** with a fresh context to perform the review. Premium quality is spent strictly on reviewing, not maintaining context.
- The headless architect ONLY returns the verdict (PASS/FAIL + report) to the manager. It NEVER reads diffs for context, and it is strictly read-only + report (no commit/merge).
- Git merge remains gated behind the owner/architect.
<!-- digest:end -->

## Forbidden

- Merging on the author's own "tests are green" (green tests proved
  nothing in wo-sense-0005 — 8 of 10 rules were silently dead with a
  green suite).
- A reviewer approving a diff it partially authored (mixed
  authorship → treat the whole diff as authored; bring in a third agent).
- Recording a review verdict without naming the reviewing agent/model.
- The architect re-reading full diffs that already carry two independent
  verdicts (waste), or skipping the sign-off entirely (rubber stamp).
