---
title: "060MultiInterface: معماری هسته واحد، پوسته‌های چندگانه"
description: معماری استاندارد برای پروژه‌هایی که چند اینترفیس دارند (CLI، وب، تلگرام، اکستنشن). تعریف تفکیک لایه‌ها، ساختار دایرکتوری‌ها و قوانین یکپارچه‌سازی.
location: fa/rules/060-multi-interface.md
agent_priority: High
last_updated: 2026-06-01
---

# معماری هسته واحد، پوسته‌های چندگانه (Single Core, Multiple Shells)

## این قانون کجا اعمال می‌شود؟

هر پروژه‌ای که از طریق **بیش از یک اینترفیس** عمل می‌کند — CLI + Web UI، CLI + ربات تلگرام، یا هر ترکیبی — باید از این معماری پیروی کند.

---

## اصل کلیدی

منطق اصلی در یک جا زندگی می‌کند. اینترفیس‌ها فقط پوسته‌های نازکی هستند که ورودی کاربر را به فراخوانی توابع Core ترجمه می‌کنند.

FastAPI **آداپتور مرکزی** است، نه مغز برنامه. وقتی لایه API آماده شد، هر اینترفیس دیگری (ربات تلگرام، اکستنشن کروم، اپ موبایل) یک HTTP Client سبک می‌شود.

```
┌──────────────────────────────────────────────────┐
│                  Core / Services                  │
│       (Python خالص، بدون I/O، بدون HTTP)          │
└───────────────────────┬──────────────────────────┘
                        │
               ┌────────▼────────┐
               │   FastAPI App   │  ← آداپتور مرکزی
               │   PORT از config│    (نه مغز پروژه)
               └──┬──────────┬───┘
                  │          │
     ┌────────────▼──┐    ┌──▼──────────────────┐
     │  CLI (main.py)│    │  Web UI (Jinja2)     │
     │  فراخوانی     │    │  سرو شده توسط       │
     │  مستقیم Core  │    │  همان FastAPI        │
     └───────────────┘    └─────────────────────┘
                                   │
               ┌───────────────────┼───────────────┐
               │                   │               │
     ┌─────────▼──┐    ┌───────────▼──┐  ┌────────▼──────┐
     │   ربات      │    │  اکستنشن    │  │  کلاینت‌های   │
     │  تلگرام     │    │  کروم       │  │  آینده        │
     │  Webhook    │    │  HTTP fetch  │  │               │
     └────────────┘    └──────────────┘  └───────────────┘
```

---

## ساختار استاندارد دایرکتوری‌ها

```
my_project/
├── src/
│   ├── core/        # منطق خالص تجاری و الگوریتم‌ها — بدون HTTP، بدون I/O
│   ├── schemas/     # مدل‌های Pydantic برای اعتبارسنجی (استفاده در همه لایه‌ها)
│   ├── services/    # I/O خارجی: دیتابیس، LLM‌ها، APIهای ثالث
│   ├── api/         # روترهای FastAPI، میدل‌ورها، وب‌هوک‌ها
│   ├── cli/         # نقاط ورود CLI (Typer یا argparse) → فراخوانی core/services
│   ├── bot/         # هندلرهای Webhook تلگرام → تفویض به core/services
│   └── web/         # فایل‌های استاتیک یا تمپلیت‌های Jinja2
├── tests/
└── main.py          # نقطه ورود: subcommandها (serve، telegram، ...)
```

---

## قوانین غیرقابل مذاکره

### ۱. هیچ I/O در core/

فایل‌های داخل `core/` هرگز نباید درخواست HTTP دریافت کنند، ورودی کاربر بخوانند، یا مستقیماً با سرویس‌های خارجی تعامل داشته باشند. داده به صورت object پایتون می‌گیرند و object پایتون برمی‌گردانند.

### ۲. اعتبارسنجی در schemas/، نه فقط در روترها

مدل‌های Pydantic باید در `src/schemas/` باشند و توسط **توابع core** هم استفاده شوند — نه فقط توسط endpoint‌های FastAPI. این تضمین می‌کند که CLI و سایر فراخوان‌های مستقیم نیز همان یکپارچگی داده را دارند.

```python
# ✅ درست — اعتبارسنجی قبل از رسیدن به هر اینترفیسی
async def discover(params: DiscoverParams) -> list[Author]:
    ...

# ❌ غلط — اعتبارسنجی فقط در روتر FastAPI
@router.post("/discover")
async def discover_endpoint(params: DiscoverParams):
    raw = {"keywords": params.keywords}  # CLI هیچ اعتبارسنجی‌ای نمی‌گیرد
    return await discover_raw(raw)
```

### ۳. ربات تلگرام از Webhook استفاده می‌کند، نه Long-Polling

وقتی سرور FastAPI در حال اجرا است، ربات تلگرام باید به عنوان یک endpoint webhook (`POST /webhook/telegram`) یکپارچه شود — نه یک پروسه Long-Polling مجزا. این معماری را یکپارچه‌تر و مصرف منابع را کمتر می‌کند.

```python
# ✅ درست — webhook در FastAPI ثبت می‌شود
@router.post("/webhook/telegram")
async def telegram_webhook(update: dict):
    await bot_handler.process(update)
```

### ۴. CORS از روز اول پیکربندی می‌شود

اکستنشن‌های کروم و هر کلاینت مبتنی بر مرورگر درخواست‌های Cross-Origin می‌زنند. `CORSMiddleware` باید از ابتدای پروژه تنظیم شود — نه وقتی باگ ظاهر شد.

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["chrome-extension://*", "http://localhost:*"],
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### ۵. اینترفیس‌ها نازک هستند — بدون منطق تجاری

فایل‌های `api/`، `cli/`، `bot/` فقط این کار را می‌کنند: parse ورودی ← فراخوانی core/services ← format خروجی. اگر یک route handler یا command function از ~۱۵ خط منطق تجاری تجاوز کرد، آن منطق باید به `core/` یا `services/` منتقل شود.

### ۶. یک نقطه ورود، چند subcommand

`main.py` تنها نقطه ورود برای همه حالت‌ها است:

```bash
uv run python main.py serve      # FastAPI + Web UI روی port پیکربندی‌شده
uv run python main.py telegram   # سرور Webhook تلگرام
uv run python main.py discover   # حالت CLI
```

---

## استراتژی تست

چون `core/` هیچ وابستگی I/O ندارد، Unit Test نیازی به mock کردن HTTP ندارد:

```python
# Unit test — بدون FastAPI، بدون HTTP، بدون mock
async def test_discover_filters_by_min_papers():
    result = await discover(DiscoverParams(keywords=["nlp"], min_papers=3))
    assert all(a.papers_count >= 3 for a in result)
```

Integration test‌ها لایه API را جداگانه با `httpx.AsyncClient` پوشش می‌دهند.

---

## مرتبط

- `rules/lang/python/fastapi.md` — قوانین کدنویسی FastAPI (روترها، async، schema‌ها)
- `rules/010-python.md` — استانداردهای Python (uv, ruff, mypy)
