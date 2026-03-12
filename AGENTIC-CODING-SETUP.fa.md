---
title: "کدنویسی ایجنتیک ۲۰۲۶"
description: راهنمای پیشرفته تنظیمات، بنچمارک‌ها و تحلیل بازگشت سرمایه برای توسعه مبتنی بر هوش مصنوعی.
location: AGENTIC-CODING-SETUP.fa.md
document_role: flagship-guide
last_updated: 2026-02-21
---

[بازگشت به README فارسی](README.fa.md)

# گزارش فنی: متدولوژی و پیکربندی کدگذاری عامل 2026

*این راهنما توسط Claude Sonnet 4.6 تهیه شده است.*

این سند راهنمای فنی اولیه این مخزن است. این به عنوان مرجع متعارف برای اجرای گردش‌های کاری کدگذاری عاملی با بهره‌وری بالا، با تمرکز بر تعادل استراتژیک بین **عملکرد محاسباتی** و **کارایی هزینه عملیاتی** بر اساس داده‌های فوریه 2026 عمل می‌کند.

---

## 📅 به‌روزرسانی‌های فنی و ویرایش‌های پارامتر (۲۰ فوریه ۲۰۲۶)

<div style="background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.1); border-radius:8px; padding:16px 20px; font-size:12px; color:#dde0f2; line-height:1.8;">
  <strong>Key Technical Revisions:</strong><br>
  1. <strong>DeepSeek V3.2-Speciale:</strong> تکرار بهینه شده توسط عامل. از طریق OpenRouter (پروتکل استفاده از ابزار) قابل دسترسی است.<br>
  2. <strong>Gemini 3.1 Pro:</strong> در 19 فوریه منتشر شد. 77.1٪ در ARC-AGI-2 (معیار استدلال جدید) ثبت شد.<br>
  3. <strong>Claude Sonnet 4.6:</strong> در 17 فوریه منتشر شد. 79.6% امتیاز SWE-bench با 3 دلار ورودی / 15 دلار ساختار قیمت گذاری خروجی.<br>
  4. <strong>Claude Opus 4.6:</strong> قیمت گذاری در ورودی 5 دلار / خروجی 25 دلاری در هر میلیون توکن تأیید شده است.
</div>

---

## 📊 1. تحلیل مقایسه ای 11 مدل کدگذاری پیشرو

### ماتریس مدل رتبه‌بندی شده (بر اساس ردیف عملکرد SWE-bench):

1. 👑 **Claude Opus 4.6** (امتیاز: 80.8%)
2. 🥈 **Gemini 3.1 Pro ** (امتیاز: 80.6%)
3. 🥉 **MiniMax M2.5** (امتیاز: 80.2%)
4. **GPT-5.4** (امتیاز: 80.0%)
5. **Claude Sonnet 4.6** (امتیاز: 79.6%)
6. **Kimi K2.5** (امتیاز: 76.8%)
7. **Gemini 3 Pro** (امتیاز: 76.2%)
8. **DeepSeek Speciale** (امتیاز: ~76%)
9. **DeepSeek V3.2** (امتیاز: ~73%)
10. **فلش جمینی 3** (امتیاز: 57.6%)
11. **GPT-5 mini** (امتیاز: ~52%)

### شاخص های کلیدی عملکرد و تعاریف معیار

قبل از بررسی داده ها، درک هدف هر معیار برای انتخاب مدل استراتژیک ضروری است:

1. **SWE-bench تایید شده (قابلیت مهندسی نرم افزار):**
   - **هدف:** توانایی مدل را برای حل مستقل مسائل GitHub در دنیای واقعی ارزیابی می کند.
   - **کاربرد دنیای واقعی:** نمرات بالا نشان دهنده قابلیت اطمینان مدل در نوشتن کد، گذراندن آزمون های واحد و تکمیل وظایف مهندسی کامل بدون دخالت انسان است. برای نقش `Builder` بسیار مهم است.

2. **Terminal-Bench 2.0 (تسلط به CLI):**
   - **هدف:** دقت در اجرای دستورات پوسته، مدیریت بسته، و ناوبری سیستم فایل را ارزیابی می کند.
   - ** ابزار واقعی: ** درصدهای بالاتر منجر به خطاهای کمتر در سطح ترمینال می شود (به عنوان مثال، نصب نادرست وابستگی). برای تنظیمات نمایندگی با دسترسی کامل به ترمینال حیاتی است.

3. **OSWorld (استفاده از رایانه و تعامل وب):**
   - **هدف:** توانایی مدل را برای استفاده از مرورگرها و برنامه های دسکتاپ مانند انسان اندازه گیری می کند.
   - ** ابزار دنیای واقعی:** اگر پروژه شما نیاز به تحقیق مستندات جدید به صورت آنلاین یا انجام آزمایش UI داشته باشد، بسیار مهم است.

4. **ARC-AGI-2 (استدلال انتزاعی جدید):**
   - **هدف:** قدرت حل مسئله را در سناریوهایی که مدل در طول آموزش با آن مواجه نشده است اندازه گیری می کند.
   - ** ابزار دنیای واقعی: ** این یک پروکسی برای "هوش خام" در هنگام مواجهه با چالش های جدید معماری است. مدل های با امتیاز بالا انتخاب اصلی برای نقش `Architect` هستند.

5. **AIME 2025 (استدلال ریاضی پیشرفته):**
   - **هدف:** منطق نمادین و ثبات را در فرآیندهای استدلال چند مرحله ای ارزیابی می کند.
   - **کاربرد دنیای واقعی:** نمرات بالا حاکی از یکپارچگی منطقی است که احتمال توهمات را در جریان کار کدگذاری پیچیده به میزان قابل توجهی کاهش می دهد.

6. **پنجره زمینه (حافظه عملیاتی):**
   - **هدف:** ظرفیت کل برای نگهداری کد مخزن و زمینه در حافظه فعال.
   - ** ابزار دنیای واقعی:** برای پروژه های در مقیاس بزرگ، یک پنجره زمینه عظیم (به عنوان مثال، 1M+) به مدل اجازه می دهد تا کل پایگاه کد را به طور همزمان درک کند و اطمینان حاصل شود که تغییرات ساختاری وابستگی های دور را از بین نمی برد.

### ماتریس معیار عملکردی (تحلیل جامع)
<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1);">
  <table style="width:100%; border-collapse:collapse; font-size:10px; color:#dde0f2; min-width:1400px;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Performance Metrics</th>
        <th>Opus 4.6</th>
        <th>Sonnet 4.6</th>
        <th>Gem 3.1 Pr</th>
        <th>Gem 3 Pro</th>
        <th>Gem 3 Flash</th>
        <th>DS V3.2</th>
        <th>DS Special</th>
        <th>MiniMax M2</th>
        <th>Kimi K2.5</th>
        <th>GPT-5.4</th>
        <th>GPT-5 mini</th>
      </tr>
    </thead>
    <tbody>
      <tr><td>SWE-bench Verified (Bug Solving)</td><td>80.8%</td><td>79.6%</td><td>80.6%</td><td>76.2%</td><td>57.6%</td><td>~73%</td><td>~76%</td><td>80.2%</td><td>76.8%</td><td>80.0%</td><td>~52%</td></tr>
      <tr><td>Terminal-Bench 2.0 (CLI Ops)</td><td>65.4%</td><td>~40%*</td><td>~60%</td><td>~52%</td><td>—</td><td>46.4%</td><td>~</td><td>~62%</td><td>~58%</td><td>64.7%</td><td>—</td></tr>
      <tr><td>OSWorld (Computer Use)</td><td>72.7%</td><td>72.5%</td><td>~70%</td><td>~55%</td><td>—</td><td>—</td><td>—</td><td>—</td><td>—</td><td>38.2%</td><td>—</td></tr>
       <tr><td>ARC-AGI-2 (Novel Reasoning)</td><td>75.2%</td><td>58.3%</td><td>77.1%</td><td>~37%</td><td>—</td><td>—</td><td>—</td><td>—</td><td>—</td><td>52.9%</td><td>—</td></tr>
       <tr><td>AIME 2025 (Advanced Math)</td><td>92.8%</td><td>100%</td><td>~96%</td><td>~90%</td><td>—</td><td>96%</td><td>99%+</td><td>~85%</td><td>96.1%</td><td>100%</td><td>—</td></tr>
       <tr><td>LiveCodeBench (Jan 2026)</td><td>~72%</td><td>~68%</td><td>~71%</td><td>~62%</td><td>~40%</td><td>~65%</td><td>~68%</td><td>~70%</td><td>~64%</td><td>~73%</td><td>~38%</td></tr>
       <tr><td>Context Window</td><td>1M β</td><td>1M β</td><td>1M</td><td>1M</td><td>1M</td><td>128K</td><td>163K</td><td>200K</td><td>256K</td><td>400K</td><td>256K</td></tr>
       <tr><td>Tool Calling in Cline</td><td>✅</td><td>✅</td><td>✅</td><td>✅</td><td>✅</td><td>✅</td><td style="color:#fbbf24;">⚠️ OR only</td><td>✅</td><td>✅</td><td>✅</td><td>✅</td></tr>
    </tbody>
  </table>
</div>

---

## 💰 2. تحلیل اقتصادی و بهینه سازی عملیاتی

- **Claude Sonnet 4.6:** نسبت عملکرد به هزینه بهینه برای گردش های کاری با فرکانس بالا (3 دلار ورودی / 15 دلار خروجی).
- **DeepSeek V3.2:** بهینه سازی شده برای اجرای با حجم بالا از طریق ذخیره سازی مقرون به صرفه (0.028$ cache-hit / $0.42 خروجی).
- **MiniMax M2.5:** عملکرد درجه مرزی با کاهش قابل توجه سربار عملیاتی (0.30 دلار ورودی / 1.20 دلار خروجی).
- **Gemini 3.1 Pro:** مرجع اولیه برای استدلال معماری غیر قطعی و پیچیده (ورودی 2 دلار / خروجی 12 دلار).

### GitHub Copilot: شامل مدل‌های درخواستی پرمیوم

تمایز مهمی که بر برنامه ریزی هزینه تأثیر می گذارد - **نه همه مدل ها در درخواست های حق بیمه هزینه Copilot**:

| مدل | نوع | درخواست حق بیمه | ماهانه (300 بودجه) |
|---|---|---|---|
| **GPT-4.1** | شامل | ✅ رایگان — صفر | نامحدود |
| **GPT-5-mini** | شامل | ✅ رایگان — صفر | نامحدود |
| **GPT-4o** | شامل | ✅ رایگان — صفر | نامحدود |
| **Claude Sonnet 4.6** | حق بیمه | ⚠️ **1x** (در حال حاضر — موقت) | 300 تعامل در ماه = ~ 10 در روز |
| **Claude Opus 4.5** | حق بیمه | ❌ **3x** | 100 تعامل / ماه = ~ 3 / روز |
| بعد از 300 پریمیوم استفاده شده | — | — | GPT-4.1 / GPT-5-mini رایگان باقی می ماند |

> ⚠️ **GitHub هشدار می دهد: ** ضریب 1x کلود سونت **موقت است** — ممکن است با تنظیم قیمت آنتروپیک به 2 برابر یا 3 برابر افزایش یابد. اگر این اتفاق بیفتد، بودجه 300 شما به 150 یا 100 کاهش می یابد. از کلود سونت فقط برای کارهای بسیار مهم استفاده کنید: بررسی معماری، ممیزی امنیتی، بن بست های منطقی.

**برای استفاده در Copilot:** Copilot را روی حالت **Auto** تنظیم کنید — به طور خودکار بین GPT-4.1 و GPT-5-mini (هر دو نامحدود/رایگان) انتخاب می‌کند و از مدل‌های با ضریب > 1 اجتناب می‌کند. فقط زمانی که به کیفیت بررسی معماری یا امنیتی نیاز دارید، به‌صورت دستی به Claude Sonnet 4.6 بروید.

---

## 🏛️ 3. تخصیص نقش استراتژیک (روش شناسی A-B-R)

1. **معمار و طراح سیستم:**  
   - **انتخاب 1 (بهترین ROI):** **MiniMax M2.5**. استدلال سطح بالا (80.2٪) در یک نقطه قیمت بسیار رقابتی. ایده آل برای پیش نویس اسناد پیچیده `task.md`.  
   - **انتخاب 2 (زمینه بی نهایت):** **Gemini 3.1 Pro**. استانداردی برای تجزیه و تحلیل بازگشتی در بین پایگاه های کد عظیم (1M+ توکن).  
   - **جایگزین آنتروپیک:** **غزل کلود 4.6**. تکرارهای با کارایی و سرعت بالا (Opus به دلیل قیمت گذاری غیرمنطقی و ROI ضعیف حذف شده است).  

2. **موتور اجرا (سازنده):**  
   - **انتخاب 1 (Agentic Economics):** **DeepSeek V3.2**. راندمان قیمت بی نظیر (به دلیل ذخیره سازی) و سرعت اجرا برای کارهای روتین توسعه.  
   - **انتخاب 2 (نیروی میان رده):** **MiniMax M2.5**. تعادل عالی بین استدلال عمیق و قیمت گذاری عملیاتی رقابتی.  

3. **کارشناس Refactor & Retreival:**  
   - **انتخاب 1:** **MiniMax M2.5**. متخصص در بازیابی اسناد بسیار بزرگ و بازسازی پیچیده در سطح بلوک.  
   - **گزینه 2:** **غزل کلود 4.6**. هنگامی که دقت معماری و رعایت الگوهای دقیق در اولویت باشد، ترجیح داده می شود.  

4. **تضمین کیفیت (بازبین):**  
   - **انتخاب 1:** **Claude 4.6 Opus**. مدل قطعی برای شناسایی خطاهای منطقی عمیق و آسیب پذیری های امنیتی.  
   - **انتخاب 2:** **Human-in-the-Loop**. بازرسی نهایی برای اطمینان از خوانایی کد، قابلیت نگهداری و استانداردهای Clean Code.  

---

## ⚖️ 3.1. استراتژی مدل: عملکرد در مقابل هزینه (تحلیل ROI)

در برنامه نویسی عاملی، هزینه فقط یک عدد نیست، بلکه سرمایه گذاری برای جلوگیری از "بدهی فنی" است. استراتژی ما بر اساس دو اصل اساسی است:

### 1. "استراتژی ساندویچ"
این متدولوژی سه لایه یکپارچگی منطقی را در طول چرخه عمر پروژه تضمین می کند:
- **لایه بالا (برنامه ریزی):** استفاده از مدل های کلاس مرزی (مانند غزل کلود 4.6) برای تحلیل زمینه و تهیه پیش نویس `task.md`. خطاها در این مرحله منجر به شکست سیستمیک پروژه می شود.
- **لایه میانی (اجرا):** بارگذاری بخش عمده ای از پیاده سازی به مدل های اقتصادی (به عنوان مثال، DeepSeek V3.2). این موتورها 80 تا 90 درصد حجم کد را با هزینه ای نزدیک به صفر تولید می کنند.
- **لایه پایین (تأیید):** بازگشت به مدل Frontier یا بازبینی کننده انسانی برای تایید نهایی و تایید منطقی.

### 2. "قانون 90/10" برای کنترل هزینه
این قانون تضمین می‌کند که صورت‌حساب API شما پایدار باقی می‌ماند:
- **90% پیام‌ها:** باید توسط مدل‌های با راندمان بالا و کم هزینه پردازش شوند (DeepSeek، MiniMax).
- **10% از پیام‌ها:** برای تصمیمات معماری حیاتی و حل بن‌بست‌های پیچیده منطقی، که توسط مدل‌های برتر (کلود اوپوس/غزل) مدیریت می‌شوند، محفوظ است.
*نتیجه: کاهش 70 تا 85 درصدی هزینه های پروژه با عدم مصالحه در کیفیت.*

---

## 🏗️ 4. زیرساخت توسعه (لیست ردیف)

*منطق رتبه بندی: این سیستم از استاندارد صنعت/بازی پیروی می کند که در آن **S-Tier** (Superior/Super) بالاتر از A-Tier به عنوان بالاترین اولویت مطلق قرار دارد و به دنبال آن A و B به ترتیب نزولی مطلوبیت عمومی قرار دارند.*

