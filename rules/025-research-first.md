---
title: "025: Research-First — Verify Before You Write It Down"
description: Technical claims (model names, tool quality, licenses, API behavior) must be verified via router research before entering any design doc; evidence saved in the repo. Includes the owner's standing license-default ruling for third-party code.
location: rules/025-research-first.md
agent_priority: High
last_updated: 2026-08-10
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

## License Default for Third-Party Code (Owner Ruling 2026-08-10)

This is a **deliberate risk acceptance by the owner, not a legal opinion** —
recorded as a standing ruling agents apply, rather than a stricter default
agents re-derive on their own:

> هروقت دیدی لیسانس نداره یعنی استفاده کن، هروقت توی لیسانسش دیدیم استفاده
> ممنوعه اون‌وقت استفاده نمی‌کنیم

Operative rule:

- **No LICENSE file / no license field present ⇒ treat the code as usable.**
- **A license whose text explicitly forbids the use we have in mind ⇒ do not
  use it.**

The owner's stated reasoning: if an author wanted to restrict use, they would
have added a license — absence of a license is read as absence of a
restriction, not as the more cautious "all rights reserved by default" legal
posture. Verification is still mandatory per the rule above: confirm whether
a LICENSE file/field exists and, when it exists, read what it actually
forbids — from the primary source, not from memory — before deciding.

**This reverses the more cautious posture two prior sessions applied, and
supersedes both as of this date:**

- **T-049** (`cefr-lexical-intelligence`, 2026-08-09) blocked the GitHub
  repo's code from adoption on the grounds of `license: null` / no LICENSE
  file present. Under this ruling, absence of a license is no longer a block
  by itself — the T-049 record stands as history, not as precedent for
  future triage of that repo or others like it.
- **`design-patterns-for-humans`** — the earlier "study only, copying into
  our repos forbidden" handling — is superseded the same way for any such
  repo that in fact has no LICENSE file; re-check the specific repo's license
  status under this rule before treating the older "study only" verdict as
  still binding.
