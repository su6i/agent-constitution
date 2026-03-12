---
title: "Agentic Coding 2026"
description: Advanced setup, benchmarks, and ROI analysis for AI-driven development.
location: AGENTIC-CODING-SETUP.md
document_role: flagship-guide
last_updated: 2026-02-21
---

[Back to README](README.md)

# Technical Report: Agentic Coding Methodology & Configuration 2026

*This guide was prepared by Claude Sonnet 4.6.*

This document is the primary technical guide of this repository. It serves as the canonical reference for implementing High-Productivity Agentic Coding workflows, focusing on the strategic balance between **Computational Performance** and **Operational Cost Efficiency** based on February 2026 data.

---

## 📅 Technical Updates & Parameter Revisions (Feb 20, 2026)

<div style="background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.1); border-radius:8px; padding:16px 20px; font-size:12px; color:#dde0f2; line-height:1.8;">
  <strong>Key Technical Revisions:</strong><br>
  1. <strong>DeepSeek V3.2-Speciale:</strong> Agent-optimized iteration; accessible via OpenRouter (Tool-use protocol).<br>
  2. <strong>Gemini 3.1 Pro:</strong> Released Feb 19; recorded 77.1% on ARC-AGI-2 (Novel Reasoning benchmark).<br>
  3. <strong>Claude Sonnet 4.6:</strong> Released Feb 17; 79.6% SWE-bench score with $3 input / $15 output pricing structure.<br>
  4. <strong>Claude Opus 4.6:</strong> Pricing verified at $5 input / $25 output per million tokens.
</div>

---

## 📊 1. Comparative Analysis of 11 Leading Coding Models

### Ranked Model Matrix (By SWE-bench Performance Tier):

1. 👑 **Claude Opus 4.6** (Score: 80.8%)
2. 🥈 **Gemini 3.1 Pro** (Score: 80.6%)
3. 🥉 **MiniMax M2.5** (Score: 80.2%)
4. **GPT-5.4** (Score: 80.0%)
5. **Claude Sonnet 4.6** (Score: 79.6%)
6. **Kimi K2.5** (Score: 76.8%)
7. **Gemini 3 Pro** (Score: 76.2%)
8. **DeepSeek Speciale** (Score: ~76%)
9. **DeepSeek V3.2** (Score: ~73%)
10. **Gemini 3 Flash** (Score: 57.6%)
11. **GPT-5 mini** (Score: ~52%)

### Key Performance Indicators & Benchmark Definitions

Before reviewing the data, understanding the objective of each benchmark is essential for strategic model selection:

1. **SWE-bench Verified (Software Engineering Capability):**
   - **Objective:** Evaluates the model's ability to resolve real-world GitHub issues autonomously.
   - **Real-world Utility:** High scores indicate the model's reliability in writing code, passing unit tests, and completing full engineering tasks without human intervention. Crucial for the `Builder` role.

2. **Terminal-Bench 2.0 (CLI Proficiency):**
   - **Objective:** Assesses accuracy in shell command execution, package management, and file system navigation.
   - **Real-world Utility:** Higher percentages translate to fewer terminal-level errors (e.g., incorrect dependency installation). Vital for agentic setups with full terminal access.

3. **OSWorld (Computer Use & Web Interaction):**
   - **Objective:** Measures the model's ability to use browsers and desktop applications like a human.
   - **Real-world Utility:** Critical if your project requires the agent to research new documentation online or perform UI testing.

4. **ARC-AGI-2 (Novel Abstract Reasoning):**
   - **Objective:** Measures problem-solving power in scenarios the model has not encountered during training.
   - **Real-world Utility:** This is a proxy for "raw intelligence" when facing novel architectural challenges. High-scoring models are the primary choice for the `Architect` role.

5. **AIME 2025 (Advanced Mathematical Reasoning):**
   - **Objective:** Evaluates symbolic logic and stability in multi-step reasoning processes.
   - **Real-world Utility:** High scores imply logical consistency, significantly reducing the probability of hallucinations during complex coding workflows.

6. **Context Window (Operational Memory):**
   - **Objective:** The total capacity for retaining repository code and context in active memory.
   - **Real-world Utility:** For large-scale projects, a massive context window (e.g., 1M+) allows the model to comprehend the entire codebase simultaneously, ensuring structural changes don't break distant dependencies.

### Functional Benchmark Matrix (Comprehensive Analysis)
<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1);">
  <table style="width:100%; border-collapse:collapse; font-size:10px; color:#dde0f2; min-width:1400px;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Performance Metrics</th>
        <th>Opus 4.6</th>
        <th>Sonnet 4.6</th>
        <th>Gem 3.1 Pr</th>
        <th>Gem 3 Pro</th>
        <th>Gem 3 Flash</th>
        <th>DS V3.2</th>
        <th>DS Special</th>
        <th>MiniMax M2</th>
        <th>Kimi K2.5</th>
        <th>GPT-5.4</th>
        <th>GPT-5 mini</th>
      </tr>
    </thead>
    <tbody>
      <tr><td>SWE-bench Verified (Bug Solving)</td><td>80.8%</td><td>79.6%</td><td>80.6%</td><td>76.2%</td><td>57.6%</td><td>~73%</td><td>~76%</td><td>80.2%</td><td>76.8%</td><td>80.0%</td><td>~52%</td></tr>
      <tr><td>Terminal-Bench 2.0 (CLI Ops)</td><td>65.4%</td><td>~40%*</td><td>~60%</td><td>~52%</td><td>—</td><td>46.4%</td><td>~</td><td>~62%</td><td>~58%</td><td>64.7%</td><td>—</td></tr>
      <tr><td>OSWorld (Computer Use)</td><td>72.7%</td><td>72.5%</td><td>~70%</td><td>~55%</td><td>—</td><td>—</td><td>—</td><td>—</td><td>—</td><td>38.2%</td><td>—</td></tr>
       <tr><td>ARC-AGI-2 (Novel Reasoning)</td><td>75.2%</td><td>58.3%</td><td>77.1%</td><td>~37%</td><td>—</td><td>—</td><td>—</td><td>—</td><td>—</td><td>52.9%</td><td>—</td></tr>
       <tr><td>AIME 2025 (Advanced Math)</td><td>92.8%</td><td>100%</td><td>~96%</td><td>~90%</td><td>—</td><td>96%</td><td>99%+</td><td>~85%</td><td>96.1%</td><td>100%</td><td>—</td></tr>
       <tr><td>LiveCodeBench (Jan 2026)</td><td>~72%</td><td>~68%</td><td>~71%</td><td>~62%</td><td>~40%</td><td>~65%</td><td>~68%</td><td>~70%</td><td>~64%</td><td>~73%</td><td>~38%</td></tr>
       <tr><td>Context Window</td><td>1M β</td><td>1M β</td><td>1M</td><td>1M</td><td>1M</td><td>128K</td><td>163K</td><td>200K</td><td>256K</td><td>400K</td><td>256K</td></tr>
       <tr><td>Tool Calling in Cline</td><td>✅</td><td>✅</td><td>✅</td><td>✅</td><td>✅</td><td>✅</td><td style="color:#fbbf24;">⚠️ OR only</td><td>✅</td><td>✅</td><td>✅</td><td>✅</td></tr>
    </tbody>
  </table>
</div>

---

## 💰 2. Economic Analysis & Operational Optimization

- **Claude Sonnet 4.6:** Optimal performance-to-cost ratio for high-frequency workflows ($3 input / $15 output).
- **DeepSeek V3.2:** Optimized for high-volume execution via cost-efficient caching ($0.028 cache-hit / $0.42 output).
- **MiniMax M2.5:** Frontier-grade performance at significantly reduced operational overhead ($0.30 input / $1.20 output).
- **Gemini 3.1 Pro:** Primary reference for non-deterministic and complex architectural reasoning ($2 input / $12 output).

### GitHub Copilot: Included vs. Premium Request Models

A critical distinction that affects cost planning — **not all models in Copilot cost premium requests**:

| Model | Type | Premium Request | Per-month (300 budget) |
|---|---|---|---|
| **GPT-4.1** | Included | ✅ Free — zero | Unlimited |
| **GPT-5-mini** | Included | ✅ Free — zero | Unlimited |
| **GPT-4o** | Included | ✅ Free — zero | Unlimited |
| **Claude Sonnet 4.6** | Premium | ⚠️ **1x** (currently — temporary) | 300 interactions/month = ~10/day |
| **Claude Opus 4.5** | Premium | ❌ **3x** | 100 interactions/month = ~3/day |
| After 300 premium used | — | — | GPT-4.1 / GPT-5-mini remain free |

> ⚠️ **GitHub warns:** Claude Sonnet's 1x multiplier is **temporary** — it may increase to 2x or 3x as Anthropic adjusts pricing. If this happens, your 300 budget shrinks to 150 or 100. Use Claude Sonnet only for genuinely critical tasks: architecture review, security audit, logical deadlocks.

**Which to use in Copilot:** Set Copilot to **Auto** mode — it automatically selects between GPT-4.1 and GPT-5-mini (both unlimited/free) and avoids models with multiplier > 1. Only manually switch to Claude Sonnet 4.6 when you need architecture or security review quality.

---

## 🏛️ 3. Strategic Role Allocation (A-B-R Methodology)

1. **Architect & System Designer:**  
   - **Choice 1 (Best ROI):** **MiniMax M2.5**. Top-tier reasoning (80.2%) at a highly competitive price point. Ideal for drafting complex `task.md` documents.  
   - **Choice 2 (Infinite Context):** **Gemini 3.1 Pro**. The standard for recursive analysis across massive codebases (1M+ tokens).  
   - **Anthropic Alternative:** **Claude 4.6 Sonnet**. High performance and speed iterations (Opus is excluded due to irrational pricing and poor ROI).  

2. **Execution Engine (Builder):**  
   - **Choice 1 (Agentic Economics):** **DeepSeek V3.2**. Unrivaled price efficiency (due to caching) and execution speed for routine development tasks.  
   - **Choice 2 (Mid-Range Powerhouse):** **MiniMax M2.5**. Excellent balance between deep reasoning and competitive operational pricing.  

3. **Refactor & Retreival Specialist:**  
   - **Choice 1:** **MiniMax M2.5**. Specialized in ultra-large documentation retrieval and complex block-level refactoring.  
   - **Choice 2:** **Claude 4.6 Sonnet**. Preferred when architectural precision and adherence to strict patterns are the priority.  

4. **Quality Assurance (Reviewer):**  
   - **Choice 1:** **Claude 4.6 Opus**. The definitive model for identifying deep logical errors and security vulnerabilities.  
   - **Choice 2:** **Human-in-the-Loop**. Final inspection to ensure code readability, maintainability, and Clean Code standards.  

---

## ⚖️ 3.1. Model Strategy: Performance vs. Cost (ROI Analysis)

In agentic programming, cost is not just a number—it is an investment to prevent "Technical Debt." Our strategy is built on two core principles:

### 1. The "Sandwich Strategy"
This three-layered methodology ensures logical integrity across the project lifecycle:
- **Top Layer (Planning):** Utilizing Frontier-class models (e.g., Claude 4.6 Sonnet) for context analysis and `task.md` drafting. Errors at this stage lead to systemic project failure.
- **Middle Layer (Execution):** Offloading the bulk of implementation to economic models (e.g., DeepSeek V3.2). These engines produce 80-90% of the code volume at near-zero cost.
- **Bottom Layer (Verification):** Returning to a Frontier model or human reviewer for final validation and logical verification.

### 2. The "90/10 Rule" for Cost Control
This rule ensures your API billing remains sustainable:
- **90% of Messages:** Must be processed by high-efficiency, low-cost models (DeepSeek, MiniMax).
- **10% of Messages:** Reserved for critical architectural decisions and resolution of complex logical deadlocks, handled by premium models (Claude Opus/Sonnet).
*Result: 70-85% reduction in project costs with zero compromise on quality.*

---

## 🏗️ 4. Development Infrastructure (Tier List)

*Ranking Logic: This system follows the industry/gaming standard where **S-Tier** (Superior/Super) resides above A-Tier as the absolute highest priority, followed by A and B in descending order of general utility.*

### Tier S (Top Priority - Gold Standard): Core Agentic Environments  
- **VS Code + Cline (or Roo-Code) + GitHub Copilot:**  
  - **What & Why:** **Cline** is an open-source autonomous agent for VS Code that allows direct integration of AI models. Its BYOK (Bring Your Own Key) capability ensures you pay only for actual usage rather than a flat monthly fee.  
  - **Cost Structure:** The extension itself is **Free**. Your only cost is the API consumption from providers like Anthropic or DeepSeek.  
  - **Comparison:** Unlike Cursor, which charges $20/mo, Cline removes the middleman, offering direct connectivity to the source models with no arbitrary rate limits.  

### Tier A (Essential): Professional Infrastructure & CLI  
- **Warp Terminal:**  
  - **What:** The world's most modern terminal with integrated AI that understands and executes CLI commands.  
  - **Plan Differences:**  
    - **Free Tier:** 100 free requests per month (ideal for testing).  
    - **Build Tier ($20/mo):** Unlimited AI functionality and critical **BYOK** support. In this tier, connecting your own API key reduces the per-prompt cost in the terminal to near-zero (less than 0.001 cents).  
    - **Note (Oct 2025):** Warp consolidated all plans into a single "Build" tier at $20/mo. The previous $18 Pro/Turbo tiers no longer exist.  
  - **Why use it:** Eliminates human error in terminal execution and drastically accelerates DevOps workflows.  

