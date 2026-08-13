# Rules Digest — Non-Negotiables (auto-generated)

<!-- DO NOT EDIT. Re-run `bin/generate-digest.sh` to regenerate. -->
<!-- Source: rules/*.md  ·  Mechanism: rules/045 §Digest Mechanism  -->
## From 000-core.md

Agents SHOULD route **all** worker-model calls (Gemini/agy, DeepSeek, MiniMax)
through the ai-router door — `delegate_worker` / `delegate_agent` — and never
launch a worker CLI directly. The router provides the cost ledger, budget caps,
and the context-discipline pack; a direct CLI call bypasses all three. The
architect calls the worker channel itself (one tool-call + a short summary),
rather than asking the owner to run it and paste the output back — relaying
costs the same tokens twice plus a round-trip. **Exception:** hours-long
interactive tasks (training/benchmark grids) go to a separate owner-started
session. This becomes a MUST once ai-router `wo-0014`'s enforcement hook lands.

Any command the agent asks the human to run must be runnable **as-is in a
brand-new terminal**:

- **Absolute paths only** — never assume a working directory, never use
  relative paths.
- **One complete command per line** — no `&&`/`;` chains, no multi-step
  one-liners. Readability beats cleverness.
- Nothing left for the human to fill in, unless a placeholder is explicitly
  marked (e.g. `<PASTE-TOKEN-HERE>`).
- If a step needs more than one command, give a numbered list — one
  copy-pasteable line per step.

All repository content is English only — code, comments, identifiers,
print/log strings, commit messages, documentation, and config files. The whole
world reads this code. This applies to **every** project, not just this repo.

Persian (or any other language) is allowed ONLY as project documentation
translations, and ONLY under **`docs/fa/`** (sub-folders under it are fine when
a document needs them). The repo root must stay clean: **no Persian file at the
root** — not even `README.fa.md` (put it at `docs/fa/README.md`).

The single allowed exception outside `docs/fa/`: one linking word/phrase inside
the English `README.md` pointing to the Persian docs.

Enforcement is mechanical, not prose: the pre-commit hook and CI scan staged
added lines for Arabic-script characters (U+0600–U+06FF) outside the allowed
paths and block the commit; a periodic sweep tool cleans up pre-existing
content.

### Names are ASCII, content is not the same question

Everything above governs what a file **says**. This governs what a file is
**called**, and it is stricter, because the two are read by different things.

Every file and directory **name** — in any repository and in the vault, and
including `NOTE-`, `WO-`, `BRIEF-` and any other generated artefact — is
English and ASCII-only. The working charset is `[A-Za-z0-9._-]` plus `/`; the
hard, enforced boundary is ASCII (bytes `0x20`–`0x7E`).

The **content** of those files is unaffected: repo content follows the English
rule above, and a vault note may be written in any language its reader prefers.
A note written in Persian is fine; a note whose *filename* carries those
Persian words is not — rename it to `NOTE-2026-07-24-owner-directives.md` and
leave the text inside exactly as it was. (This paragraph deliberately shows no
counter-example verbatim: a committed rule file is repo content and is bound by
the English-only rule above, including when the subject is that very rule.)

Why names are held to a stricter standard than content: names are what tooling
greps and globs, what URLs percent-encode, what shells word-split, and what
changes shape when a path crosses filesystems, archives, or a `rsync`. Content
is read by people, who cope. `docs/fa/` is already ASCII and stays exactly as
it is — a Persian *path* was never the exception, only Persian *text*.

Enforcement: pre-commit Rule 8 blocks any newly added, copied or renamed path
containing a non-ASCII byte, and runs on merges too. It is deliberately
forward-looking — it does not fire on existing paths — so adopting the rule
never blocks unrelated work. Renaming what already exists is a separate,
owner-approved operation — a rename is a delete plus an add to every consumer
of that path (`rules/global.md` §5 Code Preservation).

Every error you observe — lint, type, test, build, LaTeX, runtime, deprecation
warning — must be either **fixed now** or **recorded in the central
`_memory/TODO.md`** (the project's `## <project>` section — rule 050) for later.
Seeing an error and moving on without doing one of those two is forbidden.

- "It was already there" / "not caused by my change" is **not** a reason to
  ignore it — record it.
- When you defer a fix (e.g. to keep a commit's scope clean), immediately add an
  item under the project's section in the central `_memory/TODO.md` with the
  exact `file:line` and the error message.
- Applies to errors surfaced by any tool you run, not only the files you edited.

Every piece of knowledge acquired by any agent (architect or worker) during any task must be **recorded** — we pay for every token.

- **Mandatory Extraction:** Before archiving, deleting, or closing any repository or session, extracting and recording its knowledge is mandatory and obvious (do not ask for permission).
- This requirement underscores the necessity of a knowledge-service (RAG) in the AI router to ensure all acquired knowledge is properly logged and centrally maintained instead of being scattered or lost.

## From 015-language-selection.md


## Default Language: Python

Python is the default for every project — ML/inference, CLI glue, orchestration,
services, scripts, the entire application "glue". No project starts in Rust or
Go on the strength of a general performance belief; Python is the baseline
until a specific module is measured and found wanting.

## Mandatory Gate: Justify First, Rewrite Second

**No module moves to Rust or Go without a concrete, written justification —
either a profiling number (performance), or a named distribution/
reliability/install benefit specific to that module (§Broader Adoption
Criteria below). "Rust/Go is generally better" is never sufficient on either
axis.**

1. Ship the module in Python first.
2. If the candidate reason is performance: profile it under a realistic load
   (`cProfile`/`py-spy` for CPU, `memory_profiler` for RAM, wall-clock for
   latency-sensitive paths). If the candidate reason is distribution,
   reliability, or install friction: name the specific benefit and state why
   Python's normal packaging (`uv`, a venv, PyInstaller) does not already
   cover it for this module's actual deployment target.
3. Only if the profile shows the module is the actual bottleneck, or the
   named non-performance benefit is real and specific to this module — not a
   guess, not "Rust is faster/smaller/more reliable in general" — does a
   rewrite proposal go in a WO.
4. The WO that proposes the rewrite **must carry the evidence** — the
   profiling numbers, or the specific distribution/reliability/install
   argument (rule 070 §Mandatory Body — a WO without evidence is incomplete)
   — and must justify the ongoing cost of maintaining two languages in one
   codebase (build tooling, CI matrix, the pool of people who can review
   both, FFI surface area). No evidence, no rewrite — this is
   non-negotiable, not a style preference.

Guessing which module is "obviously" slow, or "obviously" worth shipping as a
binary, and rewriting it anyway violates `rules/025-research-first.md` in the
same way as guessing an API flag: find the number, or name the specific
benefit, before writing the fix.

## Broader Adoption Criteria (Owner Ruling 2026-08-10)

D-028 gated Rust/Go adoption on one dimension: a profiled CPU-bound hot path.
This widens the criteria to the dimensions the owner named — a module can
justify Rust/Go through **any** of these, argued in the WO, not assumed:

- **Distribution:** a single static binary vs. shipping a Python interpreter
  plus a venv plus a dependency tree onto the target machine.
- **Reliability:** a compiled, statically-typed core that cannot fail at
  runtime on a missing or mismatched dependency the way an interpreted script
  can.
- **Cross-platform packaging:** one cross-compiled binary per OS/arch,
  instead of packaging a Python environment separately for each.
- **Install friction:** a single executable (or `curl | tar`) vs. a
  `uv`/venv setup step on the user's own machine.

**The bulk of the code still stays Python.** Most glue, orchestration, and
ML/inference code has no distribution story that Python doesn't already
serve fine — nobody ships a dependency-free binary of a one-off internal
script, and the readability trade from D-028 still holds. What changed is
the *set of arguments* that can justify a rewrite, not a default preference
for Rust/Go; a module still needs its own case, written into the WO, before
the gate above lets it move. The FFI boundary below is unchanged regardless
of which argument justified the rewrite — a module adopted for distribution
reasons still gets wrapped by Python the same way one adopted for CPU reasons
does (§FFI Boundary: **PyO3 + `maturin`** for Rust, `cgo`/separate-binary for
Go).

## Which Language for Which Job

| Language | When | Examples |
|---|---|---|
| **Python** | Default. ML/inference, glue, orchestration, CLIs, services where the bottleneck is I/O or an external call, not CPU. | Almost everything |
| **Rust** | Low-latency / real-time paths where the profiled bottleneck is CPU-bound Python and the workload tolerates a compiled, memory-safe core. | Cueprompt's live-latency path, real-time audio processing |
| **Go** | Network-facing services or concurrent CLIs where the bottleneck is concurrency/throughput, not raw numerical CPU work. | DevOps tooling, concurrent network utilities |

This table is a starting classification, not a substitute for the gate
above — a candidate module still needs its own evidence (a profiling number,
or a specific distribution/reliability/install argument) before a rewrite is
approved, even when it matches a row here by description.

## FFI Boundary (Mandatory When a Rewrite Is Approved)

A rewritten module is a *hot core* wrapped by the existing Python system, not
a wholesale language migration:

- **Rust →Python:** `PyO3` + `maturin`. The Rust crate exposes a narrow,
  typed Python-callable surface; Python remains the caller and the glue.
- **Go → Python:** `cgo` bindings, or — when `cgo`'s build complexity isn't
  worth it — a separate Go binary invoked as a subprocess/service with a
  defined I/O contract (stdin/stdout, HTTP, or a small RPC). Prefer the
  separate-binary route unless the call frequency makes process/RPC overhead
  the new bottleneck.

The Python side keeps ownership of orchestration, tests, and CI entry points.
A hot core does not get to redefine the project's primary language.

## From 035-data-vault.md

**If a file must never be committed, it must not live inside the repo.**

`.gitignore` alone is not enough — a personal file inside the working tree is one
accident away from a commit (e.g. it can enter through a **merge**, which the
`pre-commit` hook does not run on). The only safe place for uncommittable data is
**outside the repo**, in the central vault.

A committed `CLAUDE.md` (and every harness bootloader — `GEMINI.md`, `GROK.md`,
`QWEN.md`, `MINIMAX.md`, `.cursorrules`, `.windsurfrules`,
`.github/copilot-instructions.md`) is **public**. It must be **generic, English,
security-vetted, and byte-identical to the canonical `templates/CLAUDE.md`** — a
thin bootloader that only routes the agent to `rules/DIGEST.md` → `AGENTS.md` →
`rules/`. It must contain **zero** project-specific, personal, or session data:
no names, emails, personal paths (`$HOME/@-...`), session decision logs, other
projects' details, or third-party contact info.

Project-specific agent guidance goes in **`CLAUDE.local.md`** — gitignored, never
committed (rule 040 blocks `*.local.md`) — which may symlink to
`<vault>/workspace/CLAUDE.local.md`. Claude Code auto-loads it locally without it
ever entering git.

Enforcement is mechanical: the pre-commit hook blocks a `CLAUDE.md` whose content
does not match `templates/CLAUDE.md` (hash), and the PII scan blocks personal
data in any bootloader. History that already leaked such data is a
rule-035/040 incident — scrub it (`git filter-repo`) and force-push.

The first level of `$XDG_DATA_HOME/agent-projects/` contains **exactly** two
kinds of entry and nothing else:

1. one directory per **repository**, named by the slug resolved below;
2. `_memory` — the shared cross-project space.

The owner is not a repository, so the owner's mailbox is **`_memory/inbox-owner/`**,
never a directory sitting beside the repo vaults.

Any tool or hook that creates a vault directory must first establish that the
slug belongs to a real repository — the slug appears in `_memory/REGISTRY.md`,
or the repository root is inside the owner's repository directory. If neither
holds, it writes to its global/append-only log and stops. A hook that calls
`mkdir -p` on whatever cwd it happens to see manufactures vaults for benchmark
runs and scratch clones, and a fabricated vault is indistinguishable from a
real one a week later — every consumer that enumerates the top level then
treats the noise as authoritative. Never create `REGISTRY.md` from a hook: a
missing registry means "unverified", not "empty".

Vault directory and file names follow rule 000 §Language Policy — ASCII, like
everywhere else.

## From 036-skill-versioning.md

**Every skill file must carry `version:` and `updated:` in its frontmatter:**

```yaml
---
name: my-skill
description: ...
version: 1.2.0      # semver
updated: 2026-06-30 # ISO date of the last change
---
```

**After ANY change to a skill — before committing — you MUST:**

1. Bump `version:` using semver:
   - **patch** (`1.2.0 → 1.2.1`) — typo, clarification, small fix
   - **minor** (`1.2.0 → 1.3.0`) — new section, new capability, additive
   - **major** (`1.2.0 → 2.0.0`) — rewrite or breaking change to guidance
2. Set `updated:` to today's date.

A skill edit without a version+date bump is an **incomplete change** — the same
status as code changed without updating docs (`040-git`). Do not commit it.

## From 040-git.md

The per-commit scan only sees **added** lines — a leak already sitting in a
tracked file is never re-flagged (this is how a public `CLAUDE.md` leaked names,
personal paths, and a third party's email for weeks). Therefore, **before merging
any branch into `main`, and on a periodic audit, scan the entire tracked tree —
not just the diff** — for secrets / personal data (`bin/security-audit.sh`). A
finding blocks the merge until the file is scrubbed (moved to the vault per 035)
or explicitly allow-listed. A leak found in history is a rule-035/040 incident:
purge with `git filter-repo` and force-push (owner only).

When a commit fixes or touches a security/privacy issue, the commit message must
**never describe the issue or reveal the sensitive data**. Forbidden examples:

- `remove phone number 0775XXXXXX from config`
- `scrub email / API key from <file>`
- `remove the candidate's name from a comment`

Why: commit messages are permanent and searchable in git history. Naming the
change is a signpost pointing an attacker straight at the sensitive data — and
the message persists even after the data itself is removed.

Rules:

- Describe **only** the neutral functional change (the *what*, not the *leak*).
- If a privacy hardening must be noted, keep it generic and location-free
  (e.g. `harden config handling`), never the specific value, field, or file.
- Applies to the subject, body, and any trailer.
- The same principle applies to hook/CI output: report the file and the *type*
  of finding, never the matched value.

**Author email:** Every commit must be signed with `<your-git-email>`.
Before committing, verify: `git config user.email` returns `<your-git-email>`.
If not, set it: `git config user.email "<your-git-email>"`.

**No AI co-authorship — ever.**
No agent, assistant, or AI tool may add itself as a contributor to any commit.
Forbidden in all forms:

- `Co-Authored-By: Claude ...`
- `Co-Authored-By: GitHub Copilot ...`
- `Co-Authored-By: <any-ai>@<any-domain>`
- Any variation of AI attribution in the commit message, body, or trailer

Commit messages document the *change*, not *who or what* produced it.
The human author is the sole credited contributor.

The full lifecycle of every change, in order:

1. **Agent commits** on the feature branch (one task = one commit).
2. **Agent informs** the user — and a bare "Ready to test" is **forbidden**.
   With that same message the executor hands the **full command block** (owner
   decision 2026-07-14 — this removes the round-trip where the owner relays the
   result to an architect just to get commands). All three, per `000-core`
   "Commands Given to the User" (absolute path, one command per line, runnable
   from any directory in a fresh terminal):
   - **SESSION.md is updated before the command block is handed** (branch tip + change summary + waiting status).
   - **(1) the test command(s)** with the expected result of each (what PASS
     looks like, what means FAIL). **The executor MUST have run each command
     itself — from a fresh CWD (e.g. `$HOME`), not the repo root — and seen it
     pass with no error, before handing it over.** A command the agent has not
     personally run to a clean result must not be given. Test commands must be
     cwd-independent — for `uv` repos use `uv run --directory <abs-repo> pytest
     -q`, never a bare `--project` (pytest collects from the CWD); and when a
     tool resolves its config from the CWD (e.g. `markdownlint` reads
     `.markdownlint.json` from `.`), pass that config explicitly by absolute
     path (`--config <abs>/.markdownlint.json`) or the command silently lints
     against defaults and floods false errors from any other directory;
   - **(2) the merge + branch-delete commands**, to run after approval. The
     `git merge` line **always carries a pre-written `-m "..."`** — composing
     the merge message is never left to the owner (owner decision 2026-07-14 /
     reaffirmed 2026-08-09: a bare `git merge --no-ff <branch>` handed over
     without `-m` is itself a rule violation — incident:
     `chore/vault-gitignore-scope` handed with no message drafted);
   - **(3) the push command**;
   - any cleanup command if the test creates artifacts.
   The owner runs merge/push themselves, or tells the executor to merge — but
   **the agent never pushes** (`Remote Repo Access`, `global`).
3. **User reviews** and reports any issue.
4. **Agent amends** — fixes belonging to the same task go in with
   `git commit --amend`, **never** as a new commit. The branch keeps exactly
   one commit per task.
5. **Only after explicit approval:** agent runs `git merge` (with the `-m`
   message already drafted at step 2 — never composed on the spot) +
   `git branch -d`.
6. **The user pushes — never the agent.** After merging, the agent hands over
   the push command per `000-core` "Commands Given to the User": complete,
   absolute path, one line, copy-pasteable into any fresh terminal, e.g.:

   ```bash
   git -C /Users/<you>/@-github/<project> push origin main
   ```

Merging before approval removes the user's ability to reject broken changes
without a revert. Pushing by the agent removes the user's last checkpoint
before anything becomes public — both are forbidden.

Files used only for our own notes and session memory — `TODO.md`, `SESSION.md`,
`TASKS.md`, `ROADMAP.md`, `*.session.md`, `*.local.md` — must **never** be
committed or pushed to GitHub, in this repo or any project repo.

- They must always be listed in `.gitignore`.
- The pre-commit hook (`templates/hooks/pre-commit`, Rule 3) blocks them at
  the git level even if someone force-adds with `git add -f`.
- If one of these files is already tracked in a repo, remove it with
  `git rm --cached <file>` and add it to `.gitignore` — do not just edit it.

## From 045-single-source-docs.md

Every piece of project knowledge has exactly one home:

| Content | Single home | Everything else holds |
| --- | --- | --- |
| Public design / architecture / ADRs | Repo docs — the single technical doc is exactly `docs/ARCHITECTURE.md` (English), no `TECHNICAL.md`/`DESIGN.md` variants (see `workflows/documentation.md`) | a pointer |
| Private design, playbooks, internal reviews, work orders / handoff (`NEXT-SESSION.md`) | Vault: `<vault>/workspace/` (see `035-data-vault`) | a pointer |
| Tasks / status | The ONE central `_memory/TODO.md`, `## <project>` section (`050`) — never a repo file (`040`), never a per-project file | one-line pointers + dates |
| What happened when | `workspace/SESSION.md` (append-only log) | nothing — logs are not truth |

- **Public vs private is decided by one question:** would you publish this
  file on GitHub as-is? If not, it is vault material — per `035`'s golden
  rule it must not even sit inside the repo working tree.
- **Never copy design content into TODO/SESSION/memory.** Write one line:
  what changed + where the truth lives (path, commit).
- **On conflict, the single home wins.** Fix the pointer file in the same
  session you notice the conflict; do not "interpret around" it.
- **When a decision changes, edit its single home first**, then update
  pointers. A change that only lands in a log or a TODO is not a decision.

If a vault-class file (private doc, TODO/SESSION-class file per `040`) is
found **committed** in any repo:

1. Move the working copy to the vault (`035` — a filesystem move, not a
   commit).
2. Purge the file from **all git history** (`git filter-branch`/
   `git filter-repo` + reflog expire + gc). `git rm --cached` alone leaves it
   in history forever.
3. If the repo has a remote that already received it, treat it as a leak:
   force-push the rewrite and note it in the central TODO.

## From 050-session-start.md

Before ANY action in a new session:

1. Read `rules/000-core.md` and `rules/040-git.md` (plus any rule relevant to the task).
2. Post a short, free-form acknowledgement that you have read them and will comply — covering at least: branch-first (never `main`), no AI co-authorship, the pre-commit security scan, `--amend` for minor follow-ups, readable commands (no long `&&` chains), and the merge gate.

**At the start of every session — before any action — these steps are mandatory:**

1. Read the **single central TODO** at
   `${XDG_DATA_HOME:-~/.local/share}/agent-projects/_memory/TODO.md` — one file for
   ALL projects, with a `## <project>` section each (`<project>` = the vault slug,
   see `035-data-vault.md`). Read the **current project's section** plus the
   `## 🌐 Cross-project` section. There is no per-repo `TODO.md` any more — repo-root
   `TODO.md` is personal and would get committed by accident (e.g. through a merge,
   which the pre-commit hook does not scan).
2. Read the Mailbox (`<vault>/workspace/inbox/`): list **every** unread item
   (manager↔architect notes, owner decisions) and **triage each one** — answer
   it, turn it into a WO, or close it with a written verdict. After processing,
   **move** the note to `<vault>/workspace/inbox/done/` — never delete it.
   **Whatever remains in `inbox/` is open work.** An inbox note left merely
   "announced" is an unanswered request; requests arriving here follow rule 090.
3. If the central TODO exists: read it and announce all open items grouped by priority level.
4. Announce **open branches**: run `bin/open-branches.sh --here` (or `git branch --no-merged main`) and list any unmerged / stale (>14 days) branches so they get finished, merged, or deleted — half-done branches must not be forgotten.
5. Ask: "Where do we start?"

**All tasks — for every project — go in the one central TODO**
(`_memory/TODO.md`), under that project's `## <project>` section. Never create a
per-repo `TODO.md`. New task → add it under the right project section. This is how a
solo operator sees every project's work in one place and nothing is forgotten.

**After completing any TODO item — before committing — update the central TODO:**

- Mark the item as done: `- [x]` and add completion date
- Update the status if present

A task is not done until the central TODO reflects it.

State that must survive a session lives in **durable files** — `SESSION.md`
(vault `workspace/`), the central `_memory/TODO.md`, and memory — never only in a
long live context window. A raw transcript backup is written **automatically** on
session end (`_memory/handoffs/*.jsonl`), so nothing is ever truly lost. To
reconstruct a previous session, an agent starts from the raw `.jsonl` in
`${XDG_DATA_HOME:-~/.local/share}/agent-projects/_memory/handoffs/` (newest
first — see **Where Transcripts Live** below for the exact paths, naming and
retention of both transcript stores) and writes the curated result into that
project's `SESSION.md`. Raw is
the source, `SESSION.md` is the product — and keeping it current, proactively,
when the owner signals wrap-up and before any `/clear`, is the **agent's** job.

- **Never `/clear` mid-task.** Finish the step, update `SESSION.md`, then clear.
- **Between tasks:** write `SESSION.md`, then `/clear` (or `/compact` above
  ~100k context). The state is externalised, so clearing loses nothing.
- **Task Done / Ready to test:** The update-`SESSION.md` gate is **"Ready to test" and "task done"**, NOT "session end". Any merge-ready delivery must have `SESSION.md` updated (branch tip, change summary, waiting status) **before/with** the message announcing it — the loss window is precisely between "Ready to test" and the owner's `/clear`.
- **Architect sessions** (design/review, premium model): one task per session;
  reference earlier work by re-reading `SESSION.md`/`TODO.md`, **not** by keeping
  a fat context alive — >150k context is where subscription quota burns.
- **Worker sessions** (cheap models): `/clear` freely; their state is the WO file
  plus the git branch, both external.

The rule is: **externalise the useful part, then context is cheap to reload and
`/clear` costs nothing.** Preserving raw context in the window instead is the
expensive anti-pattern.

### Mandatory Stepped Checkpoints (Owner Decree 2026-08-04)

**ذخیره‌ی اجباریِ پله‌ای.** ذخیره‌ی وضعیت به یادآوریِ مدل بسته نیست؛ به رویدادِ ابزار بسته است (`PreToolUse`). چک‌پوینتِ اجباری در **هر ۵۰ هزار توکنِ کانتکست** (۵۰k، ۱۰۰k، ۱۵۰k، …) و **یک‌بار بلافاصله پیش از هر `git commit`**. هر چک‌پوینت رونوشتِ کاملِ transcript است، پس بیشترین چیزی که یک قطعیِ ناگهانی می‌بَرد کارِ بینِ دو پله است.

**اعلام اجباری است:** بعد از هر ذخیره یک پیامِ کوتاه — «💾 سشن ذخیره شد در N هزار توکن» / «💾 سشن ذخیره شد — چک‌پوینتِ پیش از کامیت». ذخیره‌ی بی‌اعلام = ذخیره‌نکردن.
پیاده‌سازیِ مرجع: `templates/claude-code-hooks/context-checkpoint.py`.

*توجه مهم:* چک‌پوینتِ پله‌ای **پشتیبان (backstop)** ِ سشن است و هرگز **جایگزینِ** curate کردنِ `SESSION.md` نمی‌شود.

There are **three** transcript locations and they are not interchangeable. An agent
asked to reconstruct a past session must know which one to open.

| | Live store | Stepped Checkpoints | Vault backup |
|---|---|---|---|
| Path | `~/.claude/projects/<cwd-slug>/<session-uuid>.jsonl` | `${XDG_DATA_HOME:-~/.local/share}/agent-projects/_memory/handoffs/checkpoints/<ts>_<label>_<sid8>.jsonl` | `${XDG_DATA_HOME:-~/.local/share}/agent-projects/_memory/handoffs/<YYYYMMDD-HHMMSS>_<event>_<sid8>.jsonl` |
| Written by | Claude Code itself, continuously, while the session runs | `context-checkpoint.py` hook, on `PreToolUse` (every 50k tokens & pre-commit) | the `save-handoff` hook, on `PreCompact` and `SessionEnd` |
| Named by | session UUID | timestamp + step/precommit + first 8 chars of session id | timestamp + hook event + first 8 chars of the session id |
| Owner | the tool — subject to its own retention (`cleanupPeriodDays`) | us | us |
| Retention | tool-controlled; assume it can be pruned | **last 60 files only**, oldest deleted on every checkpoint | **last 40 files only**, oldest deleted on every save |

`<cwd-slug>` is the working directory with `/` and non-alphanumerics replaced by `-`
— e.g. `/Users/su6i/@-github` becomes `-Users-su6i---github`. There is one such
directory per working directory, so a repo you have not opened in months still has
its transcripts there.

**Which one to open:**

1. **Recovering a session that has already ended** → the vault copy in `handoffs/`.
   It is ours, its filename carries the date, and it survives tool-side cleanup.
   Sort newest-first and match on the timestamp.
2. **Recovering the session currently running** (it crashed, or you need the live
   window) → check `handoffs/checkpoints/` first (fast stepped checkpoint) or the live store.
3. **Older than the last 40 sessions** → only the live store may still have it. The
   vault prunes; Claude Code's own store often keeps more.

**Both survive `/clear`.** Clearing empties the context window, not the disk — no
transcript is ever lost by clearing. This is precisely why `/clear` is cheap and
keeping a fat context alive is not.

**Cheapest recovery path** (owner decree 2026-07-29): never ask a fat architect to
summarise itself — that is a round-trip at maximum context price. `/clear` first,
then have a `$0` worker read the raw `.jsonl` and write the curated result into
`SESSION.md`. Raw is the source, `SESSION.md` is the product.

**Architect memory** — the warm-start file every architect writes at the end of
a task, alongside `SESSION.md`:

- **Location:** `<vault>/workspace/architect-memory.md` — one per project, never
  in the repo.
- **Content:** decisions taken and *why*; gates/guardrails established; status of
  open WOs; and "where I stopped / what is next". It is **not** a work log — the
  chronological log is `SESSION.md`. This is the memory that survives *between
  dispatches*.
- **Scope of warmth:** the goal is a **fast cold restart** of an architect, **not**
  simulating an always-live session. Cross-day warmth is not needed, because
  context is `/clear`ed every time it passes ~150k; in-session warmth is enough.
- **Backstop, not substitute:** the `Stop` hook `check-session-saved.sh` already
  blocks the closing message of a heavy session when `SESSION.md` **or**
  `architect-memory.md` was not updated. The hook is the backstop; this rule is
  the obligation.

**Problem:** Saving the session by the architect in a fat context is the most expensive state.
**Solution:**

- The architect makes all decisions but leaves only a short "closeout note" (decisions/open status, a few lines) at the end of the task.
- A cheap sub-agent (e.g., `Haiku`, `Sonnet`, or `agy $0`) is invoked to do the mechanical writing: update `SESSION.md`, `<vault>/workspace/architect-memory.md`, `README`, `CHANGELOG`, `docs`, stage the changes, and run `git commit --amend` per rule 040.
- **Hybrid Timing (Main + Fallback):**
  - **Main Path:** A `SessionEnd` hook invokes the cheap agent with the architect's closeout note to write the digest immediately at the end of the session.
  - **Safety Net:** `SessionStart` checks if a digest was created for the previous session's `jsonl`. If not (e.g., due to a crash where the hook didn't fire), it runs the cheap agent on the raw backup before proceeding.
- **Prune step (last, after the digest is written):** the closeout agent runs
  `bin/rotate-sessions.sh --keep 4` on the project's `SESSION.md`. The raw
  `.jsonl` handoff (`_memory/handoffs/`) is the append-only backup — nothing
  is ever truly lost — so `SESSION.md` only needs to stay a **curated, living
  doc**: current state, live decisions, open work. Sessions beyond the last 4
  are replaced in place by a one-line pointer and their full text is moved to
  `<workspace>/archive/SESSION-<YYYY>.md`. Idempotent — safe to run every
  closeout even if nothing is due for archiving.
- **Merge is always done by the architect/owner** (to avoid branch-rename incidents).

## From 070-work-orders.md

1. **Executor** — the exact agent/model that will run it, e.g. `gemini`
   (free), `deepseek-flash`, `deepseek-pro`, `minimax-3 (CodeWhale)`,
   `sonnet`, `fable/opus`. Routing ladder, cheapest first:
   gemini → deepseek-flash → deepseek-pro/minimax-3 → premium; which class of
   work goes to which executor is fixed by **§Executor Routing** below.
   If the executor is a premium model, a **`Why premium:`** line is
   mandatory — implementation work defaults to cheap models; premium is for
   design-critical logic only.
2. **Base rules** — explicit paths of the rule files the WO was written
   against (at minimum `rules/000-core.md` and `rules/040-git.md`), plus an
   order to the executor: read `rules/DIGEST.md` (or the listed files)
   **before writing anything**. A WO without rule references is invalid.
3. **Complexity** — TRIVIAL / MODERATE / CRITICAL (rule 000).

**$0 first (owner ruling 2026-07-13).** The default channel for implementation
is a zero-cost one — agy Gemini 3.1 Pro (subscription, agentic) or the free
Gemini API through `delegate_worker`. DeepSeek (flash/pro) and MiniMax are
**paid fallback only**, used when a $0 channel fails review or hits quota.

| Class of work | Executor | Why / evidence |
|---|---|---|
| Audio/video, installing a TTS or model engine, anything environment-sensitive (disk, GPU, mounts) | **Gemini** ($0), else Sonnet | Owner ruling: you do not hand songwriting to a deaf man. On such a task DeepSeek filled the disk and reported the environment error as "no Metal / exFAT denies permission", never finding the reference already on disk. Gemini has a record of successful installs and listening evaluation. |
| Self-contained mechanical text/code work — patterned refactor, file moves, boilerplate, tests | **$0 worker first** (agy / gemini via `delegate_worker`); deepseek-flash or minimax-3 only as paid fallback | wo-polycast-0002 finished on the paid channel for $0.51 but still needed a review pass; the same class now runs at $0. The review pass (rule 076) is mandatory either way. |
| Live facts: does X exist, version / licence / API behaviour checks | **`delegate_research`** (grok) | A ~$0.003 call settles it — never answer from model memory, never spend premium context on it. A negative from one search model is not proof of non-existence (two real models were once reported "nonexistent"), so a negative needs a second channel. |
| Deep debugging, multi-system glue, quality-sensitive documents | **Sonnet** | flash-class models lose the thread in layered debugging (wo-0003); on Arix Sense 0005 a flash execution came back with 13 blocking defects that only independent review caught. |
| Constitution rule text, architecture, WO authoring, review and synthesis, path decisions | **the architect's premium model** (Opus/Fable) | Expensive — reserved for what the others cannot do. Cheap workers never edit rule text. |

1. **Gemini creates files sloppily** (owner ruling): every Gemini task brief
   must spell out the exact absolute path of every input and every output, and
   repeat the permitted write scope (`experiments/<agent>/` plus the named
   allowed paths) — otherwise it scatters files across the repo.
2. A disk- or environment-heavy task carries a **sanity checklist as step 0 of
   the WO itself**: free disk space, mount present, destination writable.
3. **An executor report is a claim, not evidence.** The review gate below and
   rule 076 apply before any merge, and a claim of the form "the tool is
   broken" never enters the docs without independent verification.
4. **No conclusion from n=1.** This table changes only through a reproducible
   benchmark (the `ai-router` delegation ledger) or an explicit owner ruling.
5. **Who dispatches whom** is fixed by rule 085 §Three-Layer Delegation
   (architect → Sonnet dispatcher/reviewer → `$0` worker), including the
   exemptions that keep a task in the architect's own hands. This table picks
   the executor; 085 picks the chain.

- Phases sized for one branch + one commit each (rule 040); executor stops
  for review between phases.
- **Script-first:** anything bash/python can do must be specified as a
  script, not as LLM work — scripts can be automated or handed to the
  cheapest executor.
- **Cross-project impact:** Mandatory section in every WO. Source of truth is the
  ripple column of `_memory/REGISTRY.md`. Even if no impact, explicitly state
  "None".
- **Definition of Done** with copy-pasteable absolute-path commands, one per
  line, each with its expected result (rule 000 §Commands).
- Never an instruction to merge or push without explicit owner approval.

Every round-trip to the architect re-sends the full premium context — so the
architect never leaves the owner without the next move. Every architect turn
that finishes a task, a review, or a WO **must end with the exact paste-ready
command or message for the next step** (e.g. the text the owner pastes into
the executor's session, or the single command to run). No "ask me when
ready" — the next action ships with the current answer.

Executor output is never merged on trust. In order:

1. **Mechanical** (script — `bin/review-gate.sh`): working tree clean;
   changed files within the WO's declared scope; no junk artifacts
   (`*.tmp`, `.DS_Store`, `__pycache__/`, `node_modules/`, build output,
   scratch/debug files); lint passes; staged/committed-diff secret & PII
   scan; commit count and message format per rule 040.
2. **Reviewer** (architect or reviewer agent — **never the author**; who
   may review, the reviewer ladder, and the review-and-repair pipeline are
   defined in rule 076): read the diff against the WO — scope creep,
   content deleted without being ordered, tests faked or skipped, docs not
   updated. Verdict recorded in the WO file under a `## Review` appendix
   (date, reviewing agent, verdict, findings).
3. Only then does the owner approve, and the merge happens (rule 040).

An execution report without the review verdict is not mergeable. The
executor's "ready to test" message must itself follow rule 040 §Review —
test commands with expected results, never just merge/push commands.

## From 075-identifiers.md

**`_memory/REGISTRY-IDS.md` is the single source of truth for all system identifiers.**

Identifiers must live outside session context so they remain valid across `/clear` resets and cross-session handoffs.

Only the following official prefixes are permitted:

- **`B-`**: Branch (`B-001`)
- **`T-`**: Task (`T-001`)
- **`D-`**: Owner Decision (`D-001`)
- **`N-`**: Inbox Note (`N-001`)

A new prefix may be introduced **only** by an explicit owner decision. Ad-hoc or per-message local numbering (e.g. referencing items as "1", "2", "3" in chat) is strictly forbidden.

**Permanent Lock:** Every assigned ID is permanently bound to its single topic.
Once assigned, an ID is never freed, reassigned, or reused — even after the item is completed, closed, or cancelled. Closed items must be moved to the "Closed" section of `_memory/REGISTRY-IDS.md`.

1. **Sequential Allocation:** Next ID number = `max(existing numbers for prefix) + 1`.
2. **Standard Format:** 3-digit zero-padded string (e.g., `T-007`, `B-012`).
3. **Overflow Rule:** When a prefix reaches `900`, that prefix transitions to 4-digit formatting for subsequent allocations (e.g., `T-0900`, `T-0901`).
4. **No Historical Rewriting:** Existing 3-digit IDs (e.g., `T-007`) are never retroactively rewritten when overflow occurs; they remain permanently valid.

1. **Communication Requirement (tightened 2026-08-10):** Any response or
   report to the owner that references numbered items must draw its numbers
   directly from `_memory/REGISTRY-IDS.md`. Local in-message numbering is
   prohibited. **Every reply that leaves anything pending on the owner's
   side must end with a numbered decision/action list, and every line of
   that list carries the item's stable id** (`B-`/`T-`/`D-`/`N-`). The owner
   has flagged the gap twice — "چرا بازم منتظر تصمیم/اقدام مالک رو با
   registry-ids ندادی؟" — a closing list without ids is not a lesser
   violation than bare `1/2/3` numbering, it is the *same* violation moved to
   the end of the message, and a reply missing it is incomplete.
2. **Session End Registration:** Every architect is obligated to register any newly generated items in `_memory/REGISTRY-IDS.md` before session end (enforced mechanically via the `SessionEnd` hook backstop).

## From 076-independent-review.md

**Whoever writes or modifies code never approves it.** This applies
recursively:

1. An executor's output is reviewed by a **different** agent (rule 070
   gate). Self-review, however thorough, satisfies nothing.
2. **Repairs are authored code.** If the reviewer fixes defects directly
   (review-and-repair), those fixes must be verified by an agent **other
   than the one who wrote them** — e.g. Sonnet repairs Gemini's output →
   Gemini, Haiku, or Opus (proportional to difficulty, see ladder) verifies
   Sonnet's repairs. Never the repairer itself.
3. **No independent review recorded → DoD is NOT met.** An execution
   report without a reviewer verdict (in the WO `## Review` appendix) is
   not mergeable, no exceptions.
4. **Architect signs last, cheaply.** The architect's final signature is a
   gate check, not a re-review: confirm the mechanical gate passed, read
   the reviewer verdict(s), spot-check the diff hotspots the reviewer
   flagged, run the DoD proof commands. The architect does NOT re-read the
   whole diff — burning premium context on work two agents already
   verified is the anti-pattern this rule exists to prevent.

Match the verifier to the stakes — accuracy without waste (capability-based, not cost-based):

| Work under review | Minimum independent reviewer |
|---|---|
| TRIVIAL (docs, config, mechanical edits) | any basic agent ≠ author (e.g. deepseek-flash/haiku) |
| MODERATE (features, refactors) | sonnet-class or Gemini 3.1 Pro ≠ author. **Gemini 3.1 Pro is the preferred reviewer here** because it is $0 for the owner while possessing frontier-class reasoning and an agentic harness that can run tests/shell during review (it verifies, not just reads). |
| CRITICAL (security, money, algorithms, protocol) | opus-class or architect line-by-line ≠ author |
| Repairs made BY a reviewer | one tier may drop (repairs are narrower than the original diff), but never below "basic agent ≠ repairer" |

The reviewer's model/agent name and verdict date are recorded in the WO
`## Review` appendix — "reviewed" without *who* is not reviewed.

For WO execution, the default pipeline is **review-and-repair** — the
reviewer fixes what it finds instead of bouncing rounds back to the
executor (each bounce costs a full context reload + a re-review anyway):

1. **Architect** writes the WO (design decisions fixed, scope closed).
2. **Cheap executor** implements on the WO branch ($0 ladder per 070).
3. **Reviewer agent** (≠ executor) reads the diff against the WO,
   red-teams it, and **amends fixes directly on the branch** (rule 040:
   same task = amend, not new commits). Every finding is listed in the
   verdict as BLOCKING/MINOR with file:line.
4. **Mechanical gate re-runs** after repairs (`bin/review-gate.sh`,
   full test suite, lint) — repairs that break the gate go back to step 3.
5. **Repair verification** by a third agent per the ladder above —
   scope: only the repair hunks and their blast radius.
6. **Architect sign-off** (cheap, per Independence Law §4) → owner
   approval → merge (rule 040).

Why this shape: defects caught pre-merge cost one amend; defects caught
post-merge cost a bug hunt, a new WO, and a re-review — always route the
tokens to the pre-merge side.

Fixing a worker's defect on the branch repairs one delivery. Fixing the
instruction that produced it repairs every future one. **The loop is the duty
of the architect who delegated**, not of the reviewer and not of the worker:

1. A defect found in review is repaired on the branch (pipeline above).
2. The architect asks the one question that matters: *did my WO or brief make
   this defect likely?* Ambiguous scope, a missing absolute path, an unstated
   expected result, a gate the executor could not have known about.
3. If yes, the fix goes back into the **WO template, the brief, or the routing
   table** in the same session — not onto a wishlist.
4. A defect that recurs across executors is evidence about the *instruction*;
   a defect that recurs with one executor is evidence about the routing table
   (rule 070 §Executor Routing, which changes only on reproducible evidence or
   an owner ruling).
5. **Re-prompt the same warm session first (owner ruling 2026-08-10).** When
   a worker's report is incomplete or shallow, the architect's first move is
   to re-prompt the *same* warm worker session with the specific defect — not
   to silently redo the work itself in premium context. This is the same
   discipline rule 085 §Three-Layer Delegation's "the worker stays warm"
   clause already requires for a failed verify; it applies just as much to a
   report that is merely thin as to one that fails a gate outright. For a
   browsing/verification task specifically: demand the worker produce
   **evidence it cannot fabricate** — e.g. a screenshot — as proof before
   trusting the claim. Only if a second attempt with the defect named still
   fails does the architect open a real browser (or otherwise do the check)
   itself.
6. **The corollary (owner ruling 2026-08-10): if the worker failed, suspect
   your own prompt first.** Owner's stated reason is cost: "اگه بخوای همیشه
   به جای بالابردن کیفیت پرومپت‌هات ... بخوای خودت انجام بدی، هزینه‌مون زیاد
   میشه." A better prompt plus a recorded lesson — item 3 above (WO
   template/brief/routing table) and, for a defect class rather than a
   one-off, an appended entry in `WORKER-RULES.md` §Recorded defect patterns
   (`_memory/WORKER-RULES.md`, in the same Symptom/Root cause/Rule shape) —
   is the durable fix. Architect labour spent quietly redoing the task is not
   a rescue; it is the expensive failure mode this loop exists to close off.

Tone, explicitly (owner ruling 2026-07-23): this is **better management, not
catching the agent out**. The runlog exists to improve dispatch, and a defect
traced to a vague WO is the architect's finding about itself.

Evidence base: `ai-router/workspace/EXECUTOR-RUNLOG.md`.

## From 080-knowledge-capture.md


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

## 3b. Teaching Notes to the Owner (`agent-notes`)

Owner ruling 2026-07-23. Sections 1–3 capture knowledge for *agents*; this one
captures it for the *owner*. Whenever an agent explains something instructive
in chat — how a mechanism works, why an approach was chosen, a diagnosis worth
keeping — that explanation is also written to `~/Documents/agent-notes/`.

- Filename `YYYY-MM-DD-topic.md`, **English/ASCII** (the note body may be in
  any language).
- Header names the author agent, the repo, and the session id, so a note can
  be traced back to the work that produced it.
- The authoritative format lives in that folder's own `README.md`; follow it
  rather than re-inventing a layout here (rule 045: one home per piece of
  knowledge).

Chat scrolls away and sessions are cleared. An explanation that existed only
in a transcript will be asked for — and re-derived — a second time.

## 3c. Content Strategy Register (Owner Decree 2026-08-09)

Owner ruling 2026-08-09. Content-production strategy — broken down **by
platform** — is a standing knowledge asset, not a one-off chat answer: it
must be captured as a durable reference in the Obsidian vault so it can be
found again, reused across projects, and refined over time instead of being
re-derived from scratch each time the topic comes up.

- **Location:** `<vault>/idea/35-Content-Strategy/`, with one note per
  platform category (e.g. YouTube, LinkedIn) plus an index MOC —
  `35-Content-Strategy-MOC.md` — following the vault's existing `NN-Area/`
  convention (see `00-Home.md`).
- **What goes in:** validated strategies, not raw ideas — a rule of thumb
  with the reasoning behind it, e.g. *"test demand with several short-form
  videos in a topic before committing to a long-form one; this caps the
  cost/time sunk into a long video nobody watches."* Each entry names the
  platform, the rule, and the reasoning; a rule without its reasoning is not
  reusable when circumstances change.
- **Growth model:** append-only and refined over time — a new validated
  strategy is a new entry or an edit to an existing one, never a rewrite that
  drops prior reasoning. One note = one platform's strategy set, per the
  vault's own "one note = one idea" rule (`00-Home.md`).
- This is the vault-side complement to §3b: 3b captures explanations for the
  owner, this captures **operational content strategy** so it compounds
  instead of being re-explained on demand.

## 4. Fail-Closed Gate: Knowledge Capture Report

TRIVIAL sessions are exempt from this field. For MODERATE and CRITICAL sessions, the `SessionEnd` digest **MUST** include a `knowledge-capture:` field detailing:

- `status`: `COMPLETED` / `PARTIAL` / `N/A` (no reusable knowledge emerged).
- `summary`: A concise description of the captured knowledge.
- `artifacts`: A list of paths to updated or newly created skill files or documentation.
- `reason_for_partial/NA`: If status is `PARTIAL` or `N/A`.

Failure to include this field, or an incomplete report for MODERATE/CRITICAL sessions, will trigger a review gate failure and require remediation.

## From 085-orchestration-topology.md


## The Topology Law

```
owner ── talks to ──▶ MANAGER (watches @-github, cross-repo only)
                         │ assigns a task (a note / pointer, not code)
                         ▼
                     ARCHITECT (one per repo) ── writes the WO
                         │ delegates
                         ▼
                     WORKER (Gemini 3.1 Pro; $0-first) ── implements
                         │ delivers back
                         ▼
   REVIEWER-1 (independent) ─▶ fix+amend ─▶ REVIEWER-2 ─▶ architect sign-off
                         │
                         ▼
             owner gets test / merge / push command block
```

## Message addresses

- `<agent inbox> = /Users/su6i/.local/share/agent-projects/<project>/workspace/inbox/`
- Manager inbox: `/Users/su6i/.local/share/agent-projects/@-github/workspace/inbox/`

Inboxes live in the vault, never inside a git repo. No agent may invent a mailbox path.

## Manager Charter: The Queue

The manager maintains ONE cross-project queue (`_memory/QUEUE.md`) that sequences every task across every repo. Every WO must appear in the queue with a tier + gate; a WO not in the queue is invisible and won't run.

**The manager's own WOs live in `_memory/wo/`, never in
`agent-projects/@-github/workspace/wo/`.** `@-github` is the manager's
umbrella, not a repo with its own code — any WO the manager writes is
cross-project by construction, so rule 070's single-repo path
(`agent-projects/<repo>/workspace/wo/`) never applies to it, no matter how
natural that path looks by analogy with the manager's own inbox
(`agent-projects/@-github/workspace/inbox/`, above). See rule 070 §WO
location for the full split and D-029 (2026-08-09) for the incident this
closes; a PreToolUse guard (`templates/claude-code-hooks/workdir-guard.sh`)
denies the wrong path mechanically.

## Idea-to-WO Immediacy (Owner Decree 2026-08-09)

**Every topic or idea handed to the manager immediately calls a warm
architect to write a WO and place it in the queue — no exceptions, nothing
deferred.** An idea that is only "noted" in a chat reply is a lost idea: chat
scrolls away, sessions get `/clear`ed, and a note that never became a WO
never enters `_memory/QUEUE.md`, so it is invisible to every future session
(§Manager Charter above). Taking a note in the chat response is not a
substitute for writing the WO — it is, at most, the raw material for one.

Concretely: the owner names a topic → the manager spawns (or resumes) that
repo's architect in the same turn → the architect writes the WO (rule 070
format, in the correct location per §Manager Charter above) → the WO is
added to `_memory/QUEUE.md` with a tier and gate, even if the gate is "needs
owner decision" or "blocked on X". A topic without a WO-in-the-queue does not
count as handled, regardless of how much was said about it in chat.

## End-to-End Management Workflow

1. **owner** → manager (message)
2. **manager** → writes task-note to repo architect's inbox (metadata + pointers only)
3. **architect** → writes WO in `<repo>/workspace/wo/` (rule 070 format) —
   this step is for a repo architect's own repo only; the manager's own
   cross-project WOs follow §Manager Charter above, never this path
4. **architect** → calls worker (agy $0 default) to implement
5. **worker** → implements on a feature branch
6. **reviewer** (headless architect, fresh context) → code review, verdict only
   - Max 2 review rounds. Reviewer must label each finding **blocking** vs **cosmetic**; a round is triggered only by blocking findings.
   - If still failing after 2 rounds, escalate to owner with the option to "authorize one more round", do not silently merge.
7. **architect** → commit/amend on branch
8. **owner** → approves merge (owner-only per rule 040)
9. **architect** → reports ONE status line to manager
10. **manager** → reports outcome to owner

*Data flow constraint*: Metadata up, never code/diffs to manager.

## Three-Layer Delegation

Steps 4–7 above have a fixed shape for implementation WOs. The owner approved
it on 2026-07-21; it stayed a proposal and sessions therefore ignored it. It is
a rule from 2026-07-28.

Default for an implementation WO of roughly 200–500 lines (code + tests +
docs). Each layer does only what the layer below cannot:

| Layer | Agent | Does | Must not |
|---|---|---|---|
| 3 — architect | premium (Opus/Fable) | writes the WO, dispatches layer 2, runs a short independent final check (git log + tests + lint) | read the full diff, implement |
| 2 — dispatcher/reviewer | Sonnet subagent | dispatches the WO to the worker, reviews architect-style (tests from a neutral CWD, DoD checked live, executor claims distrusted), repairs and amends on the branch, hands up **only with green tests** | author the WO it reviews |
| 1 — worker | agy / Gemini 3.1 Pro (`$0`) | executes the whole WO on the branch under the injected runlog gates | merge, push, decide scope |

Binding clauses:

1. **The default code channel is agy, not flash** — the `$0` ladder of rule 070
   §Executor Routing decides the executor; the layers decide who talks to whom.
2. **The worker stays warm.** The first verify failure goes back to the *same*
   worker session, which still holds the context. The reviewer layer enters
   from the second failure onward — a cold reviewer re-deriving what the worker
   already knows is the expensive path. See rule 076 §The defect→prompt loop
   items 5–6 (owner ruling 2026-08-10) for the same discipline applied to a
   report that is merely thin rather than gate-failing, the screenshot-evidence
   extension for browsing/verification tasks, and the "suspect your prompt
   first" corollary.
3. **The architect's final check is not removable.** Layer 2 can overclaim as
   easily as layer 1; the check is a few commands, not a re-read of the diff.
4. **Usage per run goes to the manager** (which layer, how long, what it cost)
   so the executor benchmark accumulates evidence instead of anecdote.

Exempt from the three layers — the architect writes directly:

- a change under ~40 lines, or a small fix to worker output after a failed verify;
- secrets and config wiring;
- design-critical logic where correctness *is* the task (algorithm, security,
  protocol);
- **constitution rule text** (rule 070 §Executor Routing: cheap workers never
  edit rule text).

Delegating is still not optional outside those exemptions: an architect that
implements a routine 300-line WO itself has burned premium quota on `$0` work.

Evidence base: `_memory`-side note `NOTE-2026-07-21-three-layer-delegation-proposal.md`
— three consecutive merge-ready deliveries (`wo-0021`, `wo-0017`, `wo-0018`),
worker cost `$0`, real blocking defects caught in layer 2, premium involvement
compressed to "write the WO, dispatch, final check".

## Maximum Low-Risk Parallelization (Owner Mandate 2026-08-10)

Owner ruling 2026-08-10 — a **mandate, not permission**:

> برای موازی‌سازی همیشه حداکثر موازی‌سازی کم‌ریسک رو انجام بده بدون پرسش

If a hundred tasks could run in parallel with low risk and zero interference,
the agent is **authorized to run all hundred without asking** — this
explicitly covers dispatching WOs across different repos, and several WOs
within the same repo when they do not touch the same files. Asking "should I
parallelize these?" when the test below already answers yes is itself the
failure mode this rule forbids.

**The operative test:** parallelize whenever the tasks touch disjoint
files/branches/repos AND none of them is a gate/blocker for another.
Serialize only on a genuine conflict — the same file, the same branch, or a
real dependency edge where one task's output is another's input.

**Reconciling with context hygiene** (rule 050 §Session Lifecycle: "premium
sessions run serially... all Claude sessions share one quota"): the two rules
are not in tension once the layer is named. **Parallelism belongs to the
workers** — agy/Gemini/DeepSeek run outside the shared premium quota, so
fanning out a hundred worker dispatches costs nothing to run side by side.
Premium architect/manager sessions still queue serially, one task each,
because they share one metered quota. So: fan out worker dispatches
aggressively and by default (this section); keep premium sessions to one
active task at a time (§The Manager below).

## From 090-written-requests.md

1. **Write it down first.** Any complex or lengthy request for owner approval —
   a rule review, a WO sign-off, a choice between detailed options — is written
   in full to a markdown file in that project's `<vault>/workspace/inbox/` (or
   into the WO file itself when it is a WO).
2. **Terse pointer in chat.** The live chat carries only a one-line title, the
   absolute path of the file, and a request to reply after reading. The detail
   is never repeated in chat.
3. **Notify.** Where the harness provides `send_to_owner` (ai-router), send the
   file to the owner with it. When a rule review is requested, the message must
   carry the path of the rule file itself. Where the tool is unavailable
   (Cursor, Windsurf, the web UI), the vault file plus the chat pointer is
   sufficient — this rule never requires a tool the agent does not have.
4. **Exceptions.** A short, single-context question may be asked directly in
   chat. And this rule does **not** override rule 000 §Commands or rule 040
   §Review: copy-pasteable command blocks are always printed in the chat, in
   full, with absolute paths.

## From 095-rule-change-broadcast.md

Any merge into `main` that adds, deletes, or edits a file under `rules/` is a
**rule change** and triggers all three of the following. Partial compliance is
non-compliance — an un-re-indexed change is invisible to every agent that asks
the knowledge service instead of reading the file.

1. **CHANGELOG entry** in the constitution repo, naming the rule file and what
   changed in it — not "updated rules". This is the durable record; the other
   two steps are delivery.
2. **Broadcast note** to the inbox of every active architect, sent through the
   ai-router note channel (`send_note`), addressed per rule 085 §Message
   addresses. Content: rule number, one line on what changed, the absolute path
   of the file — pointer only, never the rule text (rule 045: one home per
   piece of knowledge). Open sessions are reached by the note landing in the
   inbox they triage at their next task boundary (rule 050).
3. **RAG re-index** triggered for the rules corpus.

Ownership, so that none of the three is nobody's job:

- The **architect who merged the change** sends the note and triggers the
  re-index. It is part of the merge, not a follow-up task.
- The **ai-router architect owns the RAG index** — its build, its freshness,
  and the trigger endpoint. Other architects call the trigger; they never
  reach into the index.
- The **manager audits weekly**: for each rule-touching CHANGELOG entry of the
  past week, was a note sent and was the index re-indexed after it. A miss is
  reported to the owner, not silently repaired.

**Constitution-side changes ripple by symlink** (`.agent/constitution ->`
the repo, rule 085): consuming repos need no pull, which is exactly why the
change is silent and needs announcing.

<!-- digest-hash: 295aa269f1fb09375c1c20de365ff408e50767cc07d97d96a4cddb3018f2d566 -->
