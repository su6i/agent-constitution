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
- **[Init Workflow](.cursor/workflows/init-project.md):** How to start clean.
- **[AI Logic](.cursor/workflows/ai-optimization.md):** Architect vs Executor models.
- **[QA Protocol](.cursor/workflows/quality-assurance.md):** Zero-bug policy.
- **[Communication](.cursor/workflows/communication.md):** Standardized project reporting.
- **[Social Showcase](.cursor/workflows/social-media-showcase.md):** World-class marketing assets.

### 📝 Prompts
- **[Technical Template](.cursor/prompts/template_technical.md):** Base structure for technical docs.
- **[LinkedIn Launch](.cursor/prompts/template_linkedin_launch.md):** Viral marketing hooks.
- **[Logo Specs](.cursor/prompts/template_project_logo.md):** DALL-E/Midjourney prompts for tech branding.

### 🧠 Skills
- **[CLI Table Alignment](.cursor/skills/cli-table-alignment.md):** Pixel-perfect ASCII tables with Emoji support.
- **[Zsh Completion](.cursor/skills/zsh-completion.md):** Robust autocomplete scripts avoiding common pitfalls.
- **[YouTube SEO](.cursor/skills/youtube-seo.md):** Strategy for titles, retention, and content growth.
- **[FFmpeg Recipes](.cursor/skills/ffmpeg-recipes.md):** Copy-pasteable commands for video automation.
- **[Data Science Workflow](.cursor/skills/data-science-workflow.md):** Reproducible science structure.
- **[MacOS Automation](.cursor/skills/macos-automation.md):** Python/Zsh scripts for desktop tasks.
- **[Prompt Engineering](.cursor/skills/prompt-engineering.md):** Advanced system prompts & personas.
- **[Storytelling](.cursor/skills/storytelling-frameworks.md):** Hero's Journey applied to tech.
- **[FastAPI Best Practices](.cursor/skills/fastapi-best-practices.md):** Scalable, type-safe API patterns.
- **[Flask JSON Guide](.cursor/skills/flask-json-guide.md):** Robust structure for Flask APIs.
- **[LLM & ML Workflow](.cursor/skills/llm-ml-workflow.md):** Productionizing AI models.
- **[SwiftUI Guidelines](.cursor/skills/swiftui-guidelines.md):** iOS modern architecture & audio.
- **[Jetpack Compose](.cursor/skills/jetpack-compose-guidelines.md):** Android declarative UI & permissions.
- **[Chrome Extensions](.cursor/skills/chrome-extension-best-practices.md):** MV3 UI/UX & Shadow DOM.
- **[Modern Web UI](.cursor/skills/modern-web-ui.md):** Vanilla HTML/CSS/JS best practices.
- **[Financial Data Pipeline](.cursor/skills/financial-data-science.md):** OpenBB, Pandas-TA, & QuantStats stack.
- **[DevOps & MLOps](.cursor/skills/ops-automation.md):** CI/CD, Docker, & Experiment Tracking.
- **[System Architecting](.cursor/skills/ai-logic-patterns.md):** Master prompting & agent orchestration rules.
- **[Multi-Step RAG](.cursor/skills/multi-rag-orchestration.md):** Stateful memory & lexical tracking (SRS).
- **[Blender Automation](.cursor/skills/blender-automation.md):** Python (bpy) & Geometry Nodes.
- **[DaVinci Resolve](.cursor/skills/resolve-editor.md):** Python API & Post-Production.
- **[Remotion Video](.cursor/skills/remotion-video.md):** Programmatic video with React.
- **[Code Quality](.cursor/skills/github-code-quality.md):** Strict rules for clean, verified code changes.
- **[Kubernetes & Docs](.cursor/skills/kubernetes-docs.md):** K8s best practices & MkDocs integration.
- **[Linux CUDA Python](.cursor/skills/linux-cuda-python.md):** HPC setup, PyTorch optimization, & profiling.
- **[Python Containerization](.cursor/skills/python-containerization.md):** Docker best practices (Slim vs Alpine, Multi-stage).
- **[Python GitHub Setup](.cursor/skills/python-github-setup.md):** Actions, Templates, & Semantic Release.
- **[JS/TS Quality](.cursor/skills/js-ts-code-quality.md):** Strict TypeScript, Biome/ESLint, & Vitest.
- **[Pandas & Scikit-learn](.cursor/skills/pandas-sklearn-guide.md):** Method chaining, Pipelines, & ColumnTransformer.
- **[Python Core Standards](.cursor/skills/python-core-standards.md):** Project structure, `uv` implementation, & Typing.
- **[PyTorch Integration](.cursor/skills/pytorch-sklearn-integration.md):** Sklearn data pipelines with PyTorch models.
- **[R Language](.cursor/skills/r-lang-guide.md):** `targets` pipelines & `renv` practices.
- **[Solidity (Foundry)](.cursor/skills/solidity-foundry.md):** Modern Rust-based testing & fuzzing stack.
- **[Solidity (Hardhat)](.cursor/skills/solidity-hardhat.md):** JS/TS ecosystem guide & tooling.
- **[Web3 React](.cursor/skills/web3-react-dapps.md):** Wagmi, Viem, & dApp architecture.
- **[ASCII Games](.cursor/skills/ascii-game-dev.md):** ECS architecture & terminal rendering optimization.
- **[Desktop GUIs](.cursor/skills/desktop-gui-dev.md):** Modern Python apps with CustomTkinter & PyQt6.
- **[How-To Docs](.cursor/skills/howto-documentation.md):** Diátaxis framework & technical writing guides.
- **[Data Visualization](.cursor/skills/data-visualization.md):** Publication-quality plots with Scipy/Seaborn.
- **[Reinforcement Learning](.cursor/skills/reinforcement-learning.md):** Gymnasium envs & Stable-Baselines3 training.
- **[Manim Animation](.cursor/skills/manim-animation.md):** Math animations with Python & LaTeX.
- **[YouTube Scriptwriting](.cursor/skills/youtube-scriptwriting.md):** High-retention hooks & psychology.
- **[Advanced Screenwriting](.cursor/skills/storytelling-frameworks.md):** Save the Cat, Hero's Journey, & Story Circle.
- **[Copywriting](.cursor/skills/copywriting.md):** Information processing & conversion logic.
- **[Audio Processing](.cursor/skills/audio-processing.md):** Neural denoising & EBU R128 normalization.
- **[Speech Synthesis](.cursor/skills/speech-synthesis-multilingual.md):** SOTA multilingual protocols & cross-lingual cloning.
- **[Voice Orchestration](.cursor/skills/voice-model-orchestration.md):** Multi-model pipelines (Fish, Dia, Bark, Parler).
- **[AI Voice Synthesis](.cursor/skills/ai-voice-cloning-finetuning.md):** Multilingual fine-tuning & emotional synthesis.
- **[AI SFX Generation](.cursor/skills/ai-sfx-generation.md):** Latent diffusion for sound design.
- **[AI Cinematography](.cursor/skills/ai-cinematography.md):** Gen-video protocols (Runway, Kling, Luma).
- **[Character Consistency](.cursor/skills/visual-character-consistency.md):** Identity preservation (ComfyUI, LoRA).
- **[AI Dubbing](.cursor/skills/ai-dubbing-localization.md):** Automated localization & tone preservation.
- **[Stick Figure Animation](.cursor/skills/stick-figure-animation.md):** Fluid 2D motion & physics.
- **[Thumbnail Psychology](.cursor/skills/thumbnail-psychology.md):** Visual engagement & CTR optimization.
- **[Moltbot Orchestration](.cursor/skills/moltbot-orchestration.md):** Multi-agent video factory architecture.
- **[CLIL Screenwriting](.cursor/skills/storyteller-clil.md):** Educational storytelling & Leitner SRS.
- **[Automated Scriptwriting](.cursor/skills/automated-scriptwriting.md):** 100% automated script production pipeline.
- **[Method of Loci](.cursor/skills/method-of-loci.md):** Spatial memory & Blender-based loci construction.
- **[Dialogue TTS](.cursor/skills/dia-tts.md):** Multi-speaker turn-taking & emotional prosody.
- **[Emotional Voice Acting](.cursor/skills/emotional-voice-acting.md):** One-person multi-character production & GPT-SoVITS.
- **[Episode Structure](.cursor/skills/episode-structure-45min.md):** 45-minute 3-part format & cognitive load management.
- **[Procedural Direction](.cursor/skills/director-visual.md):** Blender & Manim semantic visuals.
- **[Master Editing](.cursor/skills/resolve-editor.md):** DaVinci Resolve API & timeline automation.

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
- **63 Skills** as `skill://<skill-name>` resources
- **Workflows** as executable tools
- **Global Rules** via `get_rules` tool

See [MCP Server README](bin/mcp-server/README.md) for full documentation.

---
*Built with strict adherence to the Prompt-Driven Development methodology.*