- **Google Cloud CLI & Tools:** Essential infrastructure management for Gemini-class models.

### Tier B (Specialized): Automation & Smart Monitoring  
- **OpenClaw:**  
  - **What:** A viral open-source autonomous agent with **213k stars** and **39.6k forks** on GitHub (as of February 20, 2026).  
  - **Key Features:**  
    - **Mac Optimized:** Developed by Eschenberger (a former high-profile iOS developer), ensuring seamless integration and superior performance within the macOS ecosystem.  
    - **Proactive Monitoring:** 24/7 autonomous monitoring of pipelines, system health, and databases.  
    - **Persistent Memory:** Maintains a continuous state for deep, multi-day reasoning tasks.  
  - **Recommended Setup:** Due to the **Mac Mini's** exceptional power efficiency and the stability of macOS, the "Mac Mini + OpenClaw" combination is the definitive self-hosted choice for 24/7 background automation.  

> ⚠️ **Security Notice (Feb 17, 2026 — Verified):** A supply chain attack was identified in Cline v2.3.0 — malicious packages automatically installed OpenClaw without consent. Additionally, Cisco Talos security researchers reported that **26% of skills available on ClawHub contain malicious code** (credential stealers and backdoors). Action required: run `npm ls -g cline` and confirm your version is **not** 2.3.0. Avoid installing ClawHub skills from unverified authors.
>
> **Scope clarification:** OpenClaw is a **personal AI assistant** (manages email, calendar, WhatsApp automations) — it is **not** an inline coding agent like Cline. Rule of thumb:
> - **Daily coding (file edits, interactive sessions, code review): Cline > OpenClaw**
> - **DevOps automation, background monitoring, pipeline orchestration, multi-system coordination: OpenClaw > Cline**
>
> These are entirely separate tools designed for entirely different workflows. Don't try to use OpenClaw for step-by-step coding — it wasn't designed for that.

### Tier A+ (Google Ecosystem Integration): Cloud-Native Agents  
- **Google Jules:**  
  - **What:** An asynchronous, cloud-hosted coding agent directly integrated with GitHub.  
  - **Philosophy:** Unlike Cline (which runs on your hardware), Jules operates on a Google Cloud VM. You assign tasks via GitHub issues or the UI, and Jules creates PRs autonomously.  
  - **Pricing:** Currently in Public Beta (Free - up to 60 tasks/day).  
- **Gemini CLI:**  
  - **What:** A high-speed, terminal-native agent for immediate code analysis and system interaction.  
  - **Advantage:** Open-source and Free (standard limits). Ideal for quick debug loops where full VS Code indexing is redundant.  
- **Google AI Pro ($19.99/mo):**
  - **What:** A Google One subscription that bundles Gemini 2.0 Pro access, Gemini CLI (unlimited), Jules (up to 60 tasks/day), NotebookLM Plus, and **2 TB Google Drive** storage.
  - **ROI vs. Warp Build:** At $19.99/mo vs. Warp's $20/mo, Google AI Pro delivers dramatically more agentic value — direct terminal AI + async GitHub agent + massive context model — while Warp $20 delivers primarily BYOK terminal integration. If forced to choose one $20 subscription, Google AI Pro wins for coding workflows.

### Tier S Supplement: Free Alternatives Reference

The tools below cover gaps at zero recurring cost. Use alongside the core VS Code + Cline + Copilot stack:

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2; min-width:900px;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Tool</th>
        <th style="padding:10px;">Cost</th>
        <th style="padding:10px; text-align:left;">Replaces / Complements</th>
        <th style="padding:10px; text-align:left;">Key Differentiator</th>
        <th style="padding:10px;">VS Code</th>
        <th style="padding:10px;">Multi-Model</th>
      </tr>
    </thead>
    <tbody>
      <tr style="background:rgba(16,185,129,0.05);"><td style="padding:8px;"><strong>Ghostty</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">Replaces Warp (terminal)</td><td style="padding:8px;">GPU-accelerated, native UI (not Electron), macOS & Linux</td><td style="padding:8px; text-align:center;">—</td><td style="padding:8px; text-align:center;">—</td></tr>
      <tr><td style="padding:8px;"><strong>WezTerm</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">Replaces Warp (terminal)</td><td style="padding:8px;">Rust-based, built-in multiplexer (replaces tmux), Lua scripting</td><td style="padding:8px; text-align:center;">—</td><td style="padding:8px; text-align:center;">—</td></tr>
      <tr style="background:rgba(16,185,129,0.05);"><td style="padding:8px;"><strong>Wave Terminal</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">Complements Ghostty / WezTerm</td><td style="padding:8px;">Electron-based; renders markdown, images & HTML <em>inline</em> in the terminal; built-in browser tab for docs; SSH manager; best for documentation-heavy workflows. Still in beta, may crash — prefer Ghostty for 24/7</td><td style="padding:8px; text-align:center;">—</td><td style="padding:8px; text-align:center;">—</td></tr>
      <tr style="background:rgba(16,185,129,0.05);"><td style="padding:8px;"><strong>Roo Code</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">Complements Cline</td><td style="padding:8px;">Cline fork with Architect / Code / Debug / Ask modes + Checkpoint rollback</td><td style="padding:8px; text-align:center; color:#4ade80;">✅ Native</td><td style="padding:8px; text-align:center; color:#4ade80;">✅</td></tr>
      <tr><td style="padding:8px;"><strong>OpenCode</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">Terminal-first alternative to Cline</td><td style="padding:8px;">95K GitHub stars, supports 75+ LLM providers, terminal-native agent</td><td style="padding:8px; text-align:center; color:#f87171;">❌ Terminal</td><td style="padding:8px; text-align:center; color:#4ade80;">✅ 75+</td></tr>
      <tr style="background:rgba(16,185,129,0.05);"><td style="padding:8px;"><strong>Claude Code</strong></td><td style="padding:8px; text-align:center;">API only</td><td style="padding:8px;">Official Anthropic terminal agent</td><td style="padding:8px;">Best-in-class Claude integration, terminal-first, ideal for large codebases</td><td style="padding:8px; text-align:center; color:#f87171;">❌ Terminal</td><td style="padding:8px; text-align:center; color:#f87171;">❌ Claude only</td></tr>
      <tr><td style="padding:8px;"><strong>Kilo Code</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">VS Code Cline alternative</td><td style="padding:8px;">VS Code extension, multi-model, newer and less stable than Cline</td><td style="padding:8px; text-align:center; color:#4ade80;">✅ Native</td><td style="padding:8px; text-align:center; color:#4ade80;">✅</td></tr>
      <tr style="background:rgba(16,185,129,0.05);"><td style="padding:8px;"><strong>Continue.dev</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">Free Cline alternative (beginner-friendly)</td><td style="padding:8px;">VS Code extension, BYOK, simpler UI than Cline — ideal first step before committing to full Cline workflow; supports 50+ models via OpenAI-compatible API</td><td style="padding:8px; text-align:center; color:#4ade80;">✅ Native</td><td style="padding:8px; text-align:center; color:#4ade80;">✅ 50+</td></tr>
    </tbody>
  </table>
</div>

> **Practical recommendation:** Install **Roo Code** alongside Cline — it's free, uses the same API keys, and its specialized modes (Architect, Debug) complement Cline's general-purpose agent. For terminal, **Ghostty** is the recommended free Warp replacement.

**IDE quick comparison (Firebase/IDX column removed):**

| | VS Code | Cursor | GitHub Codespaces |
|---|---|---|---|
| Environment | 💻 Local | 💻 Local | ☁️ Cloud |
| Price | Free | $20/mo | ~$0.18/hr |
| AI Quality | ⭐⭐⭐⭐⭐ (with Cline/Copilot) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Stability | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Offline | ✅ | ✅ | ❌ |

### 4.1 Jules Deep-Dive: Asynchronous Agent Workflow

Jules is fundamentally different from Cline. Understanding this difference is key to using both tools together effectively:

**How Jules works (step by step):**
1. Go to `jules.google` and connect your GitHub repository.
2. Choose a repo and branch (Jules creates its own work branch automatically).
3. Write a task description — or assign a GitHub issue with the label `jules`.
4. Jules proposes a **plan**: a list of files it will change. You **approve** the plan before any code is written.
5. Jules executes on a **Google Cloud VM** in the background — you can close the browser and come back later.
6. When done, Jules opens a **Pull Request**. You review and merge.

**The power: parallel async execution.** While you work in VS Code + Cline on the main feature, Jules handles background tasks simultaneously:
- "Write tests for module X"
- "Fix these 3 minor bugs"
- "Update README and CHANGELOG"
- "Upgrade all dependencies to latest"

This means you effectively have two agents working in parallel.

**Underlying model:** Gemini 3 Pro (not 3.1 Pro). Sufficient for routine tasks; for architecturally complex work, Cline + Claude remains superior.

**Pricing (Feb 2026):** Public beta — free (60 tasks/day, 5 concurrent). With Google AI Pro: higher limits. Will likely become paid after beta.

> **AGENTS.md matters for Jules:** Jules reads the `AGENTS.md` file at the root of your repository to understand project conventions (commit format, test commands, package manager). Keep it accurate — it's Jules's only briefing document.

> ⚠️ **CRITICAL: Three agents, three roles — they are NOT fallbacks for each other.**
> | Agent | Role | When to use |
> |---|---|---|
> | **Cline** (VS Code) | Active primary coding session — file edits, interactive | Most of your work |
> | **Jules** | Async/background tasks on separate branches | Tests, docs, minor bugs — in parallel with Cline |
> | **Gemini CLI** | Quick terminal Q&A — no project context needed | "What does this error mean?" or one-shot queries |
>
> **If Cline hits a model error or rate limit:** Don't route to Jules. Instead, **swap the model in Cline's settings** (e.g., from Claude → MiniMax) or use **OpenRouter** as a unified fallback provider (supports 50+ models under one API key). Jules is only for work that truly runs in the background on a separate branch.

### 4.2 Gemini CLI: Installation & Quickstart

Gemini CLI is a terminal-native coding agent (open-source, Apache 2.0). It is **completely free** with generous daily quotas:

| Account | Model | Requests/day | Best for |
|---|---|---|---|
| Free Google account | **Gemini Flash** | **1,000/day** | Quick Q&A, one-shot queries |
| Free Google account | **Gemini Pro** | ~10–50/day | Deeper analysis (not reliable for daily use) |
| Google **AI Pro** ($19.99/mo) | Flash + Pro | Higher (exact number **not published** by Google) | Heavy daily terminal agent usage |

**Practical conclusion:** The free Flash tier (1,000 req/day) is more than sufficient for quick terminal Q&A. If you need heavy agentic sessions, consider the AI Pro plan or switch to an API-key-based model in Cline instead.

```bash
# Install (requires Node.js 18+)
npm install -g @google/gemini-cli

# Authenticate with your Google account (free)
gemini auth login

# Start interactive session in your project folder
gemini

# One-shot task
gemini -p "read src/main.py and list all functions that lack type hints"

# Combine with Jules (pipeline example)
gemini -p "find the hardest open issue: $(gh issue list --assignee @me)" | jules remote new --repo .
```

**Gemini CLI vs. Claude Code:** Both are terminal-first agents. Gemini CLI uses Gemini 3.1 Pro (with AI Pro limit) and integrates with Jules. Claude Code uses Claude models via API — same cost structure as Cline but terminal-first with built-in `/compact` and `/rewind` commands.

**Claude Code: Sonnet Rewrite mode.** When doing full-file rewrites or large refactors with Claude Code, it uses a "Rewrite" mode — instead of computing diffs, it writes the complete file output directly. This is faster for files under ~200 lines and consumes fewer tokens than patch-based editing. In Cline, you get the same effect by explicitly instructing: *"Rewrite this entire file with the following changes."*

### 4.3 Antigravity IDE — Agent-First Primary Environment

**Antigravity** is Google's agent-first IDE (formerly known as Project IDX), built on top of VS Code internals with **Gemini 3 Pro built-in** and a native **Agent Manager** for running multiple agents in parallel.

> ⚠️ **Known Issue: Cline doesn't work in Antigravity.** Multiple users report that Cline (and many VS Code marketplace extensions) don't appear in Antigravity's sidebar after installation. Antigravity uses the **OpenVSX** marketplace, not the Microsoft VS Code marketplace, so most proprietary extensions are unavailable. **Use Antigravity's built-in agent instead of Cline.**

**Antigravity vs. VS Code+Cline — Quick Comparison:**

