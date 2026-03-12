---
title: Agent Constitution 📜
description: معماری زمینه‌ای اعتبارسنجی‌شده برای ایجنت‌های هوش مصنوعی
location: README.fa.md
last_updated: 2026-03-12
---

<div align="center">

<img src="assets/project_logo.png" width="350">

<h1>قانون اساسی ایجنت 📜</h1>

<p align="center" dir="ltr">
  <a href="https://github.com/su6i/agent-constitution/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-green3.svg" height="20" style="vertical-align: middle;"></a><a href="#"><img src="https://img.shields.io/badge/Status-Active-blue.svg" height="20" style="vertical-align: middle;"></a><a href="https://linkedin.com/in/su6i"><img src="assets/linkedin_su6i.svg" height="20" style="vertical-align: middle; margin-bottom: -1px; margin-left: 3px;"></a>
</p>

<strong>معماری زمینه‌ای اعتبارسنجی‌شده برای ایجنت‌های هوش مصنوعی</strong>

[🇬🇧 نسخه انگلیسی](README.md) • [Contributing](CONTRIBUTING.md) • [Changelog](CHANGELOG.md)

</div>

---

## 📍 سند اصلی
سند فنی اصلی این مخزن اکنون [AGENTIC-CODING-SETUP.fa.md](AGENTIC-CODING-SETUP.fa.md) است.

اگر به دنبال تحلیل بنچمارک‌ها، انتخاب مدل، اقتصاد استفاده، روتینگ، الگوهای کم‌هزینه و پیکربندی محیط Agentic Coding هستید، باید مطالعه را از همان فایل شروع کنید.

نقش فایل‌های اصلی به این صورت است:
- [AGENTIC-CODING-SETUP.fa.md](AGENTIC-CODING-SETUP.fa.md): راهنمای فنی شاخص و مرجع canonical نسخه فارسی.
- [README.fa.md](README.fa.md): ورودی و لایه ناوبری برای مخاطب فارسی.
- [AGENTS.md](AGENTS.md): قرارداد اجرایی ایجنت‌ها در سطح مخزن.
- [docs/INFORMATION-ARCHITECTURE.fa.md](docs/INFORMATION-ARCHITECTURE.fa.md): نقشه نسبت کل مخزن با سند شاخص.

---

## 🏗 مسئله
اکثر ایجنت‌های هوش مصنوعی مانند Cursor، Antigravity، Windsurf و Copilot به این دلیل شکست می‌خورند که حافظه و زمینه آن‌ها ساختارمند نیست. اگر یک پرامپت بسیار بلند به آن‌ها بدهید، دچار توهم می‌شوند. اگر هیچ زمینه‌ای ندهید، خروجی به کد اسپاگتی تبدیل می‌شود.

این پروژه برای حل همین شکاف ساخته شده است: یک قانون اساسی ماژولار که ایجنت را مجبور می‌کند مثل یک مهندس ارشد با قواعد روشن، حافظه منظم، و محدودیت‌های عملیاتی کار کند.

## ⚡ راه‌حل: معماری زمینه‌ای
این مخزن فقط مجموعه‌ای از rule fileها نیست. اینجا یک معماری زمینه‌ای ماژولار وجود دارد که چرخه عمر توسعه نرم‌افزار را به اجزای قابل بارگذاری تفکیک می‌کند تا ایجنت فقط همان چیزی را بخواند که در همان لحظه لازم دارد.

### ویژگی‌های اصلی
- **روتر سخت‌گیرانه:** برای جلوگیری از حدس‌زدن و انتخاب کورکورانه.
- **حافظه ماژولار:** برای کاهش خطای lost-in-the-middle.
- **پروتکل حقیقت:** برای جلوگیری از اعلام اتمام کار بدون verification.
- **لایه‌های جداگانه rule / workflow / skill:** برای این‌که دانش، فرایند و سیاست اجرایی قاطی نشوند.

## 🚀 ترتیب مطالعه
1. [AGENTIC-CODING-SETUP.fa.md](AGENTIC-CODING-SETUP.fa.md) را بخوانید.
2. [AGENTS.md](AGENTS.md) را برای قواعد اجرای ایجنت‌ها مرور کنید.
3. از `.agent/`، `templates/`، `bin/` و `docs/` به عنوان لایه‌های اجرایی و تکمیلی استفاده کنید.

## 📚 مستندات

### ⭐ راهنمای شاخص
- [AGENTIC-CODING-SETUP.fa.md](AGENTIC-CODING-SETUP.fa.md): مرجع اصلی بنچمارک، ROI، routing و setup.
- [docs/INFORMATION-ARCHITECTURE.fa.md](docs/INFORMATION-ARCHITECTURE.fa.md): توضیح می‌دهد هر بخش مخزن چه نسبتی با سند شاخص دارد.

### 🛠 گردش‌کارها
- [.agent/workflows/init-project.md](.agent/workflows/init-project.md): شروع صحیح پروژه.
- [.agent/workflows/quality-assurance.md](.agent/workflows/quality-assurance.md): پروتکل تضمین کیفیت.
- [workflows/daily-start.md](workflows/daily-start.md): شروع روزانه.
- [fa/workflows/daily-start.md](fa/workflows/daily-start.md): نسخه فارسی workflow روزانه.

### 🧠 لایه دانشی
- [.agent/rules](.agent/rules): قواعد اجرایی و استانداردها.
- [.agent/skills](.agent/skills): مهارت‌های قابل‌استفاده مجدد.
- [fa/rules](fa/rules): نسخه فارسی ruleها.
- [fa/skills](fa/skills): لایه فارسی مهارت‌ها و راهنماها.

## 🤖 یک جمع‌بندی معماری
این مخزن اکنون یک مرکز ثقل روشن دارد: سند فنی اصلی در ریشه قرار گرفته و بقیه اجزا یا آن را معرفی می‌کنند، یا enforce می‌کنند، یا بومی‌سازی و اجرایی‌اش می‌کنند. به همین دلیل README دیگر قرار نیست جای سند فنی را بگیرد؛ وظیفه‌اش هدایت کاربر به سمت آن است.

## 🤝 مشارکت
قبل از هر Pull Request فایل [CONTRIBUTING.md](CONTRIBUTING.md) را بخوانید. این پروژه روی تغییرات کوچک، دقیق و قابل‌دفاع بنا شده است.

## 📝 لایسنس
این پروژه تحت [MIT](LICENSE) منتشر شده است.
