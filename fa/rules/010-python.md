---
title: "010Python: Coding Standards (fa/)"
description: استانداردهای کدنویسی Python، ابزارها و بهترین روش‌ها (نسخه فارسی).
location: fa/rules/010-python.md
agent_priority: Medium
last_updated: 2026-02-21
---

# استانداردهای Python

## ابزارها
- مدیریت پکیج: `uv sync` / `uv add`
- فرمت‌کننده: `ruff format`
- لینتر: `ruff check --fix`
- بررسی نوع: `mypy` (strict mode)
- تست: `pytest` با پوشش کد

## کدنویسی
- توابع حداکثر ۲۰ خط.
- تایپ‌هینت برای توابع عمومی (Public) اجباری است.
- مستندسازی (Docstring) برای توابع عمومی.
- مدیریت خطا: از `except:` خالی استفاده نکنید.
- لاگینگ جایگزین `print` در کد نهایی.