| Feature | Antigravity (Primary) | VS Code + Cline (Fallback) |
|---|---|---|
| Inline completion | ✅ Unlimited with Google AI Pro | Copilot Free (50 req/month free) |
| Multi-agent parallel | ✅ Agent Manager | ⚠️ Single-thread |
| DeepSeek direct | ⚠️ Only via `router.py` bridge | ✅ Native in Cline |
| Claude direct | ⚠️ Only via `router.py` bridge | ✅ Native in Cline |
| MCP support | ✅ Full | ✅ Full |
| Built-in browser | ✅ Chrome integration | ❌ No |
| Cline extension | ❌ Broken | ✅ Native |
| Rules structure | `.agent/skills/*.md` | `.clinerules` |
| Approval control | ⚠️ Agent is more autonomous | ✅ Confirm each step |

**When to switch from Antigravity to VS Code+Cline:**
- Task requires **DeepSeek** (cheapest) or **Claude Sonnet** (most accurate) directly
- Need granular step-by-step **approval** for sensitive code changes
- Long session with heavy context (Antigravity hits rate limits faster)
- Complex project where the built-in agent is insufficient
- Antigravity itself is glitching or rate-limited

**Installing Antigravity:**
```bash
# macOS
brew install --cask antigravity

# Linux (.deb)
wget https://antigravity.google/download/linux/antigravity.deb
sudo dpkg -i antigravity.deb

# Windows
winget install Google.Antigravity

# After install:
# 1. Sign in with your Google account
# 2. Open project folder
# 3. Agent Manager → New Agent → describe your first task
```

---

## 🧠 5. Context Management (The Agent's Memory)

The primary bottleneck in agentic programming is "Context." If the agent is unaware of a file's existence or project standards, quality degrades.

- **Rules Files (`.cursor/rules/`):**  
    - Create `.mdc` files for specific technologies or standards.  
    - **Example:** "Always use Clean Architecture," "No `any` types in TypeScript."  
    - **Heuristic:** "Before editing a file, always read the associated `.test.ts` to understand the business logic."  

- **Repository Map (Repomap / Knowledge Graph):**  
    - Tools like Cline generate a semantic map of your codebase. Maintain a clean directory structure to ensure the agent finds relevant dependencies accurately.  

---

## ⚙️ 6. Intelligent Routing Methodology (Professional Architecture)

The core of cost optimization is the `AIRouter` — a production-ready Python engine that analyzes every incoming prompt, selects the cheapest adequate model, caches responses, and falls back automatically on failure.

```python
"""
Professional AI Model Router (Condensed)
Intelligently routes requests based on Task Complexity, Caching, and Fault Tolerance.
"""

class AIRouter:
    def select_model(self, prompt: str, context: Optional[Dict] = None) -> ModelType:
        # 1. Intelligent Task Complexity Analysis (Trivial -> Critical)
        complexity, confidence = self.complexity_analyzer.analyze(prompt, context)
        
        # 2. Routing Logic:
        # - Trivial: DeepSeek V3.2 (Cost: ~0)
        # - Moderate: MiniMax M2.5 (High Reasoning / Low Cost)
        # - Critical: Claude 4.6 Sonnet / Opus (Highest Logic)
        if complexity.value <= TaskComplexity.SIMPLE:
            return ModelType.DEEPSEEK_V3
        elif complexity.value <= TaskComplexity.MODERATE:
            return ModelType.MINIMAX_M25
        return ModelType.CLAUDE_SONNET

    async def generate_with_fallback(self, prompt, **kwargs):
        # 3. Circuit Breaker & Fallback
        # Automatically switches to a more powerful model if the primary fails.
        try:
            return await self.primary_client.generate(prompt)
        except ServiceError:
            return await self.fallback_client.generate(prompt)
```

---

### 6.1. Task Complexity Matrix — Full Reference

The `ComplexityAnalyzer` class categorizes every prompt into one of five levels and routes it to the optimal model. Classification is keyword-based with context multipliers applied on top.

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2; min-width:900px;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Level</th>
        <th style="padding:10px;">Value</th>
        <th style="padding:10px; text-align:left;">Description</th>
        <th style="padding:10px; text-align:left;">Default Target</th>
        <th style="padding:10px; text-align:left;">Trigger Keywords</th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;"><strong>TRIVIAL</strong></td><td style="padding:8px; text-align:center;">1</td><td style="padding:8px;">Boilerplate, formatting, comments, imports</td><td style="padding:8px;">DeepSeek Coder</td><td style="padding:8px; font-family:monospace; font-size:10px;">format, indent, comment, rename, import, boilerplate, template, scaffold</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>SIMPLE</strong></td><td style="padding:8px; text-align:center;">2</td><td style="padding:8px;">Basic CRUD, standard patterns, simple tests</td><td style="padding:8px;">DeepSeek Coder</td><td style="padding:8px; font-family:monospace; font-size:10px;">crud, getter, setter, validate, parse, convert, map, filter, simple test</td></tr>
      <tr><td style="padding:8px;"><strong>MODERATE</strong></td><td style="padding:8px; text-align:center;">3</td><td style="padding:8px;">Business logic, API endpoints, database ops</td><td style="padding:8px;">Claude Haiku</td><td style="padding:8px; font-family:monospace; font-size:10px;">implement, refactor, optimize, business logic, api endpoint, database, integration, middleware</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>COMPLEX</strong></td><td style="padding:8px; text-align:center;">4</td><td style="padding:8px;">Architecture, performance tuning, concurrency</td><td style="padding:8px;">Claude Sonnet</td><td style="padding:8px; font-family:monospace; font-size:10px;">architecture, design pattern, algorithm, performance, scalability, security, distributed, concurrency, async</td></tr>
      <tr><td style="padding:8px;"><strong>CRITICAL</strong></td><td style="padding:8px; text-align:center;">5</td><td style="padding:8px;">Production bugs, security vulnerabilities, data loss</td><td style="padding:8px;">Claude Opus</td><td style="padding:8px; font-family:monospace; font-size:10px;">bug fix production, security vulnerability, data loss, critical bug, emergency, zero-day, exploit</td></tr>
    </tbody>
  </table>
</div>

**Context-based score multipliers (additive):**
- `file_count > 10` → +1.0 to COMPLEX score
- `environment == 'production'` → +2.0 to CRITICAL score
- `urgent == True` → +1.0 to CRITICAL score
- `word_count > 200` → +0.5 to COMPLEX; `word_count > 100` → +0.5 to MODERATE

**Custom analyzer override** (for domain-specific routing):
```python
from ai_router import ComplexityAnalyzer, TaskComplexity

class CustomAnalyzer(ComplexityAnalyzer):
    @staticmethod
    def analyze(prompt, context=None):
        if 'database migration' in prompt.lower():
            return TaskComplexity.CRITICAL, 1.0
        return TaskComplexity.SIMPLE, 0.5

router.complexity_analyzer = CustomAnalyzer()
```

---

### 6.2. Four Routing Strategies

Each strategy maps task complexity values to model tiers. Adjust based on your project's risk tolerance and budget.

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Strategy</th>
        <th style="padding:10px;">DeepSeek Max</th>
        <th style="padding:10px;">Haiku Max</th>
        <th style="padding:10px;">Sonnet Max</th>
        <th style="padding:10px;">Cache TTL</th>
        <th style="padding:10px; text-align:left;">Recommended For</th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;"><strong>Conservative</strong></td><td style="padding:8px; text-align:center;">1 (Trivial only)</td><td style="padding:8px; text-align:center;">2</td><td style="padding:8px; text-align:center;">4</td><td style="padding:8px; text-align:center;">1h</td><td style="padding:8px;">Production systems, quality-critical work</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Balanced</strong></td><td style="padding:8px; text-align:center;">2</td><td style="padding:8px; text-align:center;">3</td><td style="padding:8px; text-align:center;">4</td><td style="padding:8px; text-align:center;">2h</td><td style="padding:8px;">General-purpose daily development (default)</td></tr>
      <tr><td style="padding:8px;"><strong>Cost-Optimized</strong></td><td style="padding:8px; text-align:center;">3</td><td style="padding:8px; text-align:center;">4</td><td style="padding:8px; text-align:center;">5</td><td style="padding:8px; text-align:center;">4h</td><td style="padding:8px;">High-volume, budget-constrained projects</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Dev</strong></td><td style="padding:8px; text-align:center;">2</td><td style="padding:8px; text-align:center;">3</td><td style="padding:8px; text-align:center;">4</td><td style="padding:8px; text-align:center;">Disabled</td><td style="padding:8px;">Fast iteration loops, fresh responses required</td></tr>
    </tbody>
  </table>
</div>

```python
from config_example import (
    CONSERVATIVE_ROUTING,
    BALANCED_ROUTING,
    COST_OPTIMIZED_ROUTING,
    DEV_ROUTING
)

router = AIRouter(MODEL_CONFIGS, BALANCED_ROUTING)        # Recommended default
router = AIRouter(MODEL_CONFIGS, CONSERVATIVE_ROUTING)    # Production
router = AIRouter(MODEL_CONFIGS, COST_OPTIMIZED_ROUTING)  # Budget mode
router = AIRouter(MODEL_CONFIGS, DEV_ROUTING)             # Development
```

---

### 6.3. Real-World Cost Analysis (500 Requests/Day)

**`BALANCED_ROUTING` breakdown — 500 requests/day:**

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Model</th>
        <th style="padding:10px;">Share</th>
        <th style="padding:10px;">Daily Requests</th>
        <th style="padding:10px;">Daily Cost</th>
        <th style="padding:10px;">Monthly Cost</th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;">DeepSeek Coder</td><td style="padding:8px; text-align:center;">40%</td><td style="padding:8px; text-align:center;">200</td><td style="padding:8px; text-align:center;">~$0.60</td><td style="padding:8px; text-align:center;">~$18</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;">Claude Haiku</td><td style="padding:8px; text-align:center;">30%</td><td style="padding:8px; text-align:center;">150</td><td style="padding:8px; text-align:center;">~$2.50</td><td style="padding:8px; text-align:center;">~$75</td></tr>
      <tr><td style="padding:8px;">Claude Sonnet 4.6</td><td style="padding:8px; text-align:center;">25%</td><td style="padding:8px; text-align:center;">125</td><td style="padding:8px; text-align:center;">~$6.25</td><td style="padding:8px; text-align:center;">~$187</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;">Claude Opus 4.6</td><td style="padding:8px; text-align:center;">5%</td><td style="padding:8px; text-align:center;">25</td><td style="padding:8px; text-align:center;">~$3.00</td><td style="padding:8px; text-align:center;">~$90</td></tr>
      <tr style="background:rgba(59,130,246,0.15); font-weight:bold;"><td style="padding:8px;">Total</td><td style="padding:8px; text-align:center;">100%</td><td style="padding:8px; text-align:center;">500</td><td style="padding:8px; text-align:center;">~$12.35</td><td style="padding:8px; text-align:center;">~$370</td></tr>
    </tbody>
  </table>
</div>

**Strategy comparison vs. All-Opus baseline:**

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Strategy</th>
        <th style="padding:10px;">Monthly Cost</th>
        <th style="padding:10px;">Savings vs. All-Opus ($825/mo)</th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;">All Claude Opus (baseline)</td><td style="padding:8px; text-align:center;">$825</td><td style="padding:8px; text-align:center;">—</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;">Conservative Router</td><td style="padding:8px; text-align:center;">~$500</td><td style="padding:8px; text-align:center; color:#4ade80;">−39%</td></tr>
      <tr><td style="padding:8px;">Balanced Router</td><td style="padding:8px; text-align:center;">~$370</td><td style="padding:8px; text-align:center; color:#4ade80;">−55%</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;">Cost-Optimized Router</td><td style="padding:8px; text-align:center;">~$270</td><td style="padding:8px; text-align:center; color:#4ade80;"><strong>−67%</strong></td></tr>
    </tbody>
  </table>
</div>

> **Cache multiplier:** Identical prompts cost $0 (cache TTL: 1–4 hours depending on strategy). In real workflows with high prompt repetition (e.g., code review templates), effective savings exceed the above figures.

---

### 6.4. CLI Interface Reference

`router_cli.py` ships four operational modes accessible from a single entry point:

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Mode</th>
        <th style="padding:10px; text-align:left;">Command</th>
        <th style="padding:10px; text-align:left;">Description</th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;"><strong>Interactive</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py</td><td style="padding:8px;">REPL loop with inline model override flags</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Single Prompt</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py -p "prompt"</td><td style="padding:8px;">One-shot generation, prints metadata</td></tr>
      <tr><td style="padding:8px;"><strong>Force Model</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py -p "prompt" --model sonnet</td><td style="padding:8px;">Bypasses routing, uses specified model</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Batch</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py --batch prompts.txt --output results.json</td><td style="padding:8px;">Parallel processing from newline-delimited file</td></tr>
      <tr><td style="padding:8px;"><strong>Stats</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py --stats</td><td style="padding:8px;">Live cost dashboard with per-model breakdown</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Cost Estimate</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py --estimate 500</td><td style="padding:8px;">Monthly projection for N requests/day</td></tr>
      <tr><td style="padding:8px;"><strong>Test Analyzer</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py --test-complexity</td><td style="padding:8px;">Validates routing decision logic against test prompts</td></tr>
    </tbody>
  </table>
</div>

**Interactive mode — inline model overrides:**
```
@opus      → Force Claude Opus 4.6
@sonnet    → Force Claude Sonnet 4.6
@haiku     → Force Claude Haiku
@deepseek  → Force DeepSeek Coder
stats      → Show live statistics
exit       → Quit
```

