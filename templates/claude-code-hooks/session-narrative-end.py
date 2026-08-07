#!/usr/bin/env python3
"""session-narrative-end.py — wo-6: SessionEnd hook, narrative summary.

Reads the SessionEnd hook JSON payload (saved to a temp file by the calling
.sh wrapper), extracts the transcript's human-readable text, and — unless the
session was trivial — asks the cheapest model (gemini, falling back to flash)
for a short narrative summary, then appends it to the project's
workspace/SESSION.md. Designed to be a no-op on any failure: never raises out
to the caller, never blocks session end (the .sh wrapper already backgrounds
this whole script).
"""
import fcntl
import json
import os
import re
import subprocess
import sys
from datetime import datetime
from pathlib import Path

DELEGATE = Path.home() / "@-github" / "ai-router" / "src" / "delegate.py"
EDIT_TOOLS = {"Edit", "Write", "NotebookEdit"}
GIT_MUTATION_RE = re.compile(r"\bgit\s+(commit|merge|push|rebase)\b")
MIN_USER_TURNS = 3

SECRET_PATTERNS = [
    re.compile(r"sk-[A-Za-z0-9]{20,}"),
    re.compile(r"AIza[0-9A-Za-z_\-]{35}"),
    re.compile(r"ghp_[A-Za-z0-9]{36}"),
    re.compile(r"xox[baprs]-[A-Za-z0-9-]+"),
    re.compile(r"(?i)\b(api[_-]?key|secret|password|token)\b\s*[:=]\s*\S+"),
]


def scrub(text: str) -> str:
    for pat in SECRET_PATTERNS:
        text = pat.sub("[REDACTED]", text)
    return text


VAULT = str(Path.home() / ".local" / "share" / "agent-projects")


def first_transcript_cwd(transcript_path: str) -> str:
    """The payload cwd follows the Bash tool's last `cd`, which can point
    anywhere (2026-07-20: a manager digest landed in executor-bench/ because
    the session ended cd'd into a benchmarks subdir). The first cwd recorded
    in the transcript is the directory the session was launched in."""
    try:
        with open(transcript_path, "r", errors="ignore") as f:
            for raw in f:
                try:
                    obj = json.loads(raw)
                except Exception:
                    continue
                c = obj.get("cwd")
                if c:
                    return c
    except OSError:
        pass
    return ""


def project_slug(cwd: str) -> str:
    # A cwd inside the vault names its project directly: .../agent-projects/<slug>/...
    if cwd.startswith(VAULT + os.sep):
        rel = cwd[len(VAULT) + 1:]
        return rel.split(os.sep, 1)[0].lower()
    try:
        url = subprocess.run(
            ["git", "-C", cwd, "remote", "get-url", "origin"],
            capture_output=True, text=True, timeout=3,
        ).stdout.strip()
    except Exception:
        url = ""
    if url:
        slug = url.rstrip("/").rsplit("/", 1)[-1]
        slug = slug.removesuffix(".git")
    else:
        try:
            top = subprocess.run(
                ["git", "-C", cwd, "rev-parse", "--show-toplevel"],
                capture_output=True, text=True, timeout=3,
            ).stdout.strip()
        except Exception:
            top = ""
        slug = os.path.basename(top) if top else os.path.basename(cwd)
    return slug.lower()


CLEAR_RE = re.compile(r"<command-name>/?clear</command-name>")


def last_clear_offset(transcript_path: str) -> int:
    """Byte offset just past the last `/clear` in the transcript.

    `/clear` does NOT rotate the transcript file: Claude Code keeps the same
    session_id and keeps appending, so one .jsonl can hold several logically
    separate conversations. Summarising the whole file then head/tail-truncating
    it produced digests describing a conversation from days earlier (owner
    caught this 2026-07-27: a 585KB file spanning 07-21..07-27 held 4 cleared
    conversations, and the digest described the first one). Only the span after
    the last clear is 'this session'.
    """
    off = 0
    try:
        with open(transcript_path, "r", errors="ignore") as f:
            while True:
                pos = f.tell()
                raw = f.readline()
                if not raw:
                    break
                if CLEAR_RE.search(raw):
                    off = pos + len(raw)
    except OSError:
        return 0
    return off


