#!/usr/bin/env python3
"""Generate a full Persian translation for AGENTIC-CODING-SETUP.md.

The script translates non-code Markdown lines and preserves code fences,
frontmatter, links, and inline code placeholders.
"""

from __future__ import annotations

import re
import time
from pathlib import Path

from deep_translator import GoogleTranslator


SRC = Path("AGENTIC-CODING-SETUP.md")
DST = Path("AGENTIC-CODING-SETUP.fa.md")


def should_translate(line: str) -> bool:
    st = line.strip()
    if not st:
        return False
    if st == "---":
        return False
    if st.startswith("```"):
        return False
    if st.startswith("<") and st.endswith(">"):
        return False
    # Keep markdown divider rows unchanged.
    if re.match(r"^\s*\|?\s*[-: ]+\|", st):
        return False
    # Translate table rows too, but not pure punctuation rows.
    if re.match(r"^[\s#>*`~!@#$%^&*()_+\-=\[\]{};:'\"\\|,.<>/?0-9]+$", st):
        return False
    return True


def translate_line(translator: GoogleTranslator, text: str, cache: dict[str, str]) -> str:
    if text in cache:
        return cache[text]

    placeholders: dict[str, str] = {}
    payload = text

    for i, m in enumerate(re.findall(r"`[^`]+`", payload)):
        key = f"__CODE_{i}__"
        placeholders[key] = m
        payload = payload.replace(m, key, 1)

    for i, m in enumerate(re.findall(r"\[[^\]]+\]\([^\)]+\)", payload)):
        key = f"__LINK_{i}__"
        placeholders[key] = m
        payload = payload.replace(m, key, 1)

    translated = translator.translate(payload)
    for k, v in placeholders.items():
        translated = translated.replace(k, v)

    cache[text] = translated
    time.sleep(0.03)
    return translated


def main() -> None:
    content = SRC.read_text(encoding="utf-8")
    lines = content.splitlines(keepends=True)

    translator = GoogleTranslator(source="en", target="fa")
    out: list[str] = []
    cache: dict[str, str] = {}

    in_frontmatter = False
    frontmatter_count = 0
    in_code = False

    for raw in lines:
        stripped = raw.rstrip("\n")

        if stripped.strip() == "---" and not in_code:
            frontmatter_count += 1
            if frontmatter_count == 1:
                in_frontmatter = True
            elif frontmatter_count == 2:
                in_frontmatter = False
            out.append(raw)
            continue

        if stripped.strip().startswith("```"):
            in_code = not in_code
            out.append(raw)
            continue

        if in_frontmatter or in_code or not should_translate(stripped):
            out.append(raw)
            continue

        m = re.match(r"^(\s*(?:[-*+]\s+|\d+\.\s+|>\s+|#+\s+)?)(.*?)(\s*)$", stripped)
        if m:
            prefix, body, suffix = m.groups()
            translated = translate_line(translator, body, cache)
            out.append(prefix + translated + suffix + ("\n" if raw.endswith("\n") else ""))
        else:
            translated = translate_line(translator, stripped, cache)
            out.append(translated + ("\n" if raw.endswith("\n") else ""))

    full = "".join(out)

    full = full.replace('title: "Agentic Coding 2026"', 'title: "کدنویسی ایجنتیک ۲۰۲۶"', 1)
    full = full.replace(
        "description: Advanced setup, benchmarks, and ROI analysis for AI-driven development.",
        "description: راهنمای پیشرفته تنظیمات، بنچمارک‌ها و تحلیل بازگشت سرمایه برای توسعه مبتنی بر هوش مصنوعی.",
        1,
    )
    full = full.replace("location: AGENTIC-CODING-SETUP.md", "location: AGENTIC-CODING-SETUP.fa.md", 1)
    full = full.replace("[Back to README](README.md)", "[بازگشت به README فارسی](README.fa.md)", 1)

    # Update trailing backlink if present.
    full = full.replace("[Back to README](README.md)", "[بازگشت به README فارسی](README.fa.md)")

    DST.write_text(full, encoding="utf-8")
    print(f"Wrote {DST} ({len(full.splitlines())} lines)")


if __name__ == "__main__":
    main()
