---
title: Agent Constitution 📜
description: Universal validated context architecture for AI Agents (VS Code, Antigravity, Claude)
location: README.md
last_updated: 2026-02-21
---

<div align="center">

<img src="assets/project_logo.png" width="350">

<h1>Agent Constitution 📜</h1>

<p align="center">
  <a href="https://github.com/su6i/agent-constitution/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-green3.svg" height="20" style="vertical-align: middle;"></a><a href="#"><img src="https://img.shields.io/badge/Status-Active-blue.svg" height="20" style="vertical-align: middle;"></a><a href="workflows/documentation.md"><img src="https://img.shields.io/badge/Docs-Technical-orange.svg" height="20" style="vertical-align: middle;"></a><a href="https://linkedin.com/in/su6i"><img src="assets/linkedin_su6i.svg" height="20" style="vertical-align: middle; margin-bottom: -1px; margin-left: 3px;"></a>
</p>

<strong>The Validated Context Architecture for AI Agents.</strong>

[🇮🇷 نسخه فارسی](README.fa.md) • [Contributing](CONTRIBUTING.md) • [Changelog](CHANGELOG.md)

</div>

---

## 📍 Primary Document
The main technical document of this repository is [AGENTIC-CODING-SETUP.md](AGENTIC-CODING-SETUP.md).

If you want the core benchmark analysis, cost model, routing strategy, setup patterns, and low-cost agentic coding methodology, start there first. The rest of the repository either:
- introduces that document,
- operationalizes it,
- localizes it,
- or extends it with reusable rules, workflows, and templates.

For the repository map, see [docs/INFORMATION-ARCHITECTURE.md](docs/INFORMATION-ARCHITECTURE.md).

---

## 🏗 The Problem
Most AI Agents (Cursor, AntiGravity, Windsurf, Copilot) fail because their "memory" is unstructured. You give them a 50-page prompt, they hallucinate. You give them nothing, they write spaghetti code.
**We needed a middle ground: A strict, modular "Constitution" that forces Agents to behave like Senior Engineers.**

## ⚡ The Solution: Context Architecture
This repository is not just "rules". It is a **Modular Context Architecture**.
It breaks down the software lifecycle into 5 atomic, linked workflows. The Agent loads *only* what it needs, when it needs it.

In practice, the repository now has a clear center of gravity:
- [AGENTIC-CODING-SETUP.md](AGENTIC-CODING-SETUP.md) is the flagship guide and canonical technical reference.
- [README.md](README.md) is the onboarding and navigation layer.
- [AGENTS.md](AGENTS.md) is the execution contract for agents.
- `.agent/`, `templates/`, `bin/`, and `docs/` are the implementation and support layers around that core guidance.

### Core Features 
- **⚖️ The Neural Gavel:** A strict `.cursorrules` router that prevents the Agent from guessing.
- **🧠 Modular Memory:** Workflows for Init, Docs, AI, and QA are split to prevent "Lost-in-the-Middle" errors.
- **🛡️ Truth Protocol:** Agents are forbidden from marking tasks "Done" without `ls -R` verification.
- **🤖 Anti-Hallucination:** Strict file collision and deletion safety protocols.

## 🚀 Quick Start

### Read Order
1. Read [AGENTIC-CODING-SETUP.md](AGENTIC-CODING-SETUP.md) for the core methodology.
2. Read [AGENTS.md](AGENTS.md) for execution constraints and agent behavior.
3. Use the workflow, template, and skill files as modular extensions of the core guide.

### Option A: Automated Scaffolding (Recommended)
1.  **Install the Scaffolder:**
    ```bash
    # Add this alias to your shell config (~/.zshrc)
    alias init-gh='~/path/to/agent-constitution/bin/scaffold.sh'
    ```
2.  **Run in any new project:**
    ```bash
    mkdir my-new-project && cd my-new-project
    init-gh
    ```
    *Result: The `rules/`, `workflows/`, and `.agent/prompts/` are injected and committed automatically.*