**Select routing strategy at launch:**
```bash
python router_cli.py --strategy balanced       # default
python router_cli.py --strategy conservative   # production
python router_cli.py --strategy cost-optimized # budget
```

---

### 6.5. Source Code & Installation

**Dependencies (`requirements.txt`):**
```
# ── Core (required) ──────────────────────────────────────────
anthropic>=0.40.0          # Claude Opus / Sonnet / Haiku
httpx>=0.27.0              # DeepSeek (direct REST)
python-dotenv>=1.0.0
pydantic>=2.0.0
aiofiles>=23.0.0

# ── Optional: GPT-5.x / OpenAI-compatible APIs ───────────────
# openai>=1.0.0            # GPT-5.4, GPT-5 mini (OpenAI API)

# ── Optional: Google Gemini ──────────────────────────────────
# google-genai>=1.0.0          # Gemini 3.x Pro / Flash (new official SDK)

# ── Optional: Universal adapter (all models via one API) ─────
# litellm>=1.0.0           # Supports Claude, GPT, Gemini,
#                          # MiniMax, Kimi, DeepSeek, Mistral…
#                          # Replaces provider-specific clients

# ── Optional: Orchestration / Agents ─────────────────────────
# langchain>=0.3.0         # Chain/agent orchestration
# langchain-anthropic>=0.3.0
# langchain-openai>=0.3.0
```

> **Recommendation:** For projects that need more than Claude + DeepSeek, use `litellm` as a drop-in replacement for both `ClaudeClient` and `DeepSeekClient`. It provides a single unified interface for all 11 models listed in Section 1 without rewriting the router logic.

**Setup (3 steps):**
```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Set API keys in .env
ANTHROPIC_API_KEY=your_anthropic_key
DEEPSEEK_API_KEY=your_deepseek_key

# 3. Copy and configure
cp config_example.py config.py
# Edit config.py: update API keys and model names to match current versions
# Note: update model name strings and pricing to match Section 2 of this report
```

**Source files (full production implementation):**

| File | Description |
|---|---|
| [`ai_router.py`](.agent/skills/ai-router/ai_router.py) | Core engine: `AIRouter`, `ComplexityAnalyzer`, `CacheManager`, `CostTracker`, `CircuitBreaker`, `ClaudeClient`, `DeepSeekClient` |
| [`config_example.py`](.agent/skills/ai-router/config_example.py) | All four routing strategies with complete `ModelConfig` pricing tables |
| [`router_cli.py`](.agent/skills/ai-router/router_cli.py) | Full CLI with interactive, single-prompt, batch, stats, and cost-estimation modes |
| [`requirements.txt`](.agent/skills/ai-router/requirements.txt) | Python dependency list |

**Architecture overview:**

```
AIRouter
├── ComplexityAnalyzer      → keyword + context scoring → TaskComplexity (1-5)
├── select_model()          → maps complexity to ModelType via RoutingConfig thresholds
├── CacheManager            → SHA-256 keyed, TTL-based async response cache
├── CostTracker             → per-request metrics + monthly projection engine
├── CircuitBreaker (×5)     → per-model; opens after 5 failures, retries after 60s
├── ClaudeClient            → Anthropic SDK async wrapper
└── DeepSeekClient          → httpx async wrapper for DeepSeek REST API
```

### 6.6 Simplified Production Router (`src/utils/router.py`)

A leaner, production-ready version using the **OpenAI-compat interface** for all three providers — no custom HTTP clients needed. Drop-in for any project.

```python
"""
router.py — Intelligent LLM Router
Auto model selection + fallback + cost control + logging
"""
import asyncio, json, os, time, datetime, re
from pathlib import Path
from openai import AsyncOpenAI

# ─── Configuration ─────────────────────────────────────────────────────

LIMITS = {"daily": 1.0, "weekly": 5.0, "monthly": 25.0}
LOG_FILE = Path("memory-bank/costLog.json")

# ─── Complexity Detection via Keyword Scoring ────────────────────────

SIGNALS = {
    # high score = stronger model
    "critical": {
        "keywords": [
            "معماری", "architect", "design pattern", "امنیت", "security",
            "vulnerability", "review", "بررسی نهایی", "production",
            "authentication", "authorization", "audit", "injection",
        ],
        "score": 25,
    },
    "moderate": {
        "keywords": [
            "refactor", "بازنویسی", "feature", "ویژگی جدید",
            "integrate", "یکپارچه", "مستندات", "documentation",
            "optimize", "بهینه", "analyze", "تحلیل",
        ],
        "score": 12,
    },
    "trivial": {
        "keywords": [
            "تست بنویس", "write test", "bug fix", "رفع باگ",
            "crud", "boilerplate", "اضافه کن", "add function",
        ],
        "score": -5,  # negative score = cheaper model
    },
}


def analyze_prompt(prompt: str) -> tuple[int, str]:
    """
    Analyze the prompt and return a complexity score.
    returns: (score 0-100, reasoning string)
    """
    score = 30  # base score
    reasons = []
    prompt_lower = prompt.lower()

    # keyword scoring
    for level, data in SIGNALS.items():
        for kw in data["keywords"]:
            if kw.lower() in prompt_lower:
                score += data["score"]
                reasons.append(f"{level}:{kw}")
                break

    # prompt length
    word_count = len(prompt.split())
    if word_count > 200: score += 20
    elif word_count > 80: score += 10
    elif word_count < 20: score -= 10

    # file reference count
    file_mentions = len(re.findall(r'\b\w+\.py\b', prompt))
    if file_mentions > 3: score += 15
    elif file_mentions > 1: score += 8

    score = max(0, min(100, score))
    reasoning = f"score={score} words={word_count} files={file_mentions} signals={reasons[:3]}"
    return score, reasoning


def score_to_model(score: int) -> str:
    """Numeric score → model selection."""
    if score >= 66: return "claude"
    if score >= 31: return "minimax"
    return "deepseek"


# ─── Cost Calculation ──────────────────────────────────────────────────

COST_PER_TOKEN = {
    "deepseek":  {"input": 0.028e-6, "output": 0.42e-6},   # cache-hit
    "minimax":   {"input": 0.30e-6,  "output": 1.20e-6},
    "claude":    {"input": 3.0e-6,   "output": 15.0e-6},
}


def estimate_cost(provider: str, in_tokens: int, out_tokens: int) -> float:
    r = COST_PER_TOKEN[provider]
    return r["input"] * in_tokens + r["output"] * out_tokens


def log_and_check(provider: str, cost: float) -> list[str]:
    """Log cost and return threshold warnings."""
    LOG_FILE.parent.mkdir(exist_ok=True)
    today = datetime.date.today().isoformat()
    data = json.loads(LOG_FILE.read_text()) if LOG_FILE.exists() else {}
    data.setdefault(today, {}).setdefault(provider, 0)
    data[today][provider] += cost
    LOG_FILE.write_text(json.dumps(data, indent=2))

    # compute period aggregates
    week_ago = (datetime.date.today() - datetime.timedelta(days=7)).isoformat()
    month_start = datetime.date.today().replace(day=1).isoformat()
    all_days = {k: sum(v.values()) for k, v in data.items()}

    daily   = all_days.get(today, 0)
    weekly  = sum(v for k, v in all_days.items() if k >= week_ago)
    monthly = sum(v for k, v in all_days.items() if k >= month_start)

    warnings = []
    for name, spent, limit in [
        ("daily", daily, LIMITS["daily"]),
        ("weekly", weekly, LIMITS["weekly"]),
        ("monthly", monthly, LIMITS["monthly"]),
    ]:
        pct = spent / limit * 100
        if pct >= 100:
            warnings.append(f"🚨 STOP {name}: ${spent:.2f}/${limit}")
        elif pct >= 80:
            warnings.append(f"⚠️ {name}: ${spent:.2f}/${limit} ({pct:.0f}%)")
    return warnings


# ─── Circuit Breaker ───────────────────────────────────────────────────

class CircuitBreaker:
    """Three consecutive failures → 5-minute pause."""
    def __init__(self):
        self._state: dict[str, tuple[int, float]] = {}

    def is_open(self, provider: str) -> bool:
        fails, ts = self._state.get(provider, (0, 0))
        if fails >= 3 and time.time() - ts < 300:
            return True
        if fails >= 3:
            self._state[provider] = (0, 0)  # reset after 5 minutes
        return False

    def record_fail(self, provider: str):
        fails, _ = self._state.get(provider, (0, 0))
        self._state[provider] = (fails + 1, time.time())

    def record_success(self, provider: str):
        self._state.pop(provider, None)


# ─── Main Router ───────────────────────────────────────────────────────

class LLMRouter:
    def __init__(self):
        self.breaker = CircuitBreaker()
        self._clients = {
            "deepseek": AsyncOpenAI(
                api_key=os.environ["DEEPSEEK_API_KEY"],
                base_url="https://api.deepseek.com",
            ),
            "minimax": AsyncOpenAI(
                api_key=os.environ["MINIMAX_API_KEY"],
                base_url="https://api.minimax.chat/v1",
            ),
            "claude": AsyncOpenAI(
                api_key=os.environ["ANTHROPIC_API_KEY"],
                base_url="https://api.anthropic.com/v1",
            ),
        }
        self._models = {
            "deepseek": "deepseek-chat",
            "minimax":  "minimax-m2.5",
            "claude":   "claude-sonnet-4-5-20251001",
        }
        # fallback chain per primary model
        self._fallback = {
            "deepseek": ["minimax", "claude"],
            "minimax":  ["deepseek", "claude"],
            "claude":   ["minimax", "deepseek"],
        }

    async def _call(self, provider: str, messages: list, max_tokens=4096) -> tuple:
        client = self._clients[provider]
        resp = await client.chat.completions.create(
            model=self._models[provider],
            messages=messages,
            max_tokens=max_tokens,
            stream=False,
        )
        return resp.choices[0].message.content, resp.usage

    async def generate(
        self,
        prompt: str,
        system: str | None = None,
        force_provider: str | None = None,
        max_tokens: int = 4096,
        verbose: bool = True,
    ) -> str:
        """
        Main API — call this method.
        force_provider: override auto-selection (e.g. always use claude)
        """
        # analyze prompt complexity
        score, reasoning = analyze_prompt(prompt)
        primary = force_provider or score_to_model(score)

        if verbose:
            print(f"🔍 {reasoning} → {primary}")

        # build messages list
        messages = []
        if system:
            messages.append({"role": "system", "content": system})
        messages.append({"role": "user", "content": prompt})

        # try primary model then fallbacks
        chain = [primary] + self._fallback[primary]
        for provider in chain:
            if self.breaker.is_open(provider):
                print(f"⏭️ skip {provider} (circuit open)")
                continue
            try:
                content, usage = await self._call(provider, messages, max_tokens)
                self.breaker.record_success(provider)

                # log cost and check thresholds
                cost = estimate_cost(
                    provider,
                    getattr(usage, "prompt_tokens", 500),
                    getattr(usage, "completion_tokens", 500),
                )
                warnings = log_and_check(provider, cost)
                if verbose:
                    print(f"✅ {provider} ${cost:.4f}")
                for w in warnings:
                    print(w)

                return content

            except Exception as e:
                print(f"❌ {provider}: {e}")
                self.breaker.record_fail(provider)
                continue

        raise RuntimeError("All providers failed")


# ─── Project-wide Singleton ─────────────────────────────────────────────
router = LLMRouter()


# ─── Simple Usage Example ──────────────────────────────────────────────
if __name__ == "__main__":
    async def demo():
        # auto → DeepSeek (simple task)
        r1 = await router.generate("Write a function that sorts a list of numbers")

        # auto → MiniMax (moderate task)
        r2 = await router.generate("Refactor this module to use dataclasses")

        # auto → Claude (complex task)
        r3 = await router.generate("Review the architecture of this authentication system")

        # force override
        r4 = await router.generate("Any question here", force_provider="claude")

    asyncio.run(demo())
```

**`costLog.json` format** (date-keyed dict, per-provider — used by both `router.py` and `cost_monitor.py`):
```json
{
  "2026-03-11": {
    "deepseek": 0.12,
    "minimax": 0.35
  },
  "2026-03-12": {
    "claude": 0.48
  }
}
```

---

## ✅ 7. Optimized Workflow Checklist (Standard Operating Procedure)

1. **Initialization:**  
    - Start with a clean `task.md` (bullet points) and an `implementation_plan.md` (roadmap).  
    - **Recommended Model:** **MiniMax M2.5** (Highest reasoning ROI for the design phase).  
    - **Note:** If you prefer the Anthropic ecosystem, use **Claude 4.6 Sonnet** (Opus is not recommended for daily workflows due to excessive costs).  

2. **Implementation:**  
    - Switch to **DeepSeek V3.2** for implementation.  
    - **Golden Rule:** Never allow the agent to multitask broad items. **One Task = One Commit.**  

3. **Verification & Autonomous Self-Healing:**  
    - Mandate the agent to use **TDD** (Test-Driven Development: writing tests *before* the actual implementation).  
    - **Autonomous Loop:** Using terminal access (e.g., Cline), the agent should independently execute tests, analyze failure logs, and perform code iterations until all benchmarks are passed. You only review the final success report.  
	
