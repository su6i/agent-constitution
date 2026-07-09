---
title: Agent Constitution 📜
description: Universal validated context architecture for AI Agents (VS Code, Antigravity, Claude)
location: README.md
last_updated: 2026-06-23
---

<div align="center">

<img alt="Agent Constitution logo" src="assets/project_logo.png" width="350">

<h1>Agent Constitution 📜</h1>

<p align="center">
  <a href="https://github.com/su6i/agent-constitution/blob/main/LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green3.svg" height="20" style="vertical-align: middle;"></a>
  <a href="#"><img alt="Status: Active" src="https://img.shields.io/badge/Status-Active-blue.svg" height="20" style="vertical-align: middle;"></a>
  <img alt="Skills: 367" src="https://img.shields.io/badge/Skills-367-blueviolet.svg" height="20" style="vertical-align: middle;">
  <img alt="Agents: 63" src="https://img.shields.io/badge/Agents-63-orange.svg" height="20" style="vertical-align: middle;">
  <img alt="Commands: 79" src="https://img.shields.io/badge/Commands-79-teal.svg" height="20" style="vertical-align: middle;">
  <a href="workflows/documentation.md"><img alt="Docs: Technical" src="https://img.shields.io/badge/Docs-Technical-orange.svg" height="20" style="vertical-align: middle;"></a>
  <a href="https://linkedin.com/in/su6i"><img alt="LinkedIn" src="assets/linkedin_su6i.svg" height="20" style="vertical-align: middle; margin-bottom: -1px; margin-left: 3px;"></a>
</p>