### ردیف S (اولویت برتر - استاندارد طلایی): محیط های عامل اصلی  
- **VS Code + Cline (یا Roo-Code) + GitHub Copilot:**  
  - **چه و چرا:** **Cline** یک عامل مستقل منبع باز برای VS Code است که امکان ادغام مستقیم مدل های هوش مصنوعی را فراهم می کند. قابلیت BYOK (کلید خود را بیاورید) تضمین می کند که شما فقط برای استفاده واقعی به جای هزینه ثابت ماهانه پرداخت می کنید.  
  - **ساختار هزینه:** خود برنامه افزودنی **رایگان** است. تنها هزینه شما مصرف API از ارائه دهندگانی مانند Anthropic یا DeepSeek است.  
  - **مقایسه:** برخلاف Cursor که 20 دلار در ماه دریافت می کند، Cline واسطه را حذف می کند و اتصال مستقیم به مدل های منبع را بدون محدودیت نرخ دلخواه ارائه می دهد.  

### ردیف A (ضروری): زیرساخت های حرفه ای و CLI  
- **ترمینال Warp:**  
  - **چه:** مدرن ترین ترمینال جهان با هوش مصنوعی یکپارچه که دستورات CLI را درک و اجرا می کند.  
  - **تفاوت پلان:**  
    - **سطح رایگان:** 100 درخواست رایگان در ماه (ایده آل برای آزمایش).  
    - **سطح ساخت (20 دلار در ماه): ** عملکرد نامحدود هوش مصنوعی و پشتیبانی حیاتی **BYOK**. در این ردیف، اتصال کلید API خود، هزینه هر درخواست در ترمینال را به نزدیک به صفر (کمتر از 0.001 سنت) کاهش می دهد.  
    - **توجه (اکتبر 2025):** Warp همه طرح ها را در یک ردیف "Build" با قیمت 20 دلار در ماه ادغام کرد. سطوح 18 دلاری Pro/Turbo قبلی دیگر وجود ندارند.  
  - **چرا از آن استفاده کنید:** خطای انسانی در اجرای ترمینال را حذف می کند و گردش کار DevOps را به شدت تسریع می کند.  

- **Google Cloud CLI & Tools:** مدیریت زیرساخت ضروری برای مدل‌های کلاس Gemini.

### سطح B (تخصصی): اتوماسیون و نظارت هوشمند  
- **OpenClaw:**  
  - **چه:** یک عامل مستقل منبع باز ویروسی با **213k ستاره** و **39.6k فورک** در GitHub (از 20 فوریه 2026).  
  - **ویژگی های کلیدی:**  
    - **Mac Optimized:** توسعه یافته توسط Eschenberger (یکی از توسعه دهندگان برجسته سابق iOS) که یکپارچگی یکپارچه و عملکرد برتر را در اکوسیستم macOS تضمین می کند.  
    - **نظارت فعال:** نظارت 24/7 مستقل خطوط لوله، سلامت سیستم و پایگاه های داده.  
    - **حافظه پایدار:** یک حالت مداوم برای کارهای استدلالی عمیق و چند روزه حفظ می کند.  
  - **تنظیم پیشنهادی:** به دلیل بهره وری استثنایی **Mac Mini** و پایداری macOS، ترکیب "Mac Mini + OpenClaw" انتخاب قطعی خود میزبانی برای اتوماسیون پس زمینه 24/7 است.  

> ⚠️ **اعلامیه امنیتی (17 فوریه 2026 — تایید شده):** یک حمله زنجیره تامین در Cline نسخه 2.3.0 شناسایی شد — بسته های مخرب به طور خودکار OpenClaw را بدون رضایت نصب کردند. علاوه بر این، محققان امنیتی Cisco Talos گزارش دادند که **26٪ از مهارت های موجود در ClawHub حاوی کدهای مخرب ** (دزدان اعتبار و درهای پشتی) هستند. اقدام مورد نیاز: `npm ls -g cline` را اجرا کنید و تأیید کنید که نسخه شما **نه** 2.3.0 است. از نصب مهارت های ClawHub از نویسندگان تایید نشده خودداری کنید.
>
> **توضیح محدوده:** OpenClaw یک **دستیار هوش مصنوعی شخصی** است (ایمیل، تقویم، اتوماسیون های واتس اپ را مدیریت می کند) – مانند Cline **یک عامل کدنویسی درون خطی نیست. قاعده کلی:
> - ** کدنویسی روزانه (ویرایش فایل، جلسات تعاملی، بررسی کد): Cline > OpenClaw**
> - ** اتوماسیون DevOps، نظارت پس زمینه، هماهنگی خط لوله، هماهنگی چند سیستمی: OpenClaw > Cline **
>
> اینها ابزارهای کاملاً مجزایی هستند که برای گردش های کاری کاملاً متفاوت طراحی شده اند. سعی نکنید از OpenClaw برای کدنویسی گام به گام استفاده کنید - برای آن طراحی نشده است.

### Tier A+ (Google Ecosystem Integration): عوامل بومی ابری  
- **گوگل جولز:**  
  - **چه: ** یک عامل کدنویسی ناهمزمان با میزبانی ابری که مستقیماً با GitHub یکپارچه شده است.  
  - **فلسفه:** برخلاف Cline (که بر روی سخت افزار شما اجرا می شود)، جولز بر روی یک ماشین مجازی گوگل ابری کار می کند. شما وظایف را از طریق مسائل GitHub یا UI اختصاص می دهید، و Jules به طور مستقل PR ایجاد می کند.  
  - **قیمت:** در حال حاضر در نسخه بتا عمومی (رایگان - حداکثر 60 کار در روز).  
- **جمینی CLI:**  
  - **چه:** یک عامل بومی با سرعت بالا و ترمینال برای تجزیه و تحلیل فوری کد و تعامل سیستم.  
  - ** مزیت: ** منبع باز و رایگان (محدودیت های استاندارد). ایده آل برای حلقه های اشکال زدایی سریع که در آن فهرست بندی کامل کد VS زائد است.  
- **Google AI Pro (19.99 دلار در ماه):**
  - **چه:** اشتراک Google One که دسترسی Gemini 2.0 Pro، Gemini CLI (نامحدود)، Jules (تا 60 کار در روز)، NotebookLM Plus و **2 ترابایت فضای ذخیره‌سازی Google Drive** را در اختیار شما قرار می‌دهد.
  - **ROI در مقابل Warp Build:** با قیمت 19.99 دلار در ماه در مقابل 20 دلار در ماه Warp، Google AI Pro ارزش عاملی بسیار بیشتری را ارائه می دهد - AI ترمینال مستقیم + عامل GitHub غیر همگام + مدل زمینه عظیم - در حالی که Warp 20 دلار عمدتاً یکپارچه سازی ترمینال BYOK را ارائه می دهد. اگر مجبور به انتخاب یک اشتراک 20 دلاری شوید، Google AI Pro برای گردش کار کدگذاری برنده می شود.

### مکمل Tier S: مرجع جایگزین های رایگان

ابزارهای زیر شکاف ها را با هزینه تکرارشونده صفر پوشش می دهند. در کنار پشته هسته VS Code + Cline + Copilot استفاده کنید:

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2; min-width:900px;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Tool</th>
        <th style="padding:10px;">Cost</th>
        <th style="padding:10px; text-align:left;">Replaces / Complements</th>
        <th style="padding:10px; text-align:left;">Key Differentiator</th>
        <th style="padding:10px;">VS Code</th>
        <th style="padding:10px;">Multi-Model</th>
      </tr>
    </thead>
    <tbody>
      <tr style="background:rgba(16,185,129,0.05);"><td style="padding:8px;"><strong>Ghostty</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">Replaces Warp (terminal)</td><td style="padding:8px;">GPU-accelerated, native UI (not Electron), macOS & Linux</td><td style="padding:8px; text-align:center;">—</td><td style="padding:8px; text-align:center;">—</td></tr>
      <tr><td style="padding:8px;"><strong>WezTerm</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">Replaces Warp (terminal)</td><td style="padding:8px;">Rust-based, built-in multiplexer (replaces tmux), Lua scripting</td><td style="padding:8px; text-align:center;">—</td><td style="padding:8px; text-align:center;">—</td></tr>
      <tr style="background:rgba(16,185,129,0.05);"><td style="padding:8px;"><strong>Wave Terminal</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">Complements Ghostty / WezTerm</td><td style="padding:8px;">Electron-based; renders markdown, images & HTML <em>inline</em> in the terminal; built-in browser tab for docs; SSH manager; best for documentation-heavy workflows. Still in beta, may crash — prefer Ghostty for 24/7</td><td style="padding:8px; text-align:center;">—</td><td style="padding:8px; text-align:center;">—</td></tr>
      <tr style="background:rgba(16,185,129,0.05);"><td style="padding:8px;"><strong>Roo Code</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">Complements Cline</td><td style="padding:8px;">Cline fork with Architect / Code / Debug / Ask modes + Checkpoint rollback</td><td style="padding:8px; text-align:center; color:#4ade80;">✅ Native</td><td style="padding:8px; text-align:center; color:#4ade80;">✅</td></tr>
      <tr><td style="padding:8px;"><strong>OpenCode</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">Terminal-first alternative to Cline</td><td style="padding:8px;">95K GitHub stars, supports 75+ LLM providers, terminal-native agent</td><td style="padding:8px; text-align:center; color:#f87171;">❌ Terminal</td><td style="padding:8px; text-align:center; color:#4ade80;">✅ 75+</td></tr>
      <tr style="background:rgba(16,185,129,0.05);"><td style="padding:8px;"><strong>Claude Code</strong></td><td style="padding:8px; text-align:center;">API only</td><td style="padding:8px;">Official Anthropic terminal agent</td><td style="padding:8px;">Best-in-class Claude integration, terminal-first, ideal for large codebases</td><td style="padding:8px; text-align:center; color:#f87171;">❌ Terminal</td><td style="padding:8px; text-align:center; color:#f87171;">❌ Claude only</td></tr>
      <tr><td style="padding:8px;"><strong>Kilo Code</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">VS Code Cline alternative</td><td style="padding:8px;">VS Code extension, multi-model, newer and less stable than Cline</td><td style="padding:8px; text-align:center; color:#4ade80;">✅ Native</td><td style="padding:8px; text-align:center; color:#4ade80;">✅</td></tr>
      <tr style="background:rgba(16,185,129,0.05);"><td style="padding:8px;"><strong>Continue.dev</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">Free</td><td style="padding:8px;">Free Cline alternative (beginner-friendly)</td><td style="padding:8px;">VS Code extension, BYOK, simpler UI than Cline — ideal first step before committing to full Cline workflow; supports 50+ models via OpenAI-compatible API</td><td style="padding:8px; text-align:center; color:#4ade80;">✅ Native</td><td style="padding:8px; text-align:center; color:#4ade80;">✅ 50+</td></tr>
    </tbody>
  </table>
</div>

> **توصیه عملی:** **Roo Code** را در کنار Cline نصب کنید — رایگان است، از کلیدهای API یکسان استفاده می کند و حالت های تخصصی آن (معمار، اشکال زدایی) مکمل عامل همه منظوره Cline است. برای ترمینال، **Ghostty** جایگزین رایگان Warp توصیه شده است.

### 4.1 Jules Deep-Dive: گردش کار عامل ناهمزمان

جولز اساساً با کلین متفاوت است. درک این تفاوت کلید استفاده موثر از هر دو ابزار است:

** جولز چگونه کار می کند (گام به گام):**
1. به `jules.google` بروید و مخزن GitHub خود را متصل کنید.
2. یک مخزن و شعبه را انتخاب کنید (ژول به طور خودکار شاخه کاری خود را ایجاد می کند).
3. یک شرح کار بنویسید - یا یک مشکل GitHub با برچسب `jules` اختصاص دهید.
4. جول یک **طرح** را پیشنهاد می کند: لیستی از فایل هایی که تغییر خواهد کرد. شما قبل از نوشته شدن هر کدی طرح را **تأیید** می کنید.
5. جولز روی **Google Cloud VM** در پس‌زمینه اجرا می‌شود — می‌توانید مرورگر را ببندید و بعداً برگردید.
6. پس از اتمام، جول یک **درخواست کشش** را باز می کند. شما بررسی و ادغام می کنید.

**قدرت: اجرای غیرهمگام موازی.** هنگامی که در VS Code + Cline روی ویژگی اصلی کار می کنید، ژولز وظایف پس زمینه را به طور همزمان انجام می دهد:
- "نوشتن تست برای ماژول X"
- "رفع این 3 اشکال جزئی"
- "به روز رسانی README و CHANGELOG"
- "تمام وابستگی ها را به جدیدترین ارتقا دهید"

این بدان معناست که شما به طور موثر دو عامل دارید که به طور موازی کار می کنند.

**مدل زیرین:** Gemini 3 Pro (نه 3.1 Pro). برای کارهای معمول کافی است؛ برای کارهای پیچیده معماری، Cline + Claude برتر است.

**قیمت (فوریه 2026):** بتا عمومی — رایگان (60 کار در روز، 5 کار همزمان). با Google AI Pro: محدودیت های بالاتر. به احتمال زیاد پس از بتا پرداخت می شود.

> **AGENTS.md برای Jules مهم است:** Jules فایل `AGENTS.md` را در ریشه مخزن شما می خواند تا قراردادهای پروژه را درک کند (فرمت commit، دستورات تست، مدیر بسته). آن را دقیق نگه دارید - این تنها سند توجیهی جولز است.

> ⚠️ ** حیاتی: سه عامل، سه نقش - آنها برای یکدیگر جایگزین نیستند.**
> | نماینده | نقش | زمان استفاده |
> |---|---|---|
> | **Cline** (VS Code) | جلسه کدگذاری اولیه فعال — ویرایش فایل، تعاملی | بیشتر کار شما |
> | **ژول** | وظایف Async/Background در شاخه های جداگانه | تست ها، اسناد، اشکالات جزئی — به موازات Cline |
> | **جمینی CLI** | پرسش و پاسخ سریع ترمینال — بدون نیاز به زمینه پروژه | "این خطا به چه معناست؟" یا پرس و جوهای تک شات |
>
> **اگر Cline به یک خطای مدل یا محدودیت نرخ رسید:** به جولز نروید. در عوض، **مدل را در تنظیمات Cline تعویض کنید** (به عنوان مثال، از Claude → MiniMax) یا از **OpenRouter** به عنوان یک ارائه دهنده بازگشتی یکپارچه استفاده کنید (بیش از 50 مدل را تحت یک کلید API پشتیبانی می کند). جولز فقط برای کارهایی است که واقعاً در پس‌زمینه در یک شاخه جداگانه اجرا می‌شوند.

### 4.2 Gemini CLI: نصب و راه اندازی سریع

Gemini CLI یک عامل کدگذاری ترمینال بومی (متن باز، آپاچی 2.0) است. این **کاملا رایگان** با سهمیه های روزانه سخاوتمندانه است:

| حساب کاربری | مدل | درخواست ها/روز | بهترین برای |
|---|---|---|---|
| اکانت گوگل رایگان | **فلش جمینی** | **1000/روز** | پرسش و پاسخ سریع، پرس و جوهای تک شات |
| اکانت گوگل رایگان | **جمینی پرو** | ~10-50 در روز | تجزیه و تحلیل عمیق تر (برای استفاده روزانه قابل اعتماد نیست) |
| Google **AI Pro ** (19.99 دلار در ماه) | فلش + پرو | بالاتر (تعداد دقیق **توسط گوگل منتشر نشده**) | استفاده سنگین ترمینال روزانه |

**نتیجه گیری عملی:** ردیف فلش رایگان (1000 روز در روز) برای پرسش و پاسخ سریع ترمینال کافی است. اگر به جلسات کاری سنگین نیاز دارید، برنامه AI Pro را در نظر بگیرید یا به جای آن در Cline به یک مدل مبتنی بر کلید API بروید.

```bash
# Install (requires Node.js 18+)
npm install -g @google/gemini-cli

# Authenticate with your Google account (free)
gemini auth login

# Start interactive session in your project folder
gemini

# One-shot task
gemini -p "read src/main.py and list all functions that lack type hints"

# Combine with Jules (pipeline example)
gemini -p "find the hardest open issue: $(gh issue list --assignee @me)" | jules remote new --repo .
```