def extract(transcript_path: str, start_offset: int = 0):
    """Return (condensed_text, user_turns, has_edits)."""
    lines_out = []
    user_turns = 0
    has_edits = False
    try:
        with open(transcript_path, "r", errors="ignore") as f:
            f.seek(start_offset)
            for raw in f:
                raw = raw.strip()
                if not raw:
                    continue
                try:
                    obj = json.loads(raw)
                except Exception:
                    continue
                t = obj.get("type")
                if t not in ("user", "assistant"):
                    continue
                msg = obj.get("message") or {}
                content = msg.get("content")
                role = msg.get("role", t)
                if isinstance(content, str):
                    if role == "user" and not obj.get("isMeta"):
                        user_turns += 1
                    if content.strip():
                        lines_out.append(f"{role.upper()}: {content.strip()}")
                elif isinstance(content, list):
                    for block in content:
                        if not isinstance(block, dict):
                            continue
                        btype = block.get("type")
                        if btype == "text" and block.get("text", "").strip():
                            lines_out.append(f"{role.upper()}: {block['text'].strip()}")
                        elif btype == "tool_use":
                            name = block.get("name", "")
                            if name in EDIT_TOOLS:
                                has_edits = True
                            if name == "Bash":
                                cmd = str((block.get("input") or {}).get("command", ""))
                                if GIT_MUTATION_RE.search(cmd):
                                    has_edits = True
    except FileNotFoundError:
        return "", 0, False
    text = "\n".join(lines_out)
    # cap cost: keep head + tail if huge, skip the (likely repetitive) middle
    budget = 20000
    if len(text) > budget:
        head = text[: budget // 2]
        tail = text[-budget // 2:]
        text = head + "\n...[truncated]...\n" + tail
    return scrub(text), user_turns, has_edits


def call_model(prompt: str) -> str:
    """Summarise with agy (Gemini 3.1 Pro, $0 subscription) — never weaker.

    Owner ruling 2026-07-27: a session costs real money to produce; losing it
    means paying again. So the digest is never written by a model below Claude,
    or agy at worst. The old ladder ("gemini" = free-quota gemini-2.5-flash,
    then DeepSeek "flash") is banned. If agy is unavailable we return "" and
    the caller falls back to preserving the raw tail verbatim — a truthful
    excerpt beats a cheap model's confident paraphrase.
    """
    try:
        r = subprocess.run(
            # --effort is mandatory for gemini-3.1-pro (agy 1.1.7); without it
            # agy exits with "invalid model selection" and the digest silently
            # never gets written.
            ["agy", "-p", prompt, "--model", "gemini-3.1-pro", "--effort", "low"],
            capture_output=True, text=True, timeout=180,
        )
        if r.returncode == 0 and r.stdout.strip():
            return r.stdout.strip()
    except Exception:
        pass
    return ""


def main():
    if len(sys.argv) < 2:
        return
    try:
        payload = json.loads(Path(sys.argv[1]).read_text())
    except Exception:
        return

    cwd = payload.get("cwd") or os.getcwd()
    session_id = payload.get("session_id", "unknown")
    transcript_path = payload.get("transcript_path")
    if not transcript_path or not Path(transcript_path).exists():
        return

    slug = project_slug(first_transcript_cwd(transcript_path) or cwd)
    ws = Path.home() / ".local" / "share" / "agent-projects" / slug / "workspace"
    session_md = ws / "SESSION.md"

    # Resume from where the previous digest stopped, NOT from the file start.
    #
    # Two bugs this replaces (both found 2026-07-27):
    #  1. The old guard skipped whenever this session_id already had a digest.
    #     A session_id survives /clear and resume, so a long-lived session got
    #     exactly ONE digest ever — every later conversation under that id was
    #     silently never saved. That is the owner's recurring complaint.
    #  2. Summarising from byte 0 and then head/tail-truncating meant the digest
    #     described the OLDEST conversation in the file, not the one that just
    #     ended.
    # A byte offset per transcript is format-independent: it does not care
    # whether the boundary was /clear, a resume, or a crash.
    offsets_path = Path.home() / ".claude" / "hooks" / ".digest-offsets.json"

    # SessionEnd fires once per end reason (clear, logout, prompt_input_exit,
    # other), and the .sh wrapper detaches each run with nohup. Two runs could
    # therefore overlap: both read the same offset, both spent 1-3 minutes in
    # the model call, and both appended — which is how SESSION.md got two
    # byte-identical digests two minutes apart carrying the same session id.
    # The marker was never the guard (a session id legitimately spans several
    # digests, see above); the missing piece was mutual exclusion. Holding an
    # exclusive lock across read-offset -> summarise -> append -> write-offset
    # makes the second run re-read an advanced offset and fall out at the
    # "nothing meaningful since the last digest" check below. Blocking is safe:
    # the process is already detached, so nothing waits on it.
    lock_path = Path.home() / ".claude" / "hooks" / ".digest.lock"
    lock_path.parent.mkdir(parents=True, exist_ok=True)
    with open(lock_path, "w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        _write_digest(transcript_path, offsets_path, session_id, ws, session_md)


def _write_digest(transcript_path, offsets_path, session_id, ws, session_md):
    """Summarise the un-digested span of the transcript and append it.

    Caller holds the digest lock; every offset read and write happens inside it.
    """
    marker = f"<!-- wo6-session:{session_id} -->"
    try:
        offsets = json.loads(offsets_path.read_text())
    except Exception:
        offsets = {}
    start = max(int(offsets.get(transcript_path, 0)), last_clear_offset(transcript_path))
    size = Path(transcript_path).stat().st_size
    if size - start < 2000:
        return  # nothing meaningful since the last digest

    text, user_turns, has_edits = extract(transcript_path, start)
    if not text or (user_turns < MIN_USER_TURNS and not has_edits):
        return  # trivial session, nothing worth logging

    prompt = (
        "You are appending a short entry to a running engineering project journal "
        "(SESSION.md). Below is a condensed transcript of one coding-assistant "
        "session (human turns prefixed USER:, assistant turns prefixed ASSISTANT:). "
        "Write a concise summary in at most 300 tokens: what shipped or changed, "
        "what was decided, and what's left open. Be factual and terse, matching a "
        "developer's own changelog notes — no filler, no restating this "
        "instruction, no markdown heading. Output ONLY the summary body.\n\n"
        "--- TRANSCRIPT (condensed) ---\n" + text
    )

    summary = call_model(prompt)
    kind = "agy"
    if not summary:
        # Never drop the session. A verbatim tail is worse to read than a
        # summary but it is TRUE, and the session can be reconstructed from it;
        # silence means the work is gone and has to be paid for twice.
        kind = "RAW TAIL — agy unavailable, no summary written"
        summary = "```\n" + text[-6000:] + "\n```"

    ws.mkdir(parents=True, exist_ok=True)
    ts = datetime.now().strftime("%Y-%m-%d %H:%M")
    block = (
        f"\n## Session digest — {ts} (auto · SessionEnd · wo-6 · {kind})\n"
        f"{marker}\n\n{summary}\n"
    )
    with open(session_md, "a") as f:
        f.write(block)

    # Only advance the offset once the digest is safely on disk: if anything
    # above failed, the next run re-covers the same span rather than losing it.
    offsets[transcript_path] = size
    try:
        offsets_path.write_text(json.dumps(offsets, indent=1))
    except OSError:
        pass


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"session-narrative-end.py error: {e}", file=sys.stderr)
    finally:
        if len(sys.argv) >= 2:
            try:
                os.unlink(sys.argv[1])
            except OSError:
                pass