<strong>The Validated Context Architecture for AI Agents.</strong><br>
<sub>367 skills · 63 agents · 79 commands · Works with Claude Code, Cursor, Codex, Gemini CLI</sub>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/su6i/agent-constitution/main/install.sh)
```

[🇮🇷 نسخه فارسی](README.fa.md) • [Contributing](CONTRIBUTING.md) • [Changelog](CHANGELOG.md)

</div>

---

## Demo

![Demo](assets/demo.gif)

> Regenerate: `vhs assets/demo.tape`

<div align="center">

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
- [AGENTS.md](AGENTS.md) is the execution contract and the canonical entry point for every agent harness.
- `GEMINI.md`, `GROK.md`, `QWEN.md`, `MINIMAX.md`, `.cursorrules`, `.windsurfrules`, `.clinerules`, and `.github/copilot-instructions.md` are thin bootloaders: whichever config file a tool reads natively, it lands there and is routed to [AGENTS.md](AGENTS.md) → `rules/`. No rules are duplicated in them (rule 045).
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

1. **Install the Scaffolder:**

    ```bash
    # Add this alias to your shell config (~/.zshrc)
    alias init-gh='~/path/to/agent-constitution/bin/scaffold.sh'
    ```

2. **Run in any new project:**

    ```bash
    mkdir my-new-project && cd my-new-project
    init-gh
    ```

    *Result: The `rules/`, `workflows/`, and `.agent/prompts/` are injected and committed automatically.*

### Option B: Manual Setup

1. Clone this repo.
2. Copy `rules/`, `workflows/`, and `.agent/prompts/` to your project root.
3. **Ask your Agent:**
    > "Audit my codebase against the Quality Assurance protocol."

## ⚙️ Personalization

Before using this constitution in your own project, replace the author email with your own:

| File | Lines | What to change |
|---|---|---|
| `rules/040-git.md` | 51, 52, 53, 81 | Replace `<your-git-email>` with your own email |

**Why:** The Commit Identity rule enforces a specific author email on every commit. The value shipped in this repo is the original author's address — it must be yours before you start using the rules.

```bash
# Quick replace (run from the repo root):
sed -i '' 's/<your-git-email>/your@email.com/g' rules/040-git.md
```

Then set your global git identity to match:

```bash
git config --global user.email "your@email.com"
git config --global user.name  "Your Name"
```

---

## 🪝 Git Hooks (automatic enforcement)

Three hooks turn the non-negotiable git rules (`rules/040-git.md`) into deterministic
gates that no agent or human can "forget". Their canonical sources live in
`templates/hooks/` — installing them needs nothing but a copy into your repo's
`.git/hooks/`:

```bash
cp templates/hooks/pre-commit templates/hooks/pre-merge-commit templates/hooks/commit-msg /path/to/your-repo/.git/hooks/
chmod +x /path/to/your-repo/.git/hooks/pre-commit /path/to/your-repo/.git/hooks/pre-merge-commit /path/to/your-repo/.git/hooks/commit-msg
```

If you use the optional [amir-cli](https://github.com/su6i/amir-cli) automation,
`amir init-project` (new repos) and `amir update-projects` (existing repos)
install them for you.

| Hook | What it blocks |
|------|----------------|
| `pre-commit` | Direct commits to `main`/`master` (use a feature branch); the **Docs Checklist** — a code change must also touch a doc (README / CHANGELOG / docs/ / `*.md`); personal/memory files (TODO.md, SESSION.md, force-added CLAUDE.md, …) — deleting one is allowed, that's the remediation; secrets/PII in added lines; and a `skills/**.md` edit without a `version:` bump (`rules/036-skill-versioning.md`). |
| `pre-merge-commit` | The same privacy and skill-version gates applied to **merge commits** (git never runs pre-commit on automatic merges). Branch-protection and docs checks are skipped on merges — merging an approved branch into main is the sanctioned protocol step. |
| `commit-msg` | **AI co-authorship — ever.** Any `Co-Authored-By: <AI>` trailer, a "Generated with `<AI>`" line, or a 🤖 marker in the message. |

### Don't want them? How to opt out

```bash
git commit --no-verify             # bypass for ONE commit (leaves a shell-history trace)
rm .git/hooks/commit-msg           # remove a single hook from this clone
rm .git/hooks/pre-commit
rm .git/hooks/pre-merge-commit
amir update-projects --no-hook     # sync the constitution WITHOUT (re)installing hooks
```

Removing a hook only affects that one clone; the templates and the rules stay
intact, and a later `amir update-projects` reinstalls them unless you pass `--no-hook`.

---

## 📚 Documentation

### ⭐ Flagship Guide

- **[Agentic Coding 2026](AGENTIC-CODING-SETUP.md):** Canonical benchmark, ROI, routing, tooling, and low-cost setup guide for the repository.
- **[Information Architecture](docs/INFORMATION-ARCHITECTURE.md):** Explains how the rest of the repository relates to the flagship guide.

### 🛠 Workflows

- **[Init Workflow](workflows/init-project.md):** How to start clean.
- **[First Session](workflows/first-session.md):** Onboard a scaffolded project — fill CLAUDE.md, verify structure.
- **[Propagate Updates](workflows/propagate-constitution.md):** Roll new rules/skills/hook out to every project (`amir update-projects`).
- **[AI Logic](workflows/ai-optimization.md):** Architect vs Executor models.
- **[QA Protocol](workflows/quality-assurance.md):** Zero-bug policy.
- **[Communication](workflows/communication.md):** Standardized project reporting.
- **[Social Showcase](workflows/social-media-showcase.md):** World-class marketing assets.

### 📝 Prompts

- **[Technical Template](.agent/prompts/template_technical.md):** Base structure for technical docs.
- **[LinkedIn Launch](.agent/prompts/template_linkedin_launch.md):** Viral marketing hooks.
- **[Logo Specs](.agent/prompts/template_project_logo.md):** DALL-E/Midjourney prompts for tech branding.

### 🧠 Skills (367 total)

> Search this page (`Ctrl+F`) by keyword — every skill name, tool, and technology is listed below.

<details>
<summary><strong>AI & Machine Learning</strong> (26 skills)</summary>

| Skill | Description |
| --- | --- |
| [ai-logic-patterns](skills/ai-logic-patterns.md) | Master prompting & agent orchestration rules |
| [ai-regression-testing](skills/ai-regression-testing.md) | Automated regression suites for LLM outputs |
| [ai-router](skills/ai-router/README.md) | Cost-aware model routing and fallback chains |
| [ai-video-generation](skills/ai-video-generation.md) | Gen-video with Runway, Kling, Luma, Veo |
| [agentic-engineering](skills/agentic-engineering.md) | Building robust agentic systems end-to-end |
| [autonomous-loops](skills/autonomous-loops.md) | Self-driving agent loops with quality gates |
| [autonomous-agent-harness](skills/autonomous-agent-harness.md) | Production-ready autonomous agent scaffolding |
| [continuous-learning](skills/continuous-learning.md) | Agents that improve from session observations |
| [continuous-learning-v2](skills/continuous-learning-v2.md) | v2 learning pipeline with structured memory |
| [eval-harness](skills/eval-harness.md) | LLM evaluation framework & scoring pipelines |
| [fal-ai-media](skills/fal-ai-media.md) | fal.ai image & video generation API patterns |
| [foundation-models-on-device](skills/foundation-models-on-device.md) | On-device inference (MLX, llama.cpp, Core ML) |
| [llm-ml-workflow](skills/llm-ml-workflow.md) | Productionizing AI models end-to-end |
| [llm-trading-agent-security](skills/llm-trading-agent-security.md) | Security patterns for LLM-driven trading agents |
| [ml-adoption-playbook](skills/ml-adoption-playbook.md) | Organizational ML rollout & change management |
| [multi-rag-orchestration](skills/multi-rag-orchestration.md) | Stateful multi-step RAG with lexical tracking |
| [prompt-engineering](skills/prompt-engineering.md) | Advanced system prompts, personas & few-shot |
| [prompt-optimizer](skills/prompt-optimizer.md) | Systematic prompt scoring and iteration |
| [pytorch-patterns](skills/pytorch-patterns.md) | PyTorch training loops, custom datasets, hooks |
| [python-pytorch-sklearn](skills/python-pytorch-sklearn.md) | Sklearn pipelines with PyTorch models |
| [r-lang-guide](skills/r-lang-guide.md) | `targets` pipelines & `renv` practices |
| [ragas-evaluation](skills/ragas-evaluation.md) | RAG evaluation with RAGAS metrics |
| [regex-vs-llm-structured-text](skills/regex-vs-llm-structured-text.md) | When to use regex vs LLM for text extraction |
| [reinforcement-learning](skills/reinforcement-learning.md) | Gymnasium envs & Stable-Baselines3 training |
| [recsys-pipeline-architect](skills/recsys-pipeline-architect.md) | Recommendation system pipeline design |
| [token-budget-advisor](skills/token-budget-advisor.md) | Context budget management & cost optimization |

</details>

<details>
<summary><strong>Agent Systems & Orchestration</strong> (22 skills)</summary>

| Skill | Description |
| --- | --- |
| [agent-architecture-audit](skills/agent-architecture-audit.md) | 12-layer agent stack diagnostic & audit |
| [agent-eval](skills/agent-eval.md) | Agent performance evaluation frameworks |
| [agent-harness-construction](skills/agent-harness-construction.md) | Building production agent harnesses |
| [agent-introspection-debugging](skills/agent-introspection-debugging.md) | Debug agent behavior & silent failures |
| [agent-self-evaluation](skills/agent-self-evaluation.md) | Agents that score their own outputs |
| [agentic-os](skills/agentic-os.md) | Operating-system-level agent coordination |
| [continuous-agent-loop](skills/continuous-agent-loop.md) | CI/PR-integrated continuous agent loops |
| [context-budget](skills/context-budget.md) | Token budget tracking and context hygiene |
| [cost-tracking](skills/cost-tracking.md) | Per-session and per-task cost instrumentation |
| [cost-aware-llm-pipeline](skills/cost-aware-llm-pipeline.md) | Build pipelines that stay within cost targets |
| [intent-driven-development](skills/intent-driven-development.md) | Acceptance criteria before implementation |
| [moltbot-orchestration](skills/moltbot-orchestration.md) | Multi-agent video factory architecture |
| [orch-pipeline](skills/orch-pipeline.md) | Full orchestration pipeline from plan to deploy |
| [orch-build-mvp](skills/orch-build-mvp.md) | Orchestrated MVP build workflow |
| [orch-add-feature](skills/orch-add-feature.md) | Orchestrated feature addition workflow |
| [orch-change-feature](skills/orch-change-feature.md) | Orchestrated feature change workflow |
| [orch-fix-defect](skills/orch-fix-defect.md) | Orchestrated defect fix workflow |
| [orch-refine-code](skills/orch-refine-code.md) | Orchestrated code refinement workflow |
| [parallel-execution-optimizer](skills/parallel-execution-optimizer.md) | Maximize parallelism in multi-agent runs |
| [plan-orchestrate](skills/plan-orchestrate.md) | Plan-then-orchestrate multi-step execution |
| [recursive-decision-ledger](skills/recursive-decision-ledger.md) | Decision audit trail for autonomous agents |
| [team-agent-orchestration](skills/team-agent-orchestration.md) | Coordinate teams of specialized agents |

</details>

<details>
<summary><strong>Video & Media Production</strong> (28 skills)</summary>

| Skill | Description |
| --- | --- |
| [auto-editor](skills/auto-editor.md) | Automated silence removal & jump-cut editing |
| [blender-motion-state-inspection](skills/blender-motion-state-inspection.md) | Debug Blender animation state machines |
| [davinci-resolve-scripting](skills/davinci-resolve-scripting.md) | DaVinci Resolve Python API & timeline automation |
| [fal-ai-media](skills/fal-ai-media.md) | fal.ai image/video generation (FLUX, Kling, Veo) |
| [ffmpeg-recipes](skills/ffmpeg-recipes.md) | Copy-pasteable FFmpeg commands for video automation |
| [ffmpeg-reference](skills/ffmpeg-reference.md) | Codec ops, metadata, filters & flag reference |
| [manim-video](skills/manim-video.md) | Manim scene patterns & network graph explainers |
| [motion-advanced](skills/motion-advanced.md) | Advanced motion design principles & techniques |
| [motion-foundations](skills/motion-foundations.md) | Core motion design theory & easing |
| [motion-patterns](skills/motion-patterns.md) | Reusable motion design patterns |
| [motion-ui](skills/motion-ui.md) | UI motion & micro-interaction design |
| [obs-studio](skills/obs-studio.md) | OBS automation, scenes, and streaming setup |
| [remotion-video-creation](skills/remotion-video-creation.md) | Programmatic video with React + Remotion |
| [taste](skills/taste.md) | Creative direction layer for music videos & edits |
| [video-blender-automation](skills/video-blender-automation.md) | Blender bpy API & Geometry Nodes scripting |
| [video-editing](skills/video-editing.md) | Professional video editing workflows & tools |
| [video-effects-transitions](skills/video-effects-transitions.md) | VFX, transitions & compositing techniques |
| [video-manim-math](skills/video-manim-math.md) | Manim math animations: OpenGL, plugins, shaders |
| [video-production-automation](skills/video-production-automation.md) | Full Python pipeline: Manim, MoviePy, OpenCV |
| [video-remotion-react](skills/video-remotion-react.md) | React-based programmatic video creation |
| [video-resolve-editing](skills/video-resolve-editing.md) | DaVinci Resolve post-production & color grading |
| [video-stick-figure](skills/video-stick-figure.md) | 2D stick figure animation & physics |
| [videodb](skills/videodb.md) | VideoDB vector search & scene understanding |
| [visual-ai-cinematography](skills/visual-ai-cinematography.md) | Gen-video cinematography (Runway, Kling, Luma) |
| [visual-character-consistency](skills/visual-character-consistency.md) | Identity preservation across frames (ComfyUI, LoRA) |
| [visual-director-procedural](skills/visual-director-procedural.md) | Blender & Manim semantic visual direction |
| [visual-thumbnail-psychology](skills/visual-thumbnail-psychology.md) | CTR-optimized thumbnail design psychology |
| [comfyui-stable-diffusion](skills/comfyui-stable-diffusion.md) | ComfyUI workflows & Stable Diffusion nodes |

</details>

<details>
<summary><strong>Voice, Audio & TTS</strong> (17 skills)</summary>

| Skill | Description |
| --- | --- |
| [ai-dubbing-localization](skills/ai-dubbing-localization.md) | Automated dubbing & tone-preserving localization |
| [ai-sfx-generation](skills/ai-sfx-generation.md) | Latent diffusion for sound design & SFX |
| [audio-processing](skills/audio-processing.md) | Neural denoising & EBU R128 normalization |
| [fish-speech](skills/fish-speech.md) | Fish Speech TTS model setup & fine-tuning |
| [gpt-sovits](skills/gpt-sovits.md) | GPT-SoVITS voice cloning & training |
| [heygen-api](skills/heygen-api.md) | HeyGen avatar video generation API |
| [huggingface-tts](skills/huggingface-tts.md) | HuggingFace TTS model catalog & inference |
| [mlx-whisper](skills/mlx-whisper.md) | Apple Silicon Whisper transcription via mlx-whisper |
| [music-generation](skills/music-generation.md) | AI music generation (Suno, Udio, MusicGen) |
| [opensource-tts](skills/opensource-tts.md) | Open-source TTS stack comparison & setup |
| [persian-tts-training](skills/persian-tts-training.md) | Persian-language TTS fine-tuning pipeline |
| [storytelling-tts-m4-system](skills/storytelling-tts-m4-system.md) | End-to-end TTS storytelling on Apple Silicon |
| [subtitle-generator](skills/subtitle-generator.md) | Professional subtitles with cinematic typography |
| [voice-ai-cloning-finetuning](skills/voice-ai-cloning-finetuning.md) | Multilingual voice cloning & emotional synthesis |
| [voice-dialogue-tts](skills/voice-dialogue-tts.md) | Multi-speaker turn-taking & emotional prosody |
| [voice-emotional-acting](skills/voice-emotional-acting.md) | One-person multi-character production |
| [voice-orchestration-multi-model](skills/voice-orchestration-multi-model.md) | Multi-model TTS pipelines (Fish, Dia, Bark, Parler) |
| [voice-synthesis-multilingual](skills/voice-synthesis-multilingual.md) | SOTA multilingual TTS & cross-lingual cloning |
| [xtts-v2](skills/xtts-v2.md) | XTTS-v2 fine-tuning & streaming inference |

</details>

<details>
<summary><strong>Content, YouTube & Marketing</strong> (21 skills)</summary>

| Skill | Description |
| --- | --- |
| [article-writing](skills/article-writing.md) | Long-form article structure & SEO writing |
| [brand-discovery](skills/brand-discovery.md) | Brand positioning & identity research |
| [brand-voice](skills/brand-voice.md) | Consistent brand voice modeling & guidelines |
| [competitive-platform-analysis](skills/competitive-platform-analysis.md) | Systematic competitor platform teardown |
| [competitive-report-structure](skills/competitive-report-structure.md) | Competitive intelligence report templates |
| [content-engine](skills/content-engine.md) | Automated content production pipelines |
| [copywriting](skills/copywriting.md) | Conversion-focused copy & persuasion logic |
| [crosspost](skills/crosspost.md) | Cross-platform content distribution automation |
| [marketing-campaign](skills/marketing-campaign.md) | Campaign planning, execution & measurement |
| [screenwriting-automated](skills/screenwriting-automated.md) | 100% automated script production pipeline |
| [screenwriting-frameworks](skills/screenwriting-frameworks.md) | 3-Act, Hero's Journey, beat sheets |
| [screenwriting-youtube](skills/screenwriting-youtube.md) | High-retention YouTube hooks & psychology |
| [seo](skills/seo.md) | Technical SEO, on-page optimization & audits |
| [social-graph-ranker](skills/social-graph-ranker.md) | Social network analysis & influence ranking |
| [social-publisher](skills/social-publisher.md) | Scheduled multi-platform social publishing |
| [storytelling-clil-education](skills/storytelling-clil-education.md) | Educational storytelling & Leitner SRS |
| [storytelling-narrative-frameworks](skills/storytelling-narrative-frameworks.md) | Save the Cat, Story Circle & advanced structures |
| [x-api](skills/x-api.md) | X/Twitter API v2 patterns & automation |
| [youtube-analytics](skills/youtube-analytics.md) | YouTube Data API analytics & reporting |
| [youtube-automation-pipeline](skills/youtube-automation-pipeline.md) | End-to-end YouTube publishing automation |
| [youtube-data-api](skills/youtube-data-api.md) | YouTube Data API v3 — uploads, playlists, captions |
| [youtube-dlp-web-download](skills/youtube-dlp-web-download.md) | yt-dlp: Cloudflare bypass, stream selection |
| [youtube-seo](skills/youtube-seo.md) | Titles, thumbnails, retention & channel growth |

</details>

<details>
<summary><strong>Research & Science</strong> (12 skills)</summary>

| Skill | Description |
| --- | --- |
| [deep-research](skills/deep-research.md) | Systematic multi-source research protocols |
| [exa-search](skills/exa-search.md) | Exa semantic search API integration |
| [market-research](skills/market-research.md) | Primary & secondary market research methods |
| [ml-adoption-playbook](skills/ml-adoption-playbook.md) | Enterprise ML adoption & stakeholder alignment |
| [prediction-market-oracle-research](skills/prediction-market-oracle-research.md) | Prediction market data sourcing & analysis |
| [prediction-market-risk-review](skills/prediction-market-risk-review.md) | Risk assessment for prediction market positions |
| [research-ops](skills/research-ops.md) | Research workflow automation & knowledge mgmt |
| [scientific-db-pubmed-database](skills/scientific-db-pubmed-database.md) | PubMed API queries & literature retrieval |
| [scientific-db-uspto-database](skills/scientific-db-uspto-database.md) | USPTO patent search & analysis |
| [scientific-pkg-gget](skills/scientific-pkg-gget.md) | gget for genomics data retrieval |
| [scientific-thinking-literature-review](skills/scientific-thinking-literature-review.md) | Systematic literature review methodology |
| [scientific-thinking-scholar-evaluation](skills/scientific-thinking-scholar-evaluation.md) | Academic paper quality evaluation |

</details>

<details>
<summary><strong>Python</strong> (8 skills)</summary>

| Skill | Description |
| --- | --- |
| [python-core-standards](skills/python-core-standards.md) | Project structure, `uv`, typing & conventions |
| [python-containerization](skills/python-containerization.md) | Docker: Slim vs Alpine, multi-stage builds |
| [python-github-setup](skills/python-github-setup.md) | GitHub Actions, templates & semantic release |
| [python-pandas-sklearn](skills/python-pandas-sklearn.md) | Method chaining, pipelines & ColumnTransformer |
| [python-patterns](skills/python-patterns.md) | Idiomatic Python patterns & anti-patterns |
| [python-pytorch-sklearn](skills/python-pytorch-sklearn.md) | Sklearn data pipelines with PyTorch models |
| [python-testing](skills/python-testing.md) | pytest, fixtures, parametrize & coverage |
| [generating-python-installer](skills/generating-python-installer.md) | Build distributable Python installer packages |

</details>

<details>
<summary><strong>Web & Frontend</strong> (24 skills)</summary>

| Skill | Description |
| --- | --- |
| [angular-developer](skills/angular-developer.md) | Angular architecture, RxJS & state management |
| [bun-runtime](skills/bun-runtime.md) | Bun runtime setup, bundling & testing |
| [chrome-extension-best-practices](skills/chrome-extension-best-practices.md) | MV3 extensions, UI & Shadow DOM |
| [design-system](skills/design-system.md) | Design tokens, component libraries & theming |
| [fastapi-best-practices](skills/fastapi-best-practices.md) | FastAPI: Pydantic v2, lifespan, background tasks |
| [fastapi-patterns](skills/fastapi-patterns.md) | FastAPI project structure, auth, DI & testing |
| [flask-json-guide](skills/flask-json-guide.md) | Robust Flask API structure & error handling |
| [frontend-a11y](skills/frontend-a11y.md) | Web accessibility (WCAG, ARIA, screen readers) |
| [frontend-design-direction](skills/frontend-design-direction.md) | Visual direction & design review for UIs |
| [frontend-patterns](skills/frontend-patterns.md) | Cross-framework frontend architecture patterns |
| [frontend-slides](skills/frontend-slides.md) | Browser-based presentation & slide tooling |
| [js-ts-code-quality](skills/js-ts-code-quality.md) | Strict TypeScript, Biome/ESLint & Vitest |
| [liquid-glass-design](skills/liquid-glass-design.md) | iOS 26 liquid glass UI design patterns |
| [make-interfaces-feel-better](skills/make-interfaces-feel-better.md) | Micro-interactions & polish for any UI |
| [modern-web-ui](skills/modern-web-ui.md) | Vanilla HTML/CSS/JS best practices |
| [nextjs-turbopack](skills/nextjs-turbopack.md) | Next.js App Router & Turbopack setup |
| [nuxt4-patterns](skills/nuxt4-patterns.md) | Nuxt 4 architecture & composables |
| [react-patterns](skills/react-patterns.md) | React component patterns & hooks |
| [react-performance](skills/react-performance.md) | React rendering optimization & profiling |
| [react-testing](skills/react-testing.md) | Testing Library, MSW & Vitest for React |
| [ui-demo](skills/ui-demo.md) | Interactive demo & prototype patterns |
| [vite-patterns](skills/vite-patterns.md) | Vite config, plugins & build optimization |
| [vue-patterns](skills/vue-patterns.md) | Vue 3 Composition API & ecosystem patterns |
| [ui-to-vue](skills/ui-to-vue.md) | Migrating UI components to Vue 3 |

</details>

<details>
<summary><strong>Backend</strong> (40 skills)</summary>

| Skill | Description |
| --- | --- |
| [backend-patterns](skills/backend-patterns.md) | Cross-language backend architecture patterns |
| [cpp-coding-standards](skills/cpp-coding-standards.md) | Modern C++20/23 standards & best practices |
| [cpp-testing](skills/cpp-testing.md) | Catch2, GoogleTest & CMake testing |
| [csharp-testing](skills/csharp-testing.md) | xUnit, Moq & .NET testing patterns |
| [django-celery](skills/django-celery.md) | Celery task queues with Django |
| [django-patterns](skills/django-patterns.md) | Django project structure & ORM patterns |
| [django-security](skills/django-security.md) | Django security hardening & OWASP |
| [django-tdd](skills/django-tdd.md) | TDD with Django & pytest-django |
| [django-verification](skills/django-verification.md) | Django deployment verification checklists |
| [dotnet-patterns](skills/dotnet-patterns.md) | .NET 8+ architecture & dependency injection |
| [error-handling](skills/error-handling.md) | Structured error handling across languages |
| [flask-json-guide](skills/flask-json-guide.md) | Flask JSON API patterns & error handling |
| [fsharp-testing](skills/fsharp-testing.md) | F# testing with Expecto & FsCheck |
| [golang-patterns](skills/golang-patterns.md) | Go idioms, concurrency & project layout |
| [golang-testing](skills/golang-testing.md) | Go testing: table tests, benchmarks, fuzz |
| [hexagonal-architecture](skills/hexagonal-architecture.md) | Ports & adapters pattern implementation |
| [java-coding-standards](skills/java-coding-standards.md) | Java 21+ records, sealed types & patterns |
| [jpa-patterns](skills/jpa-patterns.md) | JPA/Hibernate patterns & query optimization |
| [kotlin-coroutines-flows](skills/kotlin-coroutines-flows.md) | Kotlin coroutines, Flows & structured concurrency |
| [kotlin-exposed-patterns](skills/kotlin-exposed-patterns.md) | Kotlin Exposed ORM patterns |
| [kotlin-ktor-patterns](skills/kotlin-ktor-patterns.md) | Ktor server patterns & plugin architecture |
| [kotlin-patterns](skills/kotlin-patterns.md) | Kotlin idiomatic patterns & conventions |
| [kotlin-testing](skills/kotlin-testing.md) | Kotlin testing with Kotest & MockK |
| [laravel-patterns](skills/laravel-patterns.md) | Laravel architecture & Eloquent patterns |
| [laravel-plugin-discovery](skills/laravel-plugin-discovery.md) | Laravel package & plugin discovery |
| [laravel-security](skills/laravel-security.md) | Laravel security & authorization patterns |
| [laravel-tdd](skills/laravel-tdd.md) | TDD with Laravel & Pest |
| [laravel-verification](skills/laravel-verification.md) | Laravel deployment verification |
| [nestjs-patterns](skills/nestjs-patterns.md) | NestJS modules, providers & interceptors |
| [perl-patterns](skills/perl-patterns.md) | Modern Perl idioms & CPAN usage |
| [perl-security](skills/perl-security.md) | Perl security: taint mode & injection prevention |
| [perl-testing](skills/perl-testing.md) | Perl testing with Test::More & prove |
| [quarkus-patterns](skills/quarkus-patterns.md) | Quarkus CDI, Panache & REST patterns |
| [quarkus-security](skills/quarkus-security.md) | Quarkus OIDC & security hardening |
| [quarkus-tdd](skills/quarkus-tdd.md) | TDD with Quarkus & QuarkusTest |
| [quarkus-verification](skills/quarkus-verification.md) | Quarkus native build verification |
| [rust-patterns](skills/rust-patterns.md) | Rust ownership, traits & async patterns |
| [rust-testing](skills/rust-testing.md) | Rust testing: unit, integration & cargo nextest |
| [springboot-patterns](skills/springboot-patterns.md) | Spring Boot architecture & Spring Data |
| [springboot-security](skills/springboot-security.md) | Spring Security & OAuth2 patterns |
| [springboot-tdd](skills/springboot-tdd.md) | TDD with Spring Boot & Testcontainers |
| [springboot-verification](skills/springboot-verification.md) | Spring Boot production readiness checks |
| [tinystruct-patterns](skills/tinystruct-patterns.md) | tinystruct Java framework patterns |

</details>

<details>
<summary><strong>Mobile</strong> (12 skills)</summary>

| Skill | Description |
| --- | --- |
| [android-clean-architecture](skills/android-clean-architecture.md) | Android Clean Architecture & MVVM |
| [compose-multiplatform-patterns](skills/compose-multiplatform-patterns.md) | Kotlin Multiplatform + Compose patterns |
| [dart-flutter-patterns](skills/dart-flutter-patterns.md) | Flutter architecture & Dart patterns |
| [flutter-dart-code-review](skills/flutter-dart-code-review.md) | Flutter code review checklist |
| [ios-icon-gen](skills/ios-icon-gen.md) | iOS app icon generation & asset catalogs |
| [jetpack-compose-guidelines](skills/jetpack-compose-guidelines.md) | Android declarative UI & permissions |
| [kotlin-patterns](skills/kotlin-patterns.md) | Kotlin Android idioms & Coroutines |
| [swift-actor-persistence](skills/swift-actor-persistence.md) | Swift actors & SwiftData persistence |
| [swift-concurrency-6-2](skills/swift-concurrency-6-2.md) | Swift 6.2 strict concurrency model |
| [swift-protocol-di-testing](skills/swift-protocol-di-testing.md) | Swift protocol-based DI & testability |
| [swiftui-guidelines](skills/swiftui-guidelines.md) | SwiftUI modern architecture & audio |
| [swiftui-patterns](skills/swiftui-patterns.md) | SwiftUI component patterns & state |

</details>

<details>
<summary><strong>Database</strong> (6 skills)</summary>

| Skill | Description |
| --- | --- |
| [clickhouse-io](skills/clickhouse-io.md) | ClickHouse OLAP queries & ingestion patterns |
| [database-migrations](skills/database-migrations.md) | Safe schema migrations across databases |
| [mysql-patterns](skills/mysql-patterns.md) | MySQL indexing, query optimization & replication |
| [postgres-patterns](skills/postgres-patterns.md) | PostgreSQL: JSONB, CTEs, partitioning & RLS |
| [prisma-patterns](skills/prisma-patterns.md) | Prisma ORM schema design & migrations |
| [redis-patterns](skills/redis-patterns.md) | Redis data structures, caching & pub/sub |

</details>

<details>
<summary><strong>DevOps & Infrastructure</strong> (17 skills)</summary>

| Skill | Description |
| --- | --- |
| [canary-watch](skills/canary-watch.md) | Canary deployment monitoring & rollback |
| [config-gc](skills/config-gc.md) | Garbage-collect stale config & dead flags |
| [deployment-patterns](skills/deployment-patterns.md) | Blue/green, canary & rolling deploy patterns |
| [docker-patterns](skills/docker-patterns.md) | Dockerfile best practices & multi-stage builds |
| [flox-environments](skills/flox-environments.md) | Flox reproducible dev environments |
| [git-workflow](skills/git-workflow.md) | Git branching, rebase & PR workflow standards |
| [github-code-quality](skills/github-code-quality.md) | GitHub Actions CI, PR templates & code owners |
| [github-ops](skills/github-ops.md) | GitHub API, releases & repository automation |
| [kubernetes-docs](skills/kubernetes-docs.md) | K8s best practices & MkDocs integration |
| [kubernetes-patterns](skills/kubernetes-patterns.md) | K8s manifests, Helm charts & operator patterns |
| [latency-critical-systems](skills/latency-critical-systems.md) | Sub-millisecond latency design & profiling |
| [linux-cuda-python](skills/linux-cuda-python.md) | HPC setup, PyTorch CUDA & GPU profiling |
| [ops-automation](skills/ops-automation.md) | CI/CD, Docker & experiment tracking automation |
| [production-audit](skills/production-audit.md) | Pre-launch production readiness audit |
| [python-containerization](skills/python-containerization.md) | Python Docker: Slim vs Alpine, multi-stage |
| [uncloud](skills/uncloud.md) | Cloud cost reduction & simplification patterns |
| [data-throughput-accelerator](skills/data-throughput-accelerator.md) | High-throughput data pipeline optimization |

</details>

<details>
<summary><strong>Network & NetDevOps</strong> (10 skills)</summary>

| Skill | Description |
| --- | --- |
| [cisco-ios-patterns](skills/cisco-ios-patterns.md) | Cisco IOS/IOS-XE config & automation patterns |
| [homelab-network-readiness](skills/homelab-network-readiness.md) | Homelab pre-deployment network checklist |
| [homelab-network-setup](skills/homelab-network-setup.md) | Homelab network design & VLAN architecture |
| [homelab-pihole-dns](skills/homelab-pihole-dns.md) | Pi-hole DNS-level ad blocking setup |
| [homelab-vlan-segmentation](skills/homelab-vlan-segmentation.md) | VLAN design & 802.1Q trunk configuration |
| [homelab-wireguard-vpn](skills/homelab-wireguard-vpn.md) | WireGuard VPN setup & peer management |
| [netmiko-ssh-automation](skills/netmiko-ssh-automation.md) | Netmiko SSH automation for network devices |
| [network-bgp-diagnostics](skills/network-bgp-diagnostics.md) | BGP troubleshooting & route analysis |
| [network-config-validation](skills/network-config-validation.md) | Network config diff & compliance validation |
| [network-interface-health](skills/network-interface-health.md) | Interface health monitoring & alerting |

</details>

<details>
<summary><strong>Web3 & Blockchain</strong> (7 skills)</summary>

| Skill | Description |
| --- | --- |
| [defi-amm-security](skills/defi-amm-security.md) | AMM security: reentrancy, flash loans, MEV |
| [evm-token-decimals](skills/evm-token-decimals.md) | EVM token decimal handling & precision |
| [llm-trading-agent-security](skills/llm-trading-agent-security.md) | Security for LLM-driven on-chain agents |
| [nodejs-keccak256](skills/nodejs-keccak256.md) | keccak256 hashing in Node.js |
| [web3-react-dapps](skills/web3-react-dapps.md) | Wagmi, Viem & dApp architecture |
| [web3-solidity-foundry](skills/web3-solidity-foundry.md) | Foundry: Rust-based Solidity testing & fuzzing |
| [web3-solidity-hardhat](skills/web3-solidity-hardhat.md) | Hardhat JS/TS ecosystem & tooling |

</details>

<details>
<summary><strong>Testing & QA</strong> (10 skills)</summary>

| Skill | Description |
| --- | --- |
| [ai-regression-testing](skills/ai-regression-testing.md) | Automated regression for LLM outputs |
| [benchmark](skills/benchmark.md) | Performance benchmarking methodology |
| [benchmark-methodology](skills/benchmark-methodology.md) | Rigorous benchmark design & statistical analysis |
| [benchmark-optimization-loop](skills/benchmark-optimization-loop.md) | Iterative benchmark-driven optimization |
| [browser-qa](skills/browser-qa.md) | Browser automation & visual regression testing |
| [e2e-testing](skills/e2e-testing.md) | End-to-end testing with Playwright & Cypress |
| [ragas-evaluation](skills/ragas-evaluation.md) | RAG pipeline evaluation with RAGAS |
| [tdd-workflow](skills/tdd-workflow.md) | TDD: RED/GREEN/refactor + evidence reports |
| [verification-loop](skills/verification-loop.md) | Automated verification gate patterns |
| [windows-desktop-e2e](skills/windows-desktop-e2e.md) | Windows desktop app E2E testing |

</details>

<details>
<summary><strong>Security</strong> (9 skills)</summary>

| Skill | Description |
| --- | --- |
| [django-security](skills/django-security.md) | Django security hardening & OWASP top 10 |
| [gateguard](skills/gateguard.md) | Pre-edit investigation gate for critical files |
| [healthcare-phi-compliance](skills/healthcare-phi-compliance.md) | HIPAA PHI handling & de-identification |
| [hipaa-compliance](skills/hipaa-compliance.md) | HIPAA technical & administrative safeguards |
| [laravel-security](skills/laravel-security.md) | Laravel security & XSS/CSRF prevention |
| [safety-guard](skills/safety-guard.md) | Agent output safety filtering & guardrails |
| [security-bounty-hunter](skills/security-bounty-hunter.md) | Bug bounty methodology & vulnerability research |
| [security-review](skills/security-review.md) | Code security review checklist & SAST |
| [security-scan](skills/security-scan.md) | Automated dependency & secret scanning |

</details>

<details>
<summary><strong>Claude Code & Agent Harness</strong> (18 skills)</summary>

| Skill | Description |
| --- | --- |
| [agent-sort](skills/agent-sort.md) | Agent task routing & priority sorting |
| [canary-watch](skills/canary-watch.md) | Deployment canary monitoring |
| [claude-code-integration](skills/claude-code-integration.md) | Claude Code CLI, hooks, MCP & agentic patterns |
| [claude-devfleet](skills/claude-devfleet.md) | Claude Code fleet management & parallelism |
| [codehealth-mcp](skills/codehealth-mcp.md) | MCP-driven code health metrics & alerts |
| [configure-ecc](skills/configure-ecc.md) | ECC harness configuration & setup |
| [context-budget](skills/context-budget.md) | Token budget tracking & context hygiene |
| [cost-tracking](skills/cost-tracking.md) | Per-session LLM cost instrumentation |
| [dynamic-workflow-mode](skills/dynamic-workflow-mode.md) | Switch agent workflow modes at runtime |
| [ecc-guide](skills/ecc-guide.md) | ECC harness user guide & patterns |
| [ecc-tools-cost-audit](skills/ecc-tools-cost-audit.md) | Audit ECC tool usage & cost attribution |
| [hookify-rules](skills/hookify-rules.md) | Claude Code hook authoring & management |
| [nanoclaw-repl](skills/nanoclaw-repl.md) | REPL-based agent session persistence |
| [repo-scan](skills/repo-scan.md) | Repository structure & health scanning |
| [rules-distill](skills/rules-distill.md) | Distill project rules from code patterns |
| [skill-comply](skills/skill-comply.md) | Enforce skill usage compliance in agent runs |
| [skill-scout](skills/skill-scout.md) | Discover missing skills from agent behavior |
| [skill-stocktake](skills/skill-stocktake.md) | Audit & deduplicate skill catalog |
| [token-budget-advisor](skills/token-budget-advisor.md) | Context budget management strategies |

</details>

<details>
<summary><strong>Scripting & Automation</strong> (9 skills)</summary>

| Skill | Description |
| --- | --- |
| [automation-audit-ops](skills/automation-audit-ops.md) | Audit & optimize automation pipelines |
| [cli-table-alignment](skills/cli-table-alignment.md) | Pixel-perfect ASCII tables with emoji support |
| [dmux-workflows](skills/dmux-workflows.md) | tmux/dmux session & pane automation |
| [hookify-rules](skills/hookify-rules.md) | Claude Code hooks authoring & lifecycle |
| [macos-automation](skills/macos-automation.md) | macOS Python/Zsh desktop automation scripts |
| [terminal-ops](skills/terminal-ops.md) | Terminal productivity & shell tooling |
| [zsh-completion](skills/zsh-completion.md) | Robust zsh autocomplete without pitfalls |
| [zsh-scripting-advanced](skills/zsh-scripting-advanced.md) | SIGINT traps, option parsing & shell patterns |
| [generating-python-installer](skills/generating-python-installer.md) | Build distributable Python installer packages |

</details>

<details>
<summary><strong>Business & Operations</strong> (20 skills)</summary>

| Skill | Description |
| --- | --- |
| [carrier-relationship-management](skills/carrier-relationship-management.md) | Logistics carrier relationship & SLA management |
| [customer-billing-ops](skills/customer-billing-ops.md) | Billing automation & subscription ops |
| [customs-trade-compliance](skills/customs-trade-compliance.md) | Import/export compliance & HS code classification |
| [email-ops](skills/email-ops.md) | Email automation, filtering & CRM integration |
| [energy-procurement](skills/energy-procurement.md) | Energy market procurement & contract analysis |
| [enterprise-agent-ops](skills/enterprise-agent-ops.md) | Enterprise-scale agent deployment & governance |
| [finance-billing-ops](skills/finance-billing-ops.md) | Finance billing pipeline & reconciliation |
| [google-workspace-ops](skills/google-workspace-ops.md) | Google Workspace (Docs, Sheets, Drive) automation |
| [healthcare-cdss-patterns](skills/healthcare-cdss-patterns.md) | Clinical decision support system patterns |
| [healthcare-emr-patterns](skills/healthcare-emr-patterns.md) | Electronic medical records integration |
| [healthcare-eval-harness](skills/healthcare-eval-harness.md) | Healthcare AI evaluation & safety harness |
| [inventory-demand-planning](skills/inventory-demand-planning.md) | Demand forecasting & inventory optimization |
| [investor-materials](skills/investor-materials.md) | Pitch decks, one-pagers & investor data rooms |
| [investor-outreach](skills/investor-outreach.md) | Investor outreach sequencing & CRM |
| [jira-integration](skills/jira-integration.md) | Jira API automation & project management |
| [knowledge-ops](skills/knowledge-ops.md) | Knowledge base management & retrieval ops |
| [lead-intelligence](skills/lead-intelligence.md) | Lead enrichment & sales intelligence automation |
| [logistics-exception-management](skills/logistics-exception-management.md) | Logistics exception detection & resolution |
| [messages-ops](skills/messages-ops.md) | Messaging platform automation (Slack, Teams) |
| [product-capability](skills/product-capability.md) | Product capability mapping & gap analysis |
| [product-lens](skills/product-lens.md) | Product strategy analysis framework |
| [production-scheduling](skills/production-scheduling.md) | Manufacturing & production schedule optimization |
| [project-flow-ops](skills/project-flow-ops.md) | Project management workflow automation |
| [quality-nonconformance](skills/quality-nonconformance.md) | Quality NCR tracking & corrective actions |
| [returns-reverse-logistics](skills/returns-reverse-logistics.md) | Returns management & reverse logistics |
| [strategic-compact](skills/strategic-compact.md) | Strategy documents & executive briefings |

</details>

<details>
<summary><strong>Specialty & Misc</strong> (18 skills)</summary>

| Skill | Description |
| --- | --- |
| [ascii-game-dev](skills/ascii-game-dev.md) | ECS architecture & terminal rendering |
| [blueprint](skills/blueprint.md) | Project blueprint & scaffolding templates |
| [cv-latex-workspace](skills/cv-latex-workspace.md) | Multi-template CV with pdflatex/xelatex |
| [data-science-workflow](skills/data-science-workflow.md) | Reproducible data science project structure |
| [data-visualization](skills/data-visualization.md) | Publication-quality plots with Scipy/Seaborn |
| [desktop-gui-dev](skills/desktop-gui-dev.md) | Python GUIs with CustomTkinter & PyQt6 |
| [episode-structure-45min](skills/episode-structure-45min.md) | 45-min 3-part episode format & pacing |
| [financial-data-science](skills/financial-data-science.md) | OpenBB, Pandas-TA & QuantStats stack |
| [howto-documentation](skills/howto-documentation.md) | Diátaxis framework & technical writing |
| [image-enhancement](skills/image-enhancement.md) | Neural upscaling, denoising & post-processing |
| [imagemagick-reference](skills/imagemagick-reference.md) | ImageMagick input normalization & operations |
| [imagemagick-technical](skills/imagemagick-technical.md) | PDF conversion, color space & FX operator |
| [method-of-loci](skills/method-of-loci.md) | Spatial memory & Blender loci construction |
| [nutrient-document-processing](skills/nutrient-document-processing.md) | Document AI & structured data extraction |
| [pdf-form-filling](skills/pdf-form-filling.md) | Automated PDF form filling & generation |
| [pdf-rendering-engines](skills/pdf-rendering-engines.md) | PDF rendering stack comparison & selection |
| [storytelling-clil-education](skills/storytelling-clil-education.md) | CLIL educational storytelling & Leitner SRS |
| [visa-doc-translate](skills/visa-doc-translate.md) | Official document translation for visa applications |

</details>

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
| --- | --- |
| **Claude Code CLI** | Zero config — stdio works out of the box |
| **Cursor** | `~/.cursor/mcp.json` → `"url": "http://localhost:8765/sse"` |
| **VS Code** | Continue.dev extension → `~/.continue/config.json` |
| **Antigravity IDE** | Continue.dev extension → same `~/.continue/config.json` |
| **JetBrains** | Continue plugin → same `~/.continue/config.json` |
| **Gemini CLI** | `~/.gemini/settings.json` → `"httpUrl": "http://localhost:8765/mcp"` |

### Available Tools

| Tool | Description |
| --- | --- |
| `list_skills` | List all 343 skill names |
| `get_skill` | Read any skill — e.g. `get_skill("fastapi-best-practices")` |
| `get_rules` | Get global repository rules |
| `run_<workflow>` | Execute a workflow |

See **[MCP Server README](bin/mcp-server/README.md)** for full per-IDE setup instructions.

---

## Acknowledgements

This repository's skill catalog includes content adapted from
[ECC — Everything Claude Code](https://github.com/affaan-m/ECC) by affaan-m (MIT).
If a skill isn't found here, ECC is a good next place to look.

---
*Built with strict adherence to the Prompt-Driven Development methodology.*