**جمینی CLI در مقابل کد کلود:** هر دو عامل ترمینال اول هستند. Gemini CLI از Gemini 3.1 Pro (با محدودیت AI Pro) استفاده می کند و با Jules ادغام می شود. Claude Code از مدل‌های Claude از طریق API استفاده می‌کند - ساختار هزینه‌ای مشابه با Cline، اما ترمینال اول با دستورات داخلی `/compact` و `/rewind`.

**Claude Code: حالت بازنویسی غزل.** هنگام انجام بازنویسی کامل فایل یا refactor های بزرگ با کلود کد، از حالت "Rewrite" استفاده می کند - به جای محاسبه تفاوت ها، خروجی کامل فایل را مستقیماً می نویسد. این برای فایل‌های زیر 200 خط سریع‌تر است و نسبت به ویرایش مبتنی بر پچ، توکن‌های کمتری مصرف می‌کند. در Cline، با دستور صریح: *"کل این فایل را با تغییرات زیر بازنویسی کنید."

### 4.3 ضد گرانش IDE - عامل-اولین محیط اولیه

**Antigravity** اولین IDE عامل Google است (که قبلاً Project IDX نامیده می شد) که بر روی داخلی های VS Code با **Gemini 3 Pro داخلی** و یک **Agent Manager** بومی برای اجرای موازی چندین عامل ساخته شده است.

> ⚠️ **مشکل شناخته شده: Cline در Antigravity کار نمی کند.** چندین کاربر گزارش می دهند که Cline (و بسیاری از افزونه های بازار VS Code) پس از نصب در نوار کناری Antigravity ظاهر نمی شوند. Antigravity از بازار **OpenVSX** استفاده می کند، نه بازار Microsoft VS Code، بنابراین اکثر برنامه های افزودنی اختصاصی در دسترس نیستند. **به جای Cline از عامل داخلی Antigravity استفاده کنید.**

**ضد گرانش در مقابل کد+کلاین – مقایسه سریع:**

| ویژگی | ضد جاذبه (اولیه) | VS Code + Cline (Fallback) |
|---|---|---|
| تکمیل درون خطی | ✅ نامحدود با Google AI Pro | Copilot رایگان (50 req/ماه رایگان) |
| چند عامل موازی | ✅ مدیر عامل | ⚠️ تک رشته ای |
| DeepSeek مستقیم | ⚠️ فقط از طریق پل `router.py` | ✅ بومی در Cline |
| کلود مستقیم | ⚠️ فقط از طریق پل `router.py` | ✅ بومی در Cline |
| پشتیبانی MCP | ✅ کامل | ✅ کامل |
| مرورگر داخلی | ✅ یکپارچه سازی کروم | ❌ نه |
| پسوند Cline | ❌ شکسته | ✅ بومی |
| ساختار قوانین | `.agent/skills/*.md` | `.clinerules` |
| کنترل تایید | ⚠️ نماینده مستقل تر است | ✅ تایید هر مرحله |

**زمان تعویض از Antigravity به VS Code+Cline:**
- وظیفه مستقیماً به **DeepSeek** (ارزانترین) یا **Claude Sonnet** (دقیق ترین) نیاز دارد
- برای تغییرات حساس کد، به **تأیید ** گام به گام گرانول نیاز دارید
- جلسه طولانی با زمینه سنگین (Antigravity به محدودیت‌های نرخ سریع‌تر می‌رسد)
- پروژه پیچیده که در آن عامل داخلی کافی نیست
- ضد جاذبه به خودی خود دارای اشکال یا سرعت محدود است

**نصب Antigravity:**
```bash
# macOS
brew install --cask antigravity

# Linux (.deb)
wget https://antigravity.google/download/linux/antigravity.deb
sudo dpkg -i antigravity.deb

# Windows
winget install Google.Antigravity

# After install:
# 1. Sign in with your Google account
# 2. Open project folder
# 3. Agent Manager → New Agent → describe your first task
```

---

## 🧠 5. مدیریت زمینه (حافظه عامل)

گلوگاه اصلی در برنامه نویسی عاملی، «زمینه» است. اگر نماینده از وجود فایل یا استانداردهای پروژه بی خبر باشد، کیفیت پایین می آید.

- **فایل های قوانین (`.cursor/rules/`):**  
    - فایل های `.mdc` را برای فناوری ها یا استانداردهای خاص ایجاد کنید.  
    - **مثال:** "همیشه از معماری تمیز استفاده کنید"، "بدون نوع `any` در TypeScript."  
    - **ابتکاری:** "قبل از ویرایش یک فایل، همیشه `.test.ts` مرتبط را بخوانید تا منطق کسب و کار را درک کنید."  

- **نقشه مخزن (Repomap / نمودار دانش):**  
    - ابزارهایی مانند Cline یک نقشه معنایی از پایگاه کد شما ایجاد می کنند. یک ساختار دایرکتوری تمیز را حفظ کنید تا مطمئن شوید که عامل وابستگی های مربوطه را به طور دقیق پیدا می کند.  

---

## ⚙️ 6. متدولوژی مسیریابی هوشمند (معماری حرفه ای)

هسته اصلی بهینه‌سازی هزینه، `AIRouter` است - یک موتور پایتون آماده برای تولید که هر اعلان دریافتی را تجزیه و تحلیل می‌کند، ارزان‌ترین مدل مناسب را انتخاب می‌کند، پاسخ‌ها را در حافظه پنهان نگه می‌دارد، و به‌طور خودکار در صورت خرابی برمی‌گردد.

```python
"""
Professional AI Model Router (Condensed)
Intelligently routes requests based on Task Complexity, Caching, and Fault Tolerance.
"""

class AIRouter:
    def select_model(self, prompt: str, context: Optional[Dict] = None) -> ModelType:
        # 1. Intelligent Task Complexity Analysis (Trivial -> Critical)
        complexity, confidence = self.complexity_analyzer.analyze(prompt, context)
        
        # 2. Routing Logic:
        # - Trivial: DeepSeek V3.2 (Cost: ~0)
        # - Moderate: MiniMax M2.5 (High Reasoning / Low Cost)
        # - Critical: Claude 4.6 Sonnet / Opus (Highest Logic)
        if complexity.value <= TaskComplexity.SIMPLE:
            return ModelType.DEEPSEEK_V3
        elif complexity.value <= TaskComplexity.MODERATE:
            return ModelType.MINIMAX_M25
        return ModelType.CLAUDE_SONNET

    async def generate_with_fallback(self, prompt, **kwargs):
        # 3. Circuit Breaker & Fallback
        # Automatically switches to a more powerful model if the primary fails.
        try:
            return await self.primary_client.generate(prompt)
        except ServiceError:
            return await self.fallback_client.generate(prompt)
```

---

### 6.1. ماتریس پیچیدگی کار - مرجع کامل

کلاس `ComplexityAnalyzer` هر درخواست را در یکی از پنج سطح طبقه بندی می کند و آن را به مدل بهینه هدایت می کند. طبقه‌بندی مبتنی بر کلیدواژه است و ضریب‌های متنی در بالا اعمال می‌شود.

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2; min-width:900px;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Level</th>
        <th style="padding:10px;">Value</th>
        <th style="padding:10px; text-align:left;">Description</th>
        <th style="padding:10px; text-align:left;">Default Target</th>
        <th style="padding:10px; text-align:left;">Trigger Keywords</th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;"><strong>TRIVIAL</strong></td><td style="padding:8px; text-align:center;">1</td><td style="padding:8px;">Boilerplate, formatting, comments, imports</td><td style="padding:8px;">DeepSeek Coder</td><td style="padding:8px; font-family:monospace; font-size:10px;">format, indent, comment, rename, import, boilerplate, template, scaffold</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>SIMPLE</strong></td><td style="padding:8px; text-align:center;">2</td><td style="padding:8px;">Basic CRUD, standard patterns, simple tests</td><td style="padding:8px;">DeepSeek Coder</td><td style="padding:8px; font-family:monospace; font-size:10px;">crud, getter, setter, validate, parse, convert, map, filter, simple test</td></tr>
      <tr><td style="padding:8px;"><strong>MODERATE</strong></td><td style="padding:8px; text-align:center;">3</td><td style="padding:8px;">Business logic, API endpoints, database ops</td><td style="padding:8px;">Claude Haiku</td><td style="padding:8px; font-family:monospace; font-size:10px;">implement, refactor, optimize, business logic, api endpoint, database, integration, middleware</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>COMPLEX</strong></td><td style="padding:8px; text-align:center;">4</td><td style="padding:8px;">Architecture, performance tuning, concurrency</td><td style="padding:8px;">Claude Sonnet</td><td style="padding:8px; font-family:monospace; font-size:10px;">architecture, design pattern, algorithm, performance, scalability, security, distributed, concurrency, async</td></tr>
      <tr><td style="padding:8px;"><strong>CRITICAL</strong></td><td style="padding:8px; text-align:center;">5</td><td style="padding:8px;">Production bugs, security vulnerabilities, data loss</td><td style="padding:8px;">Claude Opus</td><td style="padding:8px; font-family:monospace; font-size:10px;">bug fix production, security vulnerability, data loss, critical bug, emergency, zero-day, exploit</td></tr>
    </tbody>
  </table>
</div>

**ضریب امتیاز مبتنی بر زمینه (افزودنی):**
- `file_count > 10` → +1.0 تا امتیاز COMPLEX
- `environment == 'production'` → +2.0 تا امتیاز بحرانی
- `urgent == True` → 1.0+ تا امتیاز بحرانی
- `word_count > 200` → +0.5 به COMPLEX؛ `word_count > 100` → +0.5 تا MODERATE

** نادیده گرفتن تحلیلگر سفارشی ** (برای مسیریابی دامنه خاص):
```python
from ai_router import ComplexityAnalyzer, TaskComplexity

class CustomAnalyzer(ComplexityAnalyzer):
    @staticmethod
    def analyze(prompt, context=None):
        if 'database migration' in prompt.lower():
            return TaskComplexity.CRITICAL, 1.0
        return TaskComplexity.SIMPLE, 0.5

router.complexity_analyzer = CustomAnalyzer()
```

---

### 6.2. چهار استراتژی مسیریابی

هر استراتژی مقادیر پیچیدگی کار را برای مدل‌سازی سطوح ترسیم می‌کند. بر اساس میزان تحمل ریسک و بودجه پروژه خود تنظیم کنید.

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Strategy</th>
        <th style="padding:10px;">DeepSeek Max</th>
        <th style="padding:10px;">Haiku Max</th>
        <th style="padding:10px;">Sonnet Max</th>
        <th style="padding:10px;">Cache TTL</th>
        <th style="padding:10px; text-align:left;">Recommended For</th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;"><strong>Conservative</strong></td><td style="padding:8px; text-align:center;">1 (Trivial only)</td><td style="padding:8px; text-align:center;">2</td><td style="padding:8px; text-align:center;">4</td><td style="padding:8px; text-align:center;">1h</td><td style="padding:8px;">Production systems, quality-critical work</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Balanced</strong></td><td style="padding:8px; text-align:center;">2</td><td style="padding:8px; text-align:center;">3</td><td style="padding:8px; text-align:center;">4</td><td style="padding:8px; text-align:center;">2h</td><td style="padding:8px;">General-purpose daily development (default)</td></tr>
      <tr><td style="padding:8px;"><strong>Cost-Optimized</strong></td><td style="padding:8px; text-align:center;">3</td><td style="padding:8px; text-align:center;">4</td><td style="padding:8px; text-align:center;">5</td><td style="padding:8px; text-align:center;">4h</td><td style="padding:8px;">High-volume, budget-constrained projects</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Dev</strong></td><td style="padding:8px; text-align:center;">2</td><td style="padding:8px; text-align:center;">3</td><td style="padding:8px; text-align:center;">4</td><td style="padding:8px; text-align:center;">Disabled</td><td style="padding:8px;">Fast iteration loops, fresh responses required</td></tr>
    </tbody>
  </table>
</div>

```python
from config_example import (
    CONSERVATIVE_ROUTING,
    BALANCED_ROUTING,
    COST_OPTIMIZED_ROUTING,
    DEV_ROUTING
)

router = AIRouter(MODEL_CONFIGS, BALANCED_ROUTING)        # Recommended default
router = AIRouter(MODEL_CONFIGS, CONSERVATIVE_ROUTING)    # Production
router = AIRouter(MODEL_CONFIGS, COST_OPTIMIZED_ROUTING)  # Budget mode
router = AIRouter(MODEL_CONFIGS, DEV_ROUTING)             # Development
```

---

### 6.3. تجزیه و تحلیل هزینه در دنیای واقعی (500 درخواست در روز)

**`BALANCED_ROUTING` تفکیک — 500 درخواست در روز:**

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Model</th>
        <th style="padding:10px;">Share</th>
        <th style="padding:10px;">Daily Requests</th>
        <th style="padding:10px;">Daily Cost</th>
        <th style="padding:10px;">Monthly Cost</th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;">DeepSeek Coder</td><td style="padding:8px; text-align:center;">40%</td><td style="padding:8px; text-align:center;">200</td><td style="padding:8px; text-align:center;">~$0.60</td><td style="padding:8px; text-align:center;">~$18</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;">Claude Haiku</td><td style="padding:8px; text-align:center;">30%</td><td style="padding:8px; text-align:center;">150</td><td style="padding:8px; text-align:center;">~$2.50</td><td style="padding:8px; text-align:center;">~$75</td></tr>
      <tr><td style="padding:8px;">Claude Sonnet 4.6</td><td style="padding:8px; text-align:center;">25%</td><td style="padding:8px; text-align:center;">125</td><td style="padding:8px; text-align:center;">~$6.25</td><td style="padding:8px; text-align:center;">~$187</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;">Claude Opus 4.6</td><td style="padding:8px; text-align:center;">5%</td><td style="padding:8px; text-align:center;">25</td><td style="padding:8px; text-align:center;">~$3.00</td><td style="padding:8px; text-align:center;">~$90</td></tr>
      <tr style="background:rgba(59,130,246,0.15); font-weight:bold;"><td style="padding:8px;">Total</td><td style="padding:8px; text-align:center;">100%</td><td style="padding:8px; text-align:center;">500</td><td style="padding:8px; text-align:center;">~$12.35</td><td style="padding:8px; text-align:center;">~$370</td></tr>
    </tbody>
  </table>
</div>

**مقایسه استراتژی در مقابل خط پایه All-Opus:**

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Strategy</th>
        <th style="padding:10px;">Monthly Cost</th>
        <th style="padding:10px;">Savings vs. All-Opus ($825/mo)</th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;">All Claude Opus (baseline)</td><td style="padding:8px; text-align:center;">$825</td><td style="padding:8px; text-align:center;">—</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;">Conservative Router</td><td style="padding:8px; text-align:center;">~$500</td><td style="padding:8px; text-align:center; color:#4ade80;">−39%</td></tr>
      <tr><td style="padding:8px;">Balanced Router</td><td style="padding:8px; text-align:center;">~$370</td><td style="padding:8px; text-align:center; color:#4ade80;">−55%</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;">Cost-Optimized Router</td><td style="padding:8px; text-align:center;">~$270</td><td style="padding:8px; text-align:center; color:#4ade80;"><strong>−67%</strong></td></tr>
    </tbody>
  </table>
</div>

> **ضریب حافظه پنهان:** درخواست های یکسان 0 دلار هزینه دارند (TTL کش: 1 تا 4 ساعت بسته به استراتژی). در گردش‌های کاری واقعی با تکرار سریع بالا (به عنوان مثال، الگوهای بررسی کد)، صرفه‌جویی مؤثر از ارقام بالا بیشتر است.

---

### 6.4. مرجع رابط CLI

`router_cli.py` چهار حالت عملیاتی قابل دسترسی از یک نقطه ورودی را ارسال می کند:

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Mode</th>
        <th style="padding:10px; text-align:left;">Command</th>
        <th style="padding:10px; text-align:left;">Description</th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;"><strong>Interactive</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py</td><td style="padding:8px;">REPL loop with inline model override flags</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Single Prompt</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py -p "prompt"</td><td style="padding:8px;">One-shot generation, prints metadata</td></tr>
      <tr><td style="padding:8px;"><strong>Force Model</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py -p "prompt" --model sonnet</td><td style="padding:8px;">Bypasses routing, uses specified model</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Batch</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py --batch prompts.txt --output results.json</td><td style="padding:8px;">Parallel processing from newline-delimited file</td></tr>
      <tr><td style="padding:8px;"><strong>Stats</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py --stats</td><td style="padding:8px;">Live cost dashboard with per-model breakdown</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Cost Estimate</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py --estimate 500</td><td style="padding:8px;">Monthly projection for N requests/day</td></tr>
      <tr><td style="padding:8px;"><strong>Test Analyzer</strong></td><td style="padding:8px; font-family:monospace;">python router_cli.py --test-complexity</td><td style="padding:8px;">Validates routing decision logic against test prompts</td></tr>
    </tbody>
  </table>
