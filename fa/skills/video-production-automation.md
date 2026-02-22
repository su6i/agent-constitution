---
title: "Video Production Automation"
description: راهنمای عملی برای خودکارسازی تولید ویدیو و مستندسازی با ابزارهای پایتون (Manim, MoviePy, OpenCV) و ابزارهای دیگر.
location: fa/skills/video-production-automation.md
agent_priority: Standard
last_updated: 2026-02-22
---

# مهارت‌های تولید ویدیو و خودکارسازی (Video Production & Automation)

این مهارت نحوه استفاده از کتابخانه‌های پایتون و ابزارهای خارجی برای ساخت مستندات ویدیویی باکیفیت و خودکار برای پروژه‌های Agentic Coding شما را شرح می‌دهد.

## ۱. استک ویدیویی پایتون (The Python Video Stack)

### ۱.۱ Manim (موتور انیمیشن ریاضی)
بهترین گزینه برای: **توضیح مفاهیم، الگوریتم‌ها و جریان منطقی.**
*   **نصب:** `pip install manim` (نیاز به ffmpeg و latex دارد).
*   **مفهوم کلیدی:** همه چیز یک `Mobject` (شیء ریاضی) است. شما آن‌ها را با `Play()` متحرک می‌کنید.
*   **تکه کد (صحنه پایه):**
    ```python
    from manim import *

    class AgentFlow(Scene):
        def construct(self):
            # Create nodes
            user = Text("کاربر").set_color(BLUE)
            agent = Text("ایجنت").set_color(GREEN).next_to(user, RIGHT, buff=2)
            
            # Animate
            self.play(Write(user))
            self.play(Write(agent))
            self.play(Arrow(user.get_right(), agent.get_left()))
            self.wait(1)
    ```

### ۱.۲ MoviePy (تدوین ویدیو)
بهترین گزینه برای: **چسباندن کلیپ‌ها، اضافه کردن صدا و برش‌های ساده.**
*   **نصب:** `pip install moviepy`
*   **مفهوم کلیدی:** `VideoFileClip` شیء اصلی شماست. از `subclip`، `concatenate_videoclips` و `write_videofile` استفاده کنید.
*   **تکه کد (تدوین ساده):**
    ```python
    from moviepy.editor import VideoFileClip, concatenate_videoclips

    # Load clips
    clip1 = VideoFileClip("recording_1.mp4").subclip(0, 5) # 5 ثانیه اول
    clip2 = VideoFileClip("recording_2.mp4").subclip(0, 5)

    # Combine
    final_clip = concatenate_videoclips([clip1, clip2])
    final_clip.write_videofile("showcase.mp4")
    ```

### ۱.۳ OpenCV و PyAutoGUI (ضبط صفحه و خودکارسازی)
بهترین گزینه برای: **خودکارسازی خودِ دمو.** استفاده از PyAutoGUI برای کنترل موس/کیبورد و OpenCV برای ضبط صفحه.
*   **نصب:** `pip install opencv-python pyautogui numpy`
*   **استراتژی:**
    1.  یک اسکریپت برای اقدامات "کاربر" (تایپ دستورات) بنویسید.
    2.  از `pyautogui.typewrite()` برای شبیه‌سازی تایپ استفاده کنید.
    3.  از `cv2.VideoWriter` برای کپچر فریم‌ها استفاده کنید (یا از یک ضبط‌کننده صفحه اختصاصی مثل OBS استفاده کنید و فقط ورودی‌ها را خودکار کنید).

## ۲. استک بصری "حرفه‌ای" (غیر پایتونی)

برای استفاده‌های "وایرال" و باکیفیت، ابزارهای پایتون ممکن است کمی خشک باشند. برای جلا دادن از این‌ها استفاده کنید:

### ۲.۱ Screen Studio (مخصوص macOS)
*   **چرا:** به طور خودکار روی نشانگر موس زوم می‌کند، موشن بلر اضافه می‌کند و حرکات ناگهانی را نرم (Smooth) می‌کند.
*   **گردش کار:** در حالی که PyAutoGUI اسکریپت شما را اجرا می‌کند، صفحه را با Screen Studio ضبط کنید. نتیجه بسیار حرفه‌ای و دست‌ساز به نظر می‌رسد.

### ۲.۲ Adobe After Effects
*   **چرا:** برای شات‌های ترکیبی پیشرفته (مثلاً موکاپ‌های سه بعدی موبایل، لایه‌های UI پیچیده).

## ۳. گردش کار خودکارسازی برای نمایش (Showcase Workflow)

1.  **سناریو نویسی (Scripting):** یک `demo_script.py` با استفاده از PyAutoGUI بنویسید تا وظیفه کدنویسی را به صورت زنده انجام دهد.
2.  **ضبط (Recording):**
    *   *گزینه الف (کیفیت بالا):* Screen Studio را اجرا کنید، سپس `python demo_script.py` را اجرا کنید.
    *   *گزینه ب (کاملاً خودکار):* از OpenCV برای ضبط صفحه در حین اجرای اسکریپت استفاده کنید.
3.  **تدوین (Editing):** از MoviePy برای حذف سکوت‌ها، افزایش سرعت پردازش‌های طولانی (مثلاً `clip.fx(vfx.speedx, 2)`) و اضافه کردن اینترو/اوترو استفاده کنید.
4.  **لایه افزودنی (Overlay):** از Manim برای تولید یک ویدیوی توضیحی (با پس‌زمینه شفاف) که منطق را شرح می‌دهد استفاده کنید، سپس آن را با MoviePy روی ویدیوی اصلی قرار دهید.
