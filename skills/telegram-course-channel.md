---
name: telegram-course-channel
title: "Telegram Course Channel"
description: Publish a course library (video + resources + subtitles + index) to a Telegram channel, in the one order that a chronological, append-only medium allows. Use when setting up a new channel for educational video, or repairing one that was uploaded in separate passes.
location: skills/telegram-course-channel.md
agent_priority: Standard
version: 1.1.0
updated: 2026-09-04
last_updated: 2026-09-04
---

**🔗 Related Skills:**

- [yt-dlp Web Download](youtube-dlp-web-download.md) - Pulling the source video
- [Subtitle Generator](subtitle-generator.md) - Producing the `.srt` per lesson
- [FFmpeg Recipes](ffmpeg-recipes.md) - The re-encode before upload
- [Data Scraper Agent](data-scraper-agent.md) - Harvesting the lesson pages
- [Knowledge Ops](knowledge-ops.md) - Distilling transcripts into skills

[Back to README](../README.md)

---

# Skill: Telegram Course Channel

A Telegram channel is an **append-only chronological log**. Nothing can be
inserted between two existing messages, ever. Every mistake in this skill
traces back to that one property, and every rule below exists because a real
channel was built without respecting it.

> **The lesson that cost the most:** a 283-lesson channel was published as three
> separate passes — all videos, then all resource archives, then all subtitles.
> The result is a channel where lesson 12's video is message 317 and its
> subtitles are message 1039. They cannot be moved together. The only repair
> left was to edit a link into each of the 283 captions. **Ship a lesson as one
> group, or you cannot ship it as one group later.**

---

## 1. The invariant

```
ONE LESSON = ONE CONTIGUOUS MESSAGE GROUP, SENT IN ONE TRANSACTION.

    [ video + caption ]          <- the anchor, carries the lesson number
    [ caption overflow ]  (opt)  <- reply to the anchor
    [ resources .zip   ]  (opt)  <- reply to the anchor
    [ subtitles .srt   ]         <- reply to the anchor
```

A lesson is not "uploaded" until every part of it is in the channel. If the
resources are not ready, **do not send the video yet**. A missing lesson is
cheap; a lesson scattered across 700 messages is permanent.

---

## 2. Bootstrap order (do not reorder)

The order is forced by the medium. Steps 0-3 happen before a single byte is
sent to the channel.

### Step 0 — Identity and privacy

The channel id, the invite link, the scraped site's domain, the course names and
the instructor's name are **private data**. They go in `.env` and the vault,
never in the repository — not in code, not in a debug script, not in a README
example, not in a test fixture.

```bash
# .env (git-ignored)
API_ID=          API_HASH=
CHANNEL_ID=      # authoritative; the uploader never falls back to another chat
TELEGRAM_TOKEN=  # optional, only useful under 50 MB
TARGET_SITE_BASE_URL=
```

Add a guard to CI or a pre-commit hook that greps the diff for `-100…`,
`t.me/+…` and the site domain. This is not paranoia: a public repo shipped a
working invite link to a private channel for eight months because one throwaway
debug script hard-coded it, and a `git rm` does not remove it from the pushed
history.

### Step 1 — Authenticate the *user* account first

The Bot API caps uploads at **50 MB** (be conservative: 45 MB). Course videos
are 100-500 MB, so in practice **the bot cannot upload the library at all** —
you need a Pyrogram user session, and creating one requires an **interactive
login the agent cannot perform**.

Do the login on day one, not on upload day. Every project that deferred it
discovered the blocker after the encode farm had already run for 15 hours.

```bash
uv run --directory <repo> scripts/tg_login.py    # owner runs this, once
```

Keep the resulting `*.session` out of git (`*.session`, `*.session-journal`).

### Step 2 — Inventory the whole source before downloading anything

Scrape the site's structure into a manifest first: course → section → lesson,
each with a **stable lesson id** and the page's text. Only then download.