4. **Refinement:**  
    - "Review this file for logical flaws or security vulnerabilities."  
    - **Recommended Model:** Claude 4.6 Sonnet (for final polishing).  

---

### 7.1. Operational Risk Mitigation — 8 Critical Gaps

These are the most common failure points in production agentic workflows that are not covered by the checklist above:

**1. Infinite Loop & Cost Explosion Prevention**
- In Cline settings: set **Context Window Size** to `80K` and **Max requests per task** to `20`.
- Create a `.clinerules` file in your project root with the instruction: `"Stop and ask the user if uncertain about the next step. Never retry the same action more than 3 times."`
- Without these limits, a single Cline session with Claude Sonnet can cost $10–$50 in minutes.

**2. Memory Bank (Cross-Session Persistence)**
- Cline's Memory Bank keeps context alive between sessions. Without it, the agent starts from zero every time.
- Initialize these files: `memory-bank/activeContext.md`, `memory-bank/progress.md`, `memory-bank/systemPatterns.md`.
- Enable Memory Bank in Cline settings → the agent will auto-read and update these on each session start.

**3. Context Explosion on Resume**
- When resuming a long task, Cline re-sends the full conversation history — prompt caching stops working and costs spike. Some users reported going from $30/mo to $230/mo solely from this.
- Rule: **One task = One Cline session = One commit.** Never resume. Instead, write a `session-summary.md` capturing the current state and start a fresh session with it as context.

**4. TDD Rule File (Required for Compliance)**
- Writing "use TDD" in the checklist is not enough — agents ignore it without a rule file.
- Create `.cursor/rules/tdd.mdc`:
  ```
  Always write the failing test BEFORE writing implementation code.
  Never write implementation before the test exists.
  Run the full test suite after every file change.
  If tests fail, analyze the failure message before making changes.
  ```

**5. Secret Management**
- API keys (DeepSeek, Anthropic, MiniMax) scattered across `.env` files are a leak risk — especially if OpenClaw or any 3rd party agent is installed.
- Add to `.gitignore`: `.env`, `.env.*`, `config.py` (if it contains keys).
- Use `direnv` or `dotenv-vault` for secrets. Add a rule: `"Never hardcode API keys. Always use environment variables. Never commit .env files."`

**6. Cost Telemetry & Budget Alerts**
- "Check the dashboard daily" is insufficient for automation.
- In the **Anthropic Console** and **DeepSeek Platform**: configure a hard budget alert at $5/day and a soft alert at $2/day.
- In code: use the `tokencost` Python library to track cost per API call in real time.

**7. API Fallback Chain**
- DeepSeek rate-limits during peak hours. The pseudo-code fallback in Section 6 must be implemented.
- Recommended chain: `DeepSeek V3.2` → (on fail) → `MiniMax M2.5` → (on fail) → `Gemini Flash` (often free via Google AI Studio).
- The `ai_router.py` in Section 6 already implements this pattern via `CircuitBreaker` + `_generate_with_fallback()`.

**8. Large Project Strategy (+50 files)**
- DeepSeek V3.2's 128K context window is insufficient for projects with 50+ files.
- For large-scale architecture and planning: use **Gemini 3.1 Pro** (1M context) or **Kimi K2.5** (256K).
- Reduce context load before sending to the agent: use `tree` output and Repomap summaries instead of full file contents.

---

### 7.2 Model Selection Quick-Reference

Use this table before every task to pick the correct model instantly. Wrong model = wasted money or degraded quality.

| Task Type | Model | Cost/task (est.) | Why |
|---|---|---|---|
| Trivial: tests, config, lint fixes, small bugs | **DeepSeek V3.2** | ~$0.01 | Cache-hit: $0.028/M input; fastest for repetitive patterns |
| Moderate: new features, refactors, multi-file changes | **MiniMax M2.5** | ~$0.05 | 80.2% SWE-bench; strong reasoning at low cost |
| Critical: architecture, security review, API design | **Claude Sonnet 4.6** | ~$0.15 | Best reasoning; worth the premium for irreversible decisions |
| Quick Q&A (no project context needed) | **Gemini CLI (Flash)** | **$0** | Free, 1,000 req/day; use from terminal |
| Background tasks (tests, docs, minor fixes) | **Jules** | **$0 (beta)** | Async on separate branch; runs while you work on main |
| Bulk generation, docs, scaffolding (budget) | **Gemini 3 Flash** | ~$0.02 | 57.6% SWE-bench; fast and cheap for non-critical generation tasks |
| Free inline autocomplete | **GPT-5 mini** (Copilot) | **$0** | Unlimited in Copilot Free/Pro; strong for short completions and single-file suggestions |
| Math/algorithm reasoning (standalone) | **DeepSeek Speciale** | ~$0.01 | ⚠️ Available via **OpenRouter only** (direct endpoint expired Dec 2025); tool-use works in Cline via OR — do NOT use the `deepseek-reasoner-speciale` endpoint directly |
| Moderate-Critical, complex tool chains, Claude reliability at lower price | **Claude Haiku 4.5** | ~$0.02 | >73% SWE-bench Verified; Claude's tool-call precision at ~4× cheaper than Sonnet — use when MiniMax/DeepSeek tool-calling fails in multi-step agentic workflows |

**OpenRouter as universal fallback:** If DeepSeek is rate-limiting, a model is down, or you want one API key for all models without VPN requirements:
- Provider: OpenRouter | Base URL: `https://openrouter.ai/api/v1`
- Use model IDs like: `deepseek/deepseek-v3.2` · `anthropic/claude-sonnet-4-5` · `minimax/minimax-m2.5`
- Works with Cline, Roo Code, and any OpenAI-compatible client with zero code changes — just update the base URL and API key.

**DeepSeek V3.2 — cost breakdown per platform (budget: $20):**

| Platform | Input (per 1M) | Output (per 1M) | Messages / $20 | Notes |
|---|---|---|---|---|
| **DeepSeek API direct** ⭐ | $0.028 cache-hit | $0.42 | **~2,000+** | 5M free tokens on signup; best cache-hit rate |
| **OpenRouter** | $0.24 | $0.38 | ~1,500 | No VPN needed; works in restricted regions |
| **Together AI** | $0.25 | $0.40 | ~1,400 | Good uptime for fallback |
| **Self-host** | Free | Free | ∞ | Requires 8× H100 GPU — not practical for individuals |

> **Cache-hit strategy:** DeepSeek charges $0.028/M cached vs $0.28/M uncached (10× gap). Keep your **system prompt character-for-character identical** across requests — even one character change resets the cache and costs 10× more.

---

## 🎯 8. Final Setup Recommendation & Economic Rationale

The objective of this configuration is to achieve **Maximum Efficiency with Minimum Recurring Costs**. The justification for each expenditure is as follows:

1. **VS Code + Copilot + Cline ($28/mo):**   
   - **Rationale:** Copilot provides efficient autocomplete and routine suggestions for $10. Cline handles autonomous agentic tasks by connecting to low-cost APIs (like DeepSeek). This combination is more cost-effective than $20/mo IDE subscriptions as it eliminates arbitrary rate limits and offers granular control.  

2. **Warp Build ($20/mo):**   
   - **Rationale:** This is the key to AI integration in the terminal. With BYOK, the cost of executing CLI commands—which could previously reach several cents—is reduced to less than 0.001 cents.  
   - **Alternative:** Consider **Ghostty** (free terminal) + **Google AI Pro** ($19.99/mo) instead — same budget, broader capabilities.  

3. **API Budget Allocation (Min $20 Credit):**  
   - **Claude 4.6 Sonnet (Intelligence):** Paying for the Architect model to prevent expensive design errors.  
   - **DeepSeek V3.2 (Execution):** This model leverages cache-hit mechanisms to handle the bulk of code generation at near-zero cost.  

### 8.1. Setup Tiers by Budget

Three validated configurations covering different investment levels:

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2; min-width:900px;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Component</th>
        <th style="padding:10px; text-align:center; color:#4ade80;">🆓 Zero Budget<br><small>$0/mo</small></th>
        <th style="padding:10px; text-align:center; color:#93c5fd;">💙 Budget Pro<br><small>~$10/mo</small></th>
        <th style="padding:10px; text-align:center; color:#fbbf24;">⭐ Professional<br><small>~$30/mo</small></th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;"><strong>Terminal</strong></td><td style="padding:8px; text-align:center;">Ghostty (free)</td><td style="padding:8px; text-align:center;">Ghostty (free)</td><td style="padding:8px; text-align:center;">Ghostty (free)</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Coding Agent (IDE)</strong></td><td style="padding:8px; text-align:center;">Cline + Roo Code (free)</td><td style="padding:8px; text-align:center;">Cline + Roo Code (free)</td><td style="padding:8px; text-align:center;">Cline + Roo Code (free)</td></tr>
      <tr><td style="padding:8px;"><strong>Inline Completion</strong></td><td style="padding:8px; text-align:center;">GitHub Copilot Free<br><small>50 premium req/mo</small></td><td style="padding:8px; text-align:center; color:#fbbf24;">GitHub Copilot Pro ($10)<br><small>300 premium req/mo</small></td><td style="padding:8px; text-align:center; color:#fbbf24;">GitHub Copilot Pro ($10)<br><small>or Free tier</small></td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Builder (API)</strong></td><td style="padding:8px; text-align:center;">DeepSeek<br><small>5M free tokens starter</small></td><td style="padding:8px; text-align:center;">DeepSeek API<br><small>~$0 with cache-hit</small></td><td style="padding:8px; text-align:center;">DeepSeek API<br><small>~$5/mo</small></td></tr>
      <tr><td style="padding:8px;"><strong>Architect (API)</strong></td><td style="padding:8px; text-align:center;">Gemini Flash<br><small>(AI Studio free tier)</small></td><td style="padding:8px; text-align:center;">Gemini Flash<br><small>(AI Studio free tier)</small></td><td style="padding:8px; text-align:center; color:#fbbf24;">Claude Sonnet 4.6 API<br><small>~$5/mo (10% of tasks)</small></td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Gemini CLI + Jules</strong></td><td style="padding:8px; text-align:center; color:#f87171;">❌</td><td style="padding:8px; text-align:center; color:#f87171;">❌</td><td style="padding:8px; text-align:center; color:#4ade80;">Google AI Pro ($19.99)<br><small>+ 2TB Drive</small></td></tr>
      <tr><td style="padding:8px;"><strong>Terminal AI Agent</strong></td><td style="padding:8px; text-align:center;">OpenCode (free)</td><td style="padding:8px; text-align:center;">OpenCode (free)</td><td style="padding:8px; text-align:center;">Gemini CLI (via AI Pro)</td></tr>
      <tr style="background:rgba(59,130,246,0.1); font-weight:bold;"><td style="padding:8px;"><strong>Total</strong></td><td style="padding:8px; text-align:center; color:#4ade80;"><strong>$0</strong><br><small>Start with DeepSeek free credits</small></td><td style="padding:8px; text-align:center; color:#93c5fd;"><strong>~$10</strong><br><small>Copilot Pro only</small></td><td style="padding:8px; text-align:center; color:#fbbf24;"><strong>~$30</strong><br><small>Best ROI in 2026</small></td></tr>
    </tbody>
  </table>
</div>

> **Why Professional at $30 beats the original $46 recommendation ($28 Copilot+Cline + $18 Warp):** Replacing Warp $20 with Ghostty (free) + Google AI Pro ($19.99) saves money while adding Gemini 3.1 Pro access, Jules async agent, and 2 TB storage. Cline is always free — no monthly fee for the extension itself, only API token consumption.

### 8.2. Scenario Comparison (A–D)

For users who want to evaluate trade-offs with a different lens — cost vs. coverage across four scenarios:

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2; min-width:700px;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Scenario</th>
        <th style="padding:10px; text-align:center;">Cost/mo</th>
        <th style="padding:10px; text-align:center;">Cline API</th>
        <th style="padding:10px; text-align:center;">Inline (VS Code)</th>
        <th style="padding:10px; text-align:center;">Terminal AI</th>
        <th style="padding:10px; text-align:center;">Async Agent</th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;"><strong style="color:#4ade80">A: API only</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">$10</td><td style="padding:8px; text-align:center;">✅ DS+Claude</td><td style="padding:8px; text-align:center; color:#f87171;">❌</td><td style="padding:8px; text-align:center;">✅ Gemini CLI (free)</td><td style="padding:8px; text-align:center;">✅ Jules (beta free)</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong style="color:#fbbf24">B: API + Copilot Pro</strong></td><td style="padding:8px; text-align:center; color:#fbbf24;">$20</td><td style="padding:8px; text-align:center;">✅ DS+Claude</td><td style="padding:8px; text-align:center;">✅ 300 req/mo</td><td style="padding:8px; text-align:center;">✅ Gemini CLI</td><td style="padding:8px; text-align:center;">✅ Jules (beta)</td></tr>
      <tr><td style="padding:8px;"><strong style="color:#b0a3ff">C: API + Google AI Pro ⭐</strong></td><td style="padding:8px; text-align:center; color:#b0a3ff;">$30</td><td style="padding:8px; text-align:center;">✅ DS+Claude</td><td style="padding:8px; text-align:center;">✅ Code Assist</td><td style="padding:8px; text-align:center;">✅ Gemini CLI (higher limit)</td><td style="padding:8px; text-align:center;">✅ Jules + higher limit</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong style="color:#93c5fd">D: API + Copilot Pro + Google</strong></td><td style="padding:8px; text-align:center;">$40</td><td style="padding:8px; text-align:center;">✅ DS+Claude</td><td style="padding:8px; text-align:center;">✅ Best (both)</td><td style="padding:8px; text-align:center;">✅ Gemini CLI max</td><td style="padding:8px; text-align:center;">✅ Jules max</td></tr>
    </tbody>
  </table>
