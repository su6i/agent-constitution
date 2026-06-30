---
title: Agent Constitution 📜
description: معماری زمینه‌ای اعتبارسنجی‌شده برای ایجنت‌های هوش مصنوعی
location: README.fa.md
last_updated: 2026-06-23
---

<div align="center">

<img alt="Agent Constitution logo" src="assets/project_logo.png" width="350">

<h1>قانون اساسی ایجنت 📜</h1>

<p align="center" dir="ltr">
  <a href="https://github.com/su6i/agent-constitution/blob/main/LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green3.svg" height="20" style="vertical-align: middle;"></a>
  <a href="#"><img alt="Status: Active" src="https://img.shields.io/badge/Status-Active-blue.svg" height="20" style="vertical-align: middle;"></a>
  <img alt="Skills: 367" src="https://img.shields.io/badge/Skills-367-blueviolet.svg" height="20" style="vertical-align: middle;">
  <img alt="Agents: 63" src="https://img.shields.io/badge/Agents-63-orange.svg" height="20" style="vertical-align: middle;">
  <img alt="Commands: 79" src="https://img.shields.io/badge/Commands-79-teal.svg" height="20" style="vertical-align: middle;">
  <a href="https://linkedin.com/in/su6i"><img alt="LinkedIn" src="assets/linkedin_su6i.svg" height="20" style="vertical-align: middle; margin-bottom: -1px; margin-left: 3px;"></a>
</p>

<strong>معماری زمینه‌ای اعتبارسنجی‌شده برای ایجنت‌های هوش مصنوعی</strong><br>
<sub dir="ltr">367 skill · 63 agent · 79 command · سازگار با Claude Code، Cursor، Codex، Gemini CLI</sub>

<div dir="ltr">

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/su6i/agent-constitution/main/install.sh)
```

</div>

[🇬🇧 English](README.md) • [Contributing](CONTRIBUTING.md) • [Changelog](CHANGELOG.md)

</div>

---

## دمو

![Demo](assets/demo.gif)

<div dir="ltr">

> بازسازی: `vhs assets/demo.tape`

</div>

---

## 📍 سند اصلی

سند فنی اصلی این مخزن [AGENTIC-CODING-SETUP.fa.md](AGENTIC-CODING-SETUP.fa.md) است.

اگر به دنبال تحلیل بنچمارک‌ها، انتخاب مدل، اقتصاد استفاده، روتینگ، الگوهای کم‌هزینه و پیکربندی محیط Agentic Coding هستید، باید مطالعه را از همان فایل شروع کنید. بقیه مخزن یا آن را معرفی می‌کند، یا اجرایی‌اش می‌کند، یا بومی‌سازی‌اش می‌کند.

نقشه فایل‌های اصلی:

- [AGENTIC-CODING-SETUP.fa.md](AGENTIC-CODING-SETUP.fa.md) — راهنمای فنی شاخص و مرجع canonical
- [README.fa.md](README.fa.md) — ورودی و لایه ناوبری
- [AGENTS.md](AGENTS.md) — قرارداد اجرایی ایجنت‌ها
- [docs/INFORMATION-ARCHITECTURE.fa.md](docs/INFORMATION-ARCHITECTURE.fa.md) — نقشه کل مخزن

---

## 🏗 مسئله

اکثر ایجنت‌های هوش مصنوعی (Cursor، Antigravity، Windsurf، Copilot) به این دلیل شکست می‌خورند که حافظه و زمینه آن‌ها ساختارمند نیست. یک پرامپت بسیار بلند → توهم. هیچ زمینه‌ای → کد اسپاگتی.

**این پروژه برای حل همین شکاف ساخته شده:** یک قانون اساسی ماژولار که ایجنت را مجبور می‌کند مثل یک مهندس ارشد رفتار کند.

## ⚡ راه‌حل: معماری زمینه‌ای

این مخزن چرخه عمر توسعه نرم‌افزار را به اجزای قابل بارگذاری تفکیک می‌کند — ایجنت فقط همان چیزی را می‌خواند که در همان لحظه لازم دارد.

### ویژگی‌های اصلی

- **روتر سخت‌گیرانه** — برای جلوگیری از حدس‌زدن
- **حافظه ماژولار** — برای کاهش خطای lost-in-the-middle
- **پروتکل حقیقت** — ایجنت بدون `ls` verification نمی‌گوید «تمام شد»
- **لایه‌های جداگانه rule / workflow / skill** — دانش، فرایند و سیاست اجرایی قاطی نمی‌شوند

---

## 🚀 شروع سریع

### نصب یک‌خطی (توصیه‌شده)

<div dir="ltr">

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/su6i/agent-constitution/main/install.sh)
```

