#!/usr/bin/env python3
"""session-transcript-pointer.py — SessionStart hook: inject transcript pointers.

Injects the current session's raw .jsonl transcript path (and previous ones)
into context at session start. After a /clear, SESSION.md only retains what was
curated; the raw transcript contains the exact commands, errors, and unrecorded
outputs. Providing this path automatically allows the agent to grep past logs
directly rather than stating it lacks context. Fail-open: any error exits
cleanly with valid JSON; a broken hook must never block session start.
"""
import datetime as dt
import json
import os
import re
import sys
from pathlib import Path

MAX_PREVIOUS = 1
MAX_BLOCK_CHARS = 600


def build_transcript_block(data: dict) -> str:
    path = data.get("transcript_path") or ""
    sid = data.get("session_id") or ""
    proj_dir = None

    if path:
        proj_dir = Path(path).parent
    else:
        # Fall back to the on-disk layout: ~/.claude/projects/<slug>/<session-id>.jsonl
        # where <slug> replaces any non-alphanumeric character with '-'.
        # Verified against real directory layout: e.g. "/@-github" becomes "---github".
        try:
            cwd = data.get("cwd") or os.getcwd()
        except Exception:
            cwd = ""
        slug = re.sub(r"[^A-Za-z0-9]", "-", cwd) if cwd else ""
        if slug:
            proj_dir = Path.home() / ".claude" / "projects" / slug
            if sid:
                path = str(proj_dir / f"{sid}.jsonl")

    lines = [
        "## Raw transcript (not in SESSION.md — grep it before saying you don't know)"
    ]
    if path:
        lines.append(f"this session : {path}")

    if proj_dir:
        try:
            if proj_dir.is_dir():
                others = sorted(
                    (f for f in proj_dir.glob("*.jsonl") if str(f) != path),
                    key=lambda f: f.stat().st_mtime,
                    reverse=True,
                )
                for prev in others[:MAX_PREVIOUS]:
                    when = dt.datetime.fromtimestamp(prev.stat().st_mtime).strftime(
                        "%Y-%m-%d %H:%M"
                    )
                    lines.append(f"previous     : {prev}  ({when})")
        except Exception:
            pass

    if len(lines) == 1:
        return ""
    return "\n".join(lines)[:MAX_BLOCK_CHARS]


def main() -> None:
    out = {
        "hookSpecificOutput": {
            "hookEventName": "SessionStart",
            "additionalContext": "",
        }
    }
    try:
        raw = sys.stdin.read()
        try:
            payload = json.loads(raw) if raw.strip() else {}
        except Exception:
            payload = {}

        if not isinstance(payload, dict):
            payload = {}

        block = build_transcript_block(payload)
        out["hookSpecificOutput"]["additionalContext"] = block
    except Exception:
        pass
    finally:
        try:
            print(json.dumps(out))
        except Exception:
            print("{}")
        sys.exit(0)


if __name__ == "__main__":
    main()