### Option B: Manual Setup
1.  Clone this repo.
2.  Copy `rules/`, `workflows/`, and `.agent/prompts/` to your project root.
3.  **Ask your Agent:**
    > "Audit my codebase against the Quality Assurance protocol."

## 📚 Documentation

### ⭐ Flagship Guide
- **[Agentic Coding 2026](AGENTIC-CODING-SETUP.md):** Canonical benchmark, ROI, routing, tooling, and low-cost setup guide for the repository.
- **[Information Architecture](docs/INFORMATION-ARCHITECTURE.md):** Explains how the rest of the repository relates to the flagship guide.

### 🛠 Workflows
- **[Init Workflow](workflows/init-project.md):** How to start clean.
- **[AI Logic](workflows/ai-optimization.md):** Architect vs Executor models.
- **[QA Protocol](workflows/quality-assurance.md):** Zero-bug policy.
- **[Communication](workflows/communication.md):** Standardized project reporting.
- **[Social Showcase](workflows/social-media-showcase.md):** World-class marketing assets.

### 📝 Prompts
- **[Technical Template](.agent/prompts/template_technical.md):** Base structure for technical docs.
- **[LinkedIn Launch](.agent/prompts/template_linkedin_launch.md):** Viral marketing hooks.
- **[Logo Specs](.agent/prompts/template_project_logo.md):** DALL-E/Midjourney prompts for tech branding.