</div>

اسکریپت:

- مخزن را در `~/.claude/agent-constitution` کلون می‌کند
- یک symlink از `~/.claude/skills/` به skill catalog می‌زند
- `~/.claude/CLAUDE.md` را با پروتکل کشف skill به‌روز می‌کند

### ترتیب مطالعه

1. [AGENTIC-CODING-SETUP.fa.md](AGENTIC-CODING-SETUP.fa.md) — روش‌شناسی اصلی
2. [AGENTS.md](AGENTS.md) — محدودیت‌های رفتاری ایجنت
3. `.agent/`، `skills/`، `workflows/` — لایه‌های اجرایی

### شخصی‌سازی

قبل از استفاده، ایمیل خود را جایگزین کنید:

<div dir="ltr">

| فایل | خطوط | چه چیزی |
|---|---|---|
| `rules/040-git.md` | 51، 52، 53، 81 | `<your-git-email>` را با ایمیل خود عوض کنید |

```bash
sed -i '' 's/<your-git-email>/your@email.com/g' rules/040-git.md
```

</div>

---

## 📚 مستندات

### ⭐ راهنمای شاخص

- **[Agentic Coding 2026](AGENTIC-CODING-SETUP.fa.md)** — بنچمارک، ROI، روتینگ و setup کم‌هزینه
- **[Information Architecture](docs/INFORMATION-ARCHITECTURE.fa.md)** — نقشه ارتباط کل مخزن

### 🛠 گردش‌کارها

- **[راه‌اندازی پروژه](workflows/init-project.md)** — شروع صحیح
- **[اولین جلسه](workflows/first-session.md)** — آنبورد پروژه جدید
- **[انتشار آپدیت‌ها](workflows/propagate-constitution.md)** — انتشار rules/skills به همه پروژه‌ها
- **[تضمین کیفیت](workflows/quality-assurance.md)** — پروتکل zero-bug

### 🤖 یکپارچه‌سازی MCP

<div dir="ltr">

```bash
cp bin/mcp-server/com.agent-constitution.mcp.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.agent-constitution.mcp.plist
curl http://localhost:8765/health  # → {"status":"ok","skills":367}
```

| ابزار | پیکربندی |
| --- | --- |
| **Claude Code CLI** | بدون تنظیم — stdio خودکار کار می‌کند |
| **Cursor** | `~/.cursor/mcp.json` → `"url": "http://localhost:8765/sse"` |
| **VS Code** | Continue.dev → `~/.continue/config.json` |
| **Gemini CLI** | `~/.gemini/settings.json` → `"httpUrl": "http://localhost:8765/mcp"` |

</div>

---

## 🧠 Skills — ۳۶۷ مهارت

> با `Ctrl+F` روی این صفحه جستجو کنید — نام هر skill، ابزار و تکنولوژی اینجا هست.

<details>
<summary><strong>هوش مصنوعی و یادگیری ماشین</strong> (۲۶ skill)</summary>

