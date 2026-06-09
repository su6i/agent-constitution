---
title: "First Session"
description: The mandatory first task in a freshly scaffolded project — fill in CLAUDE.md and verify the structure before any feature work.
location: workflows/first-session.md
agent_priority: Mandatory
last_updated: 2026-06-09
---

# First Session Workflow

[Back to README](../README.md)

> A project created by `amir init-project` ships with placeholder `CLAUDE.md`,
> `README.md`, and `.env.example` files. This workflow turns that skeleton into a
> working, documented project. **Run this before writing any feature code.**
> `TODO.md` in the new project links here as item #1.

## When this runs
The agent detects an un-onboarded project when **any** of these is true:
- `CLAUDE.md` still contains `<!-- TODO` markers.
- `TODO.md` still has the unchecked "First Session" checklist.

If detected, complete this workflow first and report `✅ onboarding done` before
proceeding to the user's actual request.

## Steps

1. **Interview / infer the project.**
   - Ask the user (one short batch of questions) OR infer from existing files:
     - What does this project do, in 1–2 sentences?
     - Tech stack (language, framework, datastore).
     - The 2–4 most relevant `skills/` modules.
     - Any hard constraints ("never touch X", "must stay offline", etc.).

2. **Fill `CLAUDE.md`.** Replace every `<!-- TODO -->` / `<!-- e.g. -->`
   placeholder with real content. Remove the markers. Leave the
   "Rules & Workflows" / "Global Rules" sections intact.

3. **Fill `README.md`.** Replace the title, one-line description, and the
   Quickstart block with real commands. A README that still says
   "TODO" is an incomplete onboarding.

4. **Fill `.env.example`.** List every environment variable the project needs
   (API keys, DB URLs, model names) with safe placeholder values. Never put
   real secrets here.

5. **Confirm storage policy.** Persistent data/artifacts go in `~/.<project>/`,
   never in the repo. A local `.storage/` (if used) is scratch only and is
   already git-ignored. Wire the code's data path accordingly.

6. **Verify the skeleton (anti-hallucination).** Run and show output:
   ```bash
   git status                          # empty dirs have .gitkeep, nothing stray
   git check-ignore lib bin src tests  # confirm NO source dir is ignored
   ls -la                              # README.md, .env.example, CLAUDE.md present
   ```
   For Python projects also confirm `pyproject.toml` and `.python-version` exist
   and `uv sync` succeeds.

7. **Tick the checklist** in `TODO.md`, then commit on a feature branch per the
   git protocol (`rules/040-git.md`).

## Done criteria
- No `TODO`/placeholder markers remain in `CLAUDE.md`, `README.md`, `.env.example`.
- No real source directory is git-ignored.
- The skeleton verification commands were run and their output shown.

---
[Back to README](../README.md)
