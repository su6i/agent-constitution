---
title: معماری اطلاعات
description: نقشه مخزن و نسبت هر بخش با سند شاخص Agentic Coding.
location: docs/INFORMATION-ARCHITECTURE.fa.md
last_updated: 2026-03-12
---

[بازگشت به README فارسی](../README.fa.md)

# معماری اطلاعات

این مخزن اکنون یک سند فنی شاخص واحد دارد:

- [AGENTIC-CODING-SETUP.fa.md](../AGENTIC-CODING-SETUP.fa.md)

این فایل، مرجع canonical فارسی برای استراتژی Agentic Coding، اقتصاد مدل‌ها، routing، و setup عملیاتی است.

## اصل ساختاری

همه فایل‌ها صرفاً appendage این سند نیستند، اما هر بخش اصلی مخزن نسبت مشخصی با آن دارد:

1. بعضی فایل‌ها آن را معرفی می‌کنند.
2. بعضی فایل‌ها آن را enforce می‌کنند.
3. بعضی فایل‌ها آن را بومی‌سازی می‌کنند.
4. بعضی فایل‌ها آن را به workflow و ابزار تبدیل می‌کنند.

## نقشه مخزن

| بخش | نقش | نسبت با سند شاخص |
|---|---|---|
| [README.fa.md](../README.fa.md) | ورودی فارسی | خواننده را به سند شاخص هدایت می‌کند |
| [AGENTIC-CODING-SETUP.fa.md](../AGENTIC-CODING-SETUP.fa.md) | سند فنی canonical فارسی | تعریف methodology، benchmarking، انتخاب مدل و اقتصاد |
| [README.md](../README.md) | ورودی انگلیسی | لایه ناوبری برای مخاطب بین‌المللی |
| [AGENTIC-CODING-SETUP.md](../AGENTIC-CODING-SETUP.md) | سند فنی canonical انگلیسی | مرجع اصلی انگلیسی همان framework |
| [AGENTS.md](../AGENTS.md) | قرارداد اجرایی ایجنت‌ها | رفتار اجرایی ایجنت را تعریف می‌کند |
| [fa](../fa) | لایه بومی‌سازی فارسی | rules, workflows, memory و redirectهای فارسی |
| [.agent/rules](../.agent/rules) | لایه policy | استانداردهای غیرقابل‌مذاکره |
| [.agent/workflows](../.agent/workflows) | لایه فرآیند | تبدیل اصول به SOP |
| [.agent/skills](../.agent/skills) | لایه دانش reusable | گسترش knowledge بدون جایگزین کردن سند شاخص |
| [templates](../templates) | لایه توزیع | انتقال معماری به پروژه‌های دیگر |
| [bin](../bin) | لایه automation | اسکریپت‌ها و ابزارهای قابل اجرا |
| [docs](../docs) | لایه توضیح تکمیلی | meta-doc و منابع مکمل |
| [memory-bank](../memory-bank) | حافظه عملیاتی | context و cost log |
| [CHANGELOG.md](../CHANGELOG.md) | تاریخچه | ثبت تغییرات مهم |
| [CONTRIBUTING.md](../CONTRIBUTING.md) | سیاست مشارکت | نحوه تغییر امن مخزن |

## ترتیب مطالعه

1. [README.fa.md](../README.fa.md)
2. [AGENTIC-CODING-SETUP.fa.md](../AGENTIC-CODING-SETUP.fa.md)
3. [AGENTS.md](../AGENTS.md)
4. سپس rules / workflows / skills

## قاعده حاکمیتی

اگر بین یک توضیح بازاری/خلاصه و methodology فنی تعارضی بود، سند شاخص فارسی را مرجع بگیرید؛ و اگر تعارض اجرایی وجود داشت، [AGENTS.md](../AGENTS.md) مرجع رفتار اجرایی است.

---

[بازگشت به README فارسی](../README.fa.md)