| Skill | توضیح |
| --- | --- |
| [ai-logic-patterns](skills/ai-logic-patterns.md) | قوانین master prompting و orchestration ایجنت |
| [ai-regression-testing](skills/ai-regression-testing.md) | تست regression خودکار برای خروجی LLM |
| [ai-router](skills/ai-router/README.md) | مسیریابی مدل با آگاهی از هزینه |
| [ai-video-generation](skills/ai-video-generation.md) | تولید ویدیو با Runway، Kling، Luma، Veo |
| [agentic-engineering](skills/agentic-engineering.md) | ساخت سیستم‌های agentic از ابتدا تا انتها |
| [autonomous-loops](skills/autonomous-loops.md) | حلقه‌های خودکار با quality gate |
| [continuous-learning](skills/continuous-learning.md) | ایجنت‌هایی که از مشاهدات session یاد می‌گیرند |
| [eval-harness](skills/eval-harness.md) | framework ارزیابی LLM و pipeline امتیازدهی |
| [fal-ai-media](skills/fal-ai-media.md) | تولید تصویر و ویدیو با fal.ai (FLUX، Kling، Veo) |
| [foundation-models-on-device](skills/foundation-models-on-device.md) | inference روی دستگاه (MLX، llama.cpp، Core ML) |
| [llm-ml-workflow](skills/llm-ml-workflow.md) | productionizing مدل‌های هوش مصنوعی |
| [multi-rag-orchestration](skills/multi-rag-orchestration.md) | RAG چندمرحله‌ای با حافظه stateful |
| [prompt-engineering](skills/prompt-engineering.md) | system prompt پیشرفته، persona و few-shot |
| [prompt-optimizer](skills/prompt-optimizer.md) | امتیازدهی و تکرار سیستماتیک prompt |
| [pytorch-patterns](skills/pytorch-patterns.md) | training loop، dataset سفارشی، hook |
| [ragas-evaluation](skills/ragas-evaluation.md) | ارزیابی RAG با معیارهای RAGAS |
| [reinforcement-learning](skills/reinforcement-learning.md) | Gymnasium و Stable-Baselines3 |
| [recsys-pipeline-architect](skills/recsys-pipeline-architect.md) | طراحی pipeline سیستم توصیه |
| [ml-adoption-playbook](skills/ml-adoption-playbook.md) | راهنمای پیاده‌سازی ML در سازمان |
| [token-budget-advisor](skills/token-budget-advisor.md) | مدیریت بودجه context و بهینه‌سازی هزینه |
| [cost-aware-llm-pipeline](skills/cost-aware-llm-pipeline.md) | ساخت pipeline در محدوده هزینه هدف |
| [regex-vs-llm-structured-text](skills/regex-vs-llm-structured-text.md) | کِی regex، کِی LLM برای استخراج متن |
| [llm-trading-agent-security](skills/llm-trading-agent-security.md) | امنیت ایجنت‌های معاملاتی مبتنی بر LLM |
| [r-lang-guide](skills/r-lang-guide.md) | pipeline با targets و renv |
| [python-pytorch-sklearn](skills/python-pytorch-sklearn.md) | pipeline داده sklearn با مدل‌های PyTorch |
| [reinforcement-learning](skills/reinforcement-learning.md) | محیط‌های Gymnasium و آموزش Stable-Baselines3 |

</details>

<details>
<summary><strong>سیستم‌های ایجنت و Orchestration</strong> (۲۲ skill)</summary>

| Skill | توضیح |
| --- | --- |
| [agent-architecture-audit](skills/agent-architecture-audit.md) | تشخیص ۱۲ لایه stack ایجنت |
| [agent-eval](skills/agent-eval.md) | framework ارزیابی عملکرد ایجنت |
| [agent-harness-construction](skills/agent-harness-construction.md) | ساخت harness ایجنت production-ready |
| [agent-introspection-debugging](skills/agent-introspection-debugging.md) | دیباگ رفتار ایجنت و شکست‌های خاموش |
| [agent-self-evaluation](skills/agent-self-evaluation.md) | ایجنت‌هایی که خروجی خود را امتیاز می‌دهند |
| [continuous-agent-loop](skills/continuous-agent-loop.md) | حلقه‌های پیوسته ایجنت با CI/PR |
| [intent-driven-development](skills/intent-driven-development.md) | معیار پذیرش قبل از پیاده‌سازی |
| [moltbot-orchestration](skills/moltbot-orchestration.md) | معماری کارخانه ویدیو چند-ایجنته |
| [orch-pipeline](skills/orch-pipeline.md) | pipeline کامل از plan تا deploy |
| [orch-build-mvp](skills/orch-build-mvp.md) | گردش کار ساخت MVP orchestrated |
| [orch-add-feature](skills/orch-add-feature.md) | گردش کار افزودن feature |
| [orch-change-feature](skills/orch-change-feature.md) | گردش کار تغییر feature |
| [orch-fix-defect](skills/orch-fix-defect.md) | گردش کار رفع نقص |
| [orch-refine-code](skills/orch-refine-code.md) | گردش کار بهبود کد |
| [parallel-execution-optimizer](skills/parallel-execution-optimizer.md) | حداکثرسازی parallelism در اجراهای چند-ایجنته |
| [plan-orchestrate](skills/plan-orchestrate.md) | اجرای plan-then-orchestrate چندمرحله‌ای |
| [recursive-decision-ledger](skills/recursive-decision-ledger.md) | دفتر audit تصمیمات ایجنت خودکار |
| [team-agent-orchestration](skills/team-agent-orchestration.md) | هماهنگی تیم ایجنت‌های تخصصی |
| [context-budget](skills/context-budget.md) | ردیابی بودجه token و بهداشت context |
| [cost-tracking](skills/cost-tracking.md) | ابزار هزینه‌سنجی per-session |
| [agentic-os](skills/agentic-os.md) | هماهنگی ایجنت در سطح سیستم‌عامل |
| [autonomous-agent-harness](skills/autonomous-agent-harness.md) | scaffold ایجنت خودکار production-ready |

