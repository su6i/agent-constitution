---
title: Rule 080: Knowledge Capture & Transfer
description: Mandates the capture and structured transfer of agent judgment, strategies, and solutions into reusable skills or knowledge artifacts.
location: rules/080-knowledge-capture.md
agent_priority: CRITICAL
last_updated: 2026-07-20
---

Every session (especially MODERATE and CRITICAL complexity tasks) generates valuable judgment, problem-solving approaches, and strategic choices. This ephemeral knowledge must be captured and structured for reusability and transfer to other agents or future tasks. This rule complements `rules/000-core.md` §"No Knowledge Lost", defining the *how* and *when* of knowledge extraction.

<!-- digest:start -->

## 1. When to Capture

Knowledge capture is mandatory **before `SessionEnd`** for any session involving MODERATE or CRITICAL complexity tasks, or whenever a new, non-trivial problem-solving approach or strategic decision is developed. TRIVIAL tasks only require capture if a novel reusable pattern emerges.

## 2. What to Capture

Capture transferable judgment, decision trees, and a menu of approaches with their trade-offs, including a recommended default for our project profile. Focus on patterns related to:

- **Financial Data Analysis:** Strategies for market analysis, risk assessment, portfolio optimization, and data integration.
- **Content Automation:** Effective pipelines for generating and distributing content across platforms like YouTube, Telegram, and LinkedIn.
- **Multi-Agent Analytical Pipelines:** Architectures and coordination mechanisms for complex problem-solving involving multiple agents.
- **Reinforcement Learning (RL) for Finance:** Best practices, model selection, and deployment strategies for RL applications in financial contexts.
- **Dev/ML/LLM/AIOps Workflows:** Reusable patterns for development, machine learning, large language model integration, and AI-driven operations.

The capture should explain *why* certain approaches were chosen over others, detailing the decision criteria and observed outcomes.

## 3. Where to Capture (Skill Discovery Order)

Knowledge must be captured in the most reusable and discoverable format possible, following this order:

- **Existing Skill Enhancement:** If an existing skill (in `skills/`) partially addresses the knowledge, update and refine that skill.
- **Upstream Catalogs:** If no local skill fits, consult `.claude/skill-sources.md` for an upstream skill to adopt before authoring anything new.
- **New Skill Creation:** If the knowledge represents a novel, self-contained, and reusable capability, create a new skill file (`skills/<skill-name>.md`, flat layout) adhering to `rules/036-skill-versioning.md`.
- **Architecture Docs:** For broader strategic insights, architectural patterns, or complex decision flows that don't fit a single skill, document them in `docs/INFORMATION-ARCHITECTURE.md` or a new, appropriately named document under `docs/`.

## 4. Fail-Closed Gate: Knowledge Capture Report

TRIVIAL sessions are exempt from this field. For MODERATE and CRITICAL sessions, the `SessionEnd` digest **MUST** include a `knowledge-capture:` field detailing:

- `status`: `COMPLETED` / `PARTIAL` / `N/A` (no reusable knowledge emerged).
- `summary`: A concise description of the captured knowledge.
- `artifacts`: A list of paths to updated or newly created skill files or documentation.
- `reason_for_partial/NA`: If status is `PARTIAL` or `N/A`.

Failure to include this field, or an incomplete report for MODERATE/CRITICAL sessions, will trigger a review gate failure and require remediation.
<!-- digest:end -->
