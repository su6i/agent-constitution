---
title: "036: Skill Versioning"
description: Every skill carries a version and date; any change must bump them — this is what makes cross-project skill installation version-safe.
location: rules/036-skill-versioning.md
agent_priority: High
last_updated: 2026-06-30
---

# Skill Versioning

## Why

Skills are a **single source of truth** shared across every project (see
`bootstrap-installer`). Project installers register them into `~/.claude/skills/`
and **only overwrite an older version** — never a newer one. That safety depends
entirely on the `version:` field being accurate. A skill edited without a version
bump is invisible to the installer: other projects keep their stale copy.

## Rule (Non-Negotiable)

<!-- digest:start -->
**Every skill file must carry `version:` and `updated:` in its frontmatter:**

```yaml
---
name: my-skill
description: ...
version: 1.2.0      # semver
updated: 2026-06-30 # ISO date of the last change
---
```

**After ANY change to a skill — before committing — you MUST:**

1. Bump `version:` using semver:
   - **patch** (`1.2.0 → 1.2.1`) — typo, clarification, small fix
   - **minor** (`1.2.0 → 1.3.0`) — new section, new capability, additive
   - **major** (`1.2.0 → 2.0.0`) — rewrite or breaking change to guidance
2. Set `updated:` to today's date.

A skill edit without a version+date bump is an **incomplete change** — the same
status as code changed without updating docs (`040-git`). Do not commit it.
<!-- digest:end -->

## New Skills

A new skill starts at `version: 1.0.0` with `updated:` set to its creation date.

## Enforcement

This is enforced deterministically by the pre-commit hook: a staged change to any
`skills/**` file whose `version:` line is unchanged from `HEAD` blocks the commit,
exactly like the personal-data and direct-to-main gates. The hook cannot be
"forgotten" by any agent or human.

## Why Not Rely on Timestamps / Git?

File mtimes are lost on clone and symlink; git history is per-repo and does not
travel with a symlinked skill. The `version:` field is the only signal that is
portable across machines and projects — so it must be maintained by hand on every
edit.
