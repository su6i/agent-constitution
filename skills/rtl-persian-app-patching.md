---
name: rtl-persian-app-patching
description: Force correct Persian/Arabic RTL rendering and fonts into third-party apps you don't own — Electron desktop apps (app.asar patch, ASAR header integrity hash, ad-hoc re-sign) and web apps (Chrome MV3 content script). Includes the BiDi direction rules that first-strong heuristics get wrong.
version: 1.0.0
updated: 2026-08-15
origin: internal
---

# Skill: Forcing Persian/RTL into apps you don't control

**When to use:** an app renders Persian/Arabic text with the wrong font, wrong
line direction, or broken punctuation placement, and you cannot change its
source. Covers Claude Desktop, VS Code, Obsidian, Slack, Telegram Desktop, Jan,
LM Studio (Electron) and any web AI chat (Gemini, ChatGPT, Claude.ai, Grok).

## Step 0 — classify the target, or you will waste hours

```bash
ls "/Applications/<App>.app/Contents/Resources/app.asar"   # exists → Electron
file "/Applications/<App>.app/Contents/MacOS/<App>" | grep -i electron
```

| Target | Patchable? | Route |
|---|---|---|
| Electron app (`app.asar` present) | yes | § Electron patch |
| Web app in the browser | yes | § Chrome extension |
| Native Swift/AppKit app (ChatGPT for Mac, Gemini for Mac as of 2026) | **no** | file a vendor bug; a system font override is the only lever, and it does not fix direction |
| Tauri / WKWebView wrapper | partly | no asar; the web assets sit in `Contents/Resources/` — same CSS payload, but the bundle still needs the re-sign step |

Never promise a user an RTL patch before this check. Native apps have no
injection surface, and telling them otherwise costs a wasted session.

## Electron patch — the five steps that actually matter (macOS)

Do all of this with the app **quit**. Every step below is required; skipping
one produces a bundle that either crashes or silently refuses to launch.

### 1. Back up the archive *and* Info.plist

```bash
cp "$RES/app.asar" "$RES/app.asar.bak"
cp "$APP/Contents/Info.plist" ~/.local/share/<tool>/Info.plist.bak
```

`codesign --remove-signature` (used by some patchers) destroys the vendor's
Apple signature **permanently** — no backup restores it, only a reinstall.
Prefer never removing it; ad-hoc re-signing on top is enough (step 4).

### 2. Extract → inject → repack, with the unpack glob derived from disk

```js
const asar = require('@electron/asar');
asar.extractAll(ASAR, TMP);
// ... append CSS/JS payload to files under .vite/build and .vite/renderer ...
await asar.createPackageWithOptions(TMP, ASAR, { unpack: computeUnpackGlob(ASAR) });
```

`unpack` must be the union of `*.node,*.dylib,spawn-helper` **and every file
already present in `app.asar.unpacked/`** — read that directory and emit
`**/<relpath>` patterns. A hardcoded extension list silently packs
extensionless native helpers (MCP servers, CLI binaries) *into* the archive;
they then fail at spawn time with `Malformed Mach-O file`, and the archive
doubles in size for no reason.

### 3. `ElectronAsarIntegrity` = SHA-256 of the ASAR **header**, not of the file

This is the single most common mistake, and it is invisible until launch:

```
FATAL:asar_util.cc:144 Integrity check failed for asar archive (<yours> vs <expected>)
```

```js
const { getRawHeader } = require('@electron/asar');
const crypto = require('crypto');
const hash = crypto.createHash('sha256')
    .update(getRawHeader(ASAR).headerString)   // header JSON, NOT the file bytes
    .digest('hex');
```

Write it into `Info.plist`:

```bash
/usr/libexec/PlistBuddy -c \
  "Set :ElectronAsarIntegrity:Resources/app.asar:hash $HASH" \
  "$APP/Contents/Info.plist"
```

With the correct header hash, integrity validation **passes** and the
`EnableEmbeddedAsarIntegrityValidation` fuse can stay ON. Disabling that fuse
(`@electron/fuses`) is the workaround people reach for when their hash is
wrong; it permanently strips the app's tamper protection and is not reverted
by any "restore" command. Do not do it unless the hash route provably fails.

### 4. Ad-hoc re-sign — mandatory on Apple Silicon

Any write inside the bundle (including the `Info.plist` edit in step 3)
invalidates the signature. An unsigned bundle on arm64 does not launch:

```
Launch failed. NSPOSIXErrorDomain Code=163 "Launchd job spawn failed"
```

```bash
xattr -cr "$APP"
codesign --force --deep --sign - "$APP"
codesign -dv "$APP" 2>&1 | grep adhoc   # expect flags=0x2(adhoc)
```

Order is fixed: **repack → write hash → re-sign**. Re-signing first and then
touching `Info.plist` reproduces the same failure.

### 5. Verify by running the binary, not by double-clicking

```bash
"/Applications/<App>.app/Contents/MacOS/<App>"
```

`open -a` swallows the fatal log. Running the executable directly prints the
integrity/signature error that tells you which of steps 2-4 is wrong. Only
after a clean start should you check the visual result.

### Restore

```bash
cp "$RES/app.asar.bak" "$RES/app.asar"
cp ~/.local/share/<tool>/Info.plist.bak "$APP/Contents/Info.plist"
codesign --force --deep --sign - "$APP"
```

**Every app update overwrites the patch** — the whole procedure is a
re-runnable script, never a one-off. Keep the patcher installed locally
(`~/.local/share/<tool>/`) rather than relying on `npx`, whose published
version may lag the fixed source by months.

