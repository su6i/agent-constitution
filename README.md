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
  <a href="https://github.com/su6i/agent-constitution/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-green3.svg" height="20" style="vertical-align: middle;"></a><a href="#"><img src="https://img.shields.io/badge/Status-Active-blue.svg" height="20" style="vertical-align: middle;"></a><a href=".cursor/workflows/documentation.md"><img src="https://img.shields.io/badge/Docs-Technical-orange.svg" height="20" style="vertical-align: middle;"></a><a href="https://linkedin.com/in/su6i"><img src="assets/linkedin_su6i.svg" height="20" style="vertical-align: middle; margin-bottom: -1px; margin-left: 3px;"></a>
</p>

<strong>The Validated Context Architecture for AI Agents.</strong>

[🇮🇷 نسخه فارسی](README.fa.md) • [Contributing](CONTRIBUTING.md) • [Changelog](CHANGELOG.md)

</div>

---

## 🏗 The Problem
Most AI Agents (Cursor, AntiGravity, Windsurf, Copilot) fail because their "memory" is unstructured. You give them a 50-page prompt, they hallucinate. You give them nothing, they write spaghetti code.
**We needed a middle ground: A strict, modular "Constitution" that forces Agents to behave like Senior Engineers.**

## ⚡ The Solution: Context Architecture
This repository is not just "rules". It is a **Modular Context Architecture**.
It breaks down the software lifecycle into 5 atomic, linked workflows. The Agent loads *only* what it needs, when it needs it.

### Core Features 
- **⚖️ The Neural Gavel:** A strict `.cursorrules` router that prevents the Agent from guessing.
- **🧠 Modular Memory:** Workflows for Init, Docs, AI, and QA are split to prevent "Lost-in-the-Middle" errors.
- **🛡️ Truth Protocol:** Agents are forbidden from marking tasks "Done" without `ls -R` verification.
- **🤖 Anti-Hallucination:** Strict file collision and deletion safety protocols.

## 🚀 Quick Start

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
    *Result: The `.cursorrules`, `.cursor/workflows/`, and `.cursor/prompts/` are injected and committed automatically.*

### Option B: Manual Setup
1.  Clone this repo.
2.  Copy `.cursorrules`, `.cursor/workflows/`, and `.cursor/prompts/` to your project root.
3.  **Ask your Agent:**
    > "Audit my codebase against the Quality Assurance protocol."

## 📚 Documentation

### 🛠 Workflows
- **[Init Workflow](.agent/workflows/init-project.md):** How to start clean.
- **[AI Logic](.agent/workflows/ai-optimization.md):** Architect vs Executor models.
- **[QA Protocol](.agent/workflows/quality-assurance.md):** Zero-bug policy.
- **[Communication](.agent/workflows/communication.md):** Standardized project reporting.
- **[Social Showcase](.agent/workflows/social-media-showcase.md):** World-class marketing assets.

### 📝 Prompts
- **[Technical Template](.agent/prompts/template_technical.md):** Base structure for technical docs.
- **[LinkedIn Launch](.agent/prompts/template_linkedin_launch.md):** Viral marketing hooks.
- **[Logo Specs](.agent/prompts/template_project_logo.md):** DALL-E/Midjourney prompts for tech branding.