</details>

<details>
<summary><strong>ویدیو و تولید رسانه</strong> (۲۸ skill)</summary>

| Skill | توضیح |
| --- | --- |
| [fal-ai-media](skills/fal-ai-media.md) | تولید تصویر/ویدیو با fal.ai |
| [ffmpeg-recipes](skills/ffmpeg-recipes.md) | دستورات آماده FFmpeg برای اتوماسیون ویدیو |
| [ffmpeg-reference](skills/ffmpeg-reference.md) | مرجع فنی کدک، متادیتا و فلگ |
| [manim-video](skills/manim-video.md) | الگوهای scene و network graph با Manim |
| [video-manim-math](skills/video-manim-math.md) | انیمیشن ریاضی: OpenGL، plugin، shader |
| [remotion-video-creation](skills/remotion-video-creation.md) | ویدیوی برنامه‌ریزی‌شده با React + Remotion |
| [video-blender-automation](skills/video-blender-automation.md) | اتوماسیون Blender با bpy API |
| [video-production-automation](skills/video-production-automation.md) | pipeline کامل Python: Manim، MoviePy، OpenCV |
| [video-editing](skills/video-editing.md) | گردش‌کار ویرایش ویدیوی حرفه‌ای |
| [video-resolve-editing](skills/video-resolve-editing.md) | DaVinci Resolve و color grading |
| [video-remotion-react](skills/video-remotion-react.md) | تولید ویدیوی برنامه‌ریزی‌شده با React |
| [video-effects-transitions](skills/video-effects-transitions.md) | جلوه‌های ویژه، ترانزیشن و compositing |
| [video-stick-figure](skills/video-stick-figure.md) | انیمیشن stick figure دوبعدی و فیزیک |
| [davinci-resolve-scripting](skills/davinci-resolve-scripting.md) | Python API و اتوماسیون timeline |
| [obs-studio](skills/obs-studio.md) | اتوماسیون OBS، scene و streaming |
| [auto-editor](skills/auto-editor.md) | حذف سکوت خودکار و jump-cut |
| [videodb](skills/videodb.md) | جستجوی vector و scene understanding در VideoDB |
| [visual-ai-cinematography](skills/visual-ai-cinematography.md) | سینماتوگرافی gen-video |
| [visual-character-consistency](skills/visual-character-consistency.md) | حفظ هویت در فریم‌ها با ComfyUI و LoRA |
| [visual-director-procedural](skills/visual-director-procedural.md) | کارگردانی بصری معنایی با Blender و Manim |
| [visual-thumbnail-psychology](skills/visual-thumbnail-psychology.md) | طراحی thumbnail با روان‌شناسی CTR |
| [taste](skills/taste.md) | لایه creative direction برای موزیک ویدیو |
| [comfyui-stable-diffusion](skills/comfyui-stable-diffusion.md) | workflow ComfyUI و node های Stable Diffusion |
| [blender-motion-state-inspection](skills/blender-motion-state-inspection.md) | دیباگ state machine انیمیشن Blender |
| [motion-advanced](skills/motion-advanced.md) | اصول پیشرفته طراحی motion |
| [motion-foundations](skills/motion-foundations.md) | نظریه پایه motion و easing |
| [motion-patterns](skills/motion-patterns.md) | الگوهای قابل استفاده مجدد motion |
| [motion-ui](skills/motion-ui.md) | motion رابط کاربری و micro-interaction |

