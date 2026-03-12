---
title: "Agentic Coding 2026 (Persian)"
description: راهنمای فارسی راه‌اندازی پیشرفته، بنچمارک‌ها، و تحلیل ROI برای توسعه مبتنی بر ایجنت.
location: AGENTIC-CODING-SETUP.fa.md
document_role: flagship-guide
last_updated: 2026-03-12
---

[بازگشت به README فارسی](README.fa.md)

# گزارش فنی: متدولوژی و پیکربندی Agentic Coding در ۲۰۲۶

*این نسخه، راهنمای فنی شاخص فارسی این مخزن است.*

این سند، مرجع canonical فارسی برای پیاده‌سازی جریان‌های کاری Agentic Coding است و بر توازن دقیق میان **کیفیت مهندسی، توان مدل، و هزینه عملیاتی** تمرکز دارد.

---

## ۱. چرا این سند مهم‌ترین سند پروژه است؟

در ساختار جدید مخزن:
- [AGENTIC-CODING-SETUP.fa.md](AGENTIC-CODING-SETUP.fa.md) سند فنی اصلی فارسی است.
- [README.fa.md](README.fa.md) ورودی و لایه ناوبری است.
- [AGENTS.md](AGENTS.md) قرارداد اجرایی برای ایجنت‌ها است.

به زبان ساده، اگر بخواهید فقط یک سند فارسی را برای تصمیم‌گیری درباره مدل‌ها، هزینه، routing، setup و الگوهای کم‌هزینه بخوانید، باید همین سند را بخوانید.

---

## ۲. به‌روزرسانی‌های کلیدی

- **GPT-5.4** جایگزین GPT-5.2 شده است.
- **DeepSeek V3.2** به عنوان گزینه اصلی کم‌هزینه تثبیت شده است.
- **Claude Haiku 4.5** به عنوان گزینه میانی ارزان‌تر از Sonnet ولی قابل‌اعتمادتر از بعضی مدل‌های اقتصادی برای tool-calling اضافه شده است.
- الگوهای **Reasoning Toggle**، **Ollama Local Models**، **Batch Prompting**، **Cache-Aware Prompting** و **R1 Distill 7B** به عنوان الگوهای کاهش هزینه افزوده شده‌اند.

---

## ۳. ماتریس مقایسه‌ای مدل‌ها

### رتبه‌بندی بر اساس SWE-bench Verified

1. Claude Opus 4.6 — 80.8%
2. Gemini 3.1 Pro — 80.6%
3. MiniMax M2.5 — 80.2%
4. GPT-5.4 — 80.0%
5. Claude Sonnet 4.6 — 79.6%
6. Kimi K2.5 — 76.8%
7. Gemini 3 Pro — 76.2%
8. DeepSeek Speciale — حدود 76%
9. DeepSeek V3.2 — حدود 73%
10. Gemini 3 Flash — 57.6%
11. GPT-5 mini — حدود 52%

### برداشت عملی از این رتبه‌بندی

- برای **کار روزانه و اقتصادی**، DeepSeek V3.2 هنوز نقطه شروع عالی است.
- برای **feature work با reasoning بهتر**، MiniMax M2.5 انتخاب بسیار خوبی است.
- برای **تصمیم‌های معماری، امنیت و review نهایی**، Sonnet 4.6 یا Opus 4.6 هنوز سطح بالاتری دارند.
- **Claude Haiku 4.5** را باید به‌عنوان گزینه bridge دید: ارزان‌تر از Sonnet، اما با reliability بهتر از برخی مدل‌های ultra-budget در workflowهای چندمرحله‌ای.

---

## ۴. شاخص‌های بنچمارک و تفسیر آن‌ها

### SWE-bench Verified
نشان می‌دهد مدل چقدر در حل issueهای واقعی مهندسی نرم‌افزار قابل‌اعتماد است.

### Terminal-Bench
برای کیفیت استفاده از shell، package manager، و عملیات فایل مهم است. برای Sonnet، عدد محافظه‌کارانه‌تر **حدود 40%** در نظر گرفته شده است تا با داده‌های جدید سازگارتر باشد.

### ARC-AGI-2
نماینده‌ی قدرت reasoning نوین و حل مسئله خارج از توزیع آموزشی است.

### AIME
نشانه‌ای برای پایداری منطقی در مسائل چندمرحله‌ای و الگوریتمی است.

### Context Window
برای پروژه‌های بزرگ اهمیت دارد. هرچه پنجره زمینه بزرگ‌تر باشد، ایجنت می‌تواند فایل‌های بیشتری را هم‌زمان درک کند.

---

## ۵. تحلیل اقتصادی

### مدل‌های اصلی از دید هزینه/کیفیت

