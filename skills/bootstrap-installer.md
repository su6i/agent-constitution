---
name: bootstrap-installer
description: Write zero-touch, idempotent install.sh / setup scripts for CLI and service projects — OS detection, uv-first dependency setup, .env config with auto-generated secrets, central-source bootstrap (clone-or-update + symlink, no submodule), and end-of-run verification. Use when creating or reviewing a project installer / bootstrap script.
origin: ECC
version: 1.1.0
updated: 2026-06-30
---

> The vault dirs (`data/shared/references/secrets/workspace`) are created on-demand
> by `bin/scaffold-vault.sh [slug]` — call it from the installer's config step (or
> any agent) instead of hand-creating per-project folders. It derives the slug the
> same way as the `035-data-vault` resolver (git remote → repo name).

# Bootstrap Installer

Write a single `install.sh` that takes a **fresh clone to a fully working project with zero user intervention** — detect the environment, install only what is missing, configure secrets safely, wire in shared central sources, and verify the result.

## When to Activate

- Creating or rewriting a project's `install.sh` / `setup.sh` / `bootstrap.sh`
- A repo must wire in a shared central resource (e.g. `agent-constitution`) **without a git submodule**
- Reviewing an installer for idempotency, safety, or zero-touch compliance

## Non-Negotiable Principles

1. **Fail-fast** — `set -euo pipefail`. On error print a clear cause and exit non-zero. Never a silent failure (aligns with `000-core` No Silent Errors).
2. **Idempotent** — safe to run repeatedly. Check before you change (`command -v`, `grep -qF`, file-exists) and install/append **only what is missing**. Running twice must be a no-op the second time.
3. **Zero-touch by default** — no blocking prompts in the happy path. Where input is unavoidable (secret keys), guard it and accept env/flag overrides so CI can run it unattended.
4. **OS-aware** — `uname -s` → `brew` (macOS) / `apt` (Debian) / etc.
5. **uv-only for Python** — ensure `uv` (auto-install + verify), then `uv sync`. Never call `pip` directly.
6. **Secrets never in the repo** — prompt or auto-generate, write to the vault (`<vault>/secrets/.env`, see `035-data-vault`). Never overwrite an existing `.env` without explicit confirmation.
7. **Verify at the end** — run an import/build smoke test and report success/failure explicitly.

## Standard Pipeline (the sections of a good install.sh)

| # | Section | What it does |
|---|---------|--------------|
| 0 | **Preamble** | shebang, `set -euo pipefail`, colors + `success`/`warn`/`error` helpers |
| 1 | **OS detection** | `uname -s` → choose package manager |
| 2 | **uv** | install if missing, verify, `uv self update \|\| true` |
| 3 | **System deps** | per-OS; `command -v` each; install only missing; **required vs optional** (optional = warn-only) |
| 4 | **Python env** | `uv sync` from `pyproject.toml` + `uv.lock` |
| 5 | **Central-source bootstrap** | clone-or-update the shared repo + symlink into the project (no submodule) |
| 6 | **Config / secrets** | ensure vault dirs; if `<vault>/secrets/.env` missing → seed from `.env.example`, prompt/auto-generate secrets; never overwrite without confirm |
| 7 | **PATH wiring** (CLI tools) | append to shell rc only if not already present (`grep -qF`) |
| 8 | **Verify** | smoke import/build; print final status + usage |

## Helper Pattern

```bash
#!/usr/bin/env bash
set -euo pipefail
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
success() { printf "${GREEN}✅ %s${NC}\n" "$1"; }
warn()    { printf "${YELLOW}⚠️  %s${NC}\n" "$1"; }
error()   { printf "${RED}❌ %s${NC}\n" "$1" >&2; exit 1; }

case "$(uname -s)" in
  Darwin) PKG="brew install" ;;
  Linux)  PKG="sudo apt-get install -y" ;;
  *) error "Unsupported OS: $(uname -s)" ;;
esac

need() {  # need <cmd> <install-arg> [optional]
  command -v "$1" >/dev/null 2>&1 && { success "$1 found"; return 0; }
  [ "${3:-}" = optional ] && { warn "$1 missing (optional) — skipping"; return 0; }
  warn "$1 missing — installing"; $PKG "$2" || error "failed to install $1"
}
```