</details>

<details>
<summary><strong>صدا، TTS و گفتار</strong> (۱۹ skill)</summary>

| Skill | توضیح |
| --- | --- |
| [persian-tts-training](skills/persian-tts-training.md) | pipeline fine-tuning TTS فارسی |
| [voice-synthesis-multilingual](skills/voice-synthesis-multilingual.md) | TTS چندزبانه SOTA و کلونینگ cross-lingual |
| [voice-orchestration-multi-model](skills/voice-orchestration-multi-model.md) | pipeline چند-مدل TTS |
| [voice-ai-cloning-finetuning](skills/voice-ai-cloning-finetuning.md) | کلونینگ صدا و سنتز احساسی |
| [voice-dialogue-tts](skills/voice-dialogue-tts.md) | چندگوینده و prosody احساسی |
| [voice-emotional-acting](skills/voice-emotional-acting.md) | بازیگری صدا با یک نفر |
| [audio-processing](skills/audio-processing.md) | denoising عصبی و normalization EBU R128 |
| [ai-dubbing-localization](skills/ai-dubbing-localization.md) | دوبلاژ خودکار و localization |
| [ai-sfx-generation](skills/ai-sfx-generation.md) | طراحی صدا با latent diffusion |
| [music-generation](skills/music-generation.md) | تولید موسیقی با Suno، Udio، MusicGen |
| [storytelling-tts-m4-system](skills/storytelling-tts-m4-system.md) | pipeline داستان‌سرایی TTS روی Apple Silicon |
| [subtitle-generator](skills/subtitle-generator.md) | زیرنویس حرفه‌ای با typography سینمایی |
| [mlx-whisper](skills/mlx-whisper.md) | تبدیل گفتار به متن روی Apple Silicon |
| [fish-speech](skills/fish-speech.md) | راه‌اندازی و fine-tuning Fish Speech TTS |
| [gpt-sovits](skills/gpt-sovits.md) | کلونینگ صدا با GPT-SoVITS |
| [xtts-v2](skills/xtts-v2.md) | fine-tuning XTTS-v2 و استریمینگ |
| [huggingface-tts](skills/huggingface-tts.md) | کاتالوگ مدل TTS روی HuggingFace |
| [opensource-tts](skills/opensource-tts.md) | مقایسه stack های TTS متن‌باز |
| [heygen-api](skills/heygen-api.md) | تولید ویدیوی avatar با HeyGen API |

</details>

<details>
<summary><strong>تولید محتوا، یوتیوب و بازاریابی</strong> (۲۳ skill)</summary>

| Skill | توضیح |
| --- | --- |
| [youtube-seo](skills/youtube-seo.md) | عنوان، thumbnail، retention و رشد کانال |
| [youtube-automation-pipeline](skills/youtube-automation-pipeline.md) | اتوماسیون انتشار end-to-end یوتیوب |
| [youtube-analytics](skills/youtube-analytics.md) | تحلیل و گزارش YouTube Data API |
| [youtube-data-api](skills/youtube-data-api.md) | YouTube Data API v3 — آپلود، playlist، caption |
| [youtube-dlp-web-download](skills/youtube-dlp-web-download.md) | yt-dlp: دور زدن Cloudflare، انتخاب stream |
| [screenwriting-youtube](skills/screenwriting-youtube.md) | hook های high-retention و روان‌شناسی |
| [screenwriting-frameworks](skills/screenwriting-frameworks.md) | ساختار سه‌پرده، سفر قهرمان، beat sheet |
| [screenwriting-automated](skills/screenwriting-automated.md) | pipeline تولید اسکریپت ۱۰۰٪ خودکار |
| [storytelling-narrative-frameworks](skills/storytelling-narrative-frameworks.md) | Save the Cat، Story Circle و ساختارهای پیشرفته |
| [content-engine](skills/content-engine.md) | pipeline تولید محتوای خودکار |
| [social-publisher](skills/social-publisher.md) | انتشار زمان‌بندی‌شده چند-پلتفرمی |
| [crosspost](skills/crosspost.md) | توزیع محتوا در پلتفرم‌های مختلف |
| [brand-discovery](skills/brand-discovery.md) | تحقیق موضع‌گیری و هویت برند |
| [brand-voice](skills/brand-voice.md) | مدل‌سازی صدای یکپارچه برند |
| [competitive-platform-analysis](skills/competitive-platform-analysis.md) | تحلیل سیستماتیک پلتفرم رقیب |
| [competitive-report-structure](skills/competitive-report-structure.md) | قالب گزارش اطلاعات رقابتی |
| [marketing-campaign](skills/marketing-campaign.md) | برنامه‌ریزی، اجرا و اندازه‌گیری کمپین |
| [seo](skills/seo.md) | SEO فنی، بهینه‌سازی on-page و audit |
| [copywriting](skills/copywriting.md) | کپی‌رایتینگ conversion-focused |
| [article-writing](skills/article-writing.md) | ساختار مقاله بلند و نوشتن برای SEO |
| [social-graph-ranker](skills/social-graph-ranker.md) | تحلیل شبکه اجتماعی و رتبه‌بندی تأثیر |
| [x-api](skills/x-api.md) | الگوهای X/Twitter API v2 |
| [storytelling-clil-education](skills/storytelling-clil-education.md) | داستان‌سرایی آموزشی و Leitner SRS |

