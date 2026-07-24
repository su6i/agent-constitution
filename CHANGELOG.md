# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## 2026-07-24 — docs: codify 3 residual inbox rulings (session.md gate, DRAFT scrutiny, written-request proposal)

### Added

- `rules/075-independent-review.md` — added `## DRAFT Rule Scrutiny` clause requiring architect scrutiny against existing rules before promotion.

### Changed

- `rules/050-session-start.md` — updated the `SESSION.md` gate from "session end" to "Ready to test" and "task done".
- `rules/040-git.md` — added sub-bullet to git step 2 requiring `SESSION.md` update before handing the command block.
- `rules/040-git.md` — Review step 2, test-command bullet: the executor must have run each test command itself (from a fresh CWD) to a clean result before handing it over, and must pass CWD-resolved configs (e.g. `markdownlint --config <abs>`) explicitly.

---

## 2026-07-21 — fix: stop link check failing on exa.ai rate-limit (429)

### Fixed

- **`.github/mlc_config.json`** — added `^https://exa.ai` to `ignorePatterns`.
  The link checker's CI IP is rate-limited by exa.ai (HTTP 429) even after the
  configured `retryOn429`/`retryCount: 5`, producing a false "dead link" and a
  red `Check Internal Links` job. The URL is live; this matches how other
  bot-blocking / rate-limiting hosts (`linkedin.com`, `npmjs.com`, `rentry.co`,
  `x402.org`) are already handled.

---

## 2026-07-21 — docs: reconcile manager governance topology into main

### Added

- **`rules/085-orchestration-topology.md`** — forward-ported five governance
  sections that were stranded on the diverged branch
  `docs/manager-governance-2026-07-19` and absent from `main`: `## Message
  addresses`, `## Manager Charter: The Queue`, `## End-to-End Management
  Workflow`, `## No Submodules & Knowledge Service`, `## No Unauthorized Folder
  Creation`. The superseded `## Four corrections (owner, 2026-07-19)` section was
  replaced (nothing lost: corrections #1/#2/#4 are the "Metadata only" /
  "Not a hard bottleneck" / "Lightweight" bullets; #3's "max 2 review rounds"
  bound is preserved verbatim in the new e2e-workflow step 6). Regenerated
  `rules/DIGEST.md`.

---

## 2026-07-20 — docs: relocate Persian docs to docs/fa/, fix and wire session rotation

### Changed

- **`README.fa.md`, `AGENTIC-CODING-SETUP.fa.md`, `docs/INFORMATION-ARCHITECTURE.fa.md`
  moved to `docs/fa/`** — enforces the root-clean Persian-docs rule (rule 000
  §Language Policy, already in force since 2026-07-15) that this repo itself
  was violating. Every cross-reference repointed both directions, including
  the pre-existing `fa/` localization tree and the English `README.md` /
  `docs/INFORMATION-ARCHITECTURE.md`. English `README.md` keeps its one-line
  «فارسی» pointer, now targeting `docs/fa/README.fa.md`. `.agent/`
  cross-references still point to English files only.
- **`workflows/documentation.md` §B** — codified: "`*.fa.md` lives under
  `docs/fa/`, never at repo root."

### Fixed

