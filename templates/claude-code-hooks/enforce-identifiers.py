#!/usr/bin/env python3
"""enforce-identifiers.py — Stop hook.

Enforces rule 075: prevents the assistant from presenting ad-hoc numbered lists
to the owner. Requires stable identifiers (B-, T-, D-, N- with 3-4 digits).
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

    lines = message.splitlines()
    bare_items = []
    
    for line in lines:
        if list_marker.match(line):
            if not id_pattern.search(line):
                bare_items.append(line)

    if bare_items:
        reason = (
            "Rule 075 violation: Ad-hoc numbering detected in your final message.\n"
            "Decision/action lists presented to the owner must use stable identifiers "
            "(B-, T-, D-, or N- followed by 3-4 digits). Do NOT use bare '1/2/3' numbering.\n"
            "Please rewrite your message to assign or reuse IDs from _memory/REGISTRY-IDS.md."
        )
        print(json.dumps({"decision": "block", "reason": reason}))
        return 0

    return 0

if __name__ == "__main__":
    sys.exit(main())