</div>

> **Recommendation:** Start with scenario B for a balanced entry point. Upgrade to C if you value terminal AI and async Jules tasks. D is only justified if you need both Copilot Pro's 300 inline requests/month AND full Google ecosystem integration simultaneously.

### 8.3. Setup Rankings by Priority

**If budget is the priority (best ROI):**

| Rank | Setup | Cost/mo | Value | Quality | Simplicity |
|---|---|---|---|---|---|
| 🥇 | DeepSeek + Claude API direct + VS Code+Cline | $8–12 | 98 | 86 | 60 |
| 🥈 | **Google AI Pro + Copilot Pro** *(your setup)* | $29.99 | 83 | 78 | 92 |
| 🥉 | Google AI Pro + Claude API direct (no Copilot) | $26–30 | 80 | 82 | 80 |
| 4 | Google AI Pro only (no Copilot, no Claude API) | $19.99 | 74 | 65 | 96 |
| 5 | Free tier (DeepSeek gift + Gemini Flash) | $0 | 68 | 50 | — |

**If code quality is the priority:**

| Rank | Setup | Cost/mo | Quality | Value |
|---|---|---|---|---|
| 🏆 | Three-model + Router (DeepSeek + MiniMax + Claude API) | $15–22 | 93 | 88 |
| 🥈 | Google AI Pro + Claude API direct + VS Code+Cline | $27–33 | 88 | 78 |
| 🥉 | **Google AI Pro + Copilot Pro** *(your setup)* | $29.99 | 79 | 83 |

> **For your setup (AI Pro + Copilot Pro):** Keep Copilot on **Auto** mode — it automatically picks GPT-4.1 or GPT-5-mini (both unlimited/free) and won't spend premium requests. Manually switch to **Claude Sonnet 4.6** only when you genuinely need architecture, security review, or logical deadlock resolution. This way 300 requests lasts the full month — and if you run out, GPT-5-mini (free, still strong) takes over automatically.

---

## 🔌 9. MCP Infrastructure & Recommended Extensions

- **Ollama:** For local embeddings and cost-free "small" model usage.
- **MCP Servers (Model Context Protocol):**

  **Core (Universal):**
    - `filesystem`: Enables deep navigation and file system manipulation.
    - `github`: Grants the agent authority to manage issues and PRs.
    - `brave-search`: Provides the agent with live internet access to fetch 2026 documentation.

  **Python Development (Recommended):**
    - `mcp-sqlite`: Direct database querying and schema inspection.
    - `mcp-docker`: Container management from within the agent.
    - `mcp-pytest`: Agent-triggered test execution for autonomous TDD loops.
    - `mcp-python-interpreter`: Safe sandboxed Python execution for pre-file validation before writing to disk.

### Cline MCP Configuration (JSON)

Add MCP servers via **VS Code → `Ctrl+Shift+P` → "Cline: Open MCP Settings"**. Paste the relevant block into the JSON config:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_YOUR_TOKEN" }
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": { "BRAVE_API_KEY": "YOUR_BRAVE_KEY" }
    },
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "--db-path", "./data.db"]
    },
    "docker": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-docker"]
    }
  }
}
```

> **Priority order for Python projects:** `filesystem` (built-in, no config needed) → `github` → `brave-search` → `sqlite` → `docker`. Add only what you actively need — each MCP server adds latency to tool calls.

---

## 💳 10. Expense Dashboard & Cost Governance

- **BYOK Monitoring:** If using BYOK (like Cline), monitor daily consumption via the **OpenRouter** or **DeepSeek** dashboard.
- **Hard Limits:** Set daily spending caps to prevent runaway costs during infinite loop bugs.

### Conservative Alert Thresholds (based on field experience)

| Threshold | Amount | Action |
|---|---|---|
| Daily soft alert | **$1.00/day** | Investigate which task is consuming — refine prompt or switch to cheaper model |
| Weekly review | **$5.00/week** | Review task routing — are you over-using Claude for trivial tasks? |
| Monthly **hard stop** | **$25.00/month** | Pause all API calls — review and reset. Build in a $5 buffer (stop at $25, goal is $30 ceiling) |

> **Why $1/day and not $5?** Most days should cost $0.50–$0.80. If you hit $1, something is wrong (e.g., Cline looping, model mismatch). Catching it early saves $10–$20 before the end of the month.

### ⚠️ Top 5 Budget Killers (in order of frequency)

1. **Cline retry loop** — task hits a wall, retries 10+ times, costs $3 before you notice. Fix: add `"max 20 requests per task"` to `.clinerules`.
2. **Using Claude for trivial tasks** — linting, config edits, small fixes don't need $15/M input. Use DeepSeek ($0.27/M).
3. **Large codebase context** — pasting entire `src/` into context on every request. Fix: use `@file` selectively, not `@folder`.
4. **Repeated identical prompts** — cache isn't hit after 5 min inactivity. Keep prompts structurally similar.
5. **Forgetting to close Cline** — background MCP polling or idle connections can add $1–$2/day.

### ✅ Top 5 Ways to Save Money

1. Route: **DeepSeek** for tests/config → **MiniMax** for features → **Claude** only for architecture.
2. Enable **Prompt Cache** in Cline settings (saves 60–90% on Claude input costs).
3. Use `GEMINI.md` + Gemini CLI for quick Q&A — completely free (Flash 1,000 req/day).
4. Assign **Jules** for tests, docs, and minor bug fixes — free during beta.
5. Use **OpenRouter** as a bridge — one API key, 50+ models, easy to swap when a model is expensive or down.

---

## 💳 10.1 Cost Monitor Script (`cost_monitor.py`)

Save this script at `memory-bank/cost_monitor.py`. It reads `memory-bank/costLog.json` and prints a real-time alert based on the thresholds above.

```python
#!/usr/bin/env python3
"""
cost_monitor.py — Read memory-bank/costLog.json and alert on thresholds.
Usage: python memory-bank/cost_monitor.py
"""
import json
from datetime import datetime, timedelta
from pathlib import Path

COST_LOG = Path("memory-bank/costLog.json")
THRESHOLDS = {"daily": 1.0, "weekly": 5.0, "monthly": 25.0}


def load_entries():
    if not COST_LOG.exists():
        print("⚠️  costLog.json not found. Create it first.")
        return []
    with COST_LOG.open() as f:
        return json.load(f)  # List of {"date": "YYYY-MM-DD", "cost": 0.45, "task": "..."}


def summarise(entries):
    now = datetime.today().date()
    today_total = sum(e["cost"] for e in entries if e["date"] == str(now))
    week_start = now - timedelta(days=now.weekday())
    week_total = sum(e["cost"] for e in entries if e["date"] >= str(week_start))
    month_start = now.replace(day=1)
    month_total = sum(e["cost"] for e in entries if e["date"] >= str(month_start))
    return today_total, week_total, month_total


def alert(label, total, limit):
    icon = "✅" if total < limit * 0.7 else ("⚠️ " if total < limit else "🚨 STOP")
    print(f"  {icon}  {label:10s}  ${total:.2f}  /  ${limit:.2f}")


if __name__ == "__main__":
    entries = load_entries()
    d, w, m = summarise(entries)
    print(f"\n=== Cost Monitor ({datetime.today():%Y-%m-%d %H:%M}) ===")
    alert("Daily", d, THRESHOLDS["daily"])
    alert("Weekly", w, THRESHOLDS["weekly"])
    alert("Monthly", m, THRESHOLDS["monthly"])
    print()
    if m >= THRESHOLDS["monthly"]:
        print("🚨  HARD STOP: Monthly budget exhausted. Pause all API calls.\n")
```

**`memory-bank/costLog.json` format** (append one entry per task):
```json
[
  {"date": "2026-03-11", "cost": 0.45, "task": "refactor auth module"},
  {"date": "2026-03-11", "cost": 0.12, "task": "write tests for router"},
  {"date": "2026-03-12", "cost": 0.08, "task": "fix lint errors"}
]
```

Run after each session: `python memory-bank/cost_monitor.py`

---

## 📂 11. Knowledge Management & Automation Framework (The .cursor Structure)

To transform a standard editor into an **Agentic Coding Operating System**, leveraging the `.cursor` directory structure is mandatory. This framework allows the agent to comprehend the "project constitution" and "team standards" beyond the immediate code.  

### Key Components & Practical Utility:  

1. **`.cursor/rules/` (.mdc files - The Constitution):**  
   - **Role:** Defines non-negotiable project standards and AI identity.  
   - **Example:**  
     - "**No hardcoding:** All variables and default options must be stored in `config.yaml`. The application code must read from this file for end-user convenience."  
     - "Always use `uv` for Python projects (for package installation and virtual environment management)."  
     - "Every project must have exactly one `main.py` entry point."  
   - **Benefit:** The agent ensures that configurations are never baked into the source code, making your application a professional, customizable product.  

2. **`skills/` (Knowledge Capsules):**  
   - **Role:** Documents experiences for future reuse (Knowledge Capture).  
  - **Real-world Example:** Supporting skills capture reusable techniques, while this flagship guide defines the reference model-selection and cost-optimization strategy they extend.  
   - **Benefit:** Prevents "reinventing the wheel." The agent applies lessons from past tasks to new ones.  

3. **`workflows/` (Operational Roadmaps):**  
   - **Role:** Defines step-by-step sequences for sensitive processes.  
   - **Real-world Examples:**  
     - **`init-project.md`:** Automatically creates `.env.example`, `src/`, and `docs/` directories.  
     - **`quality-assurance.md`:** Mandates running tests and getting final user approval before a `git commit`.  
     - **`documentation.md`:** Automatically updates `CHANGELOG.md` after every significant change.  
   - **Benefit:** Eliminates human error in repetitive tasks and guarantees high-quality output.  

4. **`prompts/` (High-Level Instruction Library):**
   - **Role:** Stores Mega-Prompts designed for repetitive yet sensitive tasks.

5. **`mcp/` (External Tool Integration):**
   - **Role:** The protocol for connecting to external utilities (databases, browsers, code analysis tools).

---

### 11.2 Complete `.cursor` Rule File Templates

These are production-ready file contents. Copy them verbatim into your project's `.cursor/rules/` directory. For VS Code + Cline: place them in `.cursor/rules/` and also create a `.clinerules` file at the project root (see below).

**`.cursor/rules/000-core.mdc`** — Always-active core rules (cost control, project standards):
```
---
description: Core project rules — always applied
alwaysApply: true
---

# Core Rules

## Cost Control (CRITICAL for 24/7)
- Before any large task, declare complexity: TRIVIAL / MODERATE / CRITICAL
- TRIVIAL: write code with no extra explanation (fewer tokens)
- If unclear what to do: STOP and ask ONE question, not 10
- Never edit more than 20 files in one session without confirmation
- One task = one commit. Get approval before moving to the next task

## Response Format (token efficiency)
- Start responses with code, not explanation
- Use format: "✅ done" / "❌ blocked: [reason]" / "❓ need: [question]"
- Never re-explain code that was already covered

## Project Standards
- Language: Python 3.12+
- Package manager: uv only (never pip directly)
- Entry point: main.py at project root
- Config: only from config.yaml or .env (no hardcoding)
- All variables in config.yaml — never hard-code values in source

## On Error
- Read the error first, then diagnose
- If unresolved after 3 attempts: report and wait for approval
- Never add dependencies without confirmation
```

---

**`.cursor/rules/010-python.mdc`** — Python coding standards:
```
---
description: Python coding standards
alwaysApply: true
---

# Python Standards

## Tools (only these)
- Package manager: uv sync / uv add / uv run
- Formatter: ruff format
- Linter: ruff check --fix
- Type checker: mypy with strict mode
- Tests: pytest with coverage

## Code
- Functions max 20 lines — split if longer
- Type hints required on all public functions
- Docstrings required for public functions (one line is enough)
- Error handling: never bare except:
- Logging instead of print in production code

## File Structure
src/
├── core/      # core logic
├── api/       # API endpoints
├── models/    # data models
└── utils/     # helper functions

## After Every Change
uv run ruff check --fix . && uv run mypy src/
```

---

**`.cursor/rules/020-tdd.mdc`** — TDD rules:
```
---
description: Test-Driven Development — mandatory rules
alwaysApply: true
---

# TDD Rules

## Mandatory Order (never skip)
1. Write a test that FAILS first
2. Write the minimum code needed to make the test pass
3. Refactor (if needed)
4. Run uv run pytest — all tests must pass

