# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## 2026-07-09 — universal agent bootloaders

### Added

- Thin bootloader files for every major non-Claude harness — `GEMINI.md`,
  `GROK.md`, `QWEN.md`, `MINIMAX.md`, `.cursorrules`, `.windsurfrules`,
  `.github/copilot-instructions.md`. Each contains no rules, only a mandatory
  redirect to `AGENTS.md` → `rules/` (single source of truth, rule 045).

### Changed

- `AGENTS.md` promoted to the canonical agent entry point: mandatory reading
  list (`000-core`, `global`, `040-git` + on-demand rules), the non-negotiables
  summary, and explicit obligations for architects/planners writing work
  orders (WOs must cite the rules they were written against).
- `.clinerules` rewritten in English (repo content is English-only;
  translations live under `fa/`) and now routes through `AGENTS.md` like the
  other bootloaders.

## 2026-07-03 — git hooks: merge gate, deletion fix, rule-036 enforcement

### Added

- `templates/hooks/pre-merge-commit` — git never runs pre-commit on automatic
  merge commits, so blocked personal files and secrets could enter main via a
  merge. The new hook execs the pre-commit gate with `CONSTITUTION_MERGE_GATE=1`;
  on merges (also detected via `MERGE_HEAD` for conflicted merges finished with
  `git commit`) Rule 1 (branch protection) and Rule 2 (docs checklist) are
  skipped — merging an approved branch into main is the sanctioned protocol
  step — while the privacy gates still scan the incoming changes.
- pre-commit Rule 5 — skill versioning (`rules/036-skill-versioning.md`) is now
  actually enforced: a staged `skills/**.md` file without `version:`/`updated:`
  frontmatter, or a modified skill whose `version:` is unchanged from HEAD,
  blocks the commit. The untracked-throwaway reminder is now Rule 6.

### Fixed

- pre-commit Rule 3 now checks only Added/Copied/Modified/Renamed files:
  deleting a tracked personal file (`git rm TODO.md`) is the rule-035
  remediation for a past leak and is no longer blocked.

## 2026-07-02 — pre-commit: PII scan operates on clean added lines

- The staged-diff PII scan now strips the leading `+` diff marker before any
  pattern matching. Fixes a false positive where decorators at added-line
  starts (`@pytest.fixture`, `@app.route`) were flagged as email addresses
  (the marker was being consumed as the email local-part). Real emails in
  added code are still caught.

## [Unreleased] - 2026-06-30

### Added

- `templates/.clinerules` — generic Cline source-of-truth pointer, seeded per repo by
  `install.sh` so Cline in every project reads the central TODO + vault + git rules.

### Fixed

- `skills/ai-router`: `import anthropic` is now optional (lazy import + guard in
  `ClaudeClient`). Grunt-work providers use `OpenAICompatibleClient` (httpx only), so a
  subscription-only setup with no Anthropic API key can run the router. Documented in
  the router README.
- `skills/ai-router/config_example.py`: corrected DeepSeek model IDs to the v4 names
  (`deepseek-v4-flash` / `deepseek-v4-pro`) and Sonnet 4.6 pricing.

- `skills/ai-router`: `RoutingConfig.roles` dict — maps role names ("planning", "acting"
  or any custom key) to ordered `ModelType` tuples; `generate(role=...)` activates
  role-based model selection (tried before complexity routing, circuit-open models
  skipped, complexity routing is the final fallback). Fallback chain honours the role
  order. Skill version bumped 1.2.0 → 1.3.0.
- `skills/ai-router`: `OpenAICompatibleClient` — generic httpx client for any
  `POST /chat/completions` provider (Grok, OpenAI, MiniMax, future providers).
  Added `ModelType.GROK` (`grok-3`, VERIFY at docs.x.ai) and `ModelType.OPENAI`
  (`gpt-4.1`, VERIFY at platform.openai.com). `_initialize_clients` wires these to
  the new client. Skill version bumped 1.3.0 → 1.4.0.
- `skills/ai-router/configure.py` — interactive wizard: asks planning/acting model
  priorities, writes `~/.config/ai-router/roles.yaml` (overridable via
  `AIROUTER_ROLES_FILE`), and prints a Cline settings snippet (Plan = subscription
  CLI, Act = proxy `http://localhost:8787/v1`). Separate from install.sh (zero-touch
  unchanged). Skill version bumped 1.4.0 → 1.5.0.

- `rules/035-data-vault.md`: added **Layered Secrets Model** section documenting
  the two-layer `_shared/secrets/.env` + `<project>/secrets/.env` resolution
  order, the multiple-Telegram-bots pattern (separate project vaults), and a
  Python `load_secrets()` reference snippet.
- `AGENTIC-CODING-SETUP.md`: updated stale model IDs and names to current values —
  `claude-opus-4-8` ($5/$25), `claude-sonnet-4-6` ($3/$15), `claude-haiku-4-5`
  ($1/$5); `MiniMax M3` / `MiniMax-M3`; removed stale date-stamped Claude ID
  (`claude-sonnet-4-5-20251001`); added deprecation notes for `deepseek-chat`
  (deprecates 2026-07-24); updated `last_updated` to 2026-06-30. Benchmark
  scores for models other than Claude kept as-is (uncertain); OpenRouter slugs
  for MiniMax/Grok flagged with VERIFY comments.

### Fixed

