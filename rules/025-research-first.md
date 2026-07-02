---
title: "025: Research-First — Verify Before You Write It Down"
description: Technical claims (model names, tool quality, licenses, API behavior) must be verified via router research before entering any design doc; evidence saved in the repo.
location: rules/025-research-first.md
agent_priority: High
last_updated: 2026-07-02
---

# Research-First — Verify Before You Write It Down

## Why

On 2026-07-02 the strongest available agent (Fable 5) wrote MusicGen and
Stable Audio Open into ChannelForge's architecture from memory. Router
research then showed both carry non-commercial licenses — adopting them for
a monetized channel would have been a license violation baked into the
design. If the strongest agent makes this mistake, every agent will.
Memory-only lessons don't transfer between agents; rules do.

## Rule (Non-Negotiable)

Before writing a specific model, library, tool, license claim, price, or
API behavior into **any design or architecture document**:

1. **Verify it** — do not trust your training data, and do not trust the
   user's claim alone either (they asked for this check). Use the router
   for current-knowledge research:

   ```bash
   cd ~/.local/share/agent-projects/_router
   python3 delegate.py --model grok --out research.md -p "<question>"
   ```

   Grok = current-knowledge/search role; DeepSeek = code; per
   `ai-router/COST-SAVING-PLAYBOOK.md`. A query costs ~$0.003.

2. **Save the evidence in the repo** — `research/YYYY-MM-DD-<topic>.md`,
   committed alongside the doc change, and cite it from the doc.

3. **Treat the researcher's output as unverified too.** License and pricing
   claims must be confirmed against the primary source (the actual license
   text, the vendor's pricing page) before a decision depends on them.

## Scope

Applies to design docs, architecture files, ADRs, playbooks, and any file
another agent will treat as truth. It does not apply to scratch notes or
exploratory conversation — but the moment a claim graduates into a document,
it needs its evidence.