- **DeepSeek V3.2:** بهترین گزینه برای حجم بالای taskهای معمولی.
- **MiniMax M2.5:** نسبت استدلال به قیمت بسیار خوب.
- **Claude Sonnet 4.6:** برای taskهای گران اما حساس.
- **Claude Haiku 4.5:** وقتی Claude-style reliability می‌خواهید اما Sonnet زیادی گران است.

### Copilot

- GPT-4.1 و GPT-5 mini معمولاً گزینه‌های included هستند.
- Claude Sonnet در Copilot ممکن است multiplier داشته باشد؛ پس برای taskهای trivial هدررفت است.

---

## ۶. تخصیص نقش‌ها در متدولوژی A-B-R

### Architect
- MiniMax M2.5
- Gemini 3.1 Pro
- Claude Sonnet 4.6

### Builder
- DeepSeek V3.2
- MiniMax M2.5

### Reviewer
- Claude Sonnet 4.6
- Claude Opus 4.6
- Human-in-the-loop

### اصل عملی
۹۰٪ taskها باید با مدل‌های اقتصادی انجام شوند و فقط ۱۰٪ taskهای معماری/امنیتی به مدل‌های premium برسند.

---

## ۷. زیرساخت پیشنهادی

### هسته اصلی
- VS Code + Cline / Roo Code
- GitHub Copilot
- DeepSeek API direct
- Claude API

### ابزارهای مکمل
- Ghostty یا WezTerm به جای Warp اگر صرفه‌جویی مهم است.
- Gemini CLI برای Q&A سریع.
- Jules برای taskهای async.
- OpenRouter به‌عنوان fallback یا تجمیع‌کننده providerها.

### درباره OpenClaw
OpenClaw جایگزین Cline برای coding session نیست. برای background automation و orchestration بهتر است، نه برای کدنویسی step-by-step.

---

## ۸. مدیریت زمینه و حافظه

برای پروژه‌های agentic، مشکل اصلی معمولاً مدل نیست؛ **context discipline** است.

### قواعد پایه
- یک task = یک session = یک commit.
- قبل از هر task: memory-bank را بخوان.
- برای taskهای طولانی: summary بنویس و session را تازه شروع کن.
- کل codebase را بی‌هدف به مدل نده؛ tree و repomap بهتر از paste کردن فایل‌های کامل هستند.

---

## ۹. روتینگ هوشمند مدل‌ها

### دسته‌بندی ساده taskها

| سطح | مثال | مدل پیش‌فرض |
|---|---|---|
| Trivial | lint fix, test tweak, rename | DeepSeek V3.2 |
| Moderate | feature, refactor, multi-file | MiniMax M2.5 |
| Critical | architecture, auth, security | Claude Sonnet 4.6 |

### اصل fallback

اگر DeepSeek fail شد:
1. MiniMax
2. Claude

اگر Claude unavailable شد:
1. MiniMax
2. DeepSeek

---

## ۱۰. Model Selection Quick Reference

| نوع task | مدل | هزینه تقریبی | توضیح |
|---|---|---|---|
| باگ کوچک، تست، config | DeepSeek V3.2 | ~$0.01 | ارزان‌ترین گزینه‌ی قابل‌اتکا |
| feature و refactor | MiniMax M2.5 | ~$0.05 | reasoning خوب با قیمت پایین |
| معماری و امنیت | Claude Sonnet 4.6 | ~$0.15 | ارزش پرداخت برای تصمیم‌های برگشت‌ناپذیر |
| Q&A سریع | Gemini CLI Flash | $0 | برای ترمینال عالی |
| کارهای async | Jules | $0 beta | شاخه‌ی جداگانه و PR |
| scaffold و docs اقتصادی | Gemini 3 Flash | ~$0.02 | سریع و ارزان |
| autocomplete | GPT-5 mini | $0 | داخل Copilot |
| reasoning مستقل | DeepSeek Speciale | ~$0.01 | فقط از OpenRouter |
| chainهای پیچیده با نیاز به Claude-style reliability | Claude Haiku 4.5 | ~$0.02 | >73% SWE-bench و ارزان‌تر از Sonnet |

### Claude Haiku 4.5 در برابر DeepSeek و MiniMax

اگر معیار **ارزش خرید برای coding روزانه** باشد:
- DeepSeek V3.2 معمولاً از Haiku به‌صرفه‌تر است.
- MiniMax M2.5 برای feature-level reasoning معمولاً ROI بهتری از Haiku دارد.
- Haiku 4.5 زمانی می‌ارزد که **دقت tool-calling و prompt-following** مهم‌تر از صرفاً قیمت خام باشد.

نتیجه:
- **اولویت عادی:** DeepSeek → MiniMax → Haiku → Sonnet
- **اولویت reliability در workflow چندمرحله‌ای:** Haiku می‌تواند قبل از Sonnet انتخاب شود.