</details>

<details>
<summary><strong>تحقیقات علمی و بازار</strong> (۱۲ skill)</summary>

| Skill | توضیح |
| --- | --- |
| [deep-research](skills/deep-research.md) | پروتکل‌های تحقیق چند-منبعی سیستماتیک |
| [exa-search](skills/exa-search.md) | یکپارچه‌سازی Exa semantic search API |
| [market-research](skills/market-research.md) | روش‌های تحقیق بازار اولیه و ثانویه |
| [research-ops](skills/research-ops.md) | اتوماسیون گردش‌کار تحقیق |
| [scientific-thinking-literature-review](skills/scientific-thinking-literature-review.md) | روش‌شناسی مرور ادبیات سیستماتیک |
| [scientific-thinking-scholar-evaluation](skills/scientific-thinking-scholar-evaluation.md) | ارزیابی کیفیت مقاله علمی |
| [scientific-db-pubmed-database](skills/scientific-db-pubmed-database.md) | query های PubMed API |
| [scientific-db-uspto-database](skills/scientific-db-uspto-database.md) | جستجوی پتنت USPTO |
| [scientific-pkg-gget](skills/scientific-pkg-gget.md) | بازیابی داده ژنومیک با gget |
| [ml-adoption-playbook](skills/ml-adoption-playbook.md) | راهنمای پیاده‌سازی ML در سازمان |
| [prediction-market-oracle-research](skills/prediction-market-oracle-research.md) | منابع داده بازار پیش‌بینی |
| [prediction-market-risk-review](skills/prediction-market-risk-review.md) | ارزیابی ریسک موضع‌گیری در بازار پیش‌بینی |

</details>

<details>
<summary><strong>Python</strong> (۸ skill)</summary>

| Skill | توضیح |
| --- | --- |
| [python-core-standards](skills/python-core-standards.md) | ساختار پروژه، uv، typing و قراردادها |
| [python-containerization](skills/python-containerization.md) | Docker: Slim vs Alpine، multi-stage |
| [python-github-setup](skills/python-github-setup.md) | GitHub Actions، template و semantic release |
| [python-pandas-sklearn](skills/python-pandas-sklearn.md) | method chaining، pipeline و ColumnTransformer |
| [python-patterns](skills/python-patterns.md) | الگوهای اصیل Python |
| [python-pytorch-sklearn](skills/python-pytorch-sklearn.md) | pipeline داده sklearn با PyTorch |
| [python-testing](skills/python-testing.md) | pytest، fixture، parametrize و coverage |
| [generating-python-installer](skills/generating-python-installer.md) | ساخت بسته‌های installer Python |

</details>

<details>
<summary><strong>وب و فرانت‌اند</strong> (۲۴ skill)</summary>