### 🧠 Skills
- **[CLI Table Alignment](skills/cli-table-alignment.md):** Pixel-perfect ASCII tables with Emoji support.
- **[Zsh Completion](skills/zsh-completion.md):** Robust autocomplete scripts avoiding common pitfalls.
- **[Zsh Scripting Advanced](skills/zsh-scripting-advanced.md):** SIGINT traps, option parsing, and advanced shell patterns.
- **[MLX Whisper](skills/mlx-whisper.md):** Apple Silicon-optimized Whisper transcription via mlx-whisper.
- **[YouTube SEO](skills/youtube-seo.md):** Strategy for titles, retention, and content growth.
- **[yt-dlp Web Download](skills/youtube-dlp-web-download.md):** Cloudflare bypass, stream selection, and bitrate-aware extraction.
- **[FFmpeg Recipes](skills/ffmpeg-recipes.md):** Copy-pasteable commands for video automation.
- **[FFmpeg Reference](skills/ffmpeg-reference.md):** Technical reference for codec ops, metadata, and flags.
- **[Data Science Workflow](skills/data-science-workflow.md):** Reproducible science structure.
- **[MacOS Automation](skills/macos-automation.md):** Python/Zsh scripts for desktop tasks.
- **[Prompt Engineering](skills/prompt-engineering.md):** Advanced system prompts & personas.
- **[Claude Code Integration](skills/claude-code-integration.md):** Claude Code CLI, hooks, MCP servers, and agentic workflow patterns.
- **[Storytelling TTS M4](skills/storytelling-tts-m4-system.md):** End-to-end TTS storytelling pipeline on Apple Silicon (XTTS, GPT-SoVITS, Kokoro).
- **[FastAPI Best Practices](skills/fastapi-best-practices.md):** Scalable, type-safe API patterns.
- **[Flask JSON Guide](skills/flask-json-guide.md):** Robust structure for Flask APIs.
- **[LLM & ML Workflow](skills/llm-ml-workflow.md):** Productionizing AI models.
- **[SwiftUI Guidelines](skills/swiftui-guidelines.md):** iOS modern architecture & audio.
- **[Jetpack Compose](skills/jetpack-compose-guidelines.md):** Android declarative UI & permissions.
- **[Chrome Extensions](skills/chrome-extension-best-practices.md):** MV3 UI/UX & Shadow DOM.
- **[Modern Web UI](skills/modern-web-ui.md):** Vanilla HTML/CSS/JS best practices.
- **[Financial Data Pipeline](skills/financial-data-science.md):** OpenBB, Pandas-TA, & QuantStats stack.
- **[DevOps & MLOps](skills/ops-automation.md):** CI/CD, Docker, & Experiment Tracking.
- **[System Architecting](skills/ai-logic-patterns.md):** Master prompting & agent orchestration rules.
- **[Multi-Step RAG](skills/multi-rag-orchestration.md):** Stateful memory & lexical tracking (SRS).
- **[Video Production Automation](skills/video-production-automation.md):** Python stack overview: Manim, MoviePy, and OpenCV.
- **[Blender Automation](skills/video-blender-automation.md):** Python (bpy) & Geometry Nodes.
- **[DaVinci Resolve](skills/video-resolve-editing.md):** Python API & Post-Production.
- **[Remotion Video](skills/video-remotion-react.md):** Programmatic video with React.
- **[Code Quality](skills/github-code-quality.md):** Strict rules for clean, verified code changes.
- **[Kubernetes & Docs](skills/kubernetes-docs.md):** K8s best practices & MkDocs integration.
- **[Linux CUDA Python](skills/linux-cuda-python.md):** HPC setup, PyTorch optimization, & profiling.
- **[Python Containerization](skills/python-containerization.md):** Docker best practices (Slim vs Alpine, Multi-stage).
- **[Python GitHub Setup](skills/python-github-setup.md):** Actions, Templates, & Semantic Release.
- **[JS/TS Quality](skills/js-ts-code-quality.md):** Strict TypeScript, Biome/ESLint, & Vitest.
- **[Pandas & Scikit-learn](skills/python-pandas-sklearn.md):** Method chaining, Pipelines, & ColumnTransformer.
- **[Python Core Standards](skills/python-core-standards.md):** Project structure, `uv` implementation, & Typing.
- **[Centralized Config Pattern](skills/centralized-config-pattern.md):** Single source of truth for multi-language projects (Bash + Python).
- **[PDF Form Filling](skills/pdf-form-filling.md):** Automated PDF form filling and document generation.
- **[PDF Rendering Engines](skills/pdf-rendering-engines.md):** PDF rendering stack comparison and engine selection.
- **[CV LaTeX Workspace](skills/cv-latex-workspace.md):** Multi-template CV system with shared macros, pdflatex/xelatex pipeline, and job-applier integration.
- **[PyTorch Integration](skills/python-pytorch-sklearn.md):** Sklearn data pipelines with PyTorch models.
- **[R Language](skills/r-lang-guide.md):** `targets` pipelines & `renv` practices.
- **[Solidity (Foundry)](skills/web3-solidity-foundry.md):** Modern Rust-based testing & fuzzing stack.
- **[Solidity (Hardhat)](skills/web3-solidity-hardhat.md):** JS/TS ecosystem guide & tooling.
- **[Web3 React](skills/web3-react-dapps.md):** Wagmi, Viem, & dApp architecture.
- **[ASCII Games](skills/ascii-game-dev.md):** ECS architecture & terminal rendering optimization.
- **[Desktop GUIs](skills/desktop-gui-dev.md):** Modern Python apps with CustomTkinter & PyQt6.
- **[How-To Docs](skills/howto-documentation.md):** Diátaxis framework & technical writing guides.
- **[Data Visualization](skills/data-visualization.md):** Publication-quality plots with Scipy/Seaborn.
- **[Image Enhancement](skills/image-enhancement.md):** Neural upscaling, denoising, and post-processing pipelines.
- **[ImageMagick Reference](skills/imagemagick-reference.md):** Input normalization, corner rounding, and standard operations.
- **[ImageMagick Technical](skills/imagemagick-technical.md):** PDF conversion math, color space, FX operator, and batch orchestration.
- **[Reinforcement Learning](skills/reinforcement-learning.md):** Gymnasium envs & Stable-Baselines3 training.
- **[Manim Animation](skills/video-manim-math.md):** Math animations with Python & LaTeX.
- **[YouTube Scriptwriting](skills/screenwriting-youtube.md):** High-retention hooks & psychology.
- **[Screenwriting Frameworks](skills/screenwriting-frameworks.md):** 3-Act structure, Hero's Journey, and beat sheet methodology.
- **[Advanced Screenwriting](skills/storytelling-narrative-frameworks.md):** Save the Cat, Hero's Journey, & Story Circle.
- **[Copywriting](skills/copywriting.md):** Information processing & conversion logic.
- **[Audio Processing](skills/audio-processing.md):** Neural denoising & EBU R128 normalization.
- **[Speech Synthesis](skills/voice-synthesis-multilingual.md):** SOTA multilingual protocols & cross-lingual cloning.
- **[Voice Orchestration](skills/voice-orchestration-multi-model.md):** Multi-model pipelines (Fish, Dia, Bark, Parler).
- **[AI Voice Synthesis](skills/voice-ai-cloning-finetuning.md):** Multilingual fine-tuning & emotional synthesis.
- **[AI SFX Generation](skills/ai-sfx-generation.md):** Latent diffusion for sound design.
- **[AI Cinematography](skills/visual-ai-cinematography.md):** Gen-video protocols (Runway, Kling, Luma).
- **[Character Consistency](skills/visual-character-consistency.md):** Identity preservation (ComfyUI, LoRA).
- **[AI Dubbing](skills/ai-dubbing-localization.md):** Automated localization & tone preservation.
- **[Stick Figure Animation](skills/video-stick-figure.md):** Fluid 2D motion & physics.
- **[Thumbnail Psychology](skills/visual-thumbnail-psychology.md):** Visual engagement & CTR optimization.
- **[Moltbot Orchestration](skills/moltbot-orchestration.md):** Multi-agent video factory architecture.
- **[CLIL Screenwriting](skills/storytelling-clil-education.md):** Educational storytelling & Leitner SRS.
- **[Automated Scriptwriting](skills/screenwriting-automated.md):** 100% automated script production pipeline.
- **[Method of Loci](skills/method-of-loci.md):** Spatial memory & Blender-based loci construction.
- **[Dialogue TTS](skills/voice-dialogue-tts.md):** Multi-speaker turn-taking & emotional prosody.
- **[Emotional Voice Acting](skills/voice-emotional-acting.md):** One-person multi-character production & GPT-SoVITS.
- **[Episode Structure](skills/episode-structure-45min.md):** 45-minute 3-part format & cognitive load management.
- **[Procedural Direction](skills/visual-director-procedural.md):** Blender & Manim semantic visuals.
- **[Subtitle Generator](skills/subtitle-generator.md):** Professional Persian subtitles with cinematic typography.