- `templates/hooks/pre-commit`:
  - Rule 2: deletion-only commits no longer require a documentation update.
    The `all_staged` variable (all diff-filter modes) is now computed alongside
    `staged` (ACMR only); if `staged` is empty but `all_staged` is non-empty, the
    docs check is explicitly skipped. This makes the intent clear rather than
    relying on an implicit empty-string exit.
  - Rule 3: added `CLAUDE.md` to the personal-files blocklist (project-level
    CLAUDE.md files may contain personal configuration; use `--no-verify` to
    commit the shared template version intentionally). Rule 3 now iterates over
    `all_staged` (not `staged`) so it also catches personal files in
    deletion-only commits.
  - Added a comment block noting that merge commits bypass pre-commit and
    recommending CI-level secret-scan and branch-protection checks as the
    server-side gate.

## [Unreleased] - 2026-06-09

### Fixed

- CI `Validate Repository`: ignore `id.atlassian.com` in the markdown link-check config — it returns HTTP 202 to the bot checker (handled like the other bot-blocked domains already in the ignore list).

### Added

- `bin/open-branches.sh` + a session-start step — report unmerged / stale git branches (current repo with `--here`, or every repo under `~/@-github`) so half-done branches are not forgotten.
- `templates/hooks/pre-commit` — canonical git pre-commit gate enforcing two
  non-negotiable rules deterministically: no direct commits to `main`/`master`,
  and the Pre-Commit Docs Checklist (code changes must touch a doc; minor
  follow-ups must be `--amend`ed). Bash 3.2 compatible. Installed by
  `amir init-project` into every new project. Bypass: `git commit --no-verify`.
- `workflows/first-session.md` — mandatory onboarding workflow to fill
  `CLAUDE.md`/`README.md`/`.env.example` and verify the skeleton before feature
  work; listed in README.
- `workflows/propagate-constitution.md` — workflow for rolling constitution
  updates (rules/skills/hook) out to every consuming project via
  `amir update-projects`; listed in README.
- `bin/mcp-server/server_http.py` — HTTP server with SSE + Streamable HTTP transports (localhost:8765)
- `bin/mcp-server/com.agent-constitution.mcp.plist` — launchd service for auto-start on login
- `/health` endpoint for status checks
- Full IDE setup docs: Cursor, VS Code, Antigravity IDE, JetBrains, Gemini CLI

### Changed

- `templates/gitignore.template` — replaced the 410-line generic toptal dump
  with a curated 2026 Python/uv ignore. Removes the `[Ll]ib`/`[Bb]in`/`scripts`/
  `include` patterns that silently hid source directories, drops the leftover
  `Roadmap/`, adds `.storage/`, and keeps full macOS/Linux/Windows sections.
- `workflows/init-project.md` — rewritten to match the submodule-based flow
  (was pointing at the retired `bin/scaffold.sh` and `.txt` prompt templates):
  src-layout, `.gitkeep`, storage policy, `uv init`, mandatory first session.

### Fixed

- CI `Check Internal Links` — repaired the long-standing red build:
  - 75 `skills/*.md` files used `](../../README.md)` (one level too deep) → `](../README.md)`.
  - ~115 links to bundled reference files not shipped in this repo (e.g. Angular/
    VideoDB/Remotion `references/*.md`, `reference/*.md`, `rules/*.md`) were
    unlinked to inline code, preserving the text without a dead link.
  - `.github/mlc_config.json` now ignores CI-flaky/external domains (w3.org,
    developer.android.com, npmjs.com, doi.org, patentsview.org, github.com/apps).
- `AGENTS.md` stale skill count updated from 77 to 343

### Fixed

- MCP server now negotiates protocol version (`2025-11-25` and `2024-11-05` supported)
- `prompts/list` returns empty list instead of error
- `resources/list` no longer sends 48KB payload on connect (skills moved to tools)

### Added

- `list_skills` tool — lists all 343 skills so Claude can discover them proactively
- `get_skill` tool — reads any skill by name without requiring the caller to know the resource URI

---

## [1.0.0] - 2026-02-07

### 🎉 Initial Release

#### Added

- **58 Technical Skills** covering:
  - Python, JS/TS, Swift, Kotlin development
  - AI/ML workflows (LLM, RAG, Reinforcement Learning)
  - Data Science pipelines (Polars, DuckDB, Pandas)
  - Creative automation (Manim, Blender, DaVinci Resolve)
  - DevOps & Infrastructure (Kubernetes, Docker, GitHub Actions)
  - Web3 & Blockchain (Solidity, Foundry)

- **6 Workflows** for:
  - Project initialization
  - Documentation standards
  - AI optimization
  - Quality assurance
  - Communication protocols
  - Social media showcase

- **6 Prompt Templates** for:
  - Technical documentation
  - LinkedIn launches
  - Project logos
  - README generation

- **Global Rules** (`.cursor/rules/global.mdc.md`)
- **Scaffolder Script** (`bin/scaffold.sh`) for project initialization
- **Unified Navigation** with "Back to README" links across all files
- **Persian README** (`README.fa.md`) for Farsi-speaking users
- **CI/CD Pipeline** for link validation

#### Changed

- Migrated from root-level files to `.cursor/` directory structure
- Converted all prompts from `.txt` to `.md` format
- Standardized skill files to Anthropic's format

---

## [1.1.0] - 2026-02-14

### Added

- **Subtitle Generator Skill** (`.cursor/skills/subtitle-generator.md`): Professional Persian subtitle pipeline (Whisper, FFmpeg, Manim).
- **Supporting Scripts** for Subtitle Generator:
  - `split_sentences.py`: Optimized Persian sentence splitting.
  - `apply_subtitle.py`: Whisper JSON to stylized ASS converter.

### Changed

- **Manim Animation Skill**: Integrated Section 19 with Persian/Emoji typography protocols and renderer warmup techniques.

---

## [Unreleased]

### Planned

- MCP Server integration
- VS Code extension
- Raycast scripts

---

[Back to README](README.md)