| Skill | توضیح |
| --- | --- |
| [fastapi-patterns](skills/fastapi-patterns.md) | ساختار پروژه FastAPI، auth، DI و تست |
| [fastapi-best-practices](skills/fastapi-best-practices.md) | FastAPI: Pydantic v2، lifespan، background tasks |
| [react-patterns](skills/react-patterns.md) | الگوهای component React و hook |
| [react-performance](skills/react-performance.md) | بهینه‌سازی rendering React |
| [react-testing](skills/react-testing.md) | Testing Library، MSW و Vitest |
| [nextjs-turbopack](skills/nextjs-turbopack.md) | Next.js App Router و Turbopack |
| [vue-patterns](skills/vue-patterns.md) | Vue 3 Composition API |
| [nuxt4-patterns](skills/nuxt4-patterns.md) | معماری Nuxt 4 |
| [angular-developer](skills/angular-developer.md) | معماری Angular، RxJS |
| [vite-patterns](skills/vite-patterns.md) | پیکربندی Vite و بهینه‌سازی build |
| [js-ts-code-quality](skills/js-ts-code-quality.md) | TypeScript سخت‌گیرانه، Biome/ESLint |
| [modern-web-ui](skills/modern-web-ui.md) | بهترین روش‌های HTML/CSS/JS خالص |
| [flask-json-guide](skills/flask-json-guide.md) | ساختار Flask API و مدیریت خطا |
| [frontend-patterns](skills/frontend-patterns.md) | الگوهای معماری فرانت‌اند |
| [frontend-a11y](skills/frontend-a11y.md) | دسترس‌پذیری وب (WCAG، ARIA) |
| [design-system](skills/design-system.md) | design token، کتابخانه component |
| [liquid-glass-design](skills/liquid-glass-design.md) | الگوهای UI liquid glass در iOS 26 |
| [chrome-extension-best-practices](skills/chrome-extension-best-practices.md) | افزونه‌های MV3، Shadow DOM |
| [bun-runtime](skills/bun-runtime.md) | راه‌اندازی Bun، bundling و تست |
| [ui-demo](skills/ui-demo.md) | الگوهای demo و prototype تعاملی |
| [vite-patterns](skills/vite-patterns.md) | پیکربندی Vite |
| [ui-to-vue](skills/ui-to-vue.md) | مهاجرت کامپوننت‌های UI به Vue 3 |
| [make-interfaces-feel-better](skills/make-interfaces-feel-better.md) | micro-interaction و polish برای هر UI |
| [frontend-slides](skills/frontend-slides.md) | ابزار ارائه مبتنی بر مرورگر |

</details>

<details>
<summary><strong>بک‌اند</strong> (۴۰+ skill)</summary>