## The payload: what to inject

### Font

```css
@font-face { font-family: 'Vazirmatn'; src: url(data:font/woff2;base64,...) format('woff2'); }
body, p, div, span, h1, h2, h3, h4, h5, h6, li, td, textarea, input,
.ProseMirror, [contenteditable] {
    font-family: 'Vazirmatn', ui-sans-serif, system-ui, sans-serif !important;
}
```

**Never `* { font-family: ... !important }`.** The universal selector also hits
icon fonts (Material Symbols, Lucide, Font Awesome, the app's own glyph font)
and every icon degenerates into a tofu box or a stray Latin letter. Enumerate
text elements instead, or exclude icons: `:not([class*="icon"]):not(i)`.

### Direction — the part everyone gets wrong

```css
/* Persian-majority UI: commit to RTL, do not guess per line */
.message, .prose, .markdown-body { direction: rtl; unicode-bidi: isolate; text-align: right; }

/* Unknown-language user content (mixed EN/FA history): per-paragraph guess */
.user-generated p { unicode-bidi: plaintext; text-align: start; }

/* Code must stay LTR no matter what */
pre, code, kbd, samp, .cm-editor, .hljs { direction: ltr !important; unicode-bidi: isolate !important; text-align: left !important; }
```

`unicode-bidi: plaintext` applies the **first-strong** rule: the paragraph's
direction is taken from its first strong-directional character. That is wrong
for the most common Persian sentence shape — one that opens with a Latin
technical term:

> `Gemini web app رو Google سرو می‌کند (تو نمی‌تونی local app رو modify کنی)`

First-strong sees `G` → lays the line out LTR → the trailing parenthesis and
the Persian clause order visually scramble, even though the sentence is
Persian. **The direction of a line is a property of its language, not of its
first character.** Rules of thumb:

1. If the *container's* language is Persian, set `direction: rtl` explicitly on
   the container and let bidi handle the embedded Latin runs. The Latin words
   still read left-to-right inside an RTL line — that is correct BiDi, not a bug.
2. Use `plaintext` only where the language genuinely varies per paragraph and
   you have no better signal.
3. If you need a per-line decision, decide by **script ratio**, not first char:

```js
const fa = (s.match(/[؀-ۿ]/g) || []).length;
const en = (s.match(/[A-Za-z]/g) || []).length;
el.dir = fa >= en * 0.35 ? 'rtl' : 'ltr';   // Persian wins unless clearly Latin
```

4. Set `dir` on the element (`el.dir = 'rtl'`) rather than only CSS: `dir`
   also fixes caret behaviour, selection, and punctuation mirroring in inputs.

## Chrome extension route (web AI apps)

For anything running in a browser — `gemini.google.com`, `chatgpt.com`,
`claude.ai`, `grok.com` — a Manifest V3 content script is strictly better than
patching a desktop wrapper: it survives updates, needs no code signing, and one
extension covers every site.

```json
{
  "manifest_version": 3,
  "name": "Persian RTL for AI chats",
  "version": "1.0.0",
  "content_scripts": [{
    "matches": ["https://gemini.google.com/*", "https://chatgpt.com/*",
                "https://claude.ai/*", "https://grok.com/*"],
    "css": ["rtl.css"],
    "js": ["rtl.js"],
    "run_at": "document_idle"
  }]
}
```

`rtl.js` must handle **streamed** responses — the text arrives token by token,
so a one-shot pass on load fixes nothing:

```js
const decide = el => { /* script-ratio rule above */ };
const scan = root => root.querySelectorAll('p, li, h1, h2, h3, td, blockquote').forEach(decide);
new MutationObserver(muts => {
    for (const m of muts) {
        if (m.type === 'characterData') decide(m.target.parentElement);
        m.addedNodes.forEach(n => n.nodeType === 1 && scan(n));
    }
}).observe(document.body, { childList: true, subtree: true, characterData: true });
scan(document);
```

Debounce the observer (`requestAnimationFrame` or a 50 ms timer) — a naive
handler re-runs on every streamed token and visibly slows long answers.

Same font caveat applies: scope the font override to text elements, and load
Vazirmatn from a bundled `web_accessible_resources` file, never a CDN (the
sites' CSP blocks external font hosts).

## Verification checklist

- [ ] App launches from the **terminal**, no `FATAL` / `Launchd job spawn failed`
- [ ] `codesign -dv` reports `adhoc`, and `codesign --verify --deep --strict` is clean
- [ ] Icons still render (the `*` selector test)
- [ ] Code blocks are LTR; Persian prose is RTL
- [ ] A Persian line **starting with a Latin word** lays out RTL
- [ ] Native binaries still spawn (MCP servers, terminals, updaters) — the
      unpack-glob regression only shows up here
- [ ] Restore script tested once, before you need it

## Known-bad shortcuts

| Shortcut | Why it bites |
|---|---|
| `codesign --remove-signature` without re-signing | bundle is unlaunchable on Apple Silicon |
| whole-file SHA-256 in `ElectronAsarIntegrity` | Electron hashes the header → `FATAL` at launch |
| disabling the integrity fuse to "fix" the above | permanent security downgrade, needs network `npx` at patch time |
| `* { font-family: ... !important }` | destroys every icon font |
| `unicode-bidi: plaintext` everywhere | mis-directs Persian lines that open with a Latin term |
| patching without re-running after updates | every app update silently reverts the patch |