</div>

** حالت تعاملی - مدل درون خطی لغو می شود:**
```
@opus      → Force Claude Opus 4.6
@sonnet    → Force Claude Sonnet 4.6
@haiku     → Force Claude Haiku
@deepseek  → Force DeepSeek Coder
stats      → Show live statistics
exit       → Quit
```

**استراتژی مسیریابی را هنگام راه اندازی انتخاب کنید:**
```bash
python router_cli.py --strategy balanced       # default
python router_cli.py --strategy conservative   # production
python router_cli.py --strategy cost-optimized # budget
```

---

### 6.5. کد منبع و نصب

**وابستگی ها (`requirements.txt`):**
```
# ── Core (required) ──────────────────────────────────────────
anthropic>=0.40.0          # Claude Opus / Sonnet / Haiku
httpx>=0.27.0              # DeepSeek (direct REST)
python-dotenv>=1.0.0
pydantic>=2.0.0
aiofiles>=23.0.0

# ── Optional: GPT-5.x / OpenAI-compatible APIs ───────────────
# openai>=1.0.0            # GPT-5.4, GPT-5 mini (OpenAI API)

# ── Optional: Google Gemini ──────────────────────────────────
# google-genai>=1.0.0          # Gemini 3.x Pro / Flash (new official SDK)

# ── Optional: Universal adapter (all models via one API) ─────
# litellm>=1.0.0           # Supports Claude, GPT, Gemini,
#                          # MiniMax, Kimi, DeepSeek, Mistral…
#                          # Replaces provider-specific clients

# ── Optional: Orchestration / Agents ─────────────────────────
# langchain>=0.3.0         # Chain/agent orchestration
# langchain-anthropic>=0.3.0
# langchain-openai>=0.3.0
```

> **توصیه:** برای پروژه هایی که به بیش از Claude + DeepSeek نیاز دارند، از `litellm` به عنوان جایگزینی برای `ClaudeClient` و `DeepSeekClient` استفاده کنید. این یک رابط واحد واحد برای تمام 11 مدل لیست شده در بخش 1 بدون بازنویسی منطق روتر فراهم می کند.

**راه اندازی (3 مرحله):**
```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Set API keys in .env
ANTHROPIC_API_KEY=your_anthropic_key
DEEPSEEK_API_KEY=your_deepseek_key

# 3. Copy and configure
cp config_example.py config.py
# Edit config.py: update API keys and model names to match current versions
# Note: update model name strings and pricing to match Section 2 of this report
```

**فایل های منبع (اجرای تولید کامل):**

| فایل | توضیحات |
|---|---|
| [__CODE_0__](.agent/skills/ai-router/ai_router.py) | موتور اصلی: `AIRouter`، `ComplexityAnalyzer`، `CacheManager`، `CostTracker`، `CircuitBreaker`، `ClaudeClient`، `DeepSeekClient` |
| [__CODE_0__](.agent/skills/ai-router/config_example.py) | هر چهار استراتژی مسیریابی با جداول قیمت گذاری کامل `ModelConfig` |
| [__CODE_0__](.agent/skills/ai-router/router_cli.py) | CLI کامل با حالت های تعاملی، تک اعلان، دسته ای، آمار و برآورد هزینه |
| [__CODE_0__](.agent/skills/ai-router/requirements.txt) | لیست وابستگی پایتون |

** مروری بر معماری:**

```
AIRouter
├── ComplexityAnalyzer      → keyword + context scoring → TaskComplexity (1-5)
├── select_model()          → maps complexity to ModelType via RoutingConfig thresholds
├── CacheManager            → SHA-256 keyed, TTL-based async response cache
├── CostTracker             → per-request metrics + monthly projection engine
├── CircuitBreaker (×5)     → per-model; opens after 5 failures, retries after 60s
├── ClaudeClient            → Anthropic SDK async wrapper
└── DeepSeekClient          → httpx async wrapper for DeepSeek REST API
```

### 6.6 روتر تولید ساده (`src/utils/router.py`)

یک نسخه نازک‌تر و آماده برای تولید با استفاده از **رابط سازگار با OpenAI** برای هر سه ارائه‌دهنده - بدون نیاز به مشتری HTTP سفارشی. کشویی برای هر پروژه

```python
"""
router.py — Intelligent LLM Router
Auto model selection + fallback + cost control + logging
"""
import asyncio, json, os, time, datetime, re
from pathlib import Path
from openai import AsyncOpenAI

# ─── Configuration ─────────────────────────────────────────────────────

LIMITS = {"daily": 1.0, "weekly": 5.0, "monthly": 25.0}
LOG_FILE = Path("memory-bank/costLog.json")

# ─── Complexity Detection via Keyword Scoring ────────────────────────

SIGNALS = {
    # high score = stronger model
    "critical": {
        "keywords": [
            "معماری", "architect", "design pattern", "امنیت", "security",
            "vulnerability", "review", "بررسی نهایی", "production",
            "authentication", "authorization", "audit", "injection",
        ],
        "score": 25,
    },
    "moderate": {
        "keywords": [
            "refactor", "بازنویسی", "feature", "ویژگی جدید",
            "integrate", "یکپارچه", "مستندات", "documentation",
            "optimize", "بهینه", "analyze", "تحلیل",
        ],
        "score": 12,
    },
    "trivial": {
        "keywords": [
            "تست بنویس", "write test", "bug fix", "رفع باگ",
            "crud", "boilerplate", "اضافه کن", "add function",
        ],
        "score": -5,  # negative score = cheaper model
    },
}


def analyze_prompt(prompt: str) -> tuple[int, str]:
    """
    Analyze the prompt and return a complexity score.
    returns: (score 0-100, reasoning string)
    """
    score = 30  # base score
    reasons = []
    prompt_lower = prompt.lower()

    # keyword scoring
    for level, data in SIGNALS.items():
        for kw in data["keywords"]:
            if kw.lower() in prompt_lower:
                score += data["score"]
                reasons.append(f"{level}:{kw}")
                break

    # prompt length
    word_count = len(prompt.split())
    if word_count > 200: score += 20
    elif word_count > 80: score += 10
    elif word_count < 20: score -= 10

    # file reference count
    file_mentions = len(re.findall(r'\b\w+\.py\b', prompt))
    if file_mentions > 3: score += 15
    elif file_mentions > 1: score += 8

    score = max(0, min(100, score))
    reasoning = f"score={score} words={word_count} files={file_mentions} signals={reasons[:3]}"
    return score, reasoning


def score_to_model(score: int) -> str:
    """Numeric score → model selection."""
    if score >= 66: return "claude"
    if score >= 31: return "minimax"
    return "deepseek"


# ─── Cost Calculation ──────────────────────────────────────────────────

COST_PER_TOKEN = {
    "deepseek":  {"input": 0.028e-6, "output": 0.42e-6},   # cache-hit
    "minimax":   {"input": 0.30e-6,  "output": 1.20e-6},
    "claude":    {"input": 3.0e-6,   "output": 15.0e-6},
}


def estimate_cost(provider: str, in_tokens: int, out_tokens: int) -> float:
    r = COST_PER_TOKEN[provider]
    return r["input"] * in_tokens + r["output"] * out_tokens


def log_and_check(provider: str, cost: float) -> list[str]:
    """Log cost and return threshold warnings."""
    LOG_FILE.parent.mkdir(exist_ok=True)
    today = datetime.date.today().isoformat()
    data = json.loads(LOG_FILE.read_text()) if LOG_FILE.exists() else {}
    data.setdefault(today, {}).setdefault(provider, 0)
    data[today][provider] += cost
    LOG_FILE.write_text(json.dumps(data, indent=2))

    # compute period aggregates
    week_ago = (datetime.date.today() - datetime.timedelta(days=7)).isoformat()
    month_start = datetime.date.today().replace(day=1).isoformat()
    all_days = {k: sum(v.values()) for k, v in data.items()}

    daily   = all_days.get(today, 0)
    weekly  = sum(v for k, v in all_days.items() if k >= week_ago)
    monthly = sum(v for k, v in all_days.items() if k >= month_start)

    warnings = []
    for name, spent, limit in [
        ("daily", daily, LIMITS["daily"]),
        ("weekly", weekly, LIMITS["weekly"]),
        ("monthly", monthly, LIMITS["monthly"]),
    ]:
        pct = spent / limit * 100
        if pct >= 100:
            warnings.append(f"🚨 STOP {name}: ${spent:.2f}/${limit}")
        elif pct >= 80:
            warnings.append(f"⚠️ {name}: ${spent:.2f}/${limit} ({pct:.0f}%)")
    return warnings


# ─── Circuit Breaker ───────────────────────────────────────────────────

class CircuitBreaker:
    """Three consecutive failures → 5-minute pause."""
    def __init__(self):
        self._state: dict[str, tuple[int, float]] = {}

    def is_open(self, provider: str) -> bool:
        fails, ts = self._state.get(provider, (0, 0))
        if fails >= 3 and time.time() - ts < 300:
            return True
        if fails >= 3:
            self._state[provider] = (0, 0)  # reset after 5 minutes
        return False

    def record_fail(self, provider: str):
        fails, _ = self._state.get(provider, (0, 0))
        self._state[provider] = (fails + 1, time.time())

    def record_success(self, provider: str):
        self._state.pop(provider, None)


# ─── Main Router ───────────────────────────────────────────────────────

class LLMRouter:
    def __init__(self):
        self.breaker = CircuitBreaker()
        self._clients = {
            "deepseek": AsyncOpenAI(
                api_key=os.environ["DEEPSEEK_API_KEY"],
                base_url="https://api.deepseek.com",
            ),
            "minimax": AsyncOpenAI(
                api_key=os.environ["MINIMAX_API_KEY"],
                base_url="https://api.minimax.chat/v1",
            ),
            "claude": AsyncOpenAI(
                api_key=os.environ["ANTHROPIC_API_KEY"],
                base_url="https://api.anthropic.com/v1",
            ),
        }
        self._models = {
            "deepseek": "deepseek-chat",
            "minimax":  "minimax-m2.5",
            "claude":   "claude-sonnet-4-5-20251001",
        }
        # fallback chain per primary model
        self._fallback = {
            "deepseek": ["minimax", "claude"],
            "minimax":  ["deepseek", "claude"],
            "claude":   ["minimax", "deepseek"],
        }

    async def _call(self, provider: str, messages: list, max_tokens=4096) -> tuple:
        client = self._clients[provider]
        resp = await client.chat.completions.create(
            model=self._models[provider],
            messages=messages,
            max_tokens=max_tokens,
            stream=False,
        )
        return resp.choices[0].message.content, resp.usage

    async def generate(
        self,
        prompt: str,
        system: str | None = None,
        force_provider: str | None = None,
        max_tokens: int = 4096,
        verbose: bool = True,
    ) -> str:
        """
        Main API — call this method.
        force_provider: override auto-selection (e.g. always use claude)
        """
        # analyze prompt complexity
        score, reasoning = analyze_prompt(prompt)
        primary = force_provider or score_to_model(score)

        if verbose:
            print(f"🔍 {reasoning} → {primary}")

        # build messages list
        messages = []
        if system:
            messages.append({"role": "system", "content": system})
        messages.append({"role": "user", "content": prompt})

        # try primary model then fallbacks
        chain = [primary] + self._fallback[primary]
        for provider in chain:
            if self.breaker.is_open(provider):
                print(f"⏭️ skip {provider} (circuit open)")
                continue
            try:
                content, usage = await self._call(provider, messages, max_tokens)
                self.breaker.record_success(provider)

                # log cost and check thresholds
                cost = estimate_cost(
                    provider,
                    getattr(usage, "prompt_tokens", 500),
                    getattr(usage, "completion_tokens", 500),
                )
                warnings = log_and_check(provider, cost)
                if verbose:
                    print(f"✅ {provider} ${cost:.4f}")
                for w in warnings:
                    print(w)

                return content

            except Exception as e:
                print(f"❌ {provider}: {e}")
                self.breaker.record_fail(provider)
                continue

        raise RuntimeError("All providers failed")


# ─── Project-wide Singleton ─────────────────────────────────────────────
router = LLMRouter()


# ─── Simple Usage Example ──────────────────────────────────────────────
if __name__ == "__main__":
    async def demo():
        # auto → DeepSeek (simple task)
        r1 = await router.generate("Write a function that sorts a list of numbers")

        # auto → MiniMax (moderate task)
        r2 = await router.generate("Refactor this module to use dataclasses")

        # auto → Claude (complex task)
        r3 = await router.generate("Review the architecture of this authentication system")

        # force override
        r4 = await router.generate("Any question here", force_provider="claude")

    asyncio.run(demo())
```

فرمت **`costLog.json`** (دیکت با کلید تاریخ، به ازای هر ارائه دهنده - هم توسط `router.py` و هم `cost_monitor.py` استفاده می شود):
```json
{
  "2026-03-11": {
    "deepseek": 0.12,
    "minimax": 0.35
  },
  "2026-03-12": {
    "claude": 0.48
  }
}
```

---

## ✅ 7. چک لیست گردش کار بهینه شده (رویه عملیاتی استاندارد)

1. **راه اندازی اولیه:**  
    - با یک `task.md` تمیز (نقاط گلوله) و یک `implementation_plan.md` (نقشه راه) شروع کنید.  
    - **مدل پیشنهادی:** **MiniMax M2.5** (بالاترین ROI استدلال برای مرحله طراحی).  
    - **توجه:** اگر اکوسیستم Anthropic را ترجیح می دهید، از **Claude 4.6 Sonnet** استفاده کنید (Opus برای گردش کار روزانه به دلیل هزینه های زیاد توصیه نمی شود).  

2. **اجرا:**  
    - برای اجرا به **DeepSeek V3.2** بروید.  
    - **قانون طلایی:** هرگز به نماینده اجازه ندهید که موارد گسترده را چند کار انجام دهد. **یک وظیفه = یک تعهد.**  

3. **تأیید و خوددرمانی خودمختار:**  
    - مامور را به استفاده از **TDD** (Test-Driven Development: نوشتن تست *قبل از* اجرای واقعی) اجباری کنید.  
    - **حلقه خودکار:** با استفاده از دسترسی ترمینال (به عنوان مثال، Cline)، عامل باید به طور مستقل آزمایش ها را اجرا کند، گزارش های خرابی را تجزیه و تحلیل کند، و تکرار کد را تا زمانی که همه معیارها تصویب شود، انجام دهد. شما فقط گزارش موفقیت نهایی را بررسی می کنید.  
	
4. **تصفیه:**  
    - "این فایل را برای نقص های منطقی یا آسیب پذیری های امنیتی بررسی کنید."  
    - **مدل پیشنهادی:** غزل کلود 4.6 (برای پرداخت نهایی).  

---

### 7.1. کاهش ریسک عملیاتی - 8 شکاف بحرانی

اینها رایج ترین نقاط شکست در گردش کار عامل تولید هستند که در چک لیست بالا پوشش داده نمی شوند:

**1. جلوگیری از انفجار حلقه بی نهایت و هزینه**
- در تنظیمات Cline: **اندازه پنجره زمینه** را روی `80K` و **حداکثر درخواست در هر کار** را روی `20` تنظیم کنید.
- یک فایل `.clinerules` در ریشه پروژه خود با دستورالعمل: `"Stop and ask the user if uncertain about the next step. Never retry the same action more than 3 times."` ایجاد کنید
- بدون این محدودیت ها، یک جلسه Cline با کلود سونت می تواند 10 تا 50 دلار در چند دقیقه هزینه داشته باشد.

**2. بانک حافظه (تداوم جلسات متقابل)**
- بانک حافظه Cline زمینه را بین جلسات زنده نگه می دارد. بدون آن، عامل هر بار از صفر شروع می کند.
- این فایل ها را مقداردهی اولیه کنید: `memory-bank/activeContext.md`، `memory-bank/progress.md`، `memory-bank/systemPatterns.md`.
- بانک حافظه را در تنظیمات Cline فعال کنید.