Two failures this prevents:

- **Numbering drift.** Downloading first and numbering later means the numbers
  come from filenames, and the source's real order is lost. Inserting one
  forgotten lesson then costs a 129-file renumber across local disk, the cloud
  mirror and the manifest.
- **Text that expires.** The lesson page's text is part of the caption. If you
  scrape it months after the video, the site will have changed its markup and
  you will silently get empty text for the newest lessons. Scrape the page and
  download the video **in the same pass**.

Number with a fixed width and leave gaps you can use:

```
001, 002, … 283          fixed 3-digit, zero-padded
```

Never parse the number with `name[:3]`. Multi-part files (`039_1`, `039_2`) and
any two-digit legacy name break that parser, and it fails *silently*: files are
skipped and others are uploaded twice. Parse with an anchored regex, and when
reading it back out of a caption, **scan every header line** — the number is on
the third line when the caption leads with course and section.

### Step 3 — Build the per-lesson bundle offline

For each lesson, produce one directory containing everything before you send
anything:

```
083/
  083.mp4          re-encoded, verified
  083.srt          subtitles
  083.caption.txt  page text, already chunked to the caption limit
  083_resources.zip  (only if the lesson has attachments)
```

The bundle is the unit of readiness. `attach_resources.py`-style repair passes
exist only because this step was skipped.

### Step 4 — Reserve the index slots **before the first video**

This is the step with no second chance. The table of contents cannot be
inserted later; it can only occupy messages that already exist above the
videos. So the very first thing the channel receives is a run of placeholder
messages, which are later *edited* into the index.

**How many. Two budgets, not one — and the second one is the one that bites.**
A post closes when *either* would be exceeded:

- **Characters**, capped at 4096 — counted in **UTF-16 code units**, which is
  what Telegram counts, not Python `len()`. Emoji and non-Latin titles make
  these diverge; `len(s.encode("utf-16-le")) // 2` is the number that matters.
  One index line is a lesson number plus a title, ~45 units; a section header
  ~30. Budget 3700 for safe chunking.
- **Entities**, capped at **100 per message**. Every `<a>`, `<b>`, `<i>` is one
  entity. Past the 100th, Telegram **silently drops the rest** — no error, no
  exception, no truncation marker; the text renders and the links past #100 are
  dead plain text. Nothing in your code will notice. Only a human scrolling the
  live channel will, months later.

```
chars    = lessons × 45 + sections × 30
entities = lessons × links_per_lesson + headers × (1 if bold else 0)
posts    = max(ceil(chars / 3700), ceil(entities / 100))
reserve  = posts × 2 + 4          # room to double the course, plus slack
```

**Decide `links_per_lesson` before you reserve, not after.** This is the trap.
A first pass ships one link per lesson (the lesson number, or the title, deep-
linked to its video) and the char budget dominates: 283 lessons in 34 sections
is ~13.7k units → 4 posts. Then someone enriches the line — a 📎 to the lesson's
resource archive, a `CC` to its subtitle file — and *the entity count triples
while the character count barely moves*. The same index now needs 8 posts, and
the four extra have to come from somewhere that may no longer exist. Enrich the
line on paper first, count entities for the **final** shape, and reserve for
that.

**Decoration competes with links for the same budget.** A bold course or section
header is an entity. On a 283-lesson index, bolding every header costs ~59 of
your 700 (7 × 100) — enough to be the difference between fitting and not. When
a budget is tight the cheapest thing to give up is emphasis, because a glyph
(`📁`) and a blank line separate a header just as well for free.

For the worked example above with three links per lesson: 283 video + 97
resource + 283 subtitle = 663 link entities + ~44 headers = ~707 → **8 posts**,
not 4. Reserve accordingly: **reserve 20 at the head**, not 12. Reserve the same
number again **at the tail**, after the last lesson, so an index that outgrows
the head has somewhere to continue and a "recently added" section has a home.
Tail slots are cheap; head slots are irreplaceable.

