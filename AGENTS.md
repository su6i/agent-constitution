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

Read these three files first. Do not skip them to save tokens — a work order,
plan, or commit produced without them is invalid and will be rejected by the
git hooks and by review:

1. `rules/000-core.md` — cost control, response format, commands-to-user, No Silent Errors
2. `rules/global.md` — Senior Architect identity and professional standards
3. `rules/040-git.md` — git protocol (the most-violated one; see summary below)

Read on demand, when the task touches the domain:

- `rules/010-python.md`, `rules/020-tdd.md`, `rules/025-research-first.md`
- `rules/030-security.md`, `rules/035-data-vault.md`, `rules/036-skill-versioning.md`
- `rules/045-single-source-docs.md`, `rules/050-session-start.md`,
  `rules/055-cross-project-memory.md`, `rules/060-multi-interface.md`
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
- Update `README.md` / `CHANGELOG.md` / affected `docs/` **before** staging.

## Writing Work Orders (architects & planners)

If you are writing a WO for another agent, the Mandatory Reading above applies
to **you first** — a WO that contradicts `rules/` poisons every downstream agent.
Every WO must:

- name the rule files it was written against (at minimum 000, 040);
- give test commands as absolute-path, one-per-line, copy-pasteable lines
  **with the expected result of each** (rule 040 §Review→Amend→Merge→Push);
- never instruct the executor to merge or push without owner approval.

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