---

## ۱۱. پیشنهاد نهایی setup

### Zero Budget
- Ghostty
- Cline / Roo
- DeepSeek free credits
- Gemini Flash free

### Budget Pro
- Copilot Pro
- DeepSeek direct
- MiniMax pay-as-you-go

### Professional
- Copilot Pro
- DeepSeek direct
- Claude API
- Gemini CLI / Jules

### جمع‌بندی اقتصادی
برای بسیاری از افراد، ترکیب **DeepSeek direct + MiniMax + Copilot Pro** نسبت به خرید subscriptionهای گران‌تر، ROI بهتری دارد.

---

## ۱۲. MCP و ابزارهای جانبی

### سرورهای پیشنهادی
- filesystem
- github
- brave-search
- sqlite
- docker

### اصل استفاده
هر MCP server فقط وقتی باید فعال شود که واقعاً لازم باشد. اضافه کردن ابزار زیاد latency و پیچیدگی ایجاد می‌کند.

---

## ۱۳. مدیریت هزینه

### آستانه‌های عملی
- هشدار روزانه: $1
- بررسی هفتگی: $5
- توقف ماهانه: $25

### پنج عامل اصلی انفجار هزینه
1. retry loop در Cline
2. استفاده بی‌مورد از Claude برای taskهای trivial
3. ارسال context بیش از حد بزرگ
4. از دست دادن cache hit
5. sessionهای طولانی و resumeهای پرهزینه

---

## ۱۴. Knowledge Management

### ساختار پیشنهادی
- `.cursor/rules/` یا `.agent/rules/`
- `memory-bank/`
- `.clinerules`
- `GEMINI.md`
- `AGENTS.md`

### اصل معماری
rule fileها policy را تعریف می‌کنند، workflowها فرآیند را، و skillها دانش reusable را. این سند اما مرجع اصلی انتخاب مدل، اقتصاد، routing و setup است.

---

## ۱۵. الگوهای پیشرفته کاهش هزینه

### ۱۵.۱ DeepSeek V3.2 با Reasoning Toggle

برای taskهای عادی reasoning را خاموش نگه دارید و فقط برای debugging و algorithm آن را روشن کنید.

```python
{"model": "deepseek/deepseek-v3.2", "reasoning": {"enabled": False}}
{"model": "deepseek/deepseek-v3.2", "reasoning": {"enabled": True}}
```

### ۱۵.۲ مدل لوکال با Ollama

برای taskهای کوچک API call را حذف کنید:

```bash
brew install ollama
ollama pull qwen2.5-coder:7b
ollama pull deepseek-r1:7b
```

#### نیازمندی سخت‌افزاری

| مدل | RAM | VRAM | Apple Silicon |
|---|---|---|---|
| Qwen2.5-Coder 7B | 8GB | 6GB | روی M1/M2 8GB قابل‌استفاده |
| DeepSeek R1 Distill 7B | 8GB | 6GB | روی M1/M2 8GB قابل‌استفاده |
| Qwen2.5-Coder 14B | 16GB | 10GB | بهتر روی M2 Pro/M3 |
| DeepSeek R1 Distill 32B | 32GB | 24GB | مناسب سیستم‌های high-end |

### ۱۵.۳ Batch Prompting به جای Round-Trips

پنج درخواست جداگانه را در یک prompt واحد ادغام کنید تا overhead تکراری حذف شود.

### ۱۵.۴ Cache-Aware Prompt Structure

system prompt را ثابت نگه دارید. روی Claude، cache hit می‌تواند اختلاف هزینه بسیار بزرگی ایجاد کند. همین اصل برای DeepSeek هم مهم است.

### ۱۵.۵ DeepSeek R1 Distill Qwen 7B برای Math/Reasoning

اگر task شما الگوریتمی، منطقی، یا ریاضیاتی است اما نمی‌خواهید سراغ Claude بروید:

- OpenRouter model id: `deepseek/deepseek-r1-distill-qwen-7b`
- نسخه محلی: `ollama pull deepseek-r1:7b`

---

## ۱۶. جمع‌بندی نهایی

اگر بخواهم این سند را در یک خط خلاصه کنم:

**برای اکثر پروژه‌ها، برنده‌ی واقعی در ۲۰۲۶ نه گران‌ترین مدل، بلکه ترکیب درست مدل ارزان، مدل میانی، و مدل review نهایی است.**

پیشنهاد عملی:
1. DeepSeek V3.2 برای bulk work
2. MiniMax M2.5 برای feature reasoning
3. Claude Haiku 4.5 برای reliability میانی
4. Claude Sonnet 4.6 برای architecture/security

---

[بازگشت به README فارسی](README.fa.md)