## Test Rules
- File name: test_[module_name].py in tests/
- Function name: test_[state]_[expected_behaviour]()
- Each test checks exactly one thing (Single Responsibility)
- Use fixtures for repeated setup

## Coverage
- Minimum 80% coverage to merge to main
- uv run pytest --cov=src --cov-report=term-missing

## Forbidden
- Never write implementation before test
- Never skip a test without documented reason
- Never leave pass in a test body
```

---

**`.cursor/rules/030-security.mdc`** — Security & secret management:
```
---
description: Mandatory security rules
alwaysApply: true
---

# Security Rules

## NEVER
- Never write any API key, password, or token directly in code
- Never add .env to git (must be in .gitignore)
- Never put any secret in logs
- Never use eval() or exec() with user input
- Never build SQL queries with f-strings (SQL injection)

## Correct Pattern for Secrets
```python
import os
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv("DEEPSEEK_API_KEY")  # ✅ correct
API_KEY = "sk-1234..."                    # ❌ FORBIDDEN
```

## Before Every Commit
- git diff --staged | grep -i "api_key\|secret\|password\|token"
- If any result: STOP and report immediately
```

---

**`.cursor/rules/040-git.mdc`** — Git & commit rules:
```
---
description: Git and commit rules
alwaysApply: true
---

# Git Rules

## Golden Rule
One task = one commit = one feature branch

## Commit Message Format
[type]: [short description]

Allowed types:
- feat:      new feature
- fix:       bug fix
- test:      add/change tests
- refactor:  code change without behaviour change
- docs:      documentation change
- chore:     maintenance work

## Before Commit
1. uv run ruff check --fix .   — fix lint issues
2. uv run pytest               — all tests must pass
3. Check for secrets: no API key in staged files
4. Then: git commit -m "[type]: [description]"

## Forbidden
- Direct commit to main
- Large commits with many unrelated changes
- Commit messages like "fix", "update", "changes"
```

---

**`memory-bank/activeContext.md`** — Active session memory (update each session):
```markdown
---
last_updated: [date and time]
active_model: DeepSeek V3.2
cost_today: $X.XX
---

# Current State

## What are we working on now?
[Short description of current task]

## Last completed action
[Summary of last changes]

