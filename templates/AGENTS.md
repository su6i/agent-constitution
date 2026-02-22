---
location: root/AGENTS.md
description: Agent Guide Template — MUST be placed in the project root to be effective.
---

# AGENTS.md — Agent Guide for [Project Name]


## Project Summary
[Provide a one-paragraph summary of the project and its goals.]

## Structure
- `src/` — Main source code.
- `tests/` — Test suite.
- `docs/` — Documentation.
- `memory-bank/` — Context management between sessions.

## Important Rules for Agents
- Focus on one task at a time.
- Write tests before implementation (TDD).
- Use `uv` for dependency management (if applicable).
- Commit format: `[type]: [short description]`.

## How to Run Tests
```bash
# Example:
uv run pytest
```

## How to Lint/Format
```bash
# Example:
uv run ruff check .
```
