#!/usr/bin/env python3
"""context-checkpoint.py — PreToolUse hook: forced, live state checkpoint.

Owner ruling 2026-08-04: "دیگه هرگز نمی‌خوام حتی یه بار هم به اجنت بگم چرا ذخیره
نکردی؟" — saving must not depend on the model remembering to save. So it is bolted
to a tool event instead:

  * every 50k tokens of context  -> checkpoint (50k, 100k, 150k, 200k, ...)
  * immediately before any commit -> checkpoint (`git commit` in a Bash call)

Each checkpoint copies the full session transcript, so a sudden crash/outage costs
at most the work done since the last 50k step. One checkpoint per threshold per
session (marker files), so it never spams.

Fail-open by contract: any error exits 0 silently. A broken save hook must never
block the session — but it also must never be silent about success, hence the
systemMessage the owner asked for.
"""
import json
import shutil
import sys
import tempfile
import time
from pathlib import Path

STEP = 50_000
DEST = Path.home() / ".local/share/agent-projects/_memory/handoffs/checkpoints"
KEEP = 60


def context_tokens(transcript: Path) -> int:
    """Current context size = last assistant usage block (input + both caches)."""
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
            return (usage.get("input_tokens", 0)
                    + usage.get("cache_read_input_tokens", 0)
                    + usage.get("cache_creation_input_tokens", 0))
    return 0


def is_commit(payload: dict) -> bool:
    if payload.get("tool_name") != "Bash":
        return False
    cmd = (payload.get("tool_input") or {}).get("command", "")
    return "git commit" in cmd


def checkpoint(transcript: Path, sid: str, label: str) -> bool:
    try:
        DEST.mkdir(parents=True, exist_ok=True)
        ts = time.strftime("%Y%m%d-%H%M%S")
        shutil.copy(transcript, DEST / f"{ts}_{label}_{sid}.jsonl")
        old = sorted(DEST.glob("*.jsonl"), key=lambda p: p.stat().st_mtime,
                     reverse=True)[KEEP:]
        for f in old:
            f.unlink(missing_ok=True)
        return True
    except Exception:
        return False


def main() -> None:
    try:
        payload = json.load(sys.stdin)
        tp = payload.get("transcript_path")
        if not tp or not Path(tp).is_file():
            return
        transcript = Path(tp)
        sid = str(payload.get("session_id", "nosession"))[:8]
        state = Path(tempfile.gettempdir()) / f"ckpt-{sid}"
        state.mkdir(parents=True, exist_ok=True)

        # --- forced save right before a commit -------------------------------
        if is_commit(payload):
            marker = state / f"commit-{int(time.time() // 300)}"  # <=1 per 5 min
            if not marker.exists():
                marker.touch()
                if checkpoint(transcript, sid, "precommit"):
                    print(json.dumps(
                        {"systemMessage": "💾 سشن ذخیره شد — چک‌پوینتِ پیش از کامیت"},
                        ensure_ascii=False))
            return

        # --- every 50k of context -------------------------------------------
        tokens = context_tokens(transcript)
        step = (tokens // STEP) * STEP
        if step < STEP:
            return
        marker = state / str(step)
        if marker.exists():
            return
        marker.touch()
        if checkpoint(transcript, sid, f"{step // 1000}k"):
            print(json.dumps(
                {"systemMessage": f"💾 سشن ذخیره شد در {step // 1000} هزار توکن"},
                ensure_ascii=False))
    except Exception:
        return


if __name__ == "__main__":
    main()
