---
title: "090: Written Request Protocol"
description: Long approval requests to the owner go in a file; the chat carries only a one-line pointer.
location: rules/090-written-requests.md
agent_priority: High
last_updated: 2026-07-27
---

# Written Request Protocol

Chat is volatile and expensive; a file is durable and free to re-read. Any
request for owner approval that is longer than a few lines therefore moves out
of the chat and into a file.

<!-- digest:start -->
1. **Write it down first.** Any complex or lengthy request for owner approval —
   a rule review, a WO sign-off, a choice between detailed options — is written
   in full to a markdown file in that project's `<vault>/workspace/inbox/` (or
   into the WO file itself when it is a WO).
2. **Terse pointer in chat.** The live chat carries only a one-line title, the
   absolute path of the file, and a request to reply after reading. The detail
   is never repeated in chat.
3. **Notify.** Where the harness provides `send_to_owner` (ai-router), send the
   file to the owner with it. When a rule review is requested, the message must
   carry the path of the rule file itself. Where the tool is unavailable
   (Cursor, Windsurf, the web UI), the vault file plus the chat pointer is
   sufficient — this rule never requires a tool the agent does not have.
4. **Exceptions.** A short, single-context question may be asked directly in
   chat. And this rule does **not** override rule 000 §Commands or rule 040
   §Review: copy-pasteable command blocks are always printed in the chat, in
   full, with absolute paths.
<!-- digest:end -->

## Why this rule exists

Owner ruling 2026-07-21, reaffirmed 2026-07-27. Long requests pasted into chat
burn premium context on every round trip, and are lost the moment the session
is cleared — four inbox notes went unanswered in one night because the request
lived only in a chat window.
