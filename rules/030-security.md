---
title: "030Security: Secret Protection"
description: Mandatory security standards and secret protection rules.
location: rules/030-security.md
agent_priority: Critical
last_updated: 2026-02-21
---

# Security Rules

## NEVER

- Never write any API key, password, or token directly in the code
- Do not add `.env` file to git (must be in .gitignore)
- Never log any secret
- Do not use `eval()` or `exec()` with user input
- Do not construct SQL queries with f-strings (SQL injection)

## Correct Pattern for Secrets

```python
import os
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv("DEEPSEEK_API_KEY")  # ✅ Correct
API_KEY = "sk-1234..."                    # ❌ Forbidden
```

## Check before every commit

- `git diff --staged | grep -i "api_key\|secret\|password\|token"`
- If there are results: STOP and report

## If a Secret or Legal/Privacy Violation Was Already Committed (Non-Negotiable)

A new commit that removes or fixes the value is **not sufficient** — the
exposed data still exists in every prior commit, in the reflog, and on any
remote/fork that already fetched it.

1. STOP. Do not push if the bad commit hasn't left the local repo yet.
2. Rotate/revoke the exposed credential immediately (it must be treated as
   compromised regardless of whether history gets cleaned).
3. Purge it from history with `git filter-repo` (preferred) or BFG Repo-Cleaner
   — a plain `git revert`/fixup commit is not acceptable.
4. This rewrites history and requires a force-push: get **explicit user
   approval** before running it, per the Merge Gate and the global rule
   against destructive git operations.
5. After the force-push, tell the user any other clone/fork must be
   re-cloned — the old history is still reachable from anyone who already
   has it.
