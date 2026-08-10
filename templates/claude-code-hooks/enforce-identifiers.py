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
"""
import sys
import json
import re

def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0

    message = payload.get("message", "")
    if not message:
        return 0

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
        print(json.dumps({"decision": "block", "reason": reason}))
        return 0

    return 0

if __name__ == "__main__":
    sys.exit(main())