**3. انفجار زمینه در رزومه**
- هنگامی که یک کار طولانی را از سر می گیرید، Cline تاریخچه مکالمه کامل را دوباره ارسال می کند - حافظه پنهان سریع کار نمی کند و هزینه ها افزایش می یابد. برخی از کاربران گزارش دادند که فقط از این قیمت از 30 دلار در ماه به 230 دلار در ماه می رسد.
- قانون: **یک کار = یک جلسه کلین = یک تعهد.** هرگز از سر نگیرید. در عوض، یک `session-summary.md` بنویسید که وضعیت فعلی را ثبت کند و یک جلسه جدید با آن به عنوان زمینه شروع کنید.

**4. فایل قانون TDD (برای انطباق لازم است)**
- نوشتن "استفاده از TDD" در چک لیست کافی نیست - نمایندگان بدون یک فایل قانون آن را نادیده می گیرند.
- ایجاد `.cursor/rules/tdd.mdc`:
  ```
  Always write the failing test BEFORE writing implementation code.
  Never write implementation before the test exists.
  Run the full test suite after every file change.
  If tests fail, analyze the failure message before making changes.
  ```

**5. مدیریت مخفی **
- کلیدهای API (DeepSeek، Anthropic، MiniMax) پراکنده در فایل های `.env` یک خطر نشت هستند — به خصوص اگر OpenClaw یا هر عامل شخص ثالثی نصب شده باشد.
- به `.gitignore` اضافه کنید: `.env`، `.env.*`، `config.py` (اگر حاوی کلید باشد).
- برای اسرار از `direnv` یا `dotenv-vault` استفاده کنید. یک قانون اضافه کنید: `"Never hardcode API keys. Always use environment variables. Never commit .env files."`

**6. تله متری هزینه و هشدارهای بودجه**
- "بررسی داشبورد روزانه" برای اتوماسیون کافی نیست.
- در **Anthropic Console** و **DeepSeek Platform**: یک هشدار بودجه سخت با قیمت 5 دلار در روز و یک هشدار نرم با قیمت 2 دلار در روز پیکربندی کنید.
- در کد: از کتابخانه `tokencost` Python برای پیگیری هزینه هر تماس API در زمان واقعی استفاده کنید.

**7. API Fallback Chain**
- نرخ-محدودیت DeepSeek در ساعات اوج مصرف. بازگشت کد شبه در بخش 6 باید پیاده سازی شود.
- زنجیره پیشنهادی: `DeepSeek V3.2` → (در صورت شکست) → `MiniMax M2.5` → (در صورت شکست) → `Gemini Flash` (اغلب رایگان از طریق Google AI Studio).
- `ai_router.py` در بخش 6 قبلاً این الگو را از طریق `CircuitBreaker` + `_generate_with_fallback()` پیاده سازی می کند.

**8. استراتژی پروژه بزرگ (+50 فایل)**
- پنجره زمینه 128K DeepSeek V3.2 برای پروژه هایی با بیش از 50 فایل کافی نیست.
- برای معماری و برنامه ریزی در مقیاس بزرگ: از **Gemini 3.1 Pro** (1M زمینه) یا **Kimi K2.5** (256K) استفاده کنید.
- قبل از ارسال به نماینده، بار زمینه را کاهش دهید: از خروجی `tree` و خلاصه Repomap به جای محتوای کامل فایل استفاده کنید.

---

### 7.2 انتخاب مدل سریع مرجع

از این جدول قبل از هر کار استفاده کنید تا فوراً مدل صحیح را انتخاب کنید. مدل اشتباه = پول هدر رفته یا کیفیت پایین.

| نوع وظیفه | مدل | هزینه/وظیفه (تخمینی) | چرا |
|---|---|---|---|
| بی اهمیت: تست، پیکربندی، رفع پرز، اشکالات کوچک | **DeepSeek V3.2** | ~ 0.01 دلار | Cache-Hit: $0.028/M ورودی؛ سریعترین برای الگوهای تکراری |
| متوسط: ویژگی های جدید، Refactor ها، تغییرات چند فایل | **MiniMax M2.5** | ~ 0.05 دلار | 80.2% SWE-bench; استدلال قوی با هزینه کم |
| بحرانی: معماری، بررسی امنیتی، طراحی API | **Claude Sonnet 4.6** | ~0.15 دلار | بهترین استدلال؛ ارزش حق بیمه برای تصمیمات برگشت ناپذیر |
| پرسش و پاسخ سریع (بدون نیاز به زمینه پروژه) | **جمینی CLI (فلش)** | **0$** | رایگان، 1000 req/day; استفاده از ترمینال |
| کارهای پس زمینه (تست ها، اسناد، اصلاحات جزئی) | **ژول** | **0$ (بتا)** | Async در شاخه جداگانه. در حالی که روی main | کار می کنید اجرا می شود
| تولید فله، اسناد، داربست (بودجه) | **فلش جمینی 3** | ~ 0.02 دلار | 57.6% SWE-bench; سریع و ارزان برای کارهای تولید غیر بحرانی |
| تکمیل خودکار درون خطی رایگان | **GPT-5 mini** (Copilot) | **0$** | نامحدود در Copilot Free/Pro. قوی برای تکمیل های کوتاه و پیشنهادات تک فایل |
| استدلال ریاضی/الگوریتم (مستقل) | **DeepSeek Speciale** | ~ 0.01 دلار | ⚠️ در دسترس از طریق **OpenRouter فقط ** (نقطه پایان مستقیم منقضی شده در دسامبر 2025)؛ استفاده از ابزار در Cline از طریق OR کار می کند — از نقطه پایانی `deepseek-reasoner-speciale` به طور مستقیم استفاده نکنید |
| زنجیره ابزار پیچیده متوسط ​​بحرانی، قابلیت اطمینان کلود با قیمت کمتر | **کلود هایکو 4.5** | ~ 0.02 دلار | > 73% SWE-bench تایید شده. دقت فراخوانی ابزار کلود ~ 4× ارزانتر از Sonnet — زمانی که فراخوانی ابزار MiniMax/DeepSeek در گردش های کاری عامل چند مرحله ای با شکست مواجه می شود استفاده کنید |

**OpenRouter به عنوان بازگشتی جهانی:** اگر DeepSeek محدود کننده نرخ باشد، یک مدل از کار افتاده است، یا یک کلید API برای همه مدل های بدون نیاز به VPN می خواهید:
- ارائه دهنده: OpenRouter | URL پایه: `https://openrouter.ai/api/v1`
- از شناسه‌های مدل مانند: `deepseek/deepseek-v3.2` · `anthropic/claude-sonnet-4-5` · `minimax/minimax-m2.5` استفاده کنید
- با Cline، Roo Code و هر کلاینت سازگار با OpenAI با تغییرات کد صفر کار می کند - فقط URL پایه و کلید API را به روز کنید.

**DeepSeek V3.2 — تفکیک هزینه هر پلتفرم (بودجه: 20 دلار):**

| پلت فرم | ورودی (در هر 1M) | خروجی (در هر 1M) | پیام ها / 20 دلار | یادداشت ها |
|---|---|---|---|---|
| **DeepSeek API direct** ⭐ | 0.028 دلار cache-hit | 0.42 دلار | **~2000+** | 5 میلیون توکن رایگان هنگام ثبت نام؛ بهترین نرخ ضربه کش |
| **OpenRouter** | 0.24 دلار | 0.38 دلار | ~1500 | بدون نیاز به VPN در مناطق محدود کار می کند |
| **هوش مصنوعی** | 0.25 دلار | 0.40 دلار | ~1400 | آپتایم خوب برای بازگشت |
| **میزبان خود** | رایگان | رایگان | ∞ | به GPU 8× H100 نیاز دارد — برای افراد کاربردی نیست |

> **استراتژی ضربه به حافظه پنهان:** DeepSeek 0.028 دلار در میلیون دلار در حافظه پنهان در مقابل 0.28 دلار در میلیون دلار بدون حافظه پنهان (10× شکاف) هزینه می کند. **اعلام سیستم کاراکتر به کاراکتر خود را یکسان نگه دارید** در تمام درخواست ها - حتی یک تغییر کاراکتر حافظه پنهان را بازنشانی می کند و هزینه آن 10× بیشتر است.

---

## 🎯 8. توصیه راه اندازی نهایی و منطق اقتصادی

هدف از این پیکربندی دستیابی به **حداکثر کارایی با حداقل هزینه های تکرارشونده** است. توجیه هر هزینه به شرح زیر است:

1. ** کد VS + Copilot + Cline (28 دلار در ماه):**   
   - **منطق:** Copilot پیشنهادات روتین و تکمیل خودکار کارآمد را با قیمت 10 دلار ارائه می دهد. Cline با اتصال به APIهای ارزان قیمت (مانند DeepSeek) وظایف نمایندگی مستقل را انجام می دهد. این ترکیب مقرون به صرفه‌تر از اشتراک‌های IDE 20 دلاری در ماه است زیرا محدودیت‌های نرخ دلخواه را حذف می‌کند و کنترل دقیقی را ارائه می‌دهد.  

2. ** ساخت Warp (20 دلار در ماه):**   
   - **دلیل:** این کلید ادغام هوش مصنوعی در ترمینال است. با BYOK، هزینه اجرای دستورات CLI - که قبلا می توانست به چندین سنت برسد - به کمتر از 0.001 سنت کاهش می یابد.  
   - **جایگزین:** به جای آن **Ghostty** (ترمینال رایگان) + **Google AI Pro** (19.99 دلار در ماه) را در نظر بگیرید — همان بودجه، قابلیت های گسترده تر.  

3. **تخصیص بودجه API (حداقل اعتبار 20 دلار):**  
   - ** غزل کلود 4.6 (هوش):** پرداخت هزینه مدل معمار برای جلوگیری از خطاهای طراحی گران قیمت.  
   - **DeepSeek V3.2 (اجرا):** این مدل از مکانیزم‌های ضربه به حافظه پنهان برای مدیریت بخش عمده‌ای از تولید کد با هزینه تقریباً صفر استفاده می‌کند.  

### 8.1. تنظیم سطوح بر اساس بودجه

سه پیکربندی معتبر که سطوح مختلف سرمایه گذاری را پوشش می دهد:

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2; min-width:900px;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Component</th>
        <th style="padding:10px; text-align:center; color:#4ade80;">🆓 Zero Budget<br><small>$0/mo</small></th>
        <th style="padding:10px; text-align:center; color:#93c5fd;">💙 Budget Pro<br><small>~$10/mo</small></th>
        <th style="padding:10px; text-align:center; color:#fbbf24;">⭐ Professional<br><small>~$30/mo</small></th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;"><strong>Terminal</strong></td><td style="padding:8px; text-align:center;">Ghostty (free)</td><td style="padding:8px; text-align:center;">Ghostty (free)</td><td style="padding:8px; text-align:center;">Ghostty (free)</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Coding Agent (IDE)</strong></td><td style="padding:8px; text-align:center;">Cline + Roo Code (free)</td><td style="padding:8px; text-align:center;">Cline + Roo Code (free)</td><td style="padding:8px; text-align:center;">Cline + Roo Code (free)</td></tr>
      <tr><td style="padding:8px;"><strong>Inline Completion</strong></td><td style="padding:8px; text-align:center;">GitHub Copilot Free<br><small>50 premium req/mo</small></td><td style="padding:8px; text-align:center; color:#fbbf24;">GitHub Copilot Pro ($10)<br><small>300 premium req/mo</small></td><td style="padding:8px; text-align:center; color:#fbbf24;">GitHub Copilot Pro ($10)<br><small>or Free tier</small></td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Builder (API)</strong></td><td style="padding:8px; text-align:center;">DeepSeek<br><small>5M free tokens starter</small></td><td style="padding:8px; text-align:center;">DeepSeek API<br><small>~$0 with cache-hit</small></td><td style="padding:8px; text-align:center;">DeepSeek API<br><small>~$5/mo</small></td></tr>
      <tr><td style="padding:8px;"><strong>Architect (API)</strong></td><td style="padding:8px; text-align:center;">Gemini Flash<br><small>(AI Studio free tier)</small></td><td style="padding:8px; text-align:center;">Gemini Flash<br><small>(AI Studio free tier)</small></td><td style="padding:8px; text-align:center; color:#fbbf24;">Claude Sonnet 4.6 API<br><small>~$5/mo (10% of tasks)</small></td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong>Gemini CLI + Jules</strong></td><td style="padding:8px; text-align:center; color:#f87171;">❌</td><td style="padding:8px; text-align:center; color:#f87171;">❌</td><td style="padding:8px; text-align:center; color:#4ade80;">Google AI Pro ($19.99)<br><small>+ 2TB Drive</small></td></tr>
      <tr><td style="padding:8px;"><strong>Terminal AI Agent</strong></td><td style="padding:8px; text-align:center;">OpenCode (free)</td><td style="padding:8px; text-align:center;">OpenCode (free)</td><td style="padding:8px; text-align:center;">Gemini CLI (via AI Pro)</td></tr>
      <tr style="background:rgba(59,130,246,0.1); font-weight:bold;"><td style="padding:8px;"><strong>Total</strong></td><td style="padding:8px; text-align:center; color:#4ade80;"><strong>$0</strong><br><small>Start with DeepSeek free credits</small></td><td style="padding:8px; text-align:center; color:#93c5fd;"><strong>~$10</strong><br><small>Copilot Pro only</small></td><td style="padding:8px; text-align:center; color:#fbbf24;"><strong>~$30</strong><br><small>Best ROI in 2026</small></td></tr>
    </tbody>
  </table>
</div>

> **چرا Professional با قیمت 30 دلار از توصیه اولیه 46 دلاری (28 دلار Copilot+Cline + 18 دلار Warp) عبور می کند:** جایگزین کردن Warp 20 دلاری با Ghostty (رایگان) + Google AI Pro (19.99 دلار) باعث صرفه جویی در هزینه می شود و در عین حال دسترسی Gemini 3.1 Pro، Jules async agent TB و 2 را نیز اضافه می کند. Cline همیشه رایگان است — بدون هزینه ماهانه برای خود افزونه، فقط مصرف توکن API.

### 8.2. مقایسه سناریو (A-D)

برای کاربرانی که می‌خواهند مبادلات را با یک لنز متفاوت ارزیابی کنند - هزینه در مقابل پوشش در چهار سناریو:

<div style="overflow-x:auto; border-radius:12px; border:1px solid rgba(255,255,255,0.1); margin-bottom:16px;">
  <table style="width:100%; border-collapse:collapse; font-size:11px; color:#dde0f2; min-width:700px;">
    <thead>
      <tr style="background:rgba(255,255,255,0.05);">
        <th style="padding:10px; text-align:left;">Scenario</th>
        <th style="padding:10px; text-align:center;">Cost/mo</th>
        <th style="padding:10px; text-align:center;">Cline API</th>
        <th style="padding:10px; text-align:center;">Inline (VS Code)</th>
        <th style="padding:10px; text-align:center;">Terminal AI</th>
        <th style="padding:10px; text-align:center;">Async Agent</th>
      </tr>
    </thead>
    <tbody>
      <tr><td style="padding:8px;"><strong style="color:#4ade80">A: API only</strong></td><td style="padding:8px; text-align:center; color:#4ade80;">$10</td><td style="padding:8px; text-align:center;">✅ DS+Claude</td><td style="padding:8px; text-align:center; color:#f87171;">❌</td><td style="padding:8px; text-align:center;">✅ Gemini CLI (free)</td><td style="padding:8px; text-align:center;">✅ Jules (beta free)</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong style="color:#fbbf24">B: API + Copilot Pro</strong></td><td style="padding:8px; text-align:center; color:#fbbf24;">$20</td><td style="padding:8px; text-align:center;">✅ DS+Claude</td><td style="padding:8px; text-align:center;">✅ 300 req/mo</td><td style="padding:8px; text-align:center;">✅ Gemini CLI</td><td style="padding:8px; text-align:center;">✅ Jules (beta)</td></tr>
      <tr><td style="padding:8px;"><strong style="color:#b0a3ff">C: API + Google AI Pro ⭐</strong></td><td style="padding:8px; text-align:center; color:#b0a3ff;">$30</td><td style="padding:8px; text-align:center;">✅ DS+Claude</td><td style="padding:8px; text-align:center;">✅ Code Assist</td><td style="padding:8px; text-align:center;">✅ Gemini CLI (higher limit)</td><td style="padding:8px; text-align:center;">✅ Jules + higher limit</td></tr>
      <tr style="background:rgba(255,255,255,0.02);"><td style="padding:8px;"><strong style="color:#93c5fd">D: API + Copilot Pro + Google</strong></td><td style="padding:8px; text-align:center;">$40</td><td style="padding:8px; text-align:center;">✅ DS+Claude</td><td style="padding:8px; text-align:center;">✅ Best (both)</td><td style="padding:8px; text-align:center;">✅ Gemini CLI max</td><td style="padding:8px; text-align:center;">✅ Jules max</td></tr>
    </tbody>
  </table>
