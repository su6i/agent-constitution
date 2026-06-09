---
title: "Init Project"
description: Initialize a new professional project following the Agent Protocol standards.
location: workflows/init-project.md
agent_priority: Standard
last_updated: 2026-06-09
---

# Project Initialization Workflow

[Back to README](../README.md)

> **💡 Automation:** Use the `amir init-project <name>` CLI — it performs every
> step below automatically (submodule, scaffold, gitignore, uv, starter files).
> This document is the *specification* that command implements; follow it
> manually only when the CLI is unavailable.

## 1. Repository & Constitution
- `git init` the target (or create the directory first for a brand-new project).
- Add the constitution as a submodule at `.agent/constitution`:
  ```bash
  git submodule add <constitution-url> .agent/constitution
  ```
- Create `.agent/local-rules/` for project-specific overrides (these take
  precedence over the constitution).

## 2. Standard Directory Structure
- Create `src/`, `tests/`, `docs/`, `assets/`.
- **Do NOT create `lib/`, `bin/`, `scripts/`, or `include/` as source folders** —
  standard `.gitignore` patterns hide them. Put code under `src/`.
- Drop a `.gitkeep` in every otherwise-empty directory so git tracks it
  (git does not track empty directories — without this they vanish on clone).
- **Storage Policy:** persistent data/logs live in `~/.<project>/`, never in the
  repo. A scratch `.storage/` is acceptable only if git-ignored.
- Keep the root clean (a handful of core files).

## 3. .gitignore (Non-Negotiable Safety Rules)
- Copy `templates/gitignore.template` (curated — avoids the `lib/`/`bin/`
  landmines, covers macOS/Linux/Windows).
- **Always** ensure these critical rules are present even if a `.gitignore`
  already existed: `.storage/`, `.env`, `.venv/`, `__pycache__/`, `.DS_Store`.

## 4. Language Setup
- Detect the stack. For Python (or unspecified):
  ```bash
  uv init            # creates pyproject.toml + pins the interpreter
  ```
  Commit `pyproject.toml` and `.python-version`. Use `uv` only — never `pip`.
- For other stacks, scaffold the idiomatic project file (`package.json`,
  `go.mod`, `Cargo.toml`, …).

## 5. Starter Files
- `CLAUDE.md` — project guide (stack, skills, constraints) with `TODO` markers.
- `README.md` — title + one-line description + Quickstart.
- `.env.example` — every required env var with placeholder values.
- `TODO.md` — must begin with the **First Session** checklist.
- `SESSION.md` — running session log.

## 6. First Session (Mandatory)
The freshly scaffolded files contain `TODO` placeholders. The very first agent
session must complete [`workflows/first-session.md`](first-session.md): fill
`CLAUDE.md`, `README.md`, and `.env.example`, then verify the skeleton.

## 7. Final Verification
- `git status` — only intended files staged; empty dirs kept via `.gitkeep`.
- `git check-ignore lib bin src tests` — confirm no source dir is ignored.
- Python: `uv sync` succeeds.

---
[Back to README](../README.md)
