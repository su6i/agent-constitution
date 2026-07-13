# Rules Digest — Non-Negotiables (auto-generated)

<!-- DO NOT EDIT. Re-run `bin/generate-digest.sh` to regenerate. -->
<!-- Source: rules/*.md  ·  Mechanism: rules/045 §Digest Mechanism  -->
<!-- Generated: 2026-07-13 -->
## From 000-core.md

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
translations, in exactly these forms:

- files under a dedicated translation folder — `docs/fa/` (canonical) or a
  root `fa/` folder in repos that already have one;
- translation files suffixed `*.fa.md` (e.g. `README.fa.md`).

The single allowed exception outside those paths: one linking word/phrase in
`README.md` pointing to the Persian docs.

Enforcement is mechanical, not prose: the pre-commit hook and CI scan staged
added lines for Arabic-script characters (U+0600–U+06FF) outside the allowed
paths and block the commit; a periodic sweep tool cleans up pre-existing
content.
Every error you observe — lint, type, test, build, LaTeX, runtime, deprecation
warning — must be either **fixed now** or **recorded in the central
`_memory/TODO.md`** (the project's `## <project>` section — rule 050) for later.
Seeing an error and moving on without doing one of those two is forbidden.

- "It was already there" / "not caused by my change" is **not** a reason to
  ignore it — record it.
- When you defer a fix (e.g. to keep a commit's scope clean), immediately add an
  item under the project's section in the central `_memory/TODO.md` with the
  exact `file:line` and the error message.
- Applies to errors surfaced by any tool you run, not only the files you edited.## From 035-data-vault.md

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
rule-035/040 incident — scrub it (`git filter-repo`) and force-push.## From 036-skill-versioning.md

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
status as code changed without updating docs (`040-git`). Do not commit it.## From 040-git.md

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
   The message MUST contain, per `000-core` "Commands Given to the User":
   - the exact verification command(s) — copy-pasteable, absolute paths,
     one per line;
   - the **expected result of each command** (what PASS looks like, what
     output means FAIL);
   - any cleanup command if the test creates artifacts.
   The user has no way to know how to test what the agent just built —
   telling them *how* is part of delivering the work.
3. **User reviews** and reports any issue.
4. **Agent amends** — fixes belonging to the same task go in with
   `git commit --amend`, **never** as a new commit. The branch keeps exactly
   one commit per task.
5. **Only after explicit approval:** agent runs `git merge` + `git branch -d`.
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
  `git rm --cached <file>` and add it to `.gitignore` — do not just edit it.## From 045-single-source-docs.md

Every piece of project knowledge has exactly one home:

| Content | Single home | Everything else holds |
| --- | --- | --- |
| Public design / architecture / ADRs | Repo docs (`ARCHITECTURE.md`, `docs/`) | a pointer |
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
   force-push the rewrite and note it in the central TODO.## From 050-session-start.md

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
2. If it exists: read it and announce all open items grouped by priority level
3. Announce **open branches**: run `bin/open-branches.sh --here` (or `git branch --no-merged main`) and list any unmerged / stale (>14 days) branches so they get finished, merged, or deleted — half-done branches must not be forgotten.
4. Ask: "Where do we start?"
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
session end (`_memory/handoffs/*.jsonl`), so nothing is ever truly lost; but the
curated, readable `SESSION.md` is the **agent's** job — update it proactively when
the owner signals wrap-up, before any `/clear`.

- **Never `/clear` mid-task.** Finish the step, update `SESSION.md`, then clear.
- **Between tasks:** write `SESSION.md`, then `/clear` (or `/compact` above
  ~100k context). The state is externalised, so clearing loses nothing.
- **Architect sessions** (design/review, premium model): one task per session;
  reference earlier work by re-reading `SESSION.md`/`TODO.md`, **not** by keeping
  a fat context alive — >150k context is where subscription quota burns.
- **Worker sessions** (cheap models): `/clear` freely; their state is the WO file
  plus the git branch, both external.

The rule is: **externalise the useful part, then context is cheap to reload and
`/clear` costs nothing.** Preserving raw context in the window instead is the
expensive anti-pattern.## From 070-work-orders.md

1. **Executor** — the exact agent/model that will run it, e.g. `gemini`
   (free), `deepseek-flash`, `deepseek-pro`, `minimax-3 (CodeWhale)`,
   `sonnet`, `fable/opus`. Routing ladder, cheapest first:
   gemini → deepseek-flash → deepseek-pro/minimax-3 → premium.
   If the executor is a premium model, a **`Why premium:`** line is
   mandatory — implementation work defaults to cheap models; premium is for
   design-critical logic only.
2. **Base rules** — explicit paths of the rule files the WO was written
   against (at minimum `rules/000-core.md` and `rules/040-git.md`), plus an
   order to the executor: read `rules/DIGEST.md` (or the listed files)
   **before writing anything**. A WO without rule references is invalid.
3. **Complexity** — TRIVIAL / MODERATE / CRITICAL (rule 000).
- Phases sized for one branch + one commit each (rule 040); executor stops
  for review between phases.
- **Script-first:** anything bash/python can do must be specified as a
  script, not as LLM work — scripts can be automated or handed to the
  cheapest executor.
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
2. **Reviewer** (architect or reviewer agent): read the diff against the WO —
   scope creep, content deleted without being ordered, tests faked or
   skipped, docs not updated. Verdict recorded in the WO file under a
   `## Review` appendix (date, verdict, findings).
3. Only then does the owner approve, and the merge happens (rule 040).

An execution report without the review verdict is not mergeable. The
executor's "ready to test" message must itself follow rule 040 §Review —
test commands with expected results, never just merge/push commands.
<!-- digest-hash: 7147a243d6d15bd9971b7d2997b2060ac85e69de961eb06e8fe8a3502686e017 -->