### 🧠 Skills
- **[CLI Table Alignment](.agent/skills/cli-table-alignment.md):** Pixel-perfect ASCII tables with Emoji support.
- **[Zsh Completion](.agent/skills/zsh-completion.md):** Robust autocomplete scripts avoiding common pitfalls.
- **[YouTube SEO](.agent/skills/youtube-seo.md):** Strategy for titles, retention, and content growth.
- **[FFmpeg Recipes](.agent/skills/ffmpeg-recipes.md):** Copy-pasteable commands for video automation.
- **[Data Science Workflow](.agent/skills/data-science-workflow.md):** Reproducible science structure.
- **[MacOS Automation](.agent/skills/macos-automation.md):** Python/Zsh scripts for desktop tasks.
- **[Prompt Engineering](.agent/skills/prompt-engineering.md):** Advanced system prompts & personas.
- **[Storytelling](.agent/skills/storytelling-frameworks.md):** Hero's Journey applied to tech.
- **[FastAPI Best Practices](.agent/skills/fastapi-best-practices.md):** Scalable, type-safe API patterns.
- **[Flask JSON Guide](.agent/skills/flask-json-guide.md):** Robust structure for Flask APIs.
- **[LLM & ML Workflow](.agent/skills/llm-ml-workflow.md):** Productionizing AI models.
- **[SwiftUI Guidelines](.agent/skills/swiftui-guidelines.md):** iOS modern architecture & audio.
- **[Jetpack Compose](.agent/skills/jetpack-compose-guidelines.md):** Android declarative UI & permissions.
- **[Chrome Extensions](.agent/skills/chrome-extension-best-practices.md):** MV3 UI/UX & Shadow DOM.
- **[Modern Web UI](.agent/skills/modern-web-ui.md):** Vanilla HTML/CSS/JS best practices.
- **[Financial Data Pipeline](.agent/skills/financial-data-science.md):** OpenBB, Pandas-TA, & QuantStats stack.
- **[DevOps & MLOps](.agent/skills/ops-automation.md):** CI/CD, Docker, & Experiment Tracking.
- **[System Architecting](.agent/skills/ai-logic-patterns.md):** Master prompting & agent orchestration rules.
- **[Multi-Step RAG](.agent/skills/multi-rag-orchestration.md):** Stateful memory & lexical tracking (SRS).
- **[Blender Automation](.agent/skills/blender-automation.md):** Python (bpy) & Geometry Nodes.
- **[DaVinci Resolve](.agent/skills/resolve-editor.md):** Python API & Post-Production.
- **[Remotion Video](.agent/skills/remotion-video.md):** Programmatic video with React.
- **[Code Quality](.agent/skills/github-code-quality.md):** Strict rules for clean, verified code changes.
- **[Kubernetes & Docs](.agent/skills/kubernetes-docs.md):** K8s best practices & MkDocs integration.
- **[Linux CUDA Python](.agent/skills/linux-cuda-python.md):** HPC setup, PyTorch optimization, & profiling.
- **[Python Containerization](.agent/skills/python-containerization.md):** Docker best practices (Slim vs Alpine, Multi-stage).
- **[Python GitHub Setup](.agent/skills/python-github-setup.md):** Actions, Templates, & Semantic Release.
- **[JS/TS Quality](.agent/skills/js-ts-code-quality.md):** Strict TypeScript, Biome/ESLint, & Vitest.
- **[Pandas & Scikit-learn](.agent/skills/pandas-sklearn-guide.md):** Method chaining, Pipelines, & ColumnTransformer.
- **[Python Core Standards](.agent/skills/python-core-standards.md):** Project structure, `uv` implementation, & Typing.
- **[PyTorch Integration](.agent/skills/pytorch-sklearn-integration.md):** Sklearn data pipelines with PyTorch models.
- **[R Language](.agent/skills/r-lang-guide.md):** `targets` pipelines & `renv` practices.
- **[Solidity (Foundry)](.agent/skills/solidity-foundry.md):** Modern Rust-based testing & fuzzing stack.
- **[Solidity (Hardhat)](.agent/skills/solidity-hardhat.md):** JS/TS ecosystem guide & tooling.
- **[Web3 React](.agent/skills/web3-react-dapps.md):** Wagmi, Viem, & dApp architecture.
- **[ASCII Games](.agent/skills/ascii-game-dev.md):** ECS architecture & terminal rendering optimization.
- **[Desktop GUIs](.agent/skills/desktop-gui-dev.md):** Modern Python apps with CustomTkinter & PyQt6.
- **[How-To Docs](.agent/skills/howto-documentation.md):** Diátaxis framework & technical writing guides.
- **[Data Visualization](.agent/skills/data-visualization.md):** Publication-quality plots with Scipy/Seaborn.
- **[Reinforcement Learning](.agent/skills/reinforcement-learning.md):** Gymnasium envs & Stable-Baselines3 training.
- **[Manim Animation](.agent/skills/manim-animation.md):** Math animations with Python & LaTeX.
- **[YouTube Scriptwriting](.agent/skills/youtube-scriptwriting.md):** High-retention hooks & psychology.
- **[Advanced Screenwriting](.agent/skills/storytelling-frameworks.md):** Save the Cat, Hero's Journey, & Story Circle.
- **[Copywriting](.agent/skills/copywriting.md):** Information processing & conversion logic.
- **[Audio Processing](.agent/skills/audio-processing.md):** Neural denoising & EBU R128 normalization.
- **[Speech Synthesis](.agent/skills/speech-synthesis-multilingual.md):** SOTA multilingual protocols & cross-lingual cloning.
- **[Voice Orchestration](.agent/skills/voice-model-orchestration.md):** Multi-model pipelines (Fish, Dia, Bark, Parler).
- **[AI Voice Synthesis](.agent/skills/ai-voice-cloning-finetuning.md):** Multilingual fine-tuning & emotional synthesis.
- **[AI SFX Generation](.agent/skills/ai-sfx-generation.md):** Latent diffusion for sound design.
- **[AI Cinematography](.agent/skills/ai-cinematography.md):** Gen-video protocols (Runway, Kling, Luma).
- **[Character Consistency](.agent/skills/visual-character-consistency.md):** Identity preservation (ComfyUI, LoRA).
- **[AI Dubbing](.agent/skills/ai-dubbing-localization.md):** Automated localization & tone preservation.
- **[Stick Figure Animation](.agent/skills/stick-figure-animation.md):** Fluid 2D motion & physics.
- **[Thumbnail Psychology](.agent/skills/thumbnail-psychology.md):** Visual engagement & CTR optimization.
- **[Moltbot Orchestration](.agent/skills/moltbot-orchestration.md):** Multi-agent video factory architecture.
- **[CLIL Screenwriting](.agent/skills/storyteller-clil.md):** Educational storytelling & Leitner SRS.
- **[Automated Scriptwriting](.agent/skills/automated-scriptwriting.md):** 100% automated script production pipeline.
- **[Method of Loci](.agent/skills/method-of-loci.md):** Spatial memory & Blender-based loci construction.
- **[Dialogue TTS](.agent/skills/dia-tts.md):** Multi-speaker turn-taking & emotional prosody.
- **[Emotional Voice Acting](.agent/skills/emotional-voice-acting.md):** One-person multi-character production & GPT-SoVITS.
- **[Episode Structure](.agent/skills/episode-structure-45min.md):** 45-minute 3-part format & cognitive load management.
- **[Procedural Direction](.agent/skills/director-visual.md):** Blender & Manim semantic visuals.
- **[Master Editing](.agent/skills/resolve-editor.md):** DaVinci Resolve API & timeline automation.
- **[Subtitle Generator](.agent/skills/subtitle-generator.md):** Professional Persian subtitles with cinematic typography.

---

## 🤖 MCP Server Integration

Connect this knowledge base to your AI assistant using the built-in MCP Server.

### Setup for Claude Desktop
Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "agent-constitution": {
      "command": "python3",
      "args": ["/path/to/agent-constitution/bin/mcp-server/server.py"]
    }
  }
}
```

### Available Resources
- **64 Skills** as `skill://<skill-name>` resources
- **Workflows** as executable tools
- **Global Rules** via `get_rules` tool

See [MCP Server README](bin/mcp-server/README.md) for full documentation.

---
*Built with strict adherence to the Prompt-Driven Development methodology.*
