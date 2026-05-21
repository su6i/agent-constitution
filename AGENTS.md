---
title: AGENTS.md
description: Project constitution and standards for autonomous agents (Antigravity, Jules, etc.)
location: AGENTS.md
last_updated: 2026-02-21
---

# AGENTS.md — Agent Guide for this Project

## Project Summary
This repository contains the constitution and standards for Agentic Coding 2026, focusing on the strategic balance between computational power and operational cost efficiency.

## Structure
- `.agent/rules/` — Core project standards and formatting rules (Universal Structure).
- `.agent/skills/` — Reusable domain-specific knowledge modules (76 skills).
- `.agent/workflows/` — Repeatable operating procedures and process templates.
- `.agent/prompts/` — Reusable prompt templates for common tasks.
- `memory-bank/` — Session-to-session context and progress tracking.
- `bin/` — Automation scripts (scaffolding, MCP server, validation).

## Important Rules for Jules & Other Agents
- Perform one task at a time — small PRs are preferred over large ones.
- Always write tests before implementing any changes (TDD).
- Use `uv` for package management, never use `pip` directly.
- Commit message format: `[type]: [short description]` (e.g., `feat: add new skill`).
- **Never mention your own name, model name, or agent identity in any commit message.** Commit messages describe the change, not who made it.

## Running Tests
```bash
uv run pytest --cov=src
```

## Linting & Formatting
```bash
uv run ruff check --fix . && uv run mypy src/
```