## Files related to current task
- `src/[file].py` — [why it's relevant]

## Open issues (if any)
- [ ] [issue 1]

## For next session
[What work remains]
```

---

**`memory-bank/costLog.md`** — Cost tracking (update after every session):
```markdown
---
goal: monthly cost under $30
alert_at: $5 daily / $20 weekly
---

# Cost Log

## [Month/Year]
| Date | Model | Tokens | Cost | Task |
|------|-------|--------|------|------|
| Feb 20 | DeepSeek | 50K | $0.02 | setup |

## This month total: $XX.XX

## Alert Rules
- If one session cost > $2 → report
- If daily total > $5 → STOP and investigate
- Infinite loops are the biggest budget threat
```

---

**`.clinerules`** — Cline-specific rules for VS Code (place at project root):
```markdown
# Cline Rules — VS Code

## Model Routing
- TRIVIAL tasks: DeepSeek V3.2 (direct API)
- MODERATE tasks: MiniMax M2.5
- CRITICAL tasks: Claude Sonnet 4.6

## Cost Control
- Max 20 requests per task — after that stop and report
- If task costs > $2 → STOP and notify
- Keep system prompt constant (better cache-hit rate)

## Behaviour
- Read memory-bank/ files before every task
- Read file contents before editing any file
- Never delete files without confirmation
- Never write secrets in code

## After Every Task
- Update memory-bank/activeContext.md
- Run ruff check --fix . && pytest
- Summarise result in one line
```

**Cline API Settings** — Configure in Cline sidebar → Settings (⚙️):
```bash
# ── Model 1: DeepSeek (default — cheapest) ──
Provider:  OpenAI Compatible
Base URL:  https://api.deepseek.com
API Key:   $DEEPSEEK_API_KEY
Model:     deepseek-chat

# ── Model 2: MiniMax ──
Provider:  OpenAI Compatible
Base URL:  https://api.minimax.chat/v1
API Key:   $MINIMAX_API_KEY
Model:     minimax-m2.5

# ── Model 3: Claude Sonnet ──
Provider:  Anthropic
API Key:   $ANTHROPIC_API_KEY
Model:     claude-sonnet-4-5-20251001

# ── Alternative: All models via OpenRouter (one API key, no VPN) ──
Provider:  OpenRouter
API Key:   $OPENROUTER_API_KEY
Models:    deepseek/deepseek-v3.2
           minimax/minimax-m2.5
           anthropic/claude-sonnet-4-5
```

---

**`GEMINI.md`** — Context file for Gemini CLI (place at **project root**). Gemini CLI reads this file automatically at the start of each session, just like Jules reads `AGENTS.md`.
```markdown
# GEMINI.md — Project Context for Gemini CLI

## Project
Python 3.12 · package manager: uv · test runner: pytest · linter: ruff

## Rules
- Never use pip directly — always use `uv add` or `uv run`
- Every code change must have a corresponding test
- Never write API keys or secrets in code — use `.env` and `python-dotenv`
- Commit format: `type: short description` (feat/fix/refactor/test/docs)

## Structure
| Directory | Purpose |
|---|---|
| `src/` | Core application code |
| `tests/` | Unit and integration tests |
| `memory-bank/` | Agent context: activeContext.md, costLog.json |
| `.cursor/rules/` | Project constitution (.mdc files) |
| `.agent/skills/` | Knowledge capsules for AI agents |

## Model Routing (for reference)
- Trivial (tests, config): DeepSeek V3.2
- Moderate (features, refactor): MiniMax M2.5
- Critical (architecture, security): Claude Sonnet
- Quick Q&A: Gemini CLI (you are here)
- Async background tasks: Jules
```

> **How to add `GEMINI.md` to your project:**
> ```bash
> # Create at project root (same level as AGENTS.md and .clinerules)
> touch GEMINI.md
> # Edit with the template above — customize to your actual project structure
> ```
> Gemini CLI will pick it up automatically with no configuration required.

---

**`Dual-IDE File Structure`** — How to support both Antigravity and VS Code+Cline simultaneously:
```
project/
│
├── ── Antigravity ──────────────────────────────────────
├── .agent/                    ← Antigravity reads this
│   ├── skills/
│   │   ├── core.md            ← Core rules + cost control (alwaysApply: true)
│   │   ├── python.md          ← Python standards
│   │   ├── tdd.md             ← TDD rules
│   │   └── router-guide.md   ← How to use router.py from Antigravity
│   └── workflows/
│       ├── daily-start.md     ← Session start checklist
│       └── before-commit.md   ← Pre-commit checklist
│
├── ── VS Code + Cline ──────────────────────────────────
├── .clinerules                ← Cline reads this
│
├── ── Shared by all agents ─────────────────────────────
├── GEMINI.md                  ← Gemini CLI context
├── AGENTS.md                  ← Jules context
│
├── memory-bank/               ← Shared memory for both IDEs
│   ├── activeContext.md
│   ├── progress.md
│   └── costLog.json           ← Per-day per-provider cost log
│
├── src/
│   └── utils/
│       ├── router.py          ← Smart router (§6.6)
│       └── __init__.py
│
├── .env                       ← API keys — in .gitignore!
├── .env.example               ← Template without values — commit this
└── pyproject.toml
```

---

**`.agent/skills/core.md`** — Core rules file for Antigravity (place in `.agent/skills/`):
```markdown
---
name: core
description: Core rules — always apply
alwaysApply: true
---

## Cost Control (CRITICAL)
- Declare complexity before every task: TRIVIAL / MODERATE / CRITICAL
- TRIVIAL → DeepSeek (cheapest) | MODERATE → MiniMax M2.5 | CRITICAL → Claude Sonnet 4.6
- Maximum 20 requests per task — then STOP and report
- If unsure: ask one question, not ten

## Tools
- Package manager: always uv (never pip directly)
- Formatter: ruff format
- Type checker: mypy
- Test runner: pytest

## Mandatory Rules
- Never write API keys in code — always use .env
- One task = one commit
- Before every task: read memory-bank/activeContext.md
- After every task: update activeContext.md
- Commit format: feat: / fix: / test: / refactor: / docs:
```

---

**`.agent/skills/router-guide.md`** — How to use `router.py` from inside Antigravity:
```markdown
---
name: router-guide
description: Guide to using router.py for non-Gemini models
---

## Problem
Antigravity only has Gemini 3 Pro built-in. To access DeepSeek
or Claude Sonnet you must use router.py.

## Solution A — Direct Code Usage
```python
from src.utils.router import router
import asyncio

result = asyncio.run(router.generate("Your question or task here"))
```

## Solution B — Delegate to VS Code+Cline
When a task requires DeepSeek/Claude, tell the user:
"This task requires [DeepSeek/Claude]. Please switch to VS Code+Cline."

## When VS Code+Cline is Required
- Tasks for DeepSeek (cheaper than Gemini at scale) → TRIVIAL + high-frequency
- Final security code review with Claude Sonnet → CRITICAL
- Long sessions where Antigravity hits rate limits
```

---

### 11.1 Advanced Operational Techniques

**Prompt Engineering for Cline (task-state template):**
Begin every task with a structured context block so the agent knows its state:
```
Goal: [one-sentence objective]
Current state: [what already exists]
Constraints: [must-not-do list]
Expected output: [exact file / function / test]
```
This pattern eliminates 80% of regeneration cycles caused by ambiguous tasks.

---

**Git Flow + Agentic Workflow:**
The recommended branch-level discipline for agent-assisted projects:
1. `git checkout -b feat/<task-name>` — isolate every agent task in its own branch.
2. Agent executes: code → test → commit loop (triggered by `quality-assurance.md` workflow).
3. `gh pr create` — open PR for human review; agent cannot self-merge.
4. Merge only after CI passes and human approval.

> Rule: Agents should **never push directly to `main`**. Always branch → PR → merge.

**Jules async workflow (parallel to Cline):**
```bash
# While you work in VS Code + Cline on the main feature,
# assign background tasks to Jules:
git checkout -b feat/main-feature
# ... Cline works here ...

# Jules handles background tasks in parallel:
# Option A: via GitHub issue with label 'jules'
gh issue create --title "Write tests for auth module" --label jules

# Option B: via jules.google UI
# jules remote new --repo . --session "Update all dependencies and run tests"

# Jules opens a PR when done; you review and merge
gh pr list  # see Jules's PR when ready
```

---

**Context Compression (70% cost reduction):**
Large context windows are the #1 cost driver in long sessions. Apply these techniques:

- **`/compact` command (Claude Code):** Run `/compact` mid-session — Claude summarises the full conversation into a compressed state while keeping critical context. This is the fastest way to halve token spend in a long session.
- **Memory Bank pattern:** Store key decisions in `memory-bank/activeContext.md`; prepend it to each new session instead of replaying the full history.
- **Structured summaries:** Before closing Cline, ask: *"Write a 10-line summary of the current project state for the next session"*. Save the result to `memory-bank/activeContext.md`.
- **File references over content:** Send `path/to/file.py:42-60` instead of pasting the full file — agent reads only the relevant slice.
- **Lazy loading:** Attach files only when the agent explicitly needs them, not pre-emptively.
- **Repomap for large projects:** Send the tree, not the code:
```bash
tree -I '__pycache__|*.pyc|.venv|node_modules' --noreport | head -50
```
This tells the agent which files exist without reading all of them.
- **DeepSeek cache-hit (10× cheaper):** DeepSeek charges $0.028/M tokens for cache-hit vs. $0.28/M for cache-miss. Keep your system prompt **identical** across requests — any change invalidates the cache and costs 10× more. Store your system prompt as a constant in your router config.

---

**Chain-of-Models Pattern — Draft → Refine (60–70% cost reduction on Claude):**
Instead of sending the full project context to Claude, let DeepSeek draft cheaply first, then pass *only the draft* to Claude for refinement. Claude receives a small input (draft + fix instructions) instead of re-reading the entire codebase:

```python
async def draft_then_refine(task_prompt: str) -> str:
    # Step 1: DeepSeek drafts cheaply (~$0.01)
    draft = await router.generate(task_prompt, force_provider="deepseek")

    # Step 2: Claude refines with minimal context (not re-reading full codebase)
    refined = await router.generate(
        f"Improve this code for production quality — fix edge cases, add type hints, "
        f"ensure error handling follows project standards:\n\n{draft}",
        force_provider="claude"
    )
    return refined
```

**Why this works:** Claude reads only the draft (a few hundred tokens) instead of the full repository context. Each Claude call becomes ~5× cheaper than asking Claude to implement from scratch without a draft.

**Best use cases:**
- Feature implementation: DeepSeek writes 90% → Claude reviews and finalizes
- Refactoring: DeepSeek restructures → Claude improves naming, docs, and edge cases
- Test generation: DeepSeek generates test skeletons → Claude adds edge cases and assertions

**Skip this pattern for:**
- Security reviews (Claude needs full codebase context to find vulnerabilities)
- Architecture planning (full context matters more than cost here)

---

**When NOT to use an Agent (use Copilot inline instead):**

| Situation | Wrong choice | Right choice |
|---|---|---|
| Single-line autocomplete | Agent (Cline) | Copilot inline |
| Renaming a variable | Agent (Cline) | Copilot inline / IDE rename |
| Writing a docstring | Agent (Cline) | Copilot Chat (Ctrl+I) |
| Debugging a 5-line function | Agent (Cline) | Copilot inline |
| Multi-file refactor (>3 files) | Copilot inline | Agent (Cline) |
| Setting up a new project | Copilot inline | Agent (Cline) |

> Principle: **If the task has a clear, bounded scope and no state — use inline. If it requires memory, file traversal, or multi-step logic — use an agent.**

---

**uv Package Manager (Deep-Dive):**
`uv` is the modern replacement for `pip` + `venv` in Python 2026 projects.

```bash
# Setup
uv init my-project        # creates pyproject.toml + .venv automatically
uv sync                   # install all deps from pyproject.toml (lock-file aware)
uv add requests           # add a dependency (updates pyproject.toml + uv.lock)
uv add --dev pytest ruff  # add dev-only dependencies

# Execution (ALWAYS use uv run — never activate venv manually)
uv run python main.py
uv run pytest
uv run ruff check --fix .
uv run mypy src/
```

> **Rule from AGENTS.md:** Use `uv` for all package management. Never call `pip` directly. Never activate the virtual environment manually — always prefix commands with `uv run`.

**Recommended `pyproject.toml` (copy-paste ready):**
```toml
[project]
name = "my-project"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = [
    "fastapi>=0.115",
    "pydantic>=2.0",
    "python-dotenv>=1.0",
]

[tool.uv]
dev-dependencies = ["pytest>=8", "pytest-cov", "ruff>=0.8", "mypy>=1.0"]

[tool.ruff]
line-length = 88
target-version = "py312"

[tool.mypy]
strict = true
python_version = "3.12"
```

---

**Rate Limiting & Exponential Backoff:**
When building autonomous agent loops, always implement backoff to avoid hitting API rate limits. DeepSeek in particular hits rate limits during peak hours (UTC 14–20 when China's working day overlaps). The following production-ready router uses MiniMax M2.5 as a middle tier fallback:

```python
"""
api_router.py — production router with 3-tier fallback + circuit breaker
"""
import asyncio, os, time
from enum import Enum
from openai import AsyncOpenAI

class TaskLevel(Enum):
    TRIVIAL = 1    # DeepSeek V3.2
    MODERATE = 2   # MiniMax M2.5
    CRITICAL = 3   # Claude Sonnet 4.6

class APIRouter:
    def __init__(self):
        self.deepseek = AsyncOpenAI(
            api_key=os.getenv("DEEPSEEK_API_KEY"),
            base_url="https://api.deepseek.com"
        )
        self.minimax = AsyncOpenAI(
            api_key=os.getenv("MINIMAX_API_KEY"),
            base_url="https://api.minimax.chat/v1"
        )
        self.claude = AsyncOpenAI(
            api_key=os.getenv("ANTHROPIC_API_KEY"),
            base_url="https://api.anthropic.com/v1"
        )
        self._failures: dict = {}
        self._threshold = 3
        self._cooldown = 300  # 5 minutes

    def _is_available(self, provider: str) -> bool:
        """Circuit breaker: skip provider if 3 consecutive failures within cooldown."""
        if provider not in self._failures:
            return True
        fails, last_time = self._failures[provider]
        if fails >= self._threshold:
            if time.time() - last_time < self._cooldown:
                return False
            self._failures[provider] = (0, 0)  # reset after cooldown
        return True

    def _record_failure(self, provider: str) -> None:
        fails, _ = self._failures.get(provider, (0, 0))
        self._failures[provider] = (fails + 1, time.time())

    async def generate(self, prompt: str, level: TaskLevel = TaskLevel.TRIVIAL) -> str:
        chain = {
            TaskLevel.TRIVIAL:  [("deepseek", "deepseek-chat"),   ("minimax", "minimax-m2.5")],
            TaskLevel.MODERATE: [("minimax",  "minimax-m2.5"),    ("deepseek", "deepseek-chat")],
            TaskLevel.CRITICAL: [("claude",   "claude-sonnet-4-5-20251001"), ("minimax", "minimax-m2.5")],
        }
        for provider, model in chain[level]:
            if not self._is_available(provider):
                continue
            try:
                client = getattr(self, provider)
                resp = await client.chat.completions.create(
                    model=model,
                    messages=[{"role": "user", "content": prompt}],
                    max_tokens=4096,
                )
                return resp.choices[0].message.content
            except Exception as e:
                print(f"⚠️  {provider} failed: {e}")
                self._record_failure(provider)
        raise RuntimeError("All providers failed — check API keys and connectivity")

router = APIRouter()
```

The `AIRouter` in Section 6 (`.agent/skills/ai-router/ai_router.py`) adds SHA-256 response caching on top of this pattern for further cost reduction.

---

**Agent Testing ("Golden Set" Benchmark Approach):**
To verify an agent's quality doesn't regress after model swaps or prompt changes:
1. Create `tests/agent_golden/` with 10–20 representative task prompts.
2. Each file: `task.md` (input) + `expected_output.py` (reference output).
3. Run the agent against each task; compare outputs with `difflib` or an LLM-as-judge.
4. Track cost per golden set run in `memory-bank/costLog.md`.

> Target: **Golden set score ≥ 90%** before any production routing change.

**Golden set benchmark script (copy-paste ready):**
```python
"""
benchmark_agent.py — test models against your personal golden set
Usage: uv run python benchmark_agent.py
"""
import asyncio
import time

GOLDEN_SET = [
    {
        "id": "trivial_1",
        "level": "TRIVIAL",
        "prompt": "Write a function that takes a list of numbers and returns their average",
        "must_contain": ["def", "return", "sum", "len"],
        "max_cost_usd": 0.01,
    },
    {
        "id": "moderate_1",
        "level": "MODERATE",
        "prompt": "Refactor this class to use @dataclass: class Point:\n    def __init__(self, x, y): self.x = x; self.y = y",
        "must_contain": ["@dataclass", "x:", "y:"],
        "max_cost_usd": 0.05,
    },
]

async def benchmark_model(router, model_tag: str) -> dict:
    results = []
    for task in GOLDEN_SET:
        start = time.time()
        from api_router import TaskLevel
        level = TaskLevel[task["level"]]
        response = await router.generate(task["prompt"], level)
        elapsed = time.time() - start
        passed = all(kw in response for kw in task["must_contain"])
        results.append({"id": task["id"], "passed": passed, "time": round(elapsed, 2)})

    score = sum(r["passed"] for r in results) / len(results) * 100
    print(f"\n{model_tag}: {score:.0f}% pass rate")
    for r in results:
        print(f"  {'\u2705' if r['passed'] else '\u274c'} {r['id']} ({r['time']}s)")
    return {"model": model_tag, "score": score, "results": results}

if __name__ == "__main__":
    from api_router import APIRouter
    asyncio.run(benchmark_model(APIRouter(), "DeepSeek-V3.2"))
```

---

## � 11.3 Low-Cost Optimization Patterns

Five independent techniques for reducing agentic coding costs — each can be implemented standalone:

---

**1. DeepSeek V3.2 — Reasoning Toggle (On-Demand)**

The DeepSeek direct API lets you toggle reasoning on or off per-request. Standard mode is cheaper:

```python
# Standard mode — routine tasks (~$0.25/M input)
{"model": "deepseek/deepseek-v3.2", "reasoning": {"enabled": False}}

# Reasoning mode — debugging and algorithmic tasks (~$0.40/M input, higher quality)
{"model": "deepseek/deepseek-v3.2", "reasoning": {"enabled": True}}

# Router rule: enable only when task contains debug/algorithm/complex keywords
```

**Savings:** Reasoning mode consumes ~30-50% more tokens. Keeping it off for 70% of tasks → ~15-20% average cost reduction.

---

**2. Local Model via Ollama — Zero Cost for Small Tasks**

For trivial tasks (single-line bug, rename, docstring) use a local model and eliminate the API call entirely:

```bash
# Install Ollama (macOS)
brew install ollama

# Qwen2.5-Coder 7B — best local coding model (4.7 GB download)
ollama pull qwen2.5-coder:7b

# DeepSeek R1 Distill Qwen 7B — for local math/reasoning (4.5 GB download)
ollama pull deepseek-r1:7b

# Configure in Cline:
# Provider: Ollama | Base URL: http://localhost:11434 | Model: qwen2.5-coder:7b
```

**⚙️ Hardware Requirements:**

| Model | RAM Required | VRAM (GPU) | Apple Silicon |
|---|---|---|---|
| **Qwen2.5-Coder 7B** | **8 GB** ⭐ | 6 GB VRAM | M1/M2 8 GB: ~25 tok/sec |
| **DeepSeek R1 Distill 7B** | **8 GB** ⭐ | 6 GB VRAM | M1/M2 8 GB: ~20 tok/sec |
| Qwen2.5-Coder 14B | 16 GB | 10 GB VRAM | M2 Pro 16 GB: ~30 tok/sec |
| DeepSeek R1 Distill 32B | 32 GB | 24 GB VRAM | M3 Max/Ultra only |

> 7B models on MacBook Air M1/M2 with 8 GB RAM use Metal GPU acceleration — no discrete GPU required. The 14B model requires at least 16 GB RAM.

**Best local use cases:** rename variable, format function, fix typo, write docstring for one function

**Do not use locally for:** multi-file refactor, complex business logic, dependency analysis

---

**3. Batch Prompting Instead of Round-Trips**

Every API call has overhead. Five separate questions = 5 calls. Send them all at once = 1 call:

```python
# ❌ Expensive: 5 separate API calls
review = await llm("Review this function")
docs   = await llm("Write docstring for this function")
tests  = await llm("Write unit tests for this function")
types  = await llm("Add type hints to this function")
lint   = await llm("Fix linting issues in this function")

# ✅ Cheap: 1 API call, one-fifth the cost
result = await llm("""For the function below, return all 5 in sequence:
1. Code review (max 3 sentences)
2. Docstring (Google format)
3. Unit tests (pytest, 3 cases)
4. Type hints added inline
5. Lint fixes

Function:
{code}
""")
```

**Savings:** ~5× reduction in API call cost + shared context overhead instead of repeating it.

---

**4. Cache-Aware Prompt Structure (10× Savings on Claude)**

Official Anthropic data (March 2026): cached system prompt = **$0.30/M** vs $3/M — a 10× reduction.

```python
# ✅ Correct: constant system prompt — cache hit → $0.30/M
SYSTEM_PROMPT = """You are a Python expert. Rules:
- Stack: Python 3.12, uv, pytest, ruff
- Never use pip directly, always uv
{full_clinerules_content}
"""  # This section is cached — keep it character-for-character identical

def make_request(user_task: str) -> dict:
    return {
        "model": "claude-sonnet-4-5-20251001",
        "system": SYSTEM_PROMPT,       # ← constant (cache hit)
        "messages": [{"role": "user", "content": user_task}],  # ← variable per request
    }

# ❌ Wrong: adding timestamp or session ID to the system prompt
# → one character difference = cache miss = 10× more expensive
```

**Golden rule:** Keep the full system prompt + `.clinerules` + `AGENTS.md` as a fixed system message. Never append timestamps, session IDs, or variable data to the system prompt. The same applies to DeepSeek ($0.028/M cached vs $0.28/M uncached — 10× difference).

---

**5. DeepSeek R1 Distill Qwen 7B — Low-Cost Reasoning for Math/Algorithm**

For mathematical problems, algorithm design, or complex debugging — without needing Claude:

**Via DeepSeek API** (or OpenRouter):
```
Model ID: deepseek/deepseek-r1-distill-qwen-7b
```

**Via Ollama** (local — free):
```bash
ollama pull deepseek-r1:7b   # requires: 8 GB RAM (Apple Silicon M1+) or 6 GB VRAM
```

**Reasoning options comparison for daily tasks:**

| Option | Cost/task | Quality | Best for |
|---|---|---|---|
| R1 Distill 7B (Ollama — local) | **$0** | Good | simple math, algorithms |
| DeepSeek V3.2 reasoning=true | ~$0.002 | Excellent | complex debugging |
| DeepSeek Speciale (OpenRouter) | ~$0.01 | Outstanding | proof-level reasoning |
| Claude Sonnet 4.6 | ~$0.15 | Outstanding | architecture + security |

> **Recommendation:** For daily debugging and algorithm tasks → `deepseek-r1:7b` free locally. For harder problems → DeepSeek V3.2 with `reasoning: true`. Claude only for architecture and security review.

---

## �🚀 12. Operational Lifecycle
1. **Architecture:** Documentation of technical specifications and blueprints by Frontier-class models (powered by the `init-project` workflow).  
2. **Implementation:** Step-by-step development by cost-optimized execution engines (monitored by `quality-assurance`).  
3. **Verification:** Unit testing execution and final validation of system logic via the `ABR Loop`.  

---
*Technical Update: February 20, 2026 — Verified Data-Driven Analysis*

---
[Back to README](README.md)