</div>

> **توصیه:** برای نقطه ورود متعادل با سناریوی B شروع کنید. اگر به هوش مصنوعی ترمینال و وظایف جولز ناهمگام اهمیت می دهید، آن را به C ارتقا دهید. D فقط در صورتی توجیه می شود که به 300 درخواست درونی Copilot Pro در ماه و ادغام کامل اکوسیستم Google به طور همزمان نیاز داشته باشید.

### 8.3. تنظیم رتبه بندی بر اساس اولویت

**اگر بودجه اولویت است (بهترین بازگشت سرمایه):**

| رتبه | راه اندازی | هزینه/ماه | ارزش | کیفیت | سادگی |
|---|---|---|---|---|---|
| 🥇 | DeepSeek + Claude API مستقیم + VS Code+Cline | 8 تا 12 دلار | 98 | 86 | 60 |
| 🥈 | **Google AI Pro + Copilot Pro** *(تنظیمات شما)* | 29.99 دلار | 83 | 78 | 92 |
| 🥉 | Google AI Pro + Claude API مستقیم (بدون Copilot) | 26 تا 30 دلار | 80 | 82 | 80 |
| 4 | فقط Google AI Pro (بدون Copilot، بدون Claude API) | 19.99 دلار | 74 | 65 | 96 |
| 5 | ردیف رایگان (هدیه DeepSeek + فلش جمینی) | 0 دلار | 68 | 50 | — |

**اگر کیفیت کد در اولویت است:**

| رتبه | راه اندازی | هزینه/ماه | کیفیت | ارزش |
|---|---|---|---|---|
| 🏆 | سه مدل + روتر (DeepSeek + MiniMax + Claude API) | 15 تا 22 دلار | 93 | 88 |
| 🥈 | Google AI Pro + Claude API مستقیم + VS Code+Cline | 27-33 دلار | 88 | 78 |
| 🥉 | **Google AI Pro + Copilot Pro** *(تنظیمات شما)* | 29.99 دلار | 79 | 83 |

> **برای راه‌اندازی شما (AI Pro + Copilot Pro):** Copilot را در حالت **Auto** نگه دارید - به طور خودکار GPT-4.1 یا GPT-5-mini (هر دو نامحدود/رایگان) را انتخاب می‌کند و درخواست‌های ممتاز را خرج نمی‌کند. تنها زمانی که واقعاً به معماری، بررسی امنیتی یا وضوح بن بست منطقی نیاز دارید، به صورت دستی به **Claude Sonnet 4.6** بروید. به این ترتیب 300 درخواست در طول یک ماه طول می کشد - و اگر تمام شود، GPT-5-mini (رایگان، هنوز هم قوی) به طور خودکار کنترل می شود.

---

## 🔌 9. MCP Infrastructure & Recommended Extensions

- **Ollama:** برای جاسازی محلی و استفاده از مدل "کوچک" بدون هزینه.
- **سرورهای MCP (پروتکل زمینه مدل):**

  ** هسته (جهانی):**
    - `filesystem`: ناوبری عمیق و دستکاری سیستم فایل را فعال می کند.
    - `github`: به نماینده اختیار می دهد تا مسائل و روابط عمومی را مدیریت کند.
    - `brave-search`: برای واکشی اسناد 2026، دسترسی مستقیم به اینترنت را در اختیار نماینده قرار می دهد.

  **توسعه پایتون (توصیه می شود):**
    - `mcp-sqlite`: جستجوی مستقیم پایگاه داده و بازرسی طرحواره.
    - `mcp-docker`: مدیریت کانتینر از درون عامل.
    - `mcp-pytest`: اجرای آزمایشی توسط عامل برای حلقه‌های TDD مستقل.
    - `mcp-python-interpreter`: اجرای ایمن Python در جعبه ایمنی برای اعتبارسنجی پیش فایل قبل از نوشتن روی دیسک.

### پیکربندی Cline MCP (JSON)

سرورهای MCP را از طریق **VS Code → `Ctrl+Shift+P` → "Cline: Open MCP Settings"** اضافه کنید. بلوک مربوطه را در پیکربندی JSON قرار دهید:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_YOUR_TOKEN" }
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": { "BRAVE_API_KEY": "YOUR_BRAVE_KEY" }
    },
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "--db-path", "./data.db"]
    },
    "docker": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-docker"]
    }
  }
}
```

> **ترتیب اولویت برای پروژه های پایتون:** `filesystem` (توکار، بدون نیاز به پیکربندی) → `github` → `brave-search` → `sqlite` → `docker`. فقط آنچه را که به طور فعال به آن نیاز دارید اضافه کنید - هر سرور MCP تاخیری را به تماس های ابزار اضافه می کند.

---

## 💳 10. داشبورد هزینه و مدیریت هزینه

- **نظارت BYOK:** در صورت استفاده از BYOK (مانند Cline)، مصرف روزانه را از طریق داشبورد **OpenRouter** یا **DeepSeek** نظارت کنید.
- **محدودیت های سخت:** سقف هزینه های روزانه را برای جلوگیری از هزینه های فرار در حین باگ های حلقه بی نهایت تنظیم کنید.

### آستانه هشدار محافظه کارانه (براساس تجربه میدانی)

| آستانه | مقدار | اقدام |
|---|---|---|
| هشدار نرم روزانه | **1.00 دلار در روز** | بررسی کنید کدام کار مصرف می‌کند — دستور را اصلاح کنید یا به مدل ارزان‌تر تغییر دهید |
| بررسی هفتگی | **5.00 دلار در هفته** | بررسی مسیریابی وظایف - آیا از کلود برای کارهای بی اهمیت بیش از حد استفاده می کنید؟ |
| ماهانه **ایست سخت** | **25.00 دلار در ماه** | مکث همه تماس‌های API - مرور و بازنشانی. ساخت در یک بافر 5 دلاری (توقف در 25 دلار، هدف سقف 30 دلار است) |

> **چرا 1 دلار در روز و نه 5 دلار؟ ** بیشتر روزها باید 0.50-0.80 دلار هزینه داشته باشند. اگر $1 را بزنید، مشکلی وجود دارد (به عنوان مثال، حلقه زدن Cline، عدم تطابق مدل). زودهنگام گرفتن آن باعث صرفه جویی 10 تا 20 دلاری قبل از پایان ماه می شود.

### ⚠️ 5 قاتل برتر بودجه (به ترتیب فراوانی)

1. **حلقه امتحان مجدد Cline** - کار به دیوار برخورد می کند، بیش از 10 بار تکرار می کند، قبل از اینکه متوجه شوید 3 دلار هزینه دارد. رفع: `"max 20 requests per task"` را به `.clinerules` اضافه کنید.
2. **استفاده از Claude برای کارهای بی اهمیت** - پرده زدن، ویرایش های پیکربندی، اصلاحات کوچک نیازی به ورودی 15 دلاری در میلیون دلار ندارند. از DeepSeek (0.27 دلار در میلیون دلار) استفاده کنید.
3. **زمینه پایگاه کد بزرگ** - در هر درخواست، کل `src/` را در متن قرار دهید. رفع: از `@file` به صورت انتخابی استفاده کنید، نه `@folder`.
4. **تکرار اعلان های یکسان ** - کش بعد از 5 دقیقه عدم فعالیت زده نمی شود. دستورات را از نظر ساختاری مشابه نگه دارید.
5. **فراموش کردن بستن Cline** - نظرسنجی پس‌زمینه MCP یا اتصالات بی‌حرکت می‌تواند 1 تا 2 دلار در روز اضافه کند.

### ✅ 5 روش برتر برای صرفه جویی در پول

1. مسیر: **DeepSeek** برای تست ها/پیکربندی → **MiniMax** برای ویژگی ها → **Claude** فقط برای معماری.
2. در تنظیمات Cline **Cache Prompt** را فعال کنید (60 تا 90٪ در هزینه های ورودی کلود صرفه جویی می کند).
3. از `GEMINI.md` + Gemini CLI برای پرسش و پاسخ سریع — کاملاً رایگان (فلش 1000 روز در روز) استفاده کنید.
4. **Jules** را برای آزمایش‌ها، اسناد و رفع اشکالات جزئی اختصاص دهید — در طول بتا رایگان.
5. از **OpenRouter** به عنوان پل استفاده کنید — یک کلید API، بیش از 50 مدل، به راحتی قابل تعویض در زمانی که یک مدل گران یا پایین است.

---

## 💳 اسکریپت نظارت بر هزینه 10.1 (`cost_monitor.py`)

این اسکریپت را در `memory-bank/cost_monitor.py` ذخیره کنید. `memory-bank/costLog.json` را می‌خواند و یک هشدار بی‌درنگ بر اساس آستانه‌های بالا چاپ می‌کند.

```python
#!/usr/bin/env python3
"""
cost_monitor.py — Read memory-bank/costLog.json and alert on thresholds.
Usage: python memory-bank/cost_monitor.py
"""
import json
from datetime import datetime, timedelta
from pathlib import Path

COST_LOG = Path("memory-bank/costLog.json")
THRESHOLDS = {"daily": 1.0, "weekly": 5.0, "monthly": 25.0}


def load_entries():
    if not COST_LOG.exists():
        print("⚠️  costLog.json not found. Create it first.")
        return []
    with COST_LOG.open() as f:
        return json.load(f)  # List of {"date": "YYYY-MM-DD", "cost": 0.45, "task": "..."}


def summarise(entries):
    now = datetime.today().date()
    today_total = sum(e["cost"] for e in entries if e["date"] == str(now))
    week_start = now - timedelta(days=now.weekday())
    week_total = sum(e["cost"] for e in entries if e["date"] >= str(week_start))
    month_start = now.replace(day=1)
    month_total = sum(e["cost"] for e in entries if e["date"] >= str(month_start))
    return today_total, week_total, month_total


def alert(label, total, limit):
    icon = "✅" if total < limit * 0.7 else ("⚠️ " if total < limit else "🚨 STOP")
    print(f"  {icon}  {label:10s}  ${total:.2f}  /  ${limit:.2f}")


if __name__ == "__main__":
    entries = load_entries()
    d, w, m = summarise(entries)
    print(f"\n=== Cost Monitor ({datetime.today():%Y-%m-%d %H:%M}) ===")
    alert("Daily", d, THRESHOLDS["daily"])
    alert("Weekly", w, THRESHOLDS["weekly"])
    alert("Monthly", m, THRESHOLDS["monthly"])
    print()
    if m >= THRESHOLDS["monthly"]:
        print("🚨  HARD STOP: Monthly budget exhausted. Pause all API calls.\n")
```

قالب **`memory-bank/costLog.json`** (یک ورودی به هر کار اضافه کنید):
```json
[
  {"date": "2026-03-11", "cost": 0.45, "task": "refactor auth module"},
  {"date": "2026-03-11", "cost": 0.12, "task": "write tests for router"},
  {"date": "2026-03-12", "cost": 0.08, "task": "fix lint errors"}
]
```

اجرا بعد از هر جلسه: `python memory-bank/cost_monitor.py`

---

## 📂 11. چارچوب مدیریت دانش و اتوماسیون (ساختار مکان نما)

برای تبدیل یک ویرایشگر استاندارد به **سیستم عامل کدگذاری عاملی**، استفاده از ساختار دایرکتوری `.cursor` الزامی است. این چارچوب به عامل اجازه می دهد تا "مقررات پروژه" و "استانداردهای تیم" را فراتر از کد فوری درک کند.  

### اجزای کلیدی و کاربرد عملی:  

1. **`.cursor/rules/` (فایل های mdc. - قانون اساسی):**  
   - **نقش:** استانداردهای پروژه غیرقابل مذاکره و هویت هوش مصنوعی را تعریف می کند.  
   - **مثال:**  
     - "**بدون هاردکد:** همه متغیرها و گزینه های پیش فرض باید در `config.yaml` ذخیره شوند. برای راحتی کاربر نهایی، کد برنامه باید از این فایل خوانده شود."  
     - "همیشه از `uv` برای پروژه های پایتون (برای نصب بسته و مدیریت محیط مجازی) استفاده کنید."  
     - "هر پروژه باید دقیقاً یک نقطه ورود `main.py` داشته باشد."  
   - ** مزیت: ** عامل تضمین می کند که پیکربندی ها هرگز در کد منبع قرار نمی گیرند و برنامه شما را به یک محصول حرفه ای و قابل تنظیم تبدیل می کند.  

2. **`skills/` (کپسول های دانش):**  
   - **نقش:** تجربیات را برای استفاده مجدد در آینده مستند می کند (گرفتن دانش).  
  - **مثال دنیای واقعی:** مهارت های پشتیبانی، تکنیک های قابل استفاده مجدد را به تصویر می کشد، در حالی که این راهنمای شاخص، استراتژی انتخاب مدل مرجع و بهینه سازی هزینه را تعریف می کند.  
   - ** مزیت: ** از "اختراع مجدد چرخ" جلوگیری می کند. عامل درس هایی را از وظایف گذشته به کارهای جدید اعمال می کند.  

3. **`workflows/` (نقشه راه های عملیاتی):**  
   - **نقش:** توالی های گام به گام را برای فرآیندهای حساس تعریف می کند.  
   - **نمونه های دنیای واقعی:**  
     - **`init-project.md`:** به طور خودکار دایرکتوری های `.env.example`، `src/`، و `docs/` را ایجاد می کند.  
     - **`quality-assurance.md`:** اجرای آزمایش ها و گرفتن تایید نهایی کاربر را قبل از `git commit` اجباری می کند.  
     - **`documentation.md`:** به طور خودکار `CHANGELOG.md` را پس از هر تغییر مهم به روز می کند.  
   - ** مزیت: ** خطای انسانی در کارهای تکراری را از بین می برد و خروجی با کیفیت بالا را تضمین می کند.  

4. **`prompts/` (کتابخانه دستورالعمل سطح بالا):**
   - **نقش:** Mega-Prompts را که برای کارهای تکراری و در عین حال حساس طراحی شده اند را ذخیره می کند.

5. **`mcp/` (ادغام ابزار خارجی):**
   - **نقش:** پروتکل برای اتصال به ابزارهای خارجی (پایگاه های داده، مرورگرها، ابزارهای تجزیه و تحلیل کد).

---

### 11.2 الگوهای فایل قانون `.cursor` را کامل کنید

اینها محتویات فایل آماده تولید هستند. آنها را کلمه به کلمه در فهرست `.cursor/rules/` پروژه خود کپی کنید. برای VS Code + Cline: آنها را در `.cursor/rules/` قرار دهید و همچنین یک فایل `.clinerules` را در ریشه پروژه ایجاد کنید (به زیر مراجعه کنید).

**`.cursor/rules/000-core.mdc`** — قوانین اصلی همیشه فعال (کنترل هزینه، استانداردهای پروژه):
```
---
description: Core project rules — always applied
alwaysApply: true
---

# Core Rules

## Cost Control (CRITICAL for 24/7)
- Before any large task, declare complexity: TRIVIAL / MODERATE / CRITICAL
- TRIVIAL: write code with no extra explanation (fewer tokens)
- If unclear what to do: STOP and ask ONE question, not 10
- Never edit more than 20 files in one session without confirmation
- One task = one commit. Get approval before moving to the next task

## Response Format (token efficiency)
- Start responses with code, not explanation
- Use format: "✅ done" / "❌ blocked: [reason]" / "❓ need: [question]"
- Never re-explain code that was already covered

## Project Standards
- Language: Python 3.12+
- Package manager: uv only (never pip directly)
- Entry point: main.py at project root
- Config: only from config.yaml or .env (no hardcoding)
- All variables in config.yaml — never hard-code values in source

