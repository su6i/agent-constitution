---
title: "Video Triage"
description: Decide whether a (mostly YouTube) video is worth watching in under 90 seconds, using captions only — no downloads, no transcription — then hand over a five-part-scored Persian report so the video itself never has to be watched when it isn't worth it.
location: skills/video-triage.md
agent_priority: Standard
last_updated: 2026-09-09
version: 1.0.0
updated: 2026-09-09
---

**🔗 Related YouTube Skills:**

- [YouTube Data API v3](youtube-data-api.md) - the fallback for exact view/like
  counts when the URL/caption ladder below can't produce them
- [YouTube Analytics](youtube-analytics.md) - channel-level analytics reporting;
  this skill triages one video at a time, not a channel

**🔗 Related Skills:**

- [Taste](taste.md) - judging direction and feel once you've already decided
  the video is worth watching

[Back to README](../README.md)

---

# Skill: Video Triage — Decide in Under 90 Seconds

Answers one question for a video URL: **is this worth my time?** — and if the
answer is "no" or "partially", extracts everything of value from it so the
owner never has to press play. The report is the deliverable, not a summary of
the report.

## 1. Hard Budget (Non-Negotiable)

> A one-hour video must never cost hours of processing. This rule is a hard
> ceiling, not advice, and it is checked before anything else in this skill.

- **≤ 90 seconds wall clock, ≤ 2 model calls, per video.** Both limits apply to
  every single triage, batch or not.
- **Never download media.** No `yt-dlp` video/audio download, no `ffmpeg`, and
  **no Whisper (or any ASR) transcription** — explicitly rejected by the
  owner. There is no slow path for this skill; there is only the ladder below
  and abort.
- The transcript comes from **YouTube's own captions** — either ingested by
  Gemini directly from the URL, or fetched from the caption track over HTTP.
  It never comes from decoding or transcribing audio.
- **If the extraction ladder cannot produce a transcript** (no captions exist
  on the video, and the caption-endpoint fallback also comes back empty):
  **abort and report**, verbatim:

  ```text
  ❌ blocked: no captions, manual review needed
  ```

  Never silently escalate to a slower path (a download, a transcription, a
  third model call) to work around missing captions. A blocked triage is a
  valid, complete outcome of this skill.

## 2. Extraction Ladder

Fastest first. Stop at the first rung that returns a usable transcript.

### Rung 1 — Gemini with the URL (default; almost always the only rung)

Call `mcp__ai-router__delegate_research` (`gemini-flash`, $0) with the watch
URL and the analysis prompt from §4. Gemini ingests YouTube links server-side,
so this is one call that returns the transcript-derived summary, chapters,
claims, resources, and whatever public metadata its own grounding can support.
This is **call 1 of 2** and is the default path — in the common case it is
also the *only* call needed.

- **Can produce:** full transcript-grounded summary, topic list, quotes and
  points with the model's own timestamps, chapter boundaries if the video has
  them, best-effort public metadata (title, channel, publish date, duration).