Give each placeholder a body that says what it is, so nobody deletes it:

```
📍 Index slot #3 — reserved
This message will be filled with the table of contents. Do not delete it.
```

**Never spend a reserved slot on anything else.** A channel that runs out of
head slots has exactly two options, both bad: append the index at the bottom
where nobody scrolls, or delete videos to free room.

### Step 5 — Upload, one lesson group at a time

Send the group of §1 as a unit, record the message ids of every part in a map
file, and only then move to the next lesson. The map is the project's memory:

```json
{"083": {"video": 388, "overflow": 389, "resources": 704, "subtitles": 705}}
```

Write it after every lesson, not at the end of the run.

### Step 6 — Fill the index into the reserved slots

Generate the index from the manifest (never from the channel), chunk it at
section boundaries, and **edit** it into the reserved messages — one chunk per
slot, in order. Deep-link each lesson to its own video message:

```
https://t.me/c/<internal_id>/<message_id>     internal_id = abs(chat_id) - 1000000000000
```

Then pin the first index post. Re-running this step must be idempotent: it
overwrites the same slots, it never sends new messages.

---

## 3. Telegram's limits, and what each one breaks

| Limit | Value | What happens if you ignore it |
|---|---|---|
| Media caption | 1024 chars | `MEDIA_CAPTION_TOO_LONG`, or a silently truncated lesson description |
| Text message | 4096 chars | `MESSAGE_TOO_LONG` mid-run, leaving a half-written index |
| Message entities | 100 per message | **the excess is dropped in silence** — links past #100 render as dead plain text, no error at send time and none at edit time |
| Deletion | irreversible | a deleted message can never be edited, so it is not a slot any more — deleting *permanently shrinks* the pool of future index slots |
| Bot upload | 50 MB | 220 of 256 files simply cannot be sent |
| User upload | ~2 GB | fine for lessons, not for raw 4K masters |
| Rate limit | `FloodWait` | **sends are dropped without an error** unless you catch it and sleep |
| Insertion | impossible | the entire design above |
| Editing | allowed, indefinitely | your only repair mechanism — hence reserved slots |

**Caption overflow.** Chunk at a paragraph boundary, fall back to a sentence
boundary, never mid-word. Send the remainder as a reply to the anchor so it
stays visually attached, and prefix it (`📄 Continued:`) so a reader knows.

Record the overflow id in the map alongside the video id, because **the
overflow message outlives its parent**. A continuation carries no media, so
every "delete the old uploads" pass that filters on *has a video* — the correct
filter, it must never touch a live lesson — leaves the continuation behind as an
orphan reading `📄 Continued: …` with nothing above it. Those orphans are not
junk to be swept: they are ordinary editable text messages sitting above the
library, which makes them the only thing that can still become an index slot
after the fact. Census the id range before assuming any of it is reusable, and
distinguish the three states — *live text* (a slot), *live media* (not a slot,
and never overwrite it), *deleted* (gone forever). Never plan growth into a
range you have not read; a range of ids that no state file mentions is far more
likely to be deleted than to be free.

**FloodWait.** Catch `pyrogram.errors.FloodWait`, sleep `e.value + 2`, retry the
same send. Without this a bulk run reports success and quietly loses messages.

---

## 4. The media pipeline, with the traps that were actually hit

```bash
ffmpeg -i in.mp4 -c:v libx265 -crf 23 -preset medium \
       -vf scale=1920:-2 -c:a aac -b:a 160k out.mp4
```

- **`-q:v` is ignored by libx265.** A wrapper that passes `-q:v 70` silently
  encodes at the default CRF 28. Always pass `-crf` explicitly and verify the
  encoder actually consumed it.
- **Never force the frame rate.** Re-encoding 23.976 fps to 25 fps destroys
  audio sync across a whole library. Omit `-r` entirely.