| Skill | توضیح |
| --- | --- |
| [golang-patterns](skills/golang-patterns.md) | idiom های Go، concurrency |
| [rust-patterns](skills/rust-patterns.md) | ownership، trait و async در Rust |
| [java-coding-standards](skills/java-coding-standards.md) | Java 21+ record، sealed type |
| [django-patterns](skills/django-patterns.md) | ساختار پروژه Django و ORM |
| [springboot-patterns](skills/springboot-patterns.md) | معماری Spring Boot |
| [nestjs-patterns](skills/nestjs-patterns.md) | module، provider و interceptor در NestJS |
| [laravel-patterns](skills/laravel-patterns.md) | معماری Laravel و Eloquent |
| [kotlin-patterns](skills/kotlin-patterns.md) | idiom های Kotlin Android |
| [backend-patterns](skills/backend-patterns.md) | الگوهای معماری بک‌اند cross-language |
| [hexagonal-architecture](skills/hexagonal-architecture.md) | الگوی ports and adapters |
| [error-handling](skills/error-handling.md) | مدیریت خطای ساختارمند |
| ... | و ۳۰+ skill دیگر (Django، Spring، Quarkus، Laravel، Perl، C++، F#) |

</details>

<details>
<summary><strong>موبایل</strong> (۱۲ skill)</summary>

| Skill | توضیح |
| --- | --- |
| [swiftui-guidelines](skills/swiftui-guidelines.md) | معماری مدرن SwiftUI |
| [swiftui-patterns](skills/swiftui-patterns.md) | الگوهای component و state در SwiftUI |
| [swift-concurrency-6-2](skills/swift-concurrency-6-2.md) | مدل concurrency سخت‌گیرانه Swift 6.2 |
| [jetpack-compose-guidelines](skills/jetpack-compose-guidelines.md) | UI اعلانی Android |
| [kotlin-patterns](skills/kotlin-patterns.md) | idiom های Kotlin و Coroutines |
| [android-clean-architecture](skills/android-clean-architecture.md) | Clean Architecture و MVVM در Android |
| [dart-flutter-patterns](skills/dart-flutter-patterns.md) | معماری Flutter |
| [compose-multiplatform-patterns](skills/compose-multiplatform-patterns.md) | Kotlin Multiplatform + Compose |
| [ios-icon-gen](skills/ios-icon-gen.md) | تولید آیکون iOS و asset catalog |
| [swift-actor-persistence](skills/swift-actor-persistence.md) | actor های Swift و SwiftData |
| [swift-protocol-di-testing](skills/swift-protocol-di-testing.md) | DI مبتنی بر protocol در Swift |
| [flutter-dart-code-review](skills/flutter-dart-code-review.md) | چک‌لیست بررسی کد Flutter |

</details>

<details>
<summary><strong>دیتابیس، DevOps، شبکه، Web3، امنیت، تست</strong> (۵۰+ skill)</summary>

| دسته | skill های کلیدی |
| --- | --- |
| **دیتابیس** | postgres-patterns، mysql-patterns، redis-patterns، database-migrations، clickhouse-io، prisma-patterns |
| **DevOps** | kubernetes-patterns، docker-patterns، deployment-patterns، git-workflow، github-ops، ops-automation |
| **شبکه/NetDevOps** | cisco-ios-patterns، netmiko-ssh-automation، network-bgp-diagnostics، homelab-wireguard-vpn |
| **Web3** | web3-solidity-foundry، web3-solidity-hardhat، web3-react-dapps، defi-amm-security |
| **امنیت** | security-review، security-scan، hipaa-compliance، gateguard، safety-guard |
| **تست** | tdd-workflow، e2e-testing، browser-qa، benchmark، ragas-evaluation |
| **Claude Code** | claude-code-integration، hookify-rules، context-budget، skill-scout |
| **دمو CLI** | [cli-demo-recording](skills/cli-demo-recording.md) — VHS، asciinema، terminalizer |

</details>

---

## 🪝 هوک‌های گیت (اعمالِ خودکار)

دو هوک، قوانینِ غیرقابل‌مذاکرهٔ گیت (`rules/040-git.md`) را به دروازه‌هایی قطعی تبدیل می‌کنند که هیچ اجنت یا انسانی نتواند «فراموش»‌شان کند. منبعِ canonicalشان در `templates/hooks/` است و با `amir init-project` (مخزنِ جدید) و `amir update-projects` (مخزنِ موجود) در `.git/hooks/` نصب می‌شوند.

| هوک | چه چیزی را بلاک می‌کند |
| ------ | ------------------------ |
| `pre-commit` | commitِ مستقیم روی `main`/`master` (باید feature branch بزنی)؛ و **چک‌لیستِ مستندات** — تغییرِ کد باید یک سند را هم به‌روز کند. |
| `commit-msg` | **هم‌نویسندگیِ هوش مصنوعی — هرگز.** هر تریلرِ `Co-Authored-By: <AI>`، خطِ «Generated with `<AI>`»، یا نشانهٔ 🤖. |

### دوستشان نداری؟ نحوهٔ غیرفعال‌سازی

```bash
git commit --no-verify             # دور زدن برای فقط یک commit (ردّش در history می‌ماند)
rm .git/hooks/commit-msg           # حذفِ یک هوک از این clone
rm .git/hooks/pre-commit
amir update-projects --no-hook     # sync constitution بدونِ نصبِ دوبارهٔ هوک‌ها
```

حذفِ یک هوک فقط همان clone را تحت‌تأثیر می‌گذارد؛ templateها و قوانین دست‌نخورده می‌مانند و `amir update-projects`ِ بعدی دوباره نصبشان می‌کند مگر `--no-hook` بدهی.

## 🤝 مشارکت

قبل از هر Pull Request فایل [CONTRIBUTING.md](CONTRIBUTING.md) را بخوانید.

## 📝 لایسنس

این پروژه تحت [MIT](LICENSE) منتشر شده است.

---

## تقدیر و تشکر

catalog مهارت‌های این مخزن شامل محتوای اقتباس‌شده از
[ECC — Everything Claude Code](https://github.com/affaan-m/ECC) نوشته affaan-m (MIT) است.
اگر مهارتی اینجا پیدا نشد، ECC جای خوبی برای جستجوی بعدی است.