- **Cannot reliably produce:** exact, current view/like counts (grounding can
  be stale), frame-accurate timecodes (Gemini's own segmentation, not the
  caption track's).

### Rung 2 — Captions endpoint (fallback: transcript incomplete or missing)

A plain HTTP fetch of the video's caption track (the `timedtext` endpoint)
plus the watch page for title / channel / date / views / likes. No binaries,
no model call to fetch — seconds of network time. Summarizing the fetched
transcript then costs **call 2 of 2**.

- **Can produce:** the exact caption text at caption-track granularity (real
  timecodes, not model-estimated ones), scraped page metadata.
- **Cannot produce:** grounded search context or anything outside the video
  itself — Rung 1's world-knowledge grounding is gone once you're off Gemini.
- Use when Rung 1 returns no transcript (private/auto-caption-off videos
  sometimes still expose a track this way) or when a report needs
  frame-accurate timecodes more than it needs grounding.

### Rung 3 — `youtube-data-api` skill (fallback: exact counts required)

Only when exact view/like counts are required and Rungs 1–2 did not produce
them. See [YouTube Data API v3](youtube-data-api.md) for `videos.list`. This
is a data lookup, not a model call, so it does not count against the 2-call
budget — but it still must fit inside the 90-second wall clock, so use it only
when a real threshold decision needs the exact number, not as decoration.

## 3. Scoring Model

Total **100**, as five weighted sub-scores. The report always prints the
sub-score table — never only the total.

| Sub-score | Weight | What it measures | How to estimate it |
| --- | --- | --- | --- |
| Signal density | 30 | Useful points per minute | Count distinct, non-redundant, concrete points; scale against video length — a 10-minute video with 8 real points scores near the top, a 60-minute video with 8 points does not |
| Novelty | 20 | Not obtainable from one web search | High if the content requires the video's specific experiment, data, or synthesis; low if it restates common knowledge a search would surface |
| Evidence | 20 | Benchmarks / code / sources vs. personal assertion | High for shown benchmarks, live demos, cited sources, working code; low for unsupported opinion or "trust me" claims |
| Actionability | 20 | Usable tomorrow | High if the owner can apply something without further research; low if it's inspiration with no concrete step |
| Noise penalty | 10 | Ads, repetition, long intro — **inverted**, 10 = clean | Start at 10, deduct for sponsor reads, restated intros/outros, padding, and repetition |

Verdict tiers:

| Score | Verdict |
| --- | --- |
| 80–100 | Watch in full |
| 55–79 | Watch only the marked ranges |
| 30–54 | The summary is enough — do not watch |
| 0–29 | Skip |

**Minutes saved** = video duration − recommended watch time, where recommended
watch time is 0 for the bottom two tiers, the sum of the marked-range
durations for the "watch only the marked ranges" tier, and the full duration
for "watch in full". Every report states this number.

## 4. Procedure — Single-Video Triage

1. **Parse the URL** and extract the video ID.
2. **Check the ledger first** (`~/.local/share/agent-projects/_memory/video-triage/triaged.jsonl`,
   §5). If the URL or video ID is already a row, return that row's data
   straight into the output template — do not spend a call re-triaging it.
3. **Run the extraction ladder** (§2), stopping at the first rung that returns
   a usable transcript, inside the 90-second / 2-call budget. If nothing on
   the ladder returns a transcript, abort per §1.
4. **Ask the model** (Rung 1, or the Rung-2-transcript summarization call) in
   English, not Persian — a strict field checklist is easier to validate, and
   it keeps the same call reusable regardless of the report's output
   language. Render the Persian template yourself from the structured
   response; never ask the model to write the Persian report directly.

   Prompt shape:

   ```text
   Analyze the YouTube video at <watch_url>. Use your own ingestion of the
   URL (captions plus any grounding search) — do not guess or invent a
   number you cannot support.

   Return, in English:
   1. title, channel, publish_date, duration_seconds, view_count, like_count
      (mark any you cannot support as "unknown")
   2. chapters: [{start_seconds, end_seconds, title}]
   3. important_headings: the topic list, in the order they occur
   4. summary: a comprehensive, substantive summary — this is the primary
      output, write it so the reader never needs to watch the video for its
      content
   5. golden_points: [{point, start_seconds, end_seconds}] — real value
      points, wherever in the video they occur, even if the video overall
      is not worth watching
   6. claims_to_verify: [{claim, timestamp_seconds}] — assertions stated as
      fact that a careful viewer should independently check
   7. resources: [{name, type: repo|tool|command|paper|link, timestamp_seconds}]
   8. comment_signal: a strong signal about top comments if your own
      ingestion supports one (e.g. "top comment says the real answer is at
      7:20"); "none found" if you cannot support one — never fabricate a
      comment
   9. signal_density (0-30), novelty (0-20), evidence (0-20),
      actionability (0-20), noise_penalty (0-10) — your own estimate per the
      rubric in §3, one line of reasoning each
   ```

5. **Compute** the total score, verdict tier, and minutes saved from the
   returned sub-scores (§3).
6. **Place timecodes** as whole seconds. Build every deep link canonically as
   `https://www.youtube.com/watch?v=<video_id>&t=<seconds>s`, always rebuilt
   from the video ID parsed in step 1 — never by appending `&t=` to the URL
   the owner pasted. A `youtu.be/<id>` or `/shorts/<id>` link carries no query
   string, so appending `&t=` to it produces a dead link. Never a fractional
   second.
7. **Build the chapter map** (output §5): one row per chapter from the
   model's `chapters` list, each with a worth flag (✅ / ❌) derived from
   whether that chapter's content contributes real signal per §3, and its
   `t=` deep link.
8. **Build the golden-points list** (output §6) from `golden_points`,
   `from–to` seconds each. If a point is scattered across an otherwise weak
   video, state the point once and say plainly that the rest of the video is
   not worth watching — do not pad this section into a second chapter map.
9. **Write the ledger row** (§5) after scoring, before rendering the report.
10. **Render** the Persian output template (§6) with everything above.

## 5. Ledger and Batch Mode

### Ledger

One JSON object per line, appended to
`~/.local/share/agent-projects/_memory/video-triage/triaged.jsonl` (create the
directory if it doesn't exist):

```json
{"url": "<watch_url>", "video_id": "<id>", "title": "<title>", "channel": "<channel>", "published": "<ISO date>", "duration_s": 3600, "score": 62, "subscores": {"signal_density": 20, "novelty": 12, "evidence": 14, "actionability": 12, "noise_penalty": 4}, "verdict": "watch only the marked ranges", "minutes_saved": 38, "triaged_at": "<ISO 8601 timestamp>"}
```

- **Re-triage of a URL already in the ledger returns the stored row** — never
  spend a call re-triaging a video already triaged.
- **Per-channel running average:** after each write, compute the average
  `score` across every ledger row for that `channel`. A channel averaging
  below **35** is reported as `auto-skip candidate` in output §10 — this is
  reported only, never acted on silently (never refuse or skip a triage on
  your own judgment because of it).

### Batch Mode

Given a playlist URL or a list of URLs, triage each one under the same
per-video 90-second / 2-call budget and ledger lookup as §4, but change the
report shape:

1. Produce **one ranked Persian table** — columns: video (title + link),
   score, verdict, minutes saved — sorted by score descending.
2. Produce the **full ten-section report** (§6) only for rows scoring **55 or
   above** (the two "watch" tiers). Rows below that stay as a table row only —
   generating a full report nobody will act on wastes the budget the ladder
   is trying to protect.

## 6. Output Template

Markdown, in Persian, in this exact order — section 3 comes before section 4
by explicit instruction. Fill every placeholder; do not add sections.

```markdown
## ۱. کارت ویدیو

- عنوان: <عنوان ویدیو>
- کانال: <نام کانال>
- تاریخ انتشار: <تاریخ>
- مدت زمان: <mm:ss یا hh:mm:ss>
- بازدید: <تعداد بازدید یا «نامشخص»>
- لایک: <تعداد لایک یا «نامشخص»>
- نسبت لایک به بازدید: <درصد یا «نامشخص»>

## ۲. حکم و امتیاز

**حکم:** <تماشای کامل | فقط تماشای بازه‌های علامت‌گذاری‌شده | خلاصه کافی است، تماشا نکنید | رد شود>
**امتیاز کل:** <۰ تا ۱۰۰>

| زیرامتیاز | وزن | امتیاز |
| --- | --- | --- |
| تراکم سیگنال | ۳۰ | <۰ تا ۳۰> |
| نوآوری | ۲۰ | <۰ تا ۲۰> |
| شواهد | ۲۰ | <۰ تا ۲۰> |
| قابلیت اجرا | ۲۰ | <۰ تا ۲۰> |
| جریمه‌ی نویز (معکوس، ۱۰ یعنی تمیز) | ۱۰ | <۰ تا ۱۰> |

**دقیقه‌ی صرفه‌جویی‌شده:** <مدت ویدیو منهای زمان تماشای پیشنهادی>

## ۳. عنوان‌های مهم

- <عنوان/موضوع مهم ۱>
- <عنوان/موضوع مهم ۲>

## ۴. خلاصه‌ی جامع

<خلاصه‌ی کامل و محتوایی — این بخش، محصول اصلی گزارش است>

## ۵. نقشه‌ی فصل‌ها

| فصل | از–تا | ارزش تماشا | لینک |
| --- | --- | --- | --- |
| <عنوان فصل> | <mm:ss–mm:ss> | ✅ ارزش دارد / ❌ ارزش ندارد | `https://www.youtube.com/watch?v=<video_id>&t=<ثانیه>s` |

## ۶. نکات طلایی با تایم‌کد

- <نکته> — <از>–<تا> ثانیه (لینک: `https://www.youtube.com/watch?v=<video_id>&t=<از>s`)
- <در صورت پراکندگی: «این نکته در طول ویدیو پراکنده است؛ باقی ویدیو ارزش تماشا ندارد.»>

## ۷. ادعاهایی که باید راستی‌آزمایی شوند

- <ادعا> — زمان: <mm:ss>

## ۸. منابع، ریپوها و دستورهای نام‌برده‌شده

- <نام منبع/ریپو/دستور> — <نوع>، زمان: <mm:ss>

## ۹. سیگنال کامنت‌های برتر

- <سیگنال کامنت، مثلاً «پاسخ واقعی در ۷:۲۰ است» یا «این ادعا اشتباه است»>
- <در صورت نبود سیگنال: «سیگنال قابل‌اتکایی از کامنت‌ها یافت نشد.»>

## ۱۰. یادداشت لجر

ردیف این ویدیو در `~/.local/share/agent-projects/_memory/video-triage/triaged.jsonl` ثبت شد.
<در صورت میانگین کانال زیر ۳۵: «⚠️ این کانال کاندید auto-skip است (میانگین: <عدد>).»>
```

## Related Skills

- [YouTube Data API v3](youtube-data-api.md) - exact view/like counts (Rung 3
  fallback)
- [YouTube Analytics](youtube-analytics.md) - channel-level analytics, not
  per-video triage
- [Taste](taste.md) - judging a video's direction and feel once you've
  decided it's worth watching

---

[Back to README](../README.md)
