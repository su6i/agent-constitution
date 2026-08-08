# Claude Code session-protection hooks

Claude Code hooks (`settings.json` — NOT git hooks) that guarantee no session data
is lost across `/compact`, `/clear`, and exit.

| Hook | Event | What it does | Mandatory / Optional |
|---|---|---|---|
| `save-handoff.sh` | `PreCompact`, `SessionEnd` | Backs up the full raw transcript → `_memory/handoffs/<ts>_<event>_<sid>.jsonl` (keeps 40) | Mandatory (اجباری) |
| `save-summary.sh` | `PostCompact` | Appends the compaction summary → `<vault>/workspace/SESSION.md` (readable digest) | Mandatory (اجباری) |
| `session-resume.sh` | `SessionStart` | Injects a continuity pointer (central TODO section + latest backup) & inbox notes per rule 050 | Mandatory (اجباری) |
| `session-snapshot.sh` | `SessionEnd` | Appends a mechanical repo snapshot (branch, last commit, dirty count, ahead/behind) to SESSION.md and global log | Mandatory (اجباری) |
| `workdir-guard.sh` | `PreToolUse` (Write\|Edit) | Enforces blast-radius gate: prevents cross-repo edits & WO/workspace leakage into working trees | Mandatory (اجباری) |
| `check-session-saved.sh` | `SessionEnd`, `PostToolUse` (git commit/push), `Stop` | Fail-closed gate preventing clear/exit if SESSION.md is older than recent commits | Mandatory (اجباری) |
| `stop-session-save.sh` | `Stop` | Systemic safety net: triggers background digest if commit was made but SESSION.md skipped | Mandatory (اجباری) |
| `session-narrative-end.sh` | `SessionEnd` | Background wrapper for AI narrative summary generator | Optional (اختیاری) |
| `session-narrative-end.py` | Background | Generates AI narrative summary of transcript span and appends to SESSION.md. Keeps two state files in `~/.claude/hooks/`: `.digest-offsets.json` (last digested byte per transcript) and `.digest.lock` (serialises overlapping runs — see note below) | Optional (اختیاری) |
| `block-ai-attribution.py` | `PreToolUse` (Bash) | Pre-commit check blocking commit messages containing AI attribution trailers/emojis | Mandatory (اجباری) |
| `context-warn.py` | `PostToolUse` (*) | Emits context warning at 100k and 150k token thresholds | Optional (اختیاری) |
| `herdr-agent-state.sh` | `SessionStart` | Reports Claude session state to Herdr pane manager (if active) | Optional (اختیاری) |
| `context-checkpoint.py` | `PreToolUse` (*) | Forced live checkpoint every 50k context tokens & before `git commit` → `_memory/handoffs/checkpoints/` | Mandatory (اجباری) |

The vault write is gated on `_memory/REGISTRY.md` or a repo under `$HOME/@-github/`, so benchmark and throwaway directories never create a vault.

## Why `session-narrative-end.py` takes a lock

`SessionEnd` fires once per end reason (`clear`, `logout`, `prompt_input_exit`,
`other`) and the `.sh` wrapper detaches each run with `nohup`, so two runs can
overlap. Because the transcript offset only advances *after* the 1–3 minute model
call, both would read the same stale offset and both append — which produced
byte-identical digests minutes apart. An exclusive `flock` spans the whole
read-offset → summarise → append → write-offset sequence; the second run then
re-reads an advanced offset and exits early.

Do **not** "fix" a repeated digest by skipping when the session id already
appears in SESSION.md. One session id legitimately spans many digests across
`/clear` and resume, and that exact guard once caused long sessions to be saved
only once, ever.

## Install

Run `install.sh` from the repository root:

```bash
bash install.sh
```

Or for a dry-run check:

```bash
bash install.sh --dry-run
```

`install.sh` automatically installs all hooks into `~/.claude/hooks/` with automatic backups (`.bak-<date>`) if destination files differ, and idempotently merges `settings.snippet.json` into `~/.claude/settings.json` (backing up settings to `<vault>/_memory/backups/`).

Slug resolution matches `035-data-vault` (git remote basename, lowercased). Requires `jq`.
