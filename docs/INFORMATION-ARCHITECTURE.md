---
title: Information Architecture
description: Repository map showing how each major area relates to the flagship Agentic Coding guide.
location: docs/INFORMATION-ARCHITECTURE.md
last_updated: 2026-03-12
---

[Back to README](../README.md)

# Information Architecture

This repository now has a single flagship technical document:

- [AGENTIC-CODING-SETUP.md](../AGENTIC-CODING-SETUP.md)

That file is the canonical reference for the repository's agentic coding methodology, model economics, routing logic, and operational setup guidance.

## Structural Principle

Not every file is a subordinate appendix of the flagship guide, but every major area of the repository now has a clear relationship to it:

1. Some files introduce it.
2. Some files enforce it.
3. Some files extend it.
4. Some files localize it.
5. Some files operationalize it in reusable form.

## Repository Map

| Area | Role | Relationship to the flagship guide |
|---|---|---|
| [README.md](../README.md) | Entry point | Explains the project and directs readers to the flagship guide first |
| [AGENTIC-CODING-SETUP.md](../AGENTIC-CODING-SETUP.md) | Canonical technical document | Defines the main methodology, benchmarks, model choices, and cost strategy |
| [AGENTS.md](../AGENTS.md) | Agent execution contract | Converts repository philosophy into actionable runtime rules for coding agents |
| [README.fa.md](../README.fa.md) | Localized entry point | Persian-facing introduction to the same project |
| [fa](../fa) | Localized support layer | Persian mirrors, rules, workflows, and memory artifacts that complement the English core |
| [.agent/rules](../.agent/rules) | Normative rules | Encodes non-negotiable behavior and standards assumed by the flagship guide |
| [.agent/workflows](../.agent/workflows) | Process layer | Turns principles from the flagship guide into repeatable operating procedures |
| [.agent/skills](../.agent/skills) | Reusable knowledge modules | Extends the flagship guide with domain-specific capsules rather than replacing it |
| [.agent/prompts](../.agent/prompts) | Prompt assets | Provides reusable prompt templates that operationalize repository standards |
| [templates](../templates) | Distribution layer | Makes the architecture portable into new repositories and projects |
| [bin](../bin) | Automation layer | Scripts that scaffold, validate, or expose the repository as tooling |
| [docs](../docs) | Supplemental explanation | Supporting material, background references, and repository meta-documentation |
| [memory-bank](../memory-bank) | Operational memory | Tracks evolving context and cost history for ongoing work |
| [CHANGELOG.md](../CHANGELOG.md) | Historical record | Records how the flagship guide and its supporting system change over time |
| [CONTRIBUTING.md](../CONTRIBUTING.md) | Contribution policy | Tells contributors how to modify the repository without breaking the flagship architecture |

## Reading Order

1. Start with [README.md](../README.md).
2. Read [AGENTIC-CODING-SETUP.md](../AGENTIC-CODING-SETUP.md).
3. Read [AGENTS.md](../AGENTS.md) before asking an agent to execute changes.
4. Use `.agent/rules`, `.agent/workflows`, and `.agent/skills` as modular deep dives.
5. Use `templates/` and `bin/` when applying the system elsewhere.

## Governance Rule

When there is ambiguity between a marketing-style summary and the technical methodology of the repository, treat [AGENTIC-CODING-SETUP.md](../AGENTIC-CODING-SETUP.md) as the authoritative source for agentic coding strategy, and treat [AGENTS.md](../AGENTS.md) as the authoritative source for execution behavior.

---
[Back to README](../README.md)