## On Error
- Read the error first, then diagnose
- If unresolved after 3 attempts: report and wait for approval
- Never add dependencies without confirmation
```

---

**`.cursor/rules/010-python.mdc`** - استانداردهای کدنویسی پایتون:
```
---
description: Python coding standards
alwaysApply: true
---

# Python Standards

## Tools (only these)
- Package manager: uv sync / uv add / uv run
- Formatter: ruff format
- Linter: ruff check --fix
- Type checker: mypy with strict mode
- Tests: pytest with coverage

## Code
- Functions max 20 lines — split if longer
- Type hints required on all public functions
- Docstrings required for public functions (one line is enough)
- Error handling: never bare except:
- Logging instead of print in production code

## File Structure
src/
├── core/      # core logic
├── api/       # API endpoints
├── models/    # data models
└── utils/     # helper functions

## After Every Change
uv run ruff check --fix . && uv run mypy src/
```

---

**`.cursor/rules/020-tdd.mdc`** — قوانین TDD:
```
---
description: Test-Driven Development — mandatory rules
alwaysApply: true
---

# TDD Rules

## Mandatory Order (never skip)
1. Write a test that FAILS first
2. Write the minimum code needed to make the test pass
3. Refactor (if needed)
4. Run uv run pytest — all tests must pass

## Test Rules
- File name: test_[module_name].py in tests/
- Function name: test_[state]_[expected_behaviour]()
- Each test checks exactly one thing (Single Responsibility)
- Use fixtures for repeated setup

## Coverage
- Minimum 80% coverage to merge to main
- uv run pytest --cov=src --cov-report=term-missing

## Forbidden
- Never write implementation before test
- Never skip a test without documented reason
- Never leave pass in a test body
```

---

**`.cursor/rules/030-security.mdc`** — امنیت و مدیریت مخفی:
```
---
description: Mandatory security rules
alwaysApply: true
---

# Security Rules

## NEVER
- Never write any API key, password, or token directly in code
- Never add .env to git (must be in .gitignore)
- Never put any secret in logs
- Never use eval() or exec() with user input
- Never build SQL queries with f-strings (SQL injection)

## Correct Pattern for Secrets
```python
واردات سیستم عامل
از واردات dotenv load_dotenv

load_dotenv()
API_KEY = os.getenv("DEEPSEEK_API_KEY") # ✅ صحیح
API_KEY = "sk-1234..." # ❌ FORBIDDEN
```

## Before Every Commit
- git diff --staged | grep -i "api_key\|secret\|password\|token"
- If any result: STOP and report immediately
```

---

**`.cursor/rules/040-git.mdc`** — قوانین Git & commit:
```
---
description: Git and commit rules
alwaysApply: true
---

# Git Rules

## Golden Rule
One task = one commit = one feature branch

## Commit Message Format
[type]: [short description]

Allowed types:
- feat:      new feature
- fix:       bug fix
- test:      add/change tests
- refactor:  code change without behaviour change
- docs:      documentation change
- chore:     maintenance work

## Before Commit
1. uv run ruff check --fix .   — fix lint issues
2. uv run pytest               — all tests must pass
3. Check for secrets: no API key in staged files
4. Then: git commit -m "[type]: [description]"

## Forbidden
- Direct commit to main
- Large commits with many unrelated changes
- Commit messages like "fix", "update", "changes"
```

---

**`memory-bank/activeContext.md`** - حافظه جلسه فعال (هر جلسه را به روز کنید):
```markdown
---
last_updated: [date and time]
active_model: DeepSeek V3.2
cost_today: $X.XX
---

# Current State

## What are we working on now?
[Short description of current task]

## Last completed action
[Summary of last changes]

