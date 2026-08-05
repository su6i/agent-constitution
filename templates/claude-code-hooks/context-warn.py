#!/usr/bin/env python3
"""context-warn.py — PostToolUse hook: warn once per threshold when the
session context approaches the expensive zone (/usage evidence 2026-07-13:
95% of quota burn happened at >150k context).

Reads the session transcript (JSONL), takes the LAST assistant message's
usage block, estimates current context = input + cache_read + cache_creation
tokens, and emits a systemMessage at 100k and again at 150k — once each per
session. Fail-open: any error exits silently; a broken hook must never
block work.
"""
import json
import sys
import tempfile
from pathlib import Path

THRESHOLDS = [100_000, 150_000]
MSG = ("⚠️ کانتکست ~{k}k توکن شد — قدم فعلی را تمام کن، SESSION.md را "
       "به‌روز کن، بعد /compact (یا برای تسک بعدی /clear). "
       "(۹۵٪ مصرف سهمیه در >150k اتفاق می‌افتد)")


def last_context_tokens(transcript: Path) -> int:
    best = 0
    try:
        lines = transcript.read_text().splitlines()
    except Exception:
        return 0
    for line in reversed(lines[-200:]):
        try:
            rec = json.loads(line)
        except Exception:
            continue
        usage = (rec.get("message") or {}).get("usage")
        if usage:
            best = (usage.get("input_tokens", 0)
                    + usage.get("cache_read_input_tokens", 0)
                    + usage.get("cache_creation_input_tokens", 0))
            break
    return best


def main() -> None:
    try:
        payload = json.load(sys.stdin)
        tp = payload.get("transcript_path")
        sid = payload.get("session_id", "nosession")
        if not tp:
            return
        tokens = last_context_tokens(Path(tp))
        state_dir = Path(tempfile.gettempdir()) / f"context-warn-{sid}"
        state_dir.mkdir(parents=True, exist_ok=True)
        for th in THRESHOLDS:
            marker = state_dir / str(th)
            if tokens >= th and not marker.exists():
                marker.touch()
                print(json.dumps(
                    {"systemMessage": MSG.format(k=th // 1000)},
                    ensure_ascii=False))
                return  # one warning per event is enough
    except Exception:
        return


if __name__ == "__main__":
    main()
