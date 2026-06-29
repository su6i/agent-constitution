---
name: weasyprint-rtl-persian-pdf
description: Render RTL/Persian (and mixed FR/EN/FA) PDFs with WeasyPrint on macOS. Use to fix font-fallback bugs — Liberation Sans breaking Persian shaping, fontconfig junk fallbacks (Noto-Yezidi/Hiragino/Microsoft-Sans), vendored fonts, and @font-face bold weight matching.
origin: community
---

# Skill: Rendering RTL/Persian PDFs with WeasyPrint on macOS

**When to use:** generating Persian/Arabic (RTL) or mixed FR/EN/FA PDFs with
WeasyPrint (HTML/CSS → PDF) on macOS. These are hard-won fixes for font fallback
bugs that do **not** happen on Linux. Skipping them wastes hours.

## TL;DR checklist

1. **Vendor the fonts** (don't trust system fonts). Put the exact `.ttf` files in a
   repo `fonts/` dir and load them with `@font-face` + absolute `file://` paths.
2. **Never put `Liberation Sans` in a Persian font stack** — it breaks Pango shaping
   on macOS and dumps the whole Persian run to Microsoft-Sans-Serif / Noto-Syriac.
   Use `DejaVu Serif` (or `DejaVu Sans`) as the fallback after the Persian font.
3. **Lock fontconfig** to only the vendored + Liberation fonts via `FONTCONFIG_FILE`
   so macOS can't reach junk fallback fonts (Noto-Serif-Yezidi, Hiragino, Microsoft).
4. **Verify with `pdffonts`**: the output must contain **zero**
   `Microsoft-Sans-Serif` / `Noto-*-Syriac` / `Noto-*-Yezidi` / `Hiragino` fonts.

## The bugs and their fixes

### Bug 1 — `Liberation Sans` poisons Persian shaping (the big one)

Symptom: bold Persian headings/titles render in a *different* font (a system Arabic
naskh look), not the intended Vazirmatn. `pdffonts` shows `Microsoft-Sans-Serif-Bold`
and `Noto-Sans-Syriac-Bold`.

Root cause: when the CSS `font-family` for a Persian element lists `'Liberation Sans'`
anywhere in the stack (even *after* the Persian font), macOS Pango mis-itemizes the
run and drops the whole bold Persian cluster to a system fallback. Body text worked
because its fallback was `DejaVu Serif`, not `Liberation Sans`.

Fix: make the Persian heading fallback match the body — `DejaVu Serif`, never
`Liberation Sans`:

```css
/* GOOD */ .rtl h1, .rtl h2, .rtl h3 { font-family:'Vazir','DejaVu Serif',serif; }
/* BAD  */ .rtl h1, .rtl h2, .rtl h3 { font-family:'Vazir','Liberation Sans',sans-serif; }
```

Same applies to table headers (`th`) and divider labels — strip `Liberation Sans`.

### Bug 2 — macOS routes Persian punctuation/uncovered glyphs to junk fonts

Symptom: even after Bug 1, `pdffonts` still lists `Noto-Serif-Yezidi`, `Hiragino`,
`Microsoft-Sans-Serif`. The Arabic comma/semicolon/question mark `،؛؟` (U+060C/061B/061F)
and a few glyphs get itemized as "common script" and fall to macOS system fonts.

Root cause: WeasyPrint/Pango's fallback for glyphs not taken from the `@font-face`
stack uses the **system fontconfig fallback chain**, which on macOS is garbage for
Arabic script.

Fix: point `FONTCONFIG_FILE` at a minimal config that exposes ONLY the vendored fonts
and the user's Liberation fonts — the junk system fonts become unreachable, so Pango
falls back to Vazir/Liberation instead. Set it **before importing weasyprint**:

```python
import os, tempfile
from pathlib import Path
FONTS = str(Path(__file__).resolve().parent / "fonts")
_conf = Path(tempfile.gettempdir()) / "fonts.conf"
_conf.write_text(f'''<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <dir>{FONTS}</dir>
  <dir>{Path.home() / "Library" / "Fonts"}</dir>
  <cachedir>{tempfile.gettempdir()}/fc-cache</cachedir>
</fontconfig>''')
os.environ["FONTCONFIG_FILE"] = str(_conf)
from weasyprint import HTML   # import AFTER setting the env var
```

### Bug 3 — `@font-face` bold weight-matching is unreliable

Declaring two `@font-face` with the same family name differing only by
`font-weight:normal|bold` works for *body* `<strong>` but combined with Bug 1 made
bold headings fail. With Bugs 1+2 fixed, the natural `h1` bold weight matches the
`font-weight:bold` Vazirmatn-Bold face correctly. (A normal-weight alias pointing at
the bold file — `@font-face{font-family:'VazirHead';src:...Bold.ttf}` + `font-weight:normal`
on the heading — is a fallback workaround if needed, but isn't necessary once the
stack uses `DejaVu Serif`.)

### Bug 4 — system Vazirmatn ≠ the one you tested with

macOS `~/Library/Fonts/Vazirmatn-Bold.ttf` was a *different version* (127 KB) than the
reference (123 KB from `github.com/rastikerdar/vazirmatn`), with different glyph/weight
coverage. Always **vendor the exact font version** rather than relying on what's installed.
Also: `fc-match "Vazirmatn"` returns **Hiragino** on this macOS (name resolution is
broken) — never rely on family-name resolution; use `@font-face` with explicit file paths.

## Diagnostic recipe (how to find which glyph uses which font)

```bash
# 1) doc-wide fallback check — MUST be 0
pdffonts guide.fa.pdf | grep -icE "microsoft|syriac|yezidi|hiragino"
# 2) per-glyph font of a specific region (e.g. the title, size>18) with pdfminer
python - <<'PY'
from pdfminer.high_level import extract_pages
from pdfminer.layout import LTTextContainer, LTChar
for page in extract_pages("guide.fa.pdf", page_numbers=[0]):
    for el in page:
        if isinstance(el, LTTextContainer):
            for line in el:
                for ch in line:
                    if isinstance(ch, LTChar) and ch.size>18 and ch.get_text().strip():
                        print(ch.get_text(), ch.fontname, round(ch.size,1))
PY
# 3) visual: pdftoppm -r 200 -png -f 1 -l 1 guide.fa.pdf out   (then inspect the image)
```

Quality bar = the Linux-built reference: `pdffonts` shows only Vazir(+Bold/Oblique),
Liberation, DejaVu, FreeSerif — **no Microsoft/Syriac/Yezidi/Hiragino**.

## Running the build (isolated, no pip pollution — respects "uv only")

```bash
export DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib:/usr/local/lib   # weasyprint native libs
uv run --no-project --python 3.12 --with weasyprint --with markdown python build_pdfs.py
```

Prereqs on macOS: `brew install pango` (pulls cairo/gobject), plus the vendored fonts.

## Other RTL gotchas (carry over from CLAUDE.md Persian rules)

- Each text block: `unicode-bidi: plaintext` so French annex (LTR) and Persian (RTL)
  each follow their own dominant script inside one RTL document.
- Strip emoji from the final HTML (a text emoji font in the stack hides ASCII digits).
- No space thousands-separator in Persian numbers.
- URLs/links and the Latin author signature inside an RTL doc need an explicit
  `direction:ltr` wrapper or they right-align and look broken.