## uv Ensure Pattern

```bash
if ! command -v uv >/dev/null 2>&1; then
  warn "uv not found — installing"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
command -v uv >/dev/null 2>&1 || error "uv install failed — see https://docs.astral.sh/uv/"
uv self update >/dev/null 2>&1 || true
uv sync
```

## Bootstrap Pattern (central shared source — no submodule)

A submodule pins a per-repo SHA and drifts. For a **single source of truth**, keep one
central clone and symlink it in. Idempotent clone-or-update:

```bash
CENTRAL="${AGENT_CONSTITUTION_DIR:-$HOME/@-github/agent-constitution}"
REMOTE="git@github.com:su6i/agent-constitution.git"

if [ -d "$CENTRAL/.git" ]; then
  git -C "$CENTRAL" pull --ff-only || warn "could not update $CENTRAL"
else
  git clone "$REMOTE" "$CENTRAL" || error "failed to clone constitution"
fi

ln -sfn "$CENTRAL" .agent/constitution   # -f replace, -n don't follow existing link
success "constitution linked → $CENTRAL"
```

`.agent/constitution` (the symlink) is gitignored. A cloner runs `install.sh` once and
the link is created; edits to the central clone are seen instantly by every project.

## Skill Registration (version-safe)

To surface the central skills in Claude Code's `/skills`, link each into
`~/.claude/skills/<name>/SKILL.md`. Many projects run their own installer against
the **same** central source, so registration must be **idempotent and version-safe**
— never clobber a newer skill registered by another project (see `036-skill-versioning`):

```bash
skill_version() { grep -m1 '^version:' "$1" | sed 's/^version:[[:space:]]*//' | tr -d '"'; }
is_newer() { [ "$1" != "$2" ] && [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -1)" = "$1" ]; }
# for each central skill f → dst=~/.claude/skills/<name>/SKILL.md:
#   symlink already points at f      → re-link (no-op, idempotent)
#   dst exists from another source    → relink ONLY if our version is strictly newer
#   dst absent                        → link
```

Because every project links to the one central source, the normal case is a no-op;
the version check only fires when sources diverge, and it keeps the newer skill.

## Config / Secrets Pattern

```bash
ENV="$VAULT/secrets/.env"
mkdir -p "$VAULT/secrets"
if [ -f "$ENV" ]; then
  success ".env present — leaving untouched"
else
  cp .env.example "$ENV"
  # auto-generate a secret without user input
  KEY="$(python3 -c 'import secrets; print(secrets.token_hex(32))')"
  printf 'ADMIN_API_KEY=%s\n' "$KEY" >> "$ENV"
  warn "seeded $ENV from .env.example — fill in provider keys"
fi
```

- Use `read -rs` for any key typed interactively (hidden input).
- Insert each key idempotently: `grep -q "^${k}=" "$ENV" || echo "${k}=${v}" >> "$ENV"`.
- Keep `.env.example` in the repo, always current (every new var added immediately).

## Anti-Patterns

- Blocking prompts on the happy path (breaks CI / unattended installs)
- `pip install` instead of `uv`
- Global/system installs without a `command -v` guard (non-idempotent)
- Silent failures (`|| true` on a step that must succeed)
- Appending to a shell rc / `.env` without a `grep` guard (duplicates on re-run)
- Overwriting an existing `.env`
- A **git submodule** for a source that should be single-truth — use the bootstrap symlink

## Quality Gate

- Runs clean **twice in a row** (second run is a no-op → proves idempotency)
- Fresh clone → working project with **no manual step**
- **No secret** written anywhere inside the repo tree (only the vault)
- Explicit **pass/fail** printed at the end (verify step actually runs the app/import)
