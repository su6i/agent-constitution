---
title: "030Security: Secret Protection (fa/)"
description: استانداردهای امنیتی اجباری و قوانین حفاظت از اسرار (نسخه فارسی).
location: fa/rules/030-security.md
agent_priority: Critical
last_updated: 2026-02-21
---

# قوانین امنیت

## هرگز انجام ندهید (NEVER)
- نوشتن API key یا پسورد به صورت مستقیم در کد.
- اضافه کردن فایل `.env` به گیت.
- استفاده از `eval()` یا `exec()` با ورودی کاربر.
- ساخت کوئری‌های SQL با f-string (جلوگیری از SQL injection).

## الگوی صحیح برای اسرار
همیشه از `os.getenv` و فایل `.env` استفاده کنید.

## قبل از کامیت
- بررسی فایل‌های مرحله‌بندی شده برای یافتن کلمات کلیدی امنیتی.

