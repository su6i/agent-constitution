# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
