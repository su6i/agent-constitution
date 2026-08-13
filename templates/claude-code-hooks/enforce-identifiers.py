#!/usr/bin/env python3
"""enforce-identifiers.py — Stop hook.

Enforces rule 075: prevents the assistant from presenting ad-hoc numbered lists
to the owner. Requires stable identifiers (B-, T-, D-, N- with 3-4 digits).

Two checks, both from rule 075 §Agent Obligations item 1:

1. Original check — a numbered list item ("1. ", "1)", "- 1. ") with no id
   anywhere on that line is ad-hoc numbering, forbidden outright.
2. Tightening, owner ruling 2026-08-10 — the owner reported the same
   violation in a different shape twice: a message carries a heading like
   "awaiting owner decision" / "منتظر تصمیم مالک" / "منتظر اقدام مالک", but
   nothing under that heading actually carries an id. That is the same
   violation (a decision/action list without stable ids) just moved to the
   end of the message instead of appearing as bare "1/2/3" — so it is
   blocked the same way. Only the first matching heading in the message is
   used as the scan start; everything from there to the end of the message
   must contain at least one id.

Payload note (fix 2026-08-10, T-072): the Stop event does NOT carry a
"message" field — it carries {session_id, transcript_path, cwd,
stop_hook_active}. The original version read payload["message"] and was
therefore a guaranteed silent no-op: it never once fired, which is exactly
what the owner reported ("the hook was supposed to be on this"). The final
assistant text is now read from the tail of the JSONL transcript instead.
"""
import sys
import json
import re


def last_assistant_text(transcript_path):
    """Return the text of the most recent assistant turn in the transcript."""
    try:
        with open(transcript_path, "r", errors="ignore") as f:
            lines = f.readlines()
    except Exception:
        return ""
    # Walk backwards: the last assistant record is the message about to be shown.
    for raw in reversed(lines[-400:]):
        try:
            obj = json.loads(raw)
        except Exception:
            continue
        if obj.get("type") != "assistant":
            continue
        content = (obj.get("message") or {}).get("content")
        if isinstance(content, str):
            return content
        if isinstance(content, list):
            parts = [b.get("text", "") for b in content
                     if isinstance(b, dict) and b.get("type") == "text"]
            text = "\n".join(p for p in parts if p)
            if text.strip():
                return text
            # tool-only turn: keep walking back to the last turn with prose
            continue
    return ""


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0

    # Loop guard (narrowed 2026-08-13, T-090 / D-065). The old form was
    # `if payload.get("stop_hook_active"): return 0`, which disabled this hook
    # after *any other* Stop hook blocked (e.g. the session-save gate). The
    # owner hit exactly that: the session-save gate blocked first, and the
    # rewritten message then sailed past the id check unexamined — the third
    # repeat of the same rule-075 violation. The anti-loop guard must only
    # cover THIS hook re-blocking the SAME text, so it is now keyed on a
    # fingerprint of the message this hook itself last blocked.

    message = payload.get("message") or ""
    if not message:
        message = last_assistant_text(payload.get("transcript_path") or "")
    if not message:
        return 0

    # Fingerprint of the exact text under review, scoped to this session.
    # Deliberately import-free and process-stable: Python's built-in hash() is
    # randomised per process (PYTHONHASHSEED) and cannot be used here, since
    # each hook invocation is a fresh process and this key must survive that.
    fingerprint = repr([
        str(payload.get("session_id") or ""),
        len(message),
        message[:200],
        message[-200:],
    ])
    marker = "/tmp/enforce-identifiers-last-block.txt"
    try:
        with open(marker, encoding="utf-8") as fh:
            if fh.read().strip() == fingerprint:
                # We already blocked this exact text once; blocking again would
                # be the infinite loop the old guard was protecting against.
                return 0
    except OSError:
        pass

    # Look for numbered lists that are likely action/decision lists for the owner.
    # Matches "1. ", "1)", "- 1. " etc.
    list_marker = re.compile(r"^\s*(?:-\s+)?\d+[\.\)]\s+")
    id_pattern = re.compile(r"[BTDN]-\d{3,4}")
    # Heading text that announces a closing owner decision/action list — English
    # and the two Persian phrasings the owner has actually used.
    heading_pattern = re.compile(
        r"owner['’]?s?\s*(decision|action)|منتظر\s*(تصمیم|اقدام)",
        re.IGNORECASE,
    )

    lines = message.splitlines()
    bare_items = []

    for line in lines:
        if list_marker.match(line):
            if not id_pattern.search(line):
                bare_items.append(line)

    # Tightening (owner ruling 2026-08-10): a decision/action heading with no
    # id anywhere after it in the message is blocked even if no line matched
    # the bare-numbered-list check above (e.g. the list uses bullets, or the
    # heading itself is the only line before the message ends).
    heading_line = None
    for i, line in enumerate(lines):
        if heading_pattern.search(line):
            heading_line = i
            break

    if heading_line is not None:
        tail = "\n".join(lines[heading_line:])
        if not id_pattern.search(tail):
            bare_items.append(lines[heading_line])

    if bare_items:
        reason = (
            "Rule 075 violation: Ad-hoc numbering detected in your final message.\n"
            "Decision/action lists presented to the owner must use stable identifiers "
            "(B-, T-, D-, or N- followed by 3-4 digits). Do NOT use bare '1/2/3' numbering.\n"
            "This also fires when a closing 'awaiting owner decision/action' heading "
            "has no id anywhere after it (owner ruling 2026-08-10) — the same violation "
            "in a different shape.\n"
            "Please rewrite your message to assign or reuse IDs from _memory/REGISTRY-IDS.md."
        )
        try:
            with open(marker, "w", encoding="utf-8") as fh:
                fh.write(fingerprint)
        except OSError:
            pass
        print(json.dumps({"decision": "block", "reason": reason}))
        return 0

    return 0

if __name__ == "__main__":
    sys.exit(main())
