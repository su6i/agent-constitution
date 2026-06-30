---
title: "035: Personal-Data Vault (Single Source of Truth)"
description: Where personal/uncommittable data lives — a central vault outside every repo, with one resolver.
location: rules/035-data-vault.md
agent_priority: High
last_updated: 2026-06-30
---

# Personal-Data Vault

## Golden Rule (Non-Negotiable)

**If a file must never be committed, it must not live inside the repo.**

`.gitignore` alone is not enough — a personal file inside the working tree is one
accident away from a commit (e.g. it can enter through a **merge**, which the
`pre-commit` hook does not run on). The only safe place for uncommittable data is
**outside the repo**, in the central vault.

## The Vault

One vault per project, outside any repository:

```
~/.local/share/agent-projects/<project>/
├── data/        # personal datasets, profiles, caches, DBs
├── shared/      # injected fragments (e.g. personal_data.tex)
├── references/  # private documents (diplomas, notes, plans)
├── secrets/     # tokens, .env, credentials
└── workspace/   # TODO.md, SESSION.md (per-project work log)
```

Central, cross-project memory lives alongside the project vaults:

```
~/.local/share/agent-projects/_memory/
├── MEMORY.md    # index only — one line per entry
├── sessions/    # cross-repo session summaries
└── archive/     # entries older than ~6 months
```

## Resolver (one resolution order everywhere)

The **project slug must be portable** — the same repo on a second machine, or
cloned into a differently-named directory, must resolve to the *same* vault.
Deriving it from the **git remote** achieves that; the local directory name does
not (it is machine-specific). This mirrors the proven pattern in the
`continuous-learning-v2` skill (project identity from `git remote get-url origin`).

Project slug resolution:

1. `AGENT_PROJECT_SLUG` — explicit override
2. repo name parsed from `git remote get-url origin`, lowercased
   (`git@github.com:su6i/ApplyForge.git` → `applyforge`) — **portable**
3. lowercase basename of the repo root — local-only fallback (no remote)

Vault root resolution:

1. `<PROJECT>_DATA_DIR` — explicit per-project override (e.g. `APPLYFORGE_DATA_DIR`)
2. `$XDG_DATA_HOME/agent-projects/<slug>`
3. `~/.local/share/agent-projects/<slug>`

Reference implementation (Python):

```python
import os, re, subprocess
from pathlib import Path

def project_slug() -> str:
    if s := os.getenv("AGENT_PROJECT_SLUG"):
        return s.lower()
    try:  # portable: same remote → same slug on any machine
        url = subprocess.check_output(
            ["git", "remote", "get-url", "origin"], text=True, stderr=subprocess.DEVNULL).strip()
        if name := re.sub(r"\.git$", "", url.rsplit("/", 1)[-1].rsplit(":", 1)[-1]):
            return name.lower()
    except Exception:
        pass
    return Path(subprocess.check_output(
        ["git", "rev-parse", "--show-toplevel"], text=True).strip()).name.lower()

def vault_root(env_var: str | None = None) -> Path:
    if env_var and (o := os.getenv(env_var)):
        return Path(o).expanduser()
    xdg = os.getenv("XDG_DATA_HOME")
    base = Path(xdg).expanduser() if xdg else Path.home() / ".local" / "share"
    return base / "agent-projects" / project_slug()

# DATA_DIR = vault_root("APPLYFORGE_DATA_DIR") / "data"
```

> **Stay portable when convenient, explicit when not.** A repo with no remote
> (e.g. a local-only project) falls back to the directory name; pin it with
> `AGENT_PROJECT_SLUG` or `<PROJECT>_DATA_DIR` if that name is not stable.

Shell equivalent: `${<PROJECT>_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/agent-projects/<slug>}`.

## Rules

- **Code never hardcodes in-repo personal paths.** Resolve `data/`, `shared/`,
  `secrets/` through the resolver above — never `REPO_ROOT/"data"`.
- **`.env` lives in `secrets/`.** Point `load_dotenv` at `<vault>/secrets/.env`.
- **`TODO.md` / `SESSION.md` live in `workspace/`** and are read from there — see
  `050-session-start.md`. They are no longer kept in the repo root.
- **Moving a file to the vault is a filesystem move**, not a commit. First confirm
  no code depends on the old in-repo path (grep `src/`), then move and repoint.
- **Never delete personal data to "clean" a repo** — relocate it to the vault.

## Why

A single, predictable location per project means: zero personal data in any repo,
one resolver to reason about, and no cross-project confusion about where a
project's work log or data actually lives.