---

## 🤖 MCP Server Integration

Connect this knowledge base to any MCP-compatible AI assistant.
Two transports available — **stdio** (Claude Code CLI) and **HTTP** (everything else).

### One-time HTTP server setup
```bash
cp bin/mcp-server/com.agent-constitution.mcp.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.agent-constitution.mcp.plist
curl http://localhost:8765/health  # → {"status":"ok","skills":343}
```

### Connect your tool

| Tool | Config |
|---|---|
| **Claude Code CLI** | Zero config — stdio works out of the box |
| **Cursor** | `~/.cursor/mcp.json` → `"url": "http://localhost:8765/sse"` |
| **VS Code** | Continue.dev extension → `~/.continue/config.json` |
| **Antigravity IDE** | Continue.dev extension → same `~/.continue/config.json` |
| **JetBrains** | Continue plugin → same `~/.continue/config.json` |
| **Gemini CLI** | `~/.gemini/settings.json` → `"httpUrl": "http://localhost:8765/mcp"` |

### Available Tools
| Tool | Description |
|---|---|
| `list_skills` | List all 343 skill names |
| `get_skill` | Read any skill — e.g. `get_skill("fastapi-best-practices")` |
| `get_rules` | Get global repository rules |
| `run_<workflow>` | Execute a workflow |

See **[MCP Server README](bin/mcp-server/README.md)** for full per-IDE setup instructions.

---
*Built with strict adherence to the Prompt-Driven Development methodology.*
