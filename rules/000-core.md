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

## Worker Delegation (route through the ai-router door)

<!-- digest:start -->
Agents SHOULD route **all** worker-model calls (Gemini/agy, DeepSeek, MiniMax)
through the ai-router door — `delegate_worker` / `delegate_agent` — and never
launch a worker CLI directly. The router provides the cost ledger, budget caps,
and the context-discipline pack; a direct CLI call bypasses all three. The
architect calls the worker channel itself (one tool-call + a short summary),
rather than asking the owner to run it and paste the output back — relaying
costs the same tokens twice plus a round-trip. **Exception:** hours-long
interactive tasks (training/benchmark grids) go to a separate owner-started
session. This becomes a MUST once ai-router `wo-0014`'s enforcement hook lands.
<!-- digest:end -->

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

<!-- digest:start -->
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
<!-- digest:end -->

## Language Policy (Non-Negotiable)

<!-- digest:start -->
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

### Names are ASCII, content is not the same question

Everything above governs what a file **says**. This governs what a file is
**called**, and it is stricter, because the two are read by different things.

Every file and directory **name** — in any repository and in the vault, and
including `NOTE-`, `WO-`, `BRIEF-` and any other generated artefact — is
English and ASCII-only. The working charset is `[A-Za-z0-9._-]` plus `/`; the
hard, enforced boundary is ASCII (bytes `0x20`–`0x7E`).

The **content** of those files is unaffected: repo content follows the English
rule above, and a vault note may be written in any language its reader prefers.
A note written in Persian is fine; a note whose *filename* carries those
Persian words is not — rename it to `NOTE-2026-07-24-owner-directives.md` and
leave the text inside exactly as it was. (This paragraph deliberately shows no
counter-example verbatim: a committed rule file is repo content and is bound by
the English-only rule above, including when the subject is that very rule.)

Why names are held to a stricter standard than content: names are what tooling
greps and globs, what URLs percent-encode, what shells word-split, and what
changes shape when a path crosses filesystems, archives, or a `rsync`. Content
is read by people, who cope. `docs/fa/` is already ASCII and stays exactly as
it is — a Persian *path* was never the exception, only Persian *text*.

Enforcement: pre-commit Rule 8 blocks any newly added, copied or renamed path
containing a non-ASCII byte, and runs on merges too. It is deliberately
forward-looking — it does not fire on existing paths — so adopting the rule
never blocks unrelated work. Renaming what already exists is a separate,
owner-approved operation — a rename is a delete plus an add to every consumer
of that path (`rules/global.md` §5 Code Preservation).
<!-- digest:end -->

## On Error

- First read the error, then diagnose
- If not solved after 3 attempts: Report and wait for approval
- Never add dependencies without approval

## No Silent Errors (Non-Negotiable)

<!-- digest:start -->
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
<!-- digest:end -->

## No Knowledge Lost (Non-Negotiable)

<!-- digest:start -->
Every piece of knowledge acquired by any agent (architect or worker) during any task must be **recorded** — we pay for every token.

- **Mandatory Extraction:** Before archiving, deleting, or closing any repository or session, extracting and recording its knowledge is mandatory and obvious (do not ask for permission).
- This requirement underscores the necessity of a knowledge-service (RAG) in the AI router to ensure all acquired knowledge is properly logged and centrally maintained instead of being scattered or lost.
<!-- digest:end -->
