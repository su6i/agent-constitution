---
title: "Propagate Constitution Updates"
description: Roll out new constitution commits (rules, skills, the pre-commit hook) to every project that uses the submodule.
location: workflows/propagate-constitution.md
agent_priority: Standard
last_updated: 2026-06-10
---

# Propagate Constitution Updates

[Back to README](../README.md)

> When this constitution repo gets new commits on `main` — new/changed rules,
> skills, templates, or the `pre-commit` hook — existing projects do **not** see
> them automatically. Each project pins the constitution as a git submodule at a
> specific commit. This workflow rolls the latest out to all of them in one step.

## When to run
- After merging changes to `agent-constitution` `main` (and pushing).
- After a project reports it's missing a new rule/skill/hook.
- Periodically, to keep every project current.

## The command (preferred)
```bash
amir update-projects                 # all projects under ~/@-github (or $AMIR_PROJECTS_DIR)
amir update-projects --dry-run       # preview first — change nothing
```
For each project under the base dir that uses the constitution submodule, it:
1. updates the submodule to the latest `main`, and
2. (re)installs the `pre-commit` hook into the project's `.git/hooks`.

It is **idempotent** and **non-destructive** — it only moves the submodule
pointer and installs the hook; it never touches your code, `CLAUDE.md`, or other
content.

### Useful flags
| Flag | Effect |
|---|---|
| `--dry-run` | List what would change, do nothing |
| `--no-hook` | Update the submodule only |
| `--no-submodule` | (Re)install the hook only |
| `--exclude "a b"` | Skip extra projects (defaults already skip `amir-cli`, `agent-constitution`) |
| `[base-dir]` | Scan a different directory (default `$AMIR_PROJECTS_DIR` or `~/@-github`) |

## What the installed hook enforces
The `pre-commit` hook it installs is **strict** and fail-closed:
- blocks direct commits to `main`/`master` (use a feature branch), and
- blocks a commit that changes code without updating documentation
  (`README`/`CHANGELOG`/`docs/`/`*.md`); fold minor follow-ups in with
  `git commit --amend`.

Deliberate one-off bypass: `git commit --no-verify`.

## After running
- Each project now has a modified submodule pointer (`.agent/constitution`).
  Commit it per project when convenient: `git add .agent/constitution && git commit`.
- SSH-URL submodules may prompt for a key passphrase. Avoid repeats with:
  ```bash
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  ```

## Manual fallback (no `amir` CLI)
Run inside a single project:
```bash
git submodule update --remote .agent/constitution
cp .agent/constitution/templates/hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

---
[Back to README](../README.md)
