---
name: cli-demo-recording
description: Create reproducible, version-controlled terminal GIF/MP4 demos for GitHub READMEs using VHS (.tape scripts) or asciinema+agg. Use when you need a demo section, a product GIF, or CI-generated terminal recordings that stay in sync with your code.
origin: agent-constitution
tools: Bash, Write, Read
---

# CLI Demo Recording

Animated terminal demos are the highest-impact addition to any CLI/developer tool README. This skill covers the two dominant approaches and when to pick each.

## Tool Comparison

| | VHS | asciinema + agg |
|---|---|---|
| **Stars** | 20K (charmbracelet/vhs) | 17K + 1.6K |
| **How it works** | Runs commands from a `.tape` script | Records a real interactive session |
| **Output** | GIF, MP4, WebM, PNG frames | `.cast` → GIF (via agg) or embed on asciinema.org |
| **Reproducible** | ✅ same script = same output | ❌ depends on live session |
| **CI-friendly** | ✅ Docker image available | ⚠️ needs PTY |
| **Best for** | Scripted, always-in-sync demos | Real workflow captures |

**Default choice: VHS** — script lives in the repo, regenerates automatically, works in CI.
**Choose asciinema** when you need a real unscripted session or want interactive web embeds.

---

## VHS

### Install

```bash
brew install vhs          # macOS/Linux (requires ttyd + ffmpeg)
brew install ffmpeg ttyd  # dependencies

# or run without installing:
docker run --rm -v $PWD:/vhs ghcr.io/charmbracelet/vhs demo.tape
```

### Tape File Anatomy

```elixir
# 1. Output format(s) — one or many
Output demo.gif
Output demo.mp4

# 2. Settings (must come before any commands)
Set Shell zsh
Set FontSize 14
Set FontFamily "JetBrains Mono"
Set Width 1200
Set Height 600
Set TypingSpeed 50ms
Set Theme "Dracula"

# 3. Commands
Type "ls skills/ | head -10"
Enter
Sleep 1s

# Hide sensitive setup, Show the interesting part
Hide
Type "cd /path/to/project"
Enter
Show

Type "cat skills/fastapi-patterns.md | head -20"
Enter
Sleep 3s
```

### All Commands

```elixir
# Text input
Type "text"           # type at current TypingSpeed
Type@200ms "slow"     # override speed for this line
Enter                 # press Enter
Tab                   # press Tab
Space                 # press Space
Backspace             # press Backspace

# Navigation
Up / Down / Left / Right
Ctrl+C / Ctrl+D / Ctrl+L

# Timing
Sleep 500ms           # pause (use after commands that produce output)
Sleep 2s
Wait /regex/          # wait until terminal shows matching text
Wait+Screen /regex/   # wait for full screen match

# Visibility
Hide                  # don't record until Show
Show                  # resume recording

# Output
Screenshot frame.png  # save current frame

# Variables
Env KEY value         # set env var before session starts

# Reuse
Source other.tape     # include another tape
```

### Settings Reference

```elixir
Set Shell            "zsh"          # bash, fish, zsh, powershell
Set FontSize         14
Set FontFamily       "Monocraft"
Set Width            1200           # pixels
Set Height           600
Set TypingSpeed      50ms           # delay between keystrokes
Set LetterSpacing    1
Set LineHeight       1.2
Set Padding          20             # px around terminal content
Set Framerate        30             # output GIF fps
Set PlaybackSpeed    1.0            # 2.0 = 2x faster output
Set LoopOffset       0%             # where GIF loop restarts
Set Theme            "Dracula"      # or JSON object

# Built-in themes: Dracula, Nord, GitHub Dark, Monokai, Tokyo Night, etc.
# Full list: vhs themes
```

### Minimal working tape for a project README

```elixir
Output assets/demo.gif

Set Width 900
Set Height 500
Set FontSize 14
Set FontFamily "JetBrains Mono"
Set Theme "GitHub Dark"
Set TypingSpeed 40ms

Hide
Type "clear"
Enter
Show

Type "ls skills/ | wc -l"
Enter
Sleep 1s

Type "cat skills/fastapi-patterns.md | head -30"
Enter
Sleep 3s

Sleep 1s
```

Run with:
```bash
vhs assets/demo.tape
```

### CI Integration (GitHub Actions)

```yaml
# .github/workflows/demo.yml
name: Regenerate demo GIF
on:
  push:
    paths: ['assets/demo.tape']
jobs:
  vhs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: charmbracelet/vhs-action@v2
      - run: vhs assets/demo.tape
      - uses: stefanzweifel/git-auto-commit-action@v5
        with:
          commit_message: "chore: regenerate demo.gif"
          file_pattern: "assets/*.gif"
```

---

## asciinema + agg

### Workflow

```bash
# 1. Record a real session
pip install asciinema
asciinema rec demo.cast

# 2. Convert to GIF
cargo install agg           # or: brew install agg
agg demo.cast demo.gif

# Options
agg demo.cast demo.gif \
  --theme dracula \
  --font-size 14 \
  --cols 100 --rows 30 \
  --fps-cap 30 \
  --idle-time-limit 1      # skip pauses > 1s
```

### Embed on asciinema.org (no GIF needed)

```bash
asciinema rec
# after recording: uploads automatically, gives you a URL
# embed in README:
[![asciicast](https://asciinema.org/a/<id>.svg)](https://asciinema.org/a/<id>)
```

---

## terminalizer (Node.js alternative)

```bash
npm install -g terminalizer
terminalizer record demo       # saves demo.yml
terminalizer render demo       # produces demo.gif
terminalizer share demo        # uploads to terminalizer.com
```

Good when: you need CSS-level customization of the frame, watermarks, or custom fonts without ttyd dependency.

---

## termtosvg (SVG output)

```bash
pip install termtosvg
termtosvg record.svg          # records and saves as animated SVG
```

SVG scales perfectly and is supported in GitHub READMEs. No GIF compression artifacts.

---

## README Embed Patterns

```markdown
<!-- GIF (VHS or agg output) -->
![Demo](assets/demo.gif)

<!-- MP4 (only works on GitHub, not npm/PyPI) -->
https://user-images.githubusercontent.com/xxx/demo.mp4

<!-- asciinema embed badge -->
[![asciicast](https://asciinema.org/a/ID.svg)](https://asciinema.org/a/ID)

<!-- SVG (termtosvg) -->
![Demo](assets/demo.svg)
```

## Recommended File Location

```
your-project/
├── assets/
│   ├── demo.tape          # VHS script (committed, version-controlled)
│   └── demo.gif           # generated output (committed or CI-generated)
└── .github/workflows/
    └── demo.yml           # optional: auto-regenerate on tape change
```

## When to Use Each

- **VHS** — CLI tools, developer tools, any project where the demo should stay in sync with the code. Script the exact commands you show in your README.
- **asciinema** — showing a real interactive workflow that's hard to script, or wanting an interactive web embed with pause/play.
- **terminalizer** — needing heavy visual customization (custom CSS, window frames, watermarks).
- **termtosvg / svg-term-cli** — when file size matters and SVG is acceptable (no GitHub Pages video restrictions).
