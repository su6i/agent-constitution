# Claude Code session-protection hooks

Claude Code hooks (settings.json — NOT git hooks) that guarantee no session data
is lost across `/compact`, `/clear`, and exit.

| Script | Event | What it does |
|---|---|---|
| `save-handoff.sh`  | PreCompact, SessionEnd | Backs up the full raw transcript → `_memory/handoffs/<ts>_<event>_<sid>.jsonl` (keeps 40) |
| `save-summary.sh`  | PostCompact | Appends the compaction summary → `<vault>/workspace/SESSION.md` (readable digest) |
| `session-resume.sh`| SessionStart | Injects a continuity pointer (central TODO section + latest backup) so the agent resumes per rule 050 |

## Install

1. `cp templates/claude-code-hooks/*.sh ~/.claude/hooks/ && chmod +x ~/.claude/hooks/*.sh`
2. Merge `settings.snippet.json` into `~/.claude/settings.json` (merge the `hooks` arrays — do not replace existing hooks). `autoCompactWindow: 200000` opts into automatic trimming (safe, because PreCompact backs up first).
3. Open `/hooks` once (or restart) so Claude Code reloads config.

Slug resolution matches `035-data-vault` (git remote basename, lowercased). Requires `jq`.
