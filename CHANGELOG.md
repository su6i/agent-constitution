# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased] - 2026-06-09

### Added
- `templates/hooks/pre-commit` — canonical git pre-commit gate enforcing two
  non-negotiable rules deterministically: no direct commits to `main`/`master`,
  and the Pre-Commit Docs Checklist (code changes must touch a doc; minor
  follow-ups must be `--amend`ed). Bash 3.2 compatible. Installed by
  `amir init-project` into every new project. Bypass: `git commit --no-verify`.
- `workflows/first-session.md` — mandatory onboarding workflow to fill
  `CLAUDE.md`/`README.md`/`.env.example` and verify the skeleton before feature
  work; listed in README.
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
