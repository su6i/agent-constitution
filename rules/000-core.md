---
title: "000Core: Global Constitution"
description: Core project standards and non-negotiable behavior rules.
location: rules/000-core.md
agent_priority: High
last_updated: 2026-06-30
---

# Core Rules

## Cost Control (24/7 CRITICAL)

- Before any major task, declare its complexity: TRIVIAL / MODERATE / CRITICAL
- If complexity is TRIVIAL: Write code without extra explanation (fewer tokens)
- If unsure what to do: STOP and ask one question, not 10 questions
- Never edit more than 20 files in a single session without approval
- One task = one commit. Get approval before moving to the next task

## Response Structure (Token Efficiency)

- Start your responses with code, do not give extra explanation
- Use the format: "✅ done" / "❌ blocked: [reason]" / "❓ need: [question]"
- Never explain the code again if it has already been explained

## Project

- Language: Python 3.12+
- Package management: ONLY `uv` (no direct pip)
- Entry point: `main.py` at the root
- Config: ONLY use `config.yaml` or `.env` (no hardcoding)
- All variables in `config.yaml` — never leave hardcoded values in code

## Commands Given to the User (Non-Negotiable)

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

## On Error

- First read the error, then diagnose
- If not solved after 3 attempts: Report and wait for approval
- Never add dependencies without approval

## No Silent Errors (Non-Negotiable)

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