- **`bin/rotate-sessions.sh`** — was an empty stub (header comment only, no
  logic), so `--dry-run --keep 4` on a real multi-session `SESSION.md`
  silently printed nothing and exited 0. Rewritten: session boundaries are
  any `##` heading (not just the literal `## Session digest —` prefix most
  real `SESSION.md` files never use), sessions are ranked by parsed date
  (robust to files that are not strictly append-only), archiving is
  idempotent by construction (an archived session becomes a single pointer
  line, never a heading, so it can't be re-selected), and the default keep
  is now N=4 (owner decision, was N=2). Wired into rule 050's closeout-agent
  architecture as the final prune step, after the digest write.
- **`.rules-ack`** — gitignored (local attestation artifact) instead of
  being left untracked with no policy.

---

## 2026-07-20 — docs: add rule 080 knowledge capture

### Added

- **`rules/080-knowledge-capture.md`** — mandates capturing transferable
  judgment (a menu of approaches with trade-offs + the recommended default for
  our project profile) into reusable skills or docs before SessionEnd, with a
  fail-closed `knowledge-capture:` digest field required for MODERATE/CRITICAL
  sessions. Defines the *how/when/where*; complements rule 000
  §"No Knowledge Lost".

## 2026-07-19 — docs: codify manager governance, closeout, and review rules

### Added

- Rule 085: Orchestration topology (Manager / Architect / Worker) codified from draft.
- Rule 000: "No Knowledge Lost" section added, mandating knowledge extraction before archival.

### Changed

- Rule 050: Upgraded closeout-agent draft to rule with a hybrid timing approach (main path on SessionEnd, fallback on SessionStart).
- Rule 070: Fixed markdownlint MD013 and MD025 errors.
- Rule 075: Changed reviewer ladder to be capability-based instead of cost-based, prioritizing Gemini 3.1 Pro as MODERATE. Rejected the Headless Architect Review draft as it contradicts the core principle of cheap reviews.
- Reconciled conflicting WO numbering and emptied quarantine.

### Fixed

- `bin/generate-digest.sh` resolved the repo root from the **caller's cwd**
  (`git rev-parse --show-toplevel`), so running it from inside any other
  repo checked that repo's nonexistent `rules/DIGEST.md` and failed. It now
  resolves from the script's own location — runnable from any directory,
  as rule 000 demands of every handed command. (Found live: owner ran the
  handed test block from the Arix repo.)

## 2026-07-16 — rule 075: independent review & repair

### Added

- **`rules/075-independent-review.md`** — no agent approves its own work
  (recursively: a reviewer's repairs need a third-party verifier); reviewer
  ladder proportional to task difficulty; review-and-repair as the default
  economical pipeline (reviewer amends fixes on the branch, mechanical gate
  re-runs, architect signs off cheaply without re-reading verified diffs);
  DoD is unmet without a named reviewer verdict. Evidence base: Arix Sense
  wo-sense-0004/0005 pilot (13 blocking defects behind a green test suite).

### Changed

- `rules/070-work-orders.md` §Post-Execution Review Gate — reviewer is
  never the author; cross-reference to rule 075; verdict must name the
  reviewing agent.

## 2026-07-15 — rule corrections: docs/ARCHITECTURE.md, Persian-in-docs/fa, command block, router door

### Changed

- **Single technical doc name standardised to `docs/ARCHITECTURE.md`** (English)
  across `workflows/documentation.md`, `rules/045`, `rules/040` docs checklist,
  and the pre-commit reminder — replacing the `TECHNICAL.md` naming introduced
  on 2026-07-13. No `TECHNICAL.md`/`DESIGN.md` variants; repos rename in their
  next WO.
- `rules/000-core.md §Language Policy` — Persian docs live ONLY under
  `docs/fa/` (sub-folders allowed there); no Persian file at the repo root, not
  even `README.fa.md` (→ `docs/fa/README.md`). Root stays clean; the one root
  exception is a single Persian link word inside the English `README.md`.
- `rules/040-git.md §Review` — at "Ready to test" the executor now hands the
  full command block: (1) cwd-independent test command(s) + expected result,
  (2) merge + branch-delete, (3) push — so the owner never round-trips through
  an architect just to get commands. Agent still never pushes.

### Added

- `rules/000-core.md §Worker Delegation` — route all worker-model calls through
  the ai-router door (`delegate_worker`/`delegate_agent`), never a direct
  worker CLI; call it yourself rather than relaying via the owner.

### Fixed

- `CHANGELOG.md` trailing blank lines (markdownlint MD012 was failing CI on main).

## 2026-07-13 — session hygiene, retroactive scan, TECHNICAL hook

### Added

- `bin/validate-wo.sh` — pure-bash script that mechanically validates a work order file against rule 070 (mandatory sections, executor specification, test blocks) and rule 000 (no relative paths or `&&` chains in test commands) before execution.
- `rules/050-session-start.md §Session Lifecycle & Context Hygiene` — codifies
  the session policy: never `/clear` mid-task; externalise state to
  `SESSION.md`/`TODO.md`/memory then clear (raw jsonl backup is automatic, the
  curated `SESSION.md` is the agent's job); architect = one task/session, never
  a fat >150k context; worker = `/clear` freely.
- `rules/040-git.md §Retroactive (Full-Tree) Security Scan` — the per-commit
  scan only sees added lines, so pre-existing leaks are invisible; a full-tree
  scan (`bin/security-audit.sh`) must run before every merge to `main` and
  periodically.

### Changed

- `templates/hooks/pre-commit` Rule 2 reminder now names `TECHNICAL.md`, so
  agents are prompted to update it alongside README.

## 2026-07-13 — generic CLAUDE.md rule + TECHNICAL.md in docs checklist

### Added

- `templates/CLAUDE.md` — the canonical generic agent bootloader. Every repo's
  committed `CLAUDE.md` must be byte-identical to it: a thin, English,
  security-vetted router to `rules/DIGEST.md` → `AGENTS.md` → `rules/`, with
  zero project/personal/session data.
- `rules/035-data-vault.md §Agent-Config Files Must Be Generic` — a committed
  `CLAUDE.md` (and every harness bootloader) is public and must be generic;
  project-specific guidance moves to gitignored `CLAUDE.local.md` (may symlink
  to `<vault>/workspace/`). Mechanical enforcement via pre-commit hash check +
  PII scan; leaked history must be scrubbed and force-pushed.

### Changed

- `rules/040-git.md` — the before-commit docs checklist now names `TECHNICAL.md`
  alongside `README.md`, so agents stop forgetting to update it before merge.

## 2026-07-12 — rule 070: work order standard

### Added

- `rules/070-work-orders.md` — mandatory WO structure: named **Executor**
  model (cheapest-first ladder, `Why premium:` justification required for
  premium models), explicit base-rule references + read-before-coding order,
  script-first bodies, absolute-path Definition-of-Done commands with
  expected results, architect **handoff protocol** (every architect turn ends
  with the paste-ready next command — round-trips to a premium model re-send
  full context), and a **post-execution review gate** (mechanical
  `review-gate.sh` checks + reviewer verdict recorded in the WO) before any
  merge.
- `AGENTS.md` — WO section now points to rule 070; 070 added to the
  on-demand reading list.

## 2026-07-11/12 — auto-generated rules digest (wo-constitution-0002 phase 1)

### Added

- `rules/DIGEST.md` — auto-generated digest of every non-negotiable section
  in `rules/*.md`. Every bootloader (`AGENTS.md`, `GEMINI.md`, `GROK.md`,
  `QWEN.md`, `MINIMAX.md`, `.cursorrules`, `.windsurfrules`, `.clinerules`,
  `.github/copilot-instructions.md`) directs the agent to read
  `rules/DIGEST.md` FIRST before the full rules — cheap models can actually
  finish reading it.
- `bin/generate-digest.sh` — extracts the marked non-negotiable sections from
  `rules/*.md` (HTML-comment markers `<!-- digest:start --> ... <!-- digest:end -->`,
  see `rules/045 §Digest Mechanism`) and produces `rules/DIGEST.md`. Flags:
  `--check` exits 1 if the committed digest is stale; `--print` writes to stdout.
- `rules/045-single-source-docs.md §Digest Mechanism` — documents the marker
  convention and the freshness signal (SHA-256 of `rules/*.md` appended as
  `<!-- digest-hash: ... -->`).
- CI: `.github/workflows/validate.yml` — new `digest-freshness` job runs
  `bin/generate-digest.sh --check` on every push/PR; fails if the committed
  digest does not match `rules/*.md`. This is the cross-check that survives
  `--no-verify` (Phase 5 will mirror the rest of the local hooks here).

### Changed

- `rules/000-core.md`, `rules/035-data-vault.md`, `rules/036-skill-versioning.md`,
  `rules/040-git.md`, `rules/045-single-source-docs.md`,
  `rules/050-session-start.md`, `rules/070-work-orders.md` — wrapped
  every non-negotiable (or "Mandatory") section with
  `<!-- digest:start/end -->` markers. Markers are annotation only — the
  full original text of each section is preserved unchanged. Digest size is
  not capped; it grows with the rules.
- All bootloaders — added the "Read `rules/DIGEST.md` first" line before the
  AGENTS.md redirect.

### Reverted (after owner review)

- 2026-07-12 amendment (this commit): the initial 2026-07-11 phase-1 commit
  had compressed rules text before adding markers, dropping prose and
  examples. Owner rejected that compression — markers must wrap full text.
  This amend restores every rule file from `main` and re-adds the markers
  as pure annotations (`git diff main -- rules/` shows additions only,
  zero deletions).

## 2026-07-11 — language policy: English-only repo content

### Added

- `rules/000-core.md` §Language Policy — all repository content is English
  only, in every project. Translations live exclusively under `docs/fa/` (or a
  legacy root `fa/`) and in `*.fa.md` files; the only exception outside those
  paths is the single linking word in `README.md` pointing to the Persian
  docs. Mechanical enforcement (pre-commit + CI scan for Arabic-script
  characters outside allowed paths) ships separately.
- `AGENTS.md` — English-only added to the Non-Negotiables summary.

## 2026-07-09 — universal agent bootloaders

### Added

- Thin bootloader files for every major non-Claude harness — `GEMINI.md`,
  `GROK.md`, `QWEN.md`, `MINIMAX.md`, `.cursorrules`, `.windsurfrules`,
  `.github/copilot-instructions.md`. Each contains no rules, only a mandatory
  redirect to `AGENTS.md` → `rules/` (single source of truth, rule 045).

### Changed

- `AGENTS.md` promoted to the canonical agent entry point: mandatory reading
  list (`000-core`, `global`, `040-git` + on-demand rules), the non-negotiables
  summary, and explicit obligations for architects/planners writing work
  orders (WOs must cite the rules they were written against).
- `.clinerules` rewritten in English (repo content is English-only;
  translations live under `fa/`) and now routes through `AGENTS.md` like the
  other bootloaders.

## 2026-07-03 — git hooks: merge gate, deletion fix, rule-036 enforcement

### Added

- `templates/hooks/pre-merge-commit` — git never runs pre-commit on automatic
  merge commits, so blocked personal files and secrets could enter main via a
  merge. The new hook execs the pre-commit gate with `CONSTITUTION_MERGE_GATE=1`;
  on merges (also detected via `MERGE_HEAD` for conflicted merges finished with
  `git commit`) Rule 1 (branch protection) and Rule 2 (docs checklist) are
  skipped — merging an approved branch into main is the sanctioned protocol
  step — while the privacy gates still scan the incoming changes.
- pre-commit Rule 5 — skill versioning (`rules/036-skill-versioning.md`) is now
  actually enforced: a staged `skills/**.md` file without `version:`/`updated:`
  frontmatter, or a modified skill whose `version:` is unchanged from HEAD,
  blocks the commit. The untracked-throwaway reminder is now Rule 6.

### Fixed

- pre-commit Rule 3 now checks only Added/Copied/Modified/Renamed files:
  deleting a tracked personal file (`git rm TODO.md`) is the rule-035
  remediation for a past leak and is no longer blocked.

## 2026-07-02 — pre-commit: PII scan operates on clean added lines

- The staged-diff PII scan now strips the leading `+` diff marker before any
  pattern matching. Fixes a false positive where decorators at added-line
  starts (`@pytest.fixture`, `@app.route`) were flagged as email addresses
  (the marker was being consumed as the email local-part). Real emails in
  added code are still caught.

## [Unreleased] - 2026-06-30

### Added

- `templates/.clinerules` — generic Cline source-of-truth pointer, seeded per repo by
  `install.sh` so Cline in every project reads the central TODO + vault + git rules.

### Fixed

- `skills/ai-router`: `import anthropic` is now optional (lazy import + guard in
  `ClaudeClient`). Grunt-work providers use `OpenAICompatibleClient` (httpx only), so a
  subscription-only setup with no Anthropic API key can run the router. Documented in
  the router README.
- `skills/ai-router/config_example.py`: corrected DeepSeek model IDs to the v4 names
  (`deepseek-v4-flash` / `deepseek-v4-pro`) and Sonnet 4.6 pricing.

- `skills/ai-router`: `RoutingConfig.roles` dict — maps role names ("planning", "acting"
  or any custom key) to ordered `ModelType` tuples; `generate(role=...)` activates
  role-based model selection (tried before complexity routing, circuit-open models
  skipped, complexity routing is the final fallback). Fallback chain honours the role
  order. Skill version bumped 1.2.0 → 1.3.0.
- `skills/ai-router`: `OpenAICompatibleClient` — generic httpx client for any
  `POST /chat/completions` provider (Grok, OpenAI, MiniMax, future providers).
  Added `ModelType.GROK` (`grok-3`, VERIFY at docs.x.ai) and `ModelType.OPENAI`
  (`gpt-4.1`, VERIFY at platform.openai.com). `_initialize_clients` wires these to
  the new client. Skill version bumped 1.3.0 → 1.4.0.
- `skills/ai-router/configure.py` — interactive wizard: asks planning/acting model
  priorities, writes `~/.config/ai-router/roles.yaml` (overridable via
  `AIROUTER_ROLES_FILE`), and prints a Cline settings snippet (Plan = subscription
  CLI, Act = proxy `http://localhost:8787/v1`). Separate from install.sh (zero-touch
  unchanged). Skill version bumped 1.4.0 → 1.5.0.

- `rules/035-data-vault.md`: added **Layered Secrets Model** section documenting
  the two-layer `_shared/secrets/.env` + `<project>/secrets/.env` resolution
  order, the multiple-Telegram-bots pattern (separate project vaults), and a
  Python `load_secrets()` reference snippet.
- `AGENTIC-CODING-SETUP.md`: updated stale model IDs and names to current values —
  `claude-opus-4-8` ($5/$25), `claude-sonnet-4-6` ($3/$15), `claude-haiku-4-5`
  ($1/$5); `MiniMax M3` / `MiniMax-M3`; removed stale date-stamped Claude ID
  (`claude-sonnet-4-5-20251001`); added deprecation notes for `deepseek-chat`
  (deprecates 2026-07-24); updated `last_updated` to 2026-06-30. Benchmark
  scores for models other than Claude kept as-is (uncertain); OpenRouter slugs
  for MiniMax/Grok flagged with VERIFY comments.

### Fixed

- `templates/hooks/pre-commit`:
  - Rule 2: deletion-only commits no longer require a documentation update.
    The `all_staged` variable (all diff-filter modes) is now computed alongside
    `staged` (ACMR only); if `staged` is empty but `all_staged` is non-empty, the
    docs check is explicitly skipped. This makes the intent clear rather than
    relying on an implicit empty-string exit.
  - Rule 3: added `CLAUDE.md` to the personal-files blocklist (project-level
    CLAUDE.md files may contain personal configuration; use `--no-verify` to
    commit the shared template version intentionally). Rule 3 now iterates over
    `all_staged` (not `staged`) so it also catches personal files in
    deletion-only commits.
  - Added a comment block noting that merge commits bypass pre-commit and
    recommending CI-level secret-scan and branch-protection checks as the
    server-side gate.

## [Unreleased] - 2026-06-09

### Fixed

- CI `Validate Repository`: ignore `id.atlassian.com` in the markdown link-check config — it returns HTTP 202 to the bot checker (handled like the other bot-blocked domains already in the ignore list).

### Added

- `bin/open-branches.sh` + a session-start step — report unmerged / stale git branches (current repo with `--here`, or every repo under `~/@-github`) so half-done branches are not forgotten.
- `templates/hooks/pre-commit` — canonical git pre-commit gate enforcing two
  non-negotiable rules deterministically: no direct commits to `main`/`master`,
  and the Pre-Commit Docs Checklist (code changes must touch a doc; minor
  follow-ups must be `--amend`ed). Bash 3.2 compatible. Installed by
  `amir init-project` into every new project. Bypass: `git commit --no-verify`.
- `workflows/first-session.md` — mandatory onboarding workflow to fill
  `CLAUDE.md`/`README.md`/`.env.example` and verify the skeleton before feature
  work; listed in README.
- `workflows/propagate-constitution.md` — workflow for rolling constitution
  updates (rules/skills/hook) out to every consuming project via
  `amir update-projects`; listed in README.
- `bin/mcp-server/server_http.py` — HTTP server with SSE + Streamable HTTP transports (localhost:8765)
- `bin/mcp-server/com.agent-constitution.mcp.plist` — launchd service for auto-start on login
- `/health` endpoint for status checks
- Full IDE setup docs: Cursor, VS Code, Antigravity IDE, JetBrains, Gemini CLI

### Changed

- `templates/gitignore.template` — replaced the 410-line generic toptal dump
  with a curated 2026 Python/uv ignore. Removes the `[Ll]ib`/`[Bb]in`/`scripts`/
  `include` patterns that silently hid source directories, drops the leftover
  `Roadmap/`, adds `.storage/`, and keeps full macOS/Linux/Windows sections.
- `workflows/init-project.md` — rewritten to match the submodule-based flow
  (was pointing at the retired `bin/scaffold.sh` and `.txt` prompt templates):
  src-layout, `.gitkeep`, storage policy, `uv init`, mandatory first session.

### Fixed

- CI `Check Internal Links` — repaired the long-standing red build:
  - 75 `skills/*.md` files used `](../../README.md)` (one level too deep) → `](../README.md)`.
  - ~115 links to bundled reference files not shipped in this repo (e.g. Angular/
    VideoDB/Remotion `references/*.md`, `reference/*.md`, `rules/*.md`) were
    unlinked to inline code, preserving the text without a dead link.
  - `.github/mlc_config.json` now ignores CI-flaky/external domains (w3.org,
    developer.android.com, npmjs.com, doi.org, patentsview.org, github.com/apps).
- `AGENTS.md` stale skill count updated from 77 to 343

### Fixed

- MCP server now negotiates protocol version (`2025-11-25` and `2024-11-05` supported)
- `prompts/list` returns empty list instead of error
- `resources/list` no longer sends 48KB payload on connect (skills moved to tools)

### Added

- `list_skills` tool — lists all 343 skills so Claude can discover them proactively
- `get_skill` tool — reads any skill by name without requiring the caller to know the resource URI

---

## [1.0.0] - 2026-02-07

### 🎉 Initial Release

#### Added

- **58 Technical Skills** covering:
  - Python, JS/TS, Swift, Kotlin development
  - AI/ML workflows (LLM, RAG, Reinforcement Learning)
  - Data Science pipelines (Polars, DuckDB, Pandas)
  - Creative automation (Manim, Blender, DaVinci Resolve)
  - DevOps & Infrastructure (Kubernetes, Docker, GitHub Actions)
  - Web3 & Blockchain (Solidity, Foundry)

- **6 Workflows** for:
  - Project initialization
  - Documentation standards
  - AI optimization
  - Quality assurance
  - Communication protocols
  - Social media showcase

- **6 Prompt Templates** for:
  - Technical documentation
  - LinkedIn launches
  - Project logos
  - README generation

- **Global Rules** (`.cursor/rules/global.mdc.md`)
- **Scaffolder Script** (`bin/scaffold.sh`) for project initialization
- **Unified Navigation** with "Back to README" links across all files
- **Persian README** (`README.fa.md`) for Farsi-speaking users
- **CI/CD Pipeline** for link validation

#### Changed

- Migrated from root-level files to `.cursor/` directory structure
- Converted all prompts from `.txt` to `.md` format
- Standardized skill files to Anthropic's format

---

## [1.1.0] - 2026-02-14

### Added

- **Subtitle Generator Skill** (`.cursor/skills/subtitle-generator.md`): Professional Persian subtitle pipeline (Whisper, FFmpeg, Manim).
- **Supporting Scripts** for Subtitle Generator:
  - `split_sentences.py`: Optimized Persian sentence splitting.
  - `apply_subtitle.py`: Whisper JSON to stylized ASS converter.

### Changed

- **Manim Animation Skill**: Integrated Section 19 with Persian/Emoji typography protocols and renderer warmup techniques.

---

## [Unreleased]

### Planned

- MCP Server integration
- VS Code extension
- Raycast scripts

---

[Back to README](README.md)