## Files related to current task
- `src/[file].py` — [why it's relevant]

## Open issues (if any)
- [ ] [issue 1]

## For next session
[What work remains]
```

---

**`memory-bank/costLog.md`** - ردیابی هزینه (بعد از هر جلسه به روز رسانی):
```markdown
---
goal: monthly cost under $30
alert_at: $5 daily / $20 weekly
---

# Cost Log

## [Month/Year]
| Date | Model | Tokens | Cost | Task |
|------|-------|--------|------|------|
| Feb 20 | DeepSeek | 50K | $0.02 | setup |

## This month total: $XX.XX

## Alert Rules
- If one session cost > $2 → report
- If daily total > $5 → STOP and investigate
- Infinite loops are the biggest budget threat
```

---

**`.clinerules`** — قوانین خاص کلاین برای VS Code (محل در ریشه پروژه):
```markdown
# Cline Rules — VS Code

## Model Routing
- TRIVIAL tasks: DeepSeek V3.2 (direct API)
- MODERATE tasks: MiniMax M2.5
- CRITICAL tasks: Claude Sonnet 4.6

## Cost Control
- Max 20 requests per task — after that stop and report
- If task costs > $2 → STOP and notify
- Keep system prompt constant (better cache-hit rate)

## Behaviour
- Read memory-bank/ files before every task
- Read file contents before editing any file
- Never delete files without confirmation
- Never write secrets in code

## After Every Task
- Update memory-bank/activeContext.md
- Run ruff check --fix . && pytest
- Summarise result in one line
```

**تنظیمات Cline API** — پیکربندی در نوار کناری Cline → تنظیمات (⚙️):
```bash
# ── Model 1: DeepSeek (default — cheapest) ──
Provider:  OpenAI Compatible
Base URL:  https://api.deepseek.com
API Key:   $DEEPSEEK_API_KEY
Model:     deepseek-chat

# ── Model 2: MiniMax ──
Provider:  OpenAI Compatible
Base URL:  https://api.minimax.chat/v1
API Key:   $MINIMAX_API_KEY
Model:     minimax-m2.5

# ── Model 3: Claude Sonnet ──
Provider:  Anthropic
API Key:   $ANTHROPIC_API_KEY
Model:     claude-sonnet-4-5-20251001

# ── Alternative: All models via OpenRouter (one API key, no VPN) ──
Provider:  OpenRouter
API Key:   $OPENROUTER_API_KEY
Models:    deepseek/deepseek-v3.2
           minimax/minimax-m2.5
           anthropic/claude-sonnet-4-5
```

---

**`GEMINI.md`** — فایل زمینه برای Gemini CLI (محل در **ریشه پروژه**). Gemini CLI این فایل را به طور خودکار در شروع هر جلسه می خواند، درست مثل جولز که `AGENTS.md` را می خواند.
```markdown
# GEMINI.md — Project Context for Gemini CLI

## Project
Python 3.12 · package manager: uv · test runner: pytest · linter: ruff

## Rules
- Never use pip directly — always use `uv add` or `uv run`
- Every code change must have a corresponding test
- Never write API keys or secrets in code — use `.env` and `python-dotenv`
- Commit format: `type: short description` (feat/fix/refactor/test/docs)

## Structure
| Directory | Purpose |
|---|---|
| `src/` | Core application code |
| `tests/` | Unit and integration tests |
| `memory-bank/` | Agent context: activeContext.md, costLog.json |
| `.cursor/rules/` | Project constitution (.mdc files) |
| `.agent/skills/` | Knowledge capsules for AI agents |

## Model Routing (for reference)
- Trivial (tests, config): DeepSeek V3.2
- Moderate (features, refactor): MiniMax M2.5
- Critical (architecture, security): Claude Sonnet
- Quick Q&A: Gemini CLI (you are here)
- Async background tasks: Jules
```

> **چگونه `GEMINI.md` را به پروژه خود اضافه کنید:**
> ``باش
> # ایجاد در ریشه پروژه (همان سطح AGENTS.md و clinerules.)
> GEMINI.md را لمس کنید
> # با الگوی بالا ویرایش کنید - به ساختار پروژه واقعی خود سفارشی کنید
> ```
> Gemini CLI آن را به طور خودکار و بدون نیاز به پیکربندی انتخاب می کند.

---

**`Dual-IDE File Structure`** — چگونه از Antigravity و VS Code+Cline به طور همزمان پشتیبانی کنیم:
```
project/
│
├── ── Antigravity ──────────────────────────────────────
├── .agent/                    ← Antigravity reads this
│   ├── skills/
│   │   ├── core.md            ← Core rules + cost control (alwaysApply: true)
│   │   ├── python.md          ← Python standards
│   │   ├── tdd.md             ← TDD rules
│   │   └── router-guide.md   ← How to use router.py from Antigravity
│   └── workflows/
│       ├── daily-start.md     ← Session start checklist
│       └── before-commit.md   ← Pre-commit checklist
│
├── ── VS Code + Cline ──────────────────────────────────
├── .clinerules                ← Cline reads this
│
├── ── Shared by all agents ─────────────────────────────
├── GEMINI.md                  ← Gemini CLI context
├── AGENTS.md                  ← Jules context
│
├── memory-bank/               ← Shared memory for both IDEs
│   ├── activeContext.md
│   ├── progress.md
│   └── costLog.json           ← Per-day per-provider cost log
│
├── src/
│   └── utils/
│       ├── router.py          ← Smart router (§6.6)
│       └── __init__.py
│
├── .env                       ← API keys — in .gitignore!
├── .env.example               ← Template without values — commit this
└── pyproject.toml
```

---

**`.agent/skills/core.md`** — فایل قوانین اصلی برای Antigravity (محل در `.agent/skills/`):
```markdown
---
name: core
description: Core rules — always apply
alwaysApply: true
---

## Cost Control (CRITICAL)
- Declare complexity before every task: TRIVIAL / MODERATE / CRITICAL
- TRIVIAL → DeepSeek (cheapest) | MODERATE → MiniMax M2.5 | CRITICAL → Claude Sonnet 4.6
- Maximum 20 requests per task — then STOP and report
- If unsure: ask one question, not ten

## Tools
- Package manager: always uv (never pip directly)
- Formatter: ruff format
- Type checker: mypy
- Test runner: pytest

## Mandatory Rules
- Never write API keys in code — always use .env
- One task = one commit
- Before every task: read memory-bank/activeContext.md
- After every task: update activeContext.md
- Commit format: feat: / fix: / test: / refactor: / docs:
```

---

**`.agent/skills/router-guide.md`** — نحوه استفاده از `router.py` از داخل Antigravity:
```markdown
---
name: router-guide
description: Guide to using router.py for non-Gemini models
---

## Problem
Antigravity only has Gemini 3 Pro built-in. To access DeepSeek
or Claude Sonnet you must use router.py.

## Solution A — Direct Code Usage
```python
از روتر واردات src.utils.router
واردات asyncio

result = asyncio.run(router.generate("سؤال یا وظیفه شما در اینجا"))
```

## Solution B — Delegate to VS Code+Cline
When a task requires DeepSeek/Claude, tell the user:
"This task requires [DeepSeek/Claude]. Please switch to VS Code+Cline."

## When VS Code+Cline is Required
- Tasks for DeepSeek (cheaper than Gemini at scale) → TRIVIAL + high-frequency
- Final security code review with Claude Sonnet → CRITICAL
- Long sessions where Antigravity hits rate limits
```

---

### 11.1 تکنیک های عملیاتی پیشرفته

**مهندسی سریع برای Cline (الگوی وضعیت وظیفه):**
هر کار را با یک بلوک بافت ساختاری شروع کنید تا عامل وضعیت آن را بداند:
```
Goal: [one-sentence objective]
Current state: [what already exists]
Constraints: [must-not-do list]
Expected output: [exact file / function / test]
```
این الگو 80 درصد از چرخه های بازسازی ناشی از وظایف مبهم را حذف می کند.

---

**Git Flow + گردش کار Agentic:**
نظم و انضباط توصیه شده در سطح شعبه برای پروژه های با کمک عامل:
1. `git checkout -b feat/<task-name>` - هر وظیفه عامل را در شاخه خودش جدا کنید.
2. عامل اجرا می کند: کد → تست → حلقه تعهد (با گردش کار `quality-assurance.md` راه اندازی می شود).
3. `gh pr create` - روابط عمومی باز برای بررسی انسانی؛ عامل نمی تواند خود ادغام شود.
4. ادغام فقط پس از تایید CI و تایید انسانی.

> قانون: نمایندگان هرگز نباید مستقیماً به `main`** فشار وارد کنند. همیشه شاخه → PR → ادغام.

**جریان کاری async جولز (موازی با Cline):**
```bash
# While you work in VS Code + Cline on the main feature,
# assign background tasks to Jules:
git checkout -b feat/main-feature
# ... Cline works here ...

# Jules handles background tasks in parallel:
# Option A: via GitHub issue with label 'jules'
gh issue create --title "Write tests for auth module" --label jules

# Option B: via jules.google UI
# jules remote new --repo . --session "Update all dependencies and run tests"

# Jules opens a PR when done; you review and merge
gh pr list  # see Jules's PR when ready
```

---

** فشرده سازی زمینه (70٪ کاهش هزینه):**
پنجره های زمینه بزرگ، محرک هزینه شماره 1 در جلسات طولانی هستند. از این تکنیک ها استفاده کنید:

- دستور **`/compact` (Claude Code):** `/compact` را در اواسط جلسه اجرا کنید - کلود مکالمه کامل را در حالت فشرده خلاصه می کند و در عین حال متن بحرانی را حفظ می کند. این سریعترین راه برای نصف کردن هزینه توکن در یک جلسه طولانی است.
- **الگوی بانک حافظه:** تصمیمات کلیدی را در `memory-bank/activeContext.md` ذخیره کنید. به جای پخش مجدد تاریخچه کامل، آن را به هر جلسه جدید اضافه کنید.
- **خلاصه های ساختاریافته:** قبل از بستن Cline، بپرسید: *"خلاصه ای 10 خطی از وضعیت فعلی پروژه برای جلسه بعدی بنویسید"*. نتیجه را در `memory-bank/activeContext.md` ذخیره کنید.
- **ارجاع فایل بر روی محتوا:** به جای چسباندن فایل کامل، `path/to/file.py:42-60` را بفرستید — عامل فقط برش مربوطه را می خواند.
- **بارگذاری تنبل:** فایل‌ها را فقط زمانی پیوست کنید که نماینده صریحاً به آنها نیاز داشته باشد، نه پیشگیرانه.
- **Repomap برای پروژه های بزرگ:** درخت را ارسال کنید نه کد:
```bash
tree -I '__pycache__|*.pyc|.venv|node_modules' --noreport | head -50
```
این به عامل می گوید که کدام فایل ها بدون خواندن همه آنها وجود دارند.
- ** DeepSeek Cache-Hit (10× ارزانتر):** DeepSeek 0.028 دلار در میلیون توکن برای cache-hit در مقابل $0.28/M برای cache-miss هزینه می کند. سیستم خود را در تمام درخواست‌ها **یکسان** نگه دارید - هر تغییری حافظه پنهان را باطل می‌کند و 10× بیشتر هزینه دارد. اعلان سیستم خود را به عنوان یک ثابت در پیکربندی روتر خود ذخیره کنید.

---

** الگوی زنجیره ای - پیش نویس → اصلاح (60 تا 70٪ کاهش هزینه در کلود):**
به‌جای ارسال متن کامل پروژه به کلود، ابتدا پیش‌نویس DeepSeek را ارزان‌تر بگذارید، سپس *فقط پیش‌نویس* را برای اصلاح به کلود ارسال کنید. کلود یک ورودی کوچک (دستورالعمل های پیش نویس + اصلاح) دریافت می کند به جای اینکه کل پایگاه کد را دوباره بخواند:

```python
async def draft_then_refine(task_prompt: str) -> str:
    # Step 1: DeepSeek drafts cheaply (~$0.01)
    draft = await router.generate(task_prompt, force_provider="deepseek")

    # Step 2: Claude refines with minimal context (not re-reading full codebase)
    refined = await router.generate(
        f"Improve this code for production quality — fix edge cases, add type hints, "
        f"ensure error handling follows project standards:\n\n{draft}",
        force_provider="claude"
    )
    return refined
```

**چرا این کار جواب می دهد:** کلود به جای متن کامل مخزن، فقط پیش نویس (چند صد نشانه) را می خواند. هر تماس Claude ~ 5× ارزانتر از درخواست از Claude برای اجرای از ابتدا بدون پیش نویس می شود.

**بهترین موارد استفاده:**
- اجرای ویژگی: DeepSeek 90% می نویسد → کلود بررسی و نهایی می کند
- Refactoring: DeepSeek restructures → Claude نامگذاری، اسناد و موارد لبه را بهبود می بخشد
- تولید آزمایش: DeepSeek اسکلت های آزمایشی ایجاد می کند → کلود موارد لبه و ادعاها را اضافه می کند

**از این الگو صرف نظر کنید برای:**
- بررسی‌های امنیتی (کلود برای یافتن آسیب‌پذیری‌ها به بستر کد کامل نیاز دارد)
- برنامه ریزی معماری (در اینجا زمینه کامل بیش از هزینه اهمیت دارد)

---

**زمانی که از Agent استفاده نکنید (به جای آن از Copilot درون خطی استفاده کنید):**

| وضعیت | انتخاب اشتباه | انتخاب درست |
|---|---|---|
| تکمیل خودکار تک خطی | نماینده (کلاین) | Copilot inline |
| تغییر نام یک متغیر | نماینده (کلاین) | Copilot inline / تغییر نام IDE |
| نوشتن یک رشته مستند | نماینده (کلاین) | Copilot Chat (Ctrl+I) |
| اشکال زدایی یک تابع 5 خطی | نماینده (کلاین) | Copilot inline |
| Refactor چند فایل (> 3 فایل) | Copilot inline | نماینده (کلاین) |
| راه اندازی یک پروژه جدید | Copilot inline | نماینده (کلاین) |

> اصل: **اگر کار دارای محدوده مشخص و محدود است و حالت ندارد - از درون خطی استفاده کنید. اگر به حافظه، پیمایش فایل یا منطق چند مرحله ای نیاز دارد - از یک عامل استفاده کنید.**

---

**مدیر بسته uv ​​(Deep-Dive):**
`uv` جایگزین مدرن برای `pip` + `venv` در پروژه های Python 2026 است.

```bash
# Setup
uv init my-project        # creates pyproject.toml + .venv automatically
uv sync                   # install all deps from pyproject.toml (lock-file aware)
uv add requests           # add a dependency (updates pyproject.toml + uv.lock)
uv add --dev pytest ruff  # add dev-only dependencies

# Execution (ALWAYS use uv run — never activate venv manually)
uv run python main.py
uv run pytest
uv run ruff check --fix .
uv run mypy src/
```

> **قانون از AGENTS.md:** از `uv` برای مدیریت تمام بسته ها استفاده کنید. هرگز مستقیماً با `pip` تماس نگیرید. هرگز محیط مجازی را به صورت دستی فعال نکنید — همیشه دستورات را با `uv run` پیشوند قرار دهید.

**توصیه `pyproject.toml` (کپی پیست آماده):**
```toml
[project]
name = "my-project"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = [
    "fastapi>=0.115",
    "pydantic>=2.0",
    "python-dotenv>=1.0",
]

[tool.uv]
dev-dependencies = ["pytest>=8", "pytest-cov", "ruff>=0.8", "mypy>=1.0"]

[tool.ruff]
line-length = 88
target-version = "py312"

[tool.mypy]
strict = true
python_version = "3.12"
```

---

**محدودیت نرخ و پسرفت نمایی:**
هنگام ایجاد حلقه‌های عامل مستقل، همیشه عقب‌نشینی را برای جلوگیری از رسیدن به محدودیت‌های نرخ API اجرا کنید. DeepSeek به ویژه در ساعات اوج مصرف به محدودیت‌های نرخ می‌رسد (UTC 14-20 زمانی که روز کاری چین همپوشانی دارد). روتر آماده تولید زیر از MiniMax M2.5 به‌عنوان یک رده متوسط ​​استفاده می‌کند:

```python
"""
api_router.py — production router with 3-tier fallback + circuit breaker
"""
import asyncio, os, time
from enum import Enum
from openai import AsyncOpenAI

class TaskLevel(Enum):
    TRIVIAL = 1    # DeepSeek V3.2
    MODERATE = 2   # MiniMax M2.5
    CRITICAL = 3   # Claude Sonnet 4.6

class APIRouter:
    def __init__(self):
        self.deepseek = AsyncOpenAI(
            api_key=os.getenv("DEEPSEEK_API_KEY"),
            base_url="https://api.deepseek.com"
        )
        self.minimax = AsyncOpenAI(
            api_key=os.getenv("MINIMAX_API_KEY"),
            base_url="https://api.minimax.chat/v1"
        )
        self.claude = AsyncOpenAI(
            api_key=os.getenv("ANTHROPIC_API_KEY"),
            base_url="https://api.anthropic.com/v1"
        )
        self._failures: dict = {}
        self._threshold = 3
        self._cooldown = 300  # 5 minutes

    def _is_available(self, provider: str) -> bool:
        """Circuit breaker: skip provider if 3 consecutive failures within cooldown."""
        if provider not in self._failures:
            return True
        fails, last_time = self._failures[provider]
        if fails >= self._threshold:
            if time.time() - last_time < self._cooldown:
                return False
            self._failures[provider] = (0, 0)  # reset after cooldown
        return True

    def _record_failure(self, provider: str) -> None:
        fails, _ = self._failures.get(provider, (0, 0))
        self._failures[provider] = (fails + 1, time.time())

    async def generate(self, prompt: str, level: TaskLevel = TaskLevel.TRIVIAL) -> str:
        chain = {
            TaskLevel.TRIVIAL:  [("deepseek", "deepseek-chat"),   ("minimax", "minimax-m2.5")],
            TaskLevel.MODERATE: [("minimax",  "minimax-m2.5"),    ("deepseek", "deepseek-chat")],
            TaskLevel.CRITICAL: [("claude",   "claude-sonnet-4-5-20251001"), ("minimax", "minimax-m2.5")],
        }
        for provider, model in chain[level]:
            if not self._is_available(provider):
                continue
            try:
                client = getattr(self, provider)
                resp = await client.chat.completions.create(
                    model=model,
                    messages=[{"role": "user", "content": prompt}],
                    max_tokens=4096,
                )
                return resp.choices[0].message.content
            except Exception as e:
                print(f"⚠️  {provider} failed: {e}")
                self._record_failure(provider)
        raise RuntimeError("All providers failed — check API keys and connectivity")

router = APIRouter()
```

`AIRouter` در بخش 6 (`.agent/skills/ai-router/ai_router.py`) ذخیره پاسخ SHA-256 را در بالای این الگو برای کاهش بیشتر هزینه اضافه می کند.

---

**تست عامل (رویکرد معیار "مجموعه طلایی"):**
برای تأیید کیفیت عامل پس از تعویض مدل یا تغییرات سریع، پسرفت نمی کند:
1. `tests/agent_golden/` را با 10 تا 20 دستور کار نماینده ایجاد کنید.
2. هر فایل: `task.md` (ورودی) + `expected_output.py` (خروجی مرجع).
3. عامل را در برابر هر وظیفه اجرا کنید. خروجی ها را با `difflib` یا LLM-as-judge مقایسه کنید.
4. پیگیری هزینه هر مجموعه طلایی در `memory-bank/costLog.md`.

> هدف: ** امتیاز مجموعه طلایی ≥ 90% ** قبل از هر تغییر مسیر تولید.

**اسکریپت محک مجموعه طلایی (آماده کپی پیست):**
```python
"""
benchmark_agent.py — test models against your personal golden set
Usage: uv run python benchmark_agent.py
"""
import asyncio
import time

GOLDEN_SET = [
    {
        "id": "trivial_1",
        "level": "TRIVIAL",
        "prompt": "Write a function that takes a list of numbers and returns their average",
        "must_contain": ["def", "return", "sum", "len"],
        "max_cost_usd": 0.01,
    },
    {
        "id": "moderate_1",
        "level": "MODERATE",
        "prompt": "Refactor this class to use @dataclass: class Point:\n    def __init__(self, x, y): self.x = x; self.y = y",
        "must_contain": ["@dataclass", "x:", "y:"],
        "max_cost_usd": 0.05,
    },
]

async def benchmark_model(router, model_tag: str) -> dict:
    results = []
    for task in GOLDEN_SET:
        start = time.time()
        from api_router import TaskLevel
        level = TaskLevel[task["level"]]
        response = await router.generate(task["prompt"], level)
        elapsed = time.time() - start
        passed = all(kw in response for kw in task["must_contain"])
        results.append({"id": task["id"], "passed": passed, "time": round(elapsed, 2)})

    score = sum(r["passed"] for r in results) / len(results) * 100
    print(f"\n{model_tag}: {score:.0f}% pass rate")
    for r in results:
        print(f"  {'\u2705' if r['passed'] else '\u274c'} {r['id']} ({r['time']}s)")
    return {"model": model_tag, "score": score, "results": results}

if __name__ == "__main__":
    from api_router import APIRouter
    asyncio.run(benchmark_model(APIRouter(), "DeepSeek-V3.2"))
```

---

## � 11.3 الگوهای بهینه سازی کم هزینه

پنج تکنیک مستقل برای کاهش هزینه‌های کدگذاری عاملی - هر کدام را می‌توان به‌صورت مستقل پیاده‌سازی کرد:

---

**1. DeepSeek V3.2 - تغییر حالت استدلال (در صورت تقاضا)**

DeepSeek Direct API به شما امکان می دهد استدلال را در هر درخواست روشن یا خاموش کنید. حالت استاندارد ارزان تر است:

```python
# Standard mode — routine tasks (~$0.25/M input)
{"model": "deepseek/deepseek-v3.2", "reasoning": {"enabled": False}}

# Reasoning mode — debugging and algorithmic tasks (~$0.40/M input, higher quality)
{"model": "deepseek/deepseek-v3.2", "reasoning": {"enabled": True}}

# Router rule: enable only when task contains debug/algorithm/complex keywords
```

** صرفه جویی: ** حالت استدلال 30-50٪ توکن های بیشتری مصرف می کند. خاموش نگه داشتن آن برای 70٪ از وظایف → ~ 15-20٪ کاهش هزینه متوسط.

---

**2. مدل محلی از طریق Ollama — هزینه صفر برای کارهای کوچک**

برای کارهای بی اهمیت (اشکال تک خطی، تغییر نام، رشته مستندات) از یک مدل محلی استفاده کنید و تماس API را به طور کامل حذف کنید:

```bash
# Install Ollama (macOS)
brew install ollama

# Qwen2.5-Coder 7B — best local coding model (4.7 GB download)
ollama pull qwen2.5-coder:7b

# DeepSeek R1 Distill Qwen 7B — for local math/reasoning (4.5 GB download)
ollama pull deepseek-r1:7b

# Configure in Cline:
# Provider: Ollama | Base URL: http://localhost:11434 | Model: qwen2.5-coder:7b
```

**⚙️ مورد نیاز سخت افزار:**

| مدل | رم مورد نیاز | VRAM (GPU) | سیلیکون سیب |
|---|---|---|---|
| **Qwen2.5-Coder 7B** | **8 گیگابایت** ⭐ | 6 گیگابایت VRAM | M1/M2 8 گیگابایت: ~25 توک در ثانیه |
| **DeepSeek R1 Distill 7B** | **8 گیگابایت** ⭐ | 6 گیگابایت VRAM | M1/M2 8 گیگابایت: ~20 توک در ثانیه |
| Qwen2.5-Coder 14B | 16 گیگابایت | 10 گیگابایت VRAM | M2 Pro 16 گیگابایت: ~30 توک در ثانیه |
| DeepSeek R1 Distill 32B | 32 گیگابایت | 24 گیگابایت VRAM | فقط M3 Max/Ultra |

> مدل‌های 7B در MacBook Air M1/M2 با 8 گیگابایت رم از شتاب GPU فلزی استفاده می‌کنند — بدون نیاز به GPU مجزا. مدل 14B به حداقل 16 گیگابایت رم نیاز دارد.

**بهترین موارد استفاده محلی:** تغییر نام متغیر، تابع قالب، رفع اشتباه تایپی، نوشتن رشته سند برای یک تابع

**به صورت محلی برای:** بازساز چند فایل، منطق تجاری پیچیده، تجزیه و تحلیل وابستگی استفاده نکنید

---

**3. درخواست دسته ای به جای رفت و برگشت**

هر تماس API سربار دارد. پنج سوال جداگانه = 5 تماس. همه آنها را یکجا ارسال کنید = 1 تماس:

```python
# ❌ Expensive: 5 separate API calls
review = await llm("Review this function")
docs   = await llm("Write docstring for this function")
tests  = await llm("Write unit tests for this function")
types  = await llm("Add type hints to this function")
lint   = await llm("Fix linting issues in this function")

# ✅ Cheap: 1 API call, one-fifth the cost
result = await llm("""For the function below, return all 5 in sequence:
1. Code review (max 3 sentences)
2. Docstring (Google format)
3. Unit tests (pytest, 3 cases)
4. Type hints added inline
5. Lint fixes

Function:
{code}
""")
```

** صرفه جویی: ** ~ 5× کاهش در هزینه تماس API + سربار زمینه مشترک به جای تکرار آن.

---

**4. ساختار اعلان Cache-Aware (10× Savings on Claude)**

داده‌های رسمی Anthropic (مارس 2026): درخواست سیستم حافظه پنهان = **0.30$/M** در مقابل $3/M — کاهش 10×.

```python
# ✅ Correct: constant system prompt — cache hit → $0.30/M
SYSTEM_PROMPT = """You are a Python expert. Rules:
- Stack: Python 3.12, uv, pytest, ruff
- Never use pip directly, always uv
{full_clinerules_content}
"""  # This section is cached — keep it character-for-character identical

def make_request(user_task: str) -> dict:
    return {
        "model": "claude-sonnet-4-5-20251001",
        "system": SYSTEM_PROMPT,       # ← constant (cache hit)
        "messages": [{"role": "user", "content": user_task}],  # ← variable per request
    }

# ❌ Wrong: adding timestamp or session ID to the system prompt
# → one character difference = cache miss = 10× more expensive
```

**قانون طلایی:** اعلان کامل سیستم + `.clinerules` + `AGENTS.md` را به عنوان پیام سیستم ثابت نگه دارید. هرگز مُهرهای زمانی، شناسه‌های جلسه یا داده‌های متغیر را به درخواست سیستم اضافه نکنید. همین امر در مورد DeepSeek نیز صدق می کند (0.028 دلار در حافظه پنهان در مقابل 0.28 دلار در میلیون دلار ذخیره نشده - 10× تفاوت).

---

**5. DeepSeek R1 Distill Qwen 7B — استدلال کم هزینه برای ریاضی/الگوریتم**

برای مسائل ریاضی، طراحی الگوریتم یا اشکال زدایی پیچیده - بدون نیاز به کلود:

**از طریق DeepSeek API** (یا OpenRouter):
```
Model ID: deepseek/deepseek-r1-distill-qwen-7b
```

**از طریق اوللاما** (محلی - رایگان):
```bash
ollama pull deepseek-r1:7b   # requires: 8 GB RAM (Apple Silicon M1+) or 6 GB VRAM
```

**مقایسه گزینه های استدلال برای کارهای روزانه:**

| گزینه | هزینه/وظیفه | کیفیت | بهترین برای |
|---|---|---|---|
| R1 Distill 7B (Ollama — محلی) | **0$** | خوب | ریاضی ساده، الگوریتم |
| استدلال DeepSeek V3.2=true | ~ 0.002 دلار | عالی | اشکال زدایی پیچیده |
| DeepSeek Speciale (OpenRouter) | ~ 0.01 دلار | برجسته | استدلال در سطح اثبات |
| کلود سونت 4.6 | ~0.15 دلار | برجسته | معماری + امنیت |

> **توصیه:** برای اشکال زدایی روزانه و وظایف الگوریتم → `deepseek-r1:7b` رایگان به صورت محلی. برای مشکلات سخت تر → DeepSeek V3.2 با `reasoning: true`. کلود فقط برای بررسی معماری و امنیت.

---

## �🚀 12. چرخه عمر عملیاتی
1. **معماری:** مستندسازی مشخصات فنی و طرح‌های اولیه توسط مدل‌های کلاس Frontier (با گردش کار `init-project`).  
2. ** پیاده سازی: ** توسعه گام به گام توسط موتورهای اجرایی بهینه سازی شده (با نظارت `quality-assurance`).  
3. **تأیید:** اجرای تست واحد و تایید نهایی منطق سیستم از طریق `ABR Loop`.  

---
* به روز رسانی فنی: 20 فوریه 2026 - تجزیه و تحلیل تایید شده مبتنی بر داده *

---
[بازگشت به README فارسی](README.fa.md)


