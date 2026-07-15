---
title: AGENTS.md
description: Canonical entry point for ALL non-Claude agents (Gemini, Codex, Jules, Antigravity, Cursor, Windsurf, Copilot, Grok, Qwen, DeepSeek/MiniMax via Cline, ...)
location: AGENTS.md
last_updated: 2026-07-09
---

# AGENTS.md — Canonical Agent Entry Point

**Whatever harness brought you here** — `GEMINI.md`, `GROK.md`, `QWEN.md`,
`MINIMAX.md`, `.cursorrules`, `.windsurfrules`, `.clinerules`,
`.github/copilot-instructions.md`, `.antigravity/`, or any other tool-specific
config — those files are thin bootloaders. **This file is the gate; the constitution itself lives in `rules/`.**

## Mandatory Reading (before ANY task — no exceptions)

**Read `rules/DIGEST.md` FIRST** — it is the short auto-generated list of
non-negotiables every agent must follow. Skim it once, refer back when unsure.

Then read these three files before any task. Do not skip them to save tokens —
a work order, plan, or commit produced without them is invalid and will be
rejected by the git hooks and by review:

1. `rules/000-core.md` — cost control, response format, commands-to-user, No Silent Errors
2. `rules/global.md` — Senior Architect identity and professional standards
3. `rules/040-git.md` — git protocol (the most-violated one; see summary below)

Read on demand, when the task touches the domain:

- `rules/010-python.md`, `rules/020-tdd.md`, `rules/025-research-first.md`
- `rules/030-security.md`, `rules/035-data-vault.md`, `rules/036-skill-versioning.md`
- `rules/045-single-source-docs.md`, `rules/050-session-start.md`,
  `rules/055-cross-project-memory.md`, `rules/060-multi-interface.md`,
  `rules/070-work-orders.md` (mandatory when writing or executing a WO)
- `rules/lang/<language>/` for language-specific standards

## Non-Negotiables (reminder only — full text is in `rules/`)

- **Feature branch first.** Never commit to `main`; the pre-commit hook blocks it.
- Commit format: `[type]: [short description]` — types: `feat`, `fix`, `test`,
  `refactor`, `docs`, `chore`. **No AI attribution ever** (no `Co-Authored-By`,
  no model names) — the commit-msg hook blocks it.
- One task = one commit; fixes to the same task go in with `git commit --amend`.
- **Merge only after explicit owner approval. The owner pushes — never the agent.**
- Package management: `uv` only, never `pip` directly.
- No hardcoded values or secrets; config in `config.yaml` / `.env`.
- Never delete a file without explicit owner approval.
- Never claim "done" without proof (`ls`, test output).
- **English only** in all repo content; translations only under `docs/fa/`
  (or a legacy root `fa/`) and `*.fa.md` files (rule 000 §Language Policy).
- Update `README.md` / `CHANGELOG.md` / affected `docs/` **before** staging.

## Writing Work Orders (architects & planners)

The full WO standard is `rules/070-work-orders.md` — read it before writing
any WO. Non-negotiable minimum:

- **Executor named** (exact model; ladder cheapest-first; `Why premium:`
  line required for premium models);
- rule files the WO was written against (at minimum 000, 040) + an order to
  read them/`rules/DIGEST.md` before coding;
- test commands as absolute-path, one-per-line, copy-pasteable lines
  **with the expected result of each** (rule 040 §Review→Amend→Merge→Push);
- never instruct the executor to merge or push without owner approval;
- executor output passes the post-execution review gate (070) before merge.

## Structure

- `rules/` — the constitution (numbered, non-negotiable)
- `skills/` — reusable domain knowledge modules (367 skills)
- `workflows/` — repeatable operating procedures
- `.agent/` — agents, commands, prompts, hooks
- `memory-bank/` — session-to-session context
- `bin/` — automation scripts (scaffolding, MCP server, validation)
- `templates/` — files rolled out to consumer projects (incl. git hooks)

## Running Tests / Lint

```bash
uv run pytest --cov=src
```

```bash
uv run ruff check --fix . && uv run mypy src/
```

## Context Discipline (token economy — ai-router wo-0012)

- Read a file ONCE, whole; never re-read an unchanged file (you have it in context — scroll, don't re-fetch).
- Prefer `grep -n` to locate, then read ONLY the needed section.
- Batch related reads into one command, not N small ones.
- One WO phase per session; end the session between phases (fresh context beats fat cached context).
- Never paste large file bodies into your own replies/summaries.
- At task end, report tokens/cost if the harness exposes them.