- **Convert 24-bit PCM audio.** Screen-recorded course video often carries
  uncompressed audio; `-c:a aac -b:a 160k` alone can cut file size 40×.
- **Use a native ffmpeg build.** An x86_64 binary under Rosetta on Apple silicon
  measured **2.9× slower** than the arm64 build, on the same machine.
- **Size the job before renting hardware.** Encode two representative clips,
  measure, extrapolate. A 2-vCPU cloud box was 110+ hours for a job the local
  laptop did in 15.5.
- **Verify by decoding, not by existence.** For every output: full decode to
  `null`, duration within tolerance of the source, and an audio stream present.
  Log the result per file.

Run the batch detached and keep the disk awake:

```bash
nohup ./compress_library.sh > compress.log 2>&1 &
caffeinate -s -w $!        # sleeps when the encode finishes, screen stays off
```

---

## 5. Idempotence rules (each one is a bug that happened)

1. **Write archives to `.part`, then rename.** An interrupted zip leaves a
   truncated file that the next run trusts and uploads.
2. **State files are written incrementally**, and a lost state file must not
   cause double work — check the live artefact too. The caption-link pass checks
   both its state file and whether the caption already contains the link.
3. **Renames in the cloud mirror are server-side** (`rclone moveto`), never
   re-upload. A renumber of 129 files must not push 129 files again.
4. **Skip is not success.** A run that skipped a file must say so and exit
   non-zero if the skip was unexpected.
5. **`--dry-run` must be real.** A dry run that takes a different code path is
   not a dry run; it validates nothing. Print exactly what the live run would
   send.

---

## 6. Distilling the transcripts (if you own the channel, not the content)

Course transcripts are someone else's teaching. What may leave the vault is
**procedural knowledge in your own words** — the method, the decision rules, the
checklist. What may never leave it is the **expression**: no transcript text, no
lesson or course titles, no site or instructor names, no quoted passages.

Batch by section (one section = one skill's worth of material), cap each batch
around 120k characters, and run it on a **$0 worker** — a 1M-token job has no
business in an architect session. Gate every generated skill before it is
committed to a public repo:

- a **banned-term scan** derived from the manifest and transcript metadata, so
  it cannot drift out of date, plus a vault-side list for instructor/site names;
- an **n-gram overlap test** (8-grams) against the full transcript corpus, which
  catches copied phrasing no name list would contain.

Exclude fenced and inline code from both — a command carries no expression.

---

## 7. Pre-flight checklist

Before the first message is sent to a new channel:

- [ ] `.env` holds channel id and site; nothing identifying is in the repo
- [ ] a commit-time guard greps for channel ids, invite links and the domain
- [ ] the user session exists (owner has run the interactive login)
- [ ] the full source inventory is scraped, with stable lesson numbers **and**
      lesson page text
- [ ] every lesson has a complete bundle on disk (video, subtitles, caption,
      resources)
- [ ] the encode is verified by full decode, duration and audio stream
- [ ] the **final** index line is decided on paper — how many links per lesson,
      which glyphs, which headers bold — before a single slot is reserved
- [ ] index slots reserved at the head **and** the tail, sized by the formula
      against **both** budgets, entities included
- [ ] every index generator enforces the entity cap itself and hard-fails when
      it runs out of slots — a generator that only counts characters will
      silently ship dead links
- [ ] if there is more than one index (a head table of contents and a tail
      listing, say), **both are produced by the same builder**. Two generators
      drift, and the drift is invisible until a reader notices one has links the
      other does not
- [ ] the uploader handles `FloodWait`, caption overflow and resume
- [ ] the message map is written after every lesson

And two questions to answer out loud before starting. **If a lesson is inserted
in the middle six months from now, what does it cost?** If the answer is more
than "renumber the manifest and send one group", the design is not finished.
**And if every index line grows a second and third link, does the reserve still
hold?** If that answer is a guess, go back and count — it is the cheapest hour
of the project, and the only one that cannot be bought back later.
