#!/usr/bin/env python3
"""Block a git commit whose *message* carries AI attribution.

Constitution rule 040-git: "No AI co-authorship — ever." Each repo already
enforces this with a commit-msg hook, which is the authoritative check — it sees
the exact message git received. This hook exists only to save the rejected
round-trip by catching the message before git runs.

Because it is an optimisation and not the authority, it is deliberately biased
towards false negatives: it inspects only text that is genuinely part of a
commit message (-m/--message values, and -F/--file heredoc bodies) and never the
command line as a whole. Scanning the whole line blocks legitimate work — a
grep for the trailer, a test fixture, or documentation of this very rule all
contain both "git commit" and the banned string without creating a commit.

PreToolUse / matcher: Bash. Exit 2 = block and feed stderr back to the model.
"""
import json
import re
import shlex
import sys

PATTERNS = [
    (re.compile(r"co-authored-by\s*:", re.IGNORECASE), "Co-Authored-By trailer"),
    (re.compile(r"generated\s+with\s+\[?\s*claude", re.IGNORECASE), "'Generated with Claude'"),
    (re.compile(r"co-created\s+with\s+claude", re.IGNORECASE), "'Co-created with Claude'"),
    (re.compile("\U0001F916"), "robot emoji (U+1F916)"),
]

MESSAGE_FLAGS = {"-m", "--message"}
FILE_FLAGS = {"-F", "--file"}


def commit_messages(command: str):
    """Yield each chunk of text that will end up in a commit message."""
    try:
        tokens = shlex.split(command, comments=False)
    except ValueError:
        return  # unbalanced quotes — let git decide, do not guess

    # Require an actual `git ... commit` invocation, not a mention of one.
    try:
        git_at = tokens.index("git")
    except ValueError:
        return
    rest = tokens[git_at + 1:]
    subcommands = [t for t in rest if not t.startswith("-")]
    if not subcommands or subcommands[0] != "commit":
        return

    reads_from_stdin = False
    for i, token in enumerate(rest):
        if token in MESSAGE_FLAGS and i + 1 < len(rest):
            yield rest[i + 1]
        elif token.startswith("-m") and len(token) > 2:
            yield token[2:]                      # -m"msg"
        elif token.startswith("--message="):
            yield token.split("=", 1)[1]
        elif token in FILE_FLAGS and i + 1 < len(rest) and rest[i + 1] == "-":
            reads_from_stdin = True

    # `git commit -F -` takes the message from a heredoc later in the command.
    if reads_from_stdin:
        heredoc = re.search(r"<<-?\s*'?([A-Za-z_][A-Za-z0-9_]*)'?\n(.*?)\n\1",
                            command, re.DOTALL)
        if heredoc:
            yield heredoc.group(2)


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0

    if payload.get("tool_name") != "Bash":
        return 0

    command = payload.get("tool_input", {}).get("command", "") or ""
    message = "\n".join(commit_messages(command))
    if not message:
        return 0

    hits = [label for pattern, label in PATTERNS if pattern.search(message)]
    if not hits:
        return 0

    print(
        "BLOCKED: this commit message contains AI attribution "
        f"({', '.join(hits)}).\n"
        "Constitution rule 040-git: \"No AI co-authorship - ever.\"\n"
        "Rewrite the message with no attribution trailer, no 'Generated with' "
        "line and no robot emoji, then commit again.\n"
        "Note: the harness appends that trailer by default - strip it "
        "explicitly rather than relying on the default.",
        file=sys.stderr,
    )
    return 2


if __name__ == "__main__":
    sys.exit(main())
