# CLAUDE.md — Agent Constitution

## What This Repo Is
A validated context architecture for AI agents. The canonical technical reference is [AGENTIC-CODING-SETUP.md](AGENTIC-CODING-SETUP.md). This file tells you how to behave when working inside this repository.

## Mandatory: Read Before Any Task
Always read these before starting work:
- `.agent/rules/000-core.md` — Cost control, response format, error handling
- `.agent/rules/global.md` — Senior Architect identity, professional standards
- `.agent/rules/040-git.md` — Git protocol (feature branches required)

Read the others on demand:
- `.agent/rules/010-python.md` — Python standards
- `.agent/rules/020-tdd.md` — TDD rules
- `.agent/rules/030-security.md` — Security checks

## Skills (75 available)
Before implementing anything domain-specific, check `.agent/skills/` for an existing knowledge module. Read the relevant skill file first.

**By domain:**
| Domain | Skills to check |
|---|---|
| Python | `python-core-standards`, `python-containerization`, `python-github-setup`, `python-pandas-sklearn`, `python-pytorch-sklearn` |
| Web | `fastapi-best-practices`, `flask-json-guide`, `modern-web-ui`, `js-ts-code-quality` |
| AI/ML | `llm-ml-workflow`, `prompt-engineering`, `multi-rag-orchestration`, `reinforcement-learning`, `ai-logic-patterns` |
| Video | `video-production-automation`, `video-blender-automation`, `ffmpeg-recipes`, `ffmpeg-reference`, `video-manim-math` |
| Voice/Audio | `voice-orchestration-multi-model`, `voice-synthesis-multilingual`, `voice-dialogue-tts`, `audio-processing` |
| Visual | `visual-ai-cinematography`, `visual-character-consistency`, `imagemagick-reference`, `image-enhancement` |
| DevOps | `ops-automation`, `kubernetes-docs`, `linux-cuda-python`, `github-code-quality` |
| Mobile | `swiftui-guidelines`, `jetpack-compose-guidelines` |
| Web3 | `web3-solidity-foundry`, `web3-solidity-hardhat`, `web3-react-dapps` |
| Scripting | `zsh-scripting-advanced`, `zsh-completion`, `macos-automation` |
| Content | `screenwriting-youtube`, `screenwriting-frameworks`, `storytelling-narrative-frameworks`, `youtube-seo`, `copywriting` |
| Claude Code | `claude-code-integration` |

## Workflows
For structured tasks, follow the matching workflow:
- **New project setup** → `.agent/workflows/init-project.md`
- **AI feature work** → `.agent/workflows/ai-optimization.md`
- **Testing & commits** → `.agent/workflows/quality-assurance.md`
- **Writing docs** → `.agent/workflows/documentation.md`
- **Marketing assets** → `.agent/workflows/social-media-showcase.md`

## Git Protocol (Non-Negotiable)
```
git checkout -b feature/task-name   # ALWAYS branch first
# ... do the work ...
git commit -m "type(scope): description"
git checkout main && git merge feature/task-name && git branch -d feature/task-name
```
Never commit directly to `main`. A pre-commit hook will block it.

## Key Constraints
- Package manager: `uv` only (never `pip` directly)
- No hardcoded values — config in `config.yaml` or `.env`
- Do not delete any file without explicit user approval
- Never claim a task is done without showing proof (`ls`, test output, etc.)
- All cross-references in `.agent/` files must point to English files, not `fa/`
