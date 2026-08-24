---
title: "Open-Source TTS — Multilingual Voice Synthesis"
description: Free alternatives to ElevenLabs — edge-tts, F5-TTS, GPT-SoVITS, OpenVoice, Piper for Persian, English, French
location: skills/opensource-tts.md
agent_priority: Standard
last_updated: 2026-08-24
version: 1.2.0
updated: 2026-08-24
---

# Open-Source TTS — Multilingual Voice Synthesis

> **دو قیدِ الزامی پیش از هر اجرا (حکمِ مالک):**
> ۱. هر اجرای مدلِ محلی از پشتِ **`run-capped`** (سقف ۸–۱۲GB) و با **dtype ِ
>    ۱۶ بیتی** — بخشِ «سقفِ حافظه» در انتهای همین فایل. یک `torch.float32` ِ
>    جاافتاده دو بار مکِ مالک را هنگ کرده است.
> ۲. **`edge-tts` را هرگز پیشنهاد نده** — مالک آن را ردّ کرده است. جدول و مثال‌های
>    زیر فقط مرجعِ فنی‌اند، نه توصیه. کندیِ موتورِ باکیفیت را با سخت‌افزار حل کن،
>    نه با افتِ کیفیت.

## Quick Decision Table

| Tool | Persian (fa) | French (fr) | English (en) | Quality | Speed | Setup | Best For |
| ------ | :---: | :---: | :---: | --------- | ------- | ------- | ---------- |
| **edge-tts** | fa-IR (4 voices) | fr-FR/fr-CA | Yes | Good | Instant | Trivial | Quick narration, no GPU |
| **F5-TTS** | Via cloning | Via cloning | Native | Excellent | Fast (GPU) | Moderate | Zero-shot voice cloning |
| **GPT-SoVITS** | Via training | Via training | Native | Best | Medium | Complex | Fine-tuned voice, 1 min sample |
| **OpenVoice V2** | Cross-lingual | Native | Native | Very good | Fast | Moderate | Multi-lingual from one reference |
| **Piper** | fa (صدای اجتماعیِ Mana-Persian-Piper) | Yes (fr_FR) | Yes | Good | Very fast | Easy | Offline, embedded systems |

**Decision guide:**

- Need Persian voice fast with no GPU → `edge-tts` with `fa-IR-DilaraNeural`
- Need to clone a specific person's voice → `F5-TTS` (zero-shot, 5s ref) or `GPT-SoVITS` (1 min training)
- Need French narration, offline → `Piper` (fr_FR-siwis-medium)
- Need same voice across EN/FR/ZH from one sample → `OpenVoice V2`

---

## 1. edge-tts

Microsoft Edge TTS via Python — no GPU, needs internet.

### Install

```bash
pip install edge-tts
# or isolated:
pipx install edge-tts
```

### List voices (fa-IR, fr-FR, en-US)

```bash
edge-tts --list-voices | grep -E "^(fa-IR|fr-FR|en-US)"
# Key voices:
# fa-IR-DilaraNeural   Female  Persian
# fa-IR-FaridNeural    Male    Persian
# fr-FR-DeniseNeural   Female  French (best quality)
# fr-FR-HenriNeural    Male    French
# en-US-AriaNeural     Female  English
```

### CLI generate

```bash
edge-tts --voice fa-IR-DilaraNeural \
  --text "سلام، این یک آزمایش است." \
  --write-media out.mp3 \
  --write-subtitles out.srt

# With rate/pitch adjustment (note: negative values need = syntax)
edge-tts --voice fr-FR-DeniseNeural \
  --rate=-10% --pitch=-5Hz \
  --text "Bonjour le monde." \
  --write-media fr_out.mp3
```

### Python API (async)

```python
import asyncio
import edge_tts

async def synthesize(text: str, voice: str, output: str):
    communicate = edge_tts.Communicate(text, voice)
    await communicate.save(output)

# Single file
asyncio.run(synthesize("سلام دنیا", "fa-IR-DilaraNeural", "output.mp3"))

# With subtitles
async def synthesize_with_subs(text: str, voice: str, mp3_out: str, srt_out: str):
    communicate = edge_tts.Communicate(text, voice)
    submaker = edge_tts.SubMaker()
    with open(mp3_out, "wb") as f:
        async for chunk in communicate.stream():
            if chunk["type"] == "audio":
                f.write(chunk["data"])
            elif chunk["type"] == "WordBoundary":
                submaker.feed(chunk)
    with open(srt_out, "w", encoding="utf-8") as f:
        f.write(submaker.get_srt())
```

---

## 2. F5-TTS

Zero-shot voice cloning with flow matching. Requires GPU (MPS on Apple Silicon works).

### Install

```bash
# Inference only:
pip install f5-tts

# Apple Silicon — install PyTorch first:
pip install torch torchaudio
pip install f5-tts
```

### CLI — zero-shot cloning

```bash
# ref_audio: 3–12s WAV of the target voice
# ref_text: exact transcript of ref_audio
# gen_text: what you want synthesized
f5-tts_infer-cli \
  --model F5TTS_v1_Base \
  --ref_audio reference_voice.wav \
  --ref_text "The quick brown fox jumps over the lazy dog." \
  --gen_text "Hello, this is a cloned voice speaking new text." \
  --output_file output.wav

# Leave --ref_text "" to auto-transcribe (uses Whisper, extra VRAM)
f5-tts_infer-cli \
  --model F5TTS_v1_Base \
  --ref_audio reference_voice.wav \
  --ref_text "" \
  --gen_text "Text to synthesize."
```

### Python API

```python
from f5_tts.api import F5TTS

tts = F5TTS()  # downloads F5TTS_v1_Base automatically

wav, sr, _ = tts.infer(
    ref_file="reference_voice.wav",
    ref_text="Transcript of the reference audio.",
    gen_text="Text you want the cloned voice to speak.",
    file_wave="output.wav",   # optional: save to file
)
# wav is a numpy array, sr = sample rate (24000)

# For Persian cloning — use a fa-IR speaker as ref_audio:
wav, sr, _ = tts.infer(
    ref_file="persian_speaker_sample.wav",
    ref_text="متن نمونه صدای مرجع",
    gen_text="این متن با صدای کلون شده خوانده می‌شود",
)
```

**Notes:** ref audio must be under 12s; model is CC-BY-NC; pre-trained EN+ZH — use cloning for other languages.
Gradio UI: `f5-tts_infer-gradio` — Fine-tune UI: `f5-tts_finetune-gradio`

---

## 3. GPT-SoVITS

Few-shot TTS: 5s zero-shot or 1-min fine-tune for high voice similarity.
Officially supports: EN, ZH, JA, KO, Cantonese.

### Install (macOS/Linux)

```bash
conda create -n GPTSoVits python=3.10
conda activate GPTSoVits
git clone https://github.com/RVC-Boss/GPT-SoVITS.git
cd GPT-SoVITS
# macOS (MPS or CPU):
bash install.sh --device MPS --source HF
# Linux CUDA:
bash install.sh --device CU128 --source HF
```

### 1-minute voice training workflow

```bash
# 1. Launch WebUI
python webui.py

# In the WebUI (http://localhost:9874):
# Tab: "1. ASR & Label" → upload audio → slice → denoise → ASR → proofread
# Tab: "2. Fine-tune" → select sliced dataset → train GPT + SoVITS models
# Tab: "3. Inference" → load trained models → generate
```

### Inference API (Python — via local HTTP server)

```python
import requests

# Start server first: python GPT_SoVITS/inference_webui.py
resp = requests.post("http://localhost:9880/tts", json={
    "text": "Hello, synthesized speech.",
    "text_lang": "en",
    "ref_audio_path": "reference.wav",
    "prompt_text": "Reference audio transcript",
    "prompt_lang": "en",
})
with open("output.wav", "wb") as f:
    f.write(resp.content)  # response is audio/wav
```

---

## 4. OpenVoice

Tone color cloning + cross-lingual synthesis. V2 natively supports EN, ES, FR, ZH, JA, KO.

### Install (V2)

```bash
conda create -n openvoice python=3.9 && conda activate openvoice
git clone https://github.com/myshell-ai/OpenVoice.git && cd OpenVoice
pip install -e .
pip install git+https://github.com/myshell-ai/MeloTTS.git
python -m unidic download
# Checkpoints: https://myshell-public-repo-host.s3.amazonaws.com/openvoice/checkpoints_v2_0417.zip → checkpoints_v2/
```

### Python API — tone color cloning

```python
import torch
from openvoice import se_extractor
from openvoice.api import ToneColorConverter

device = "mps" if torch.backends.mps.is_available() else "cuda" if torch.cuda.is_available() else "cpu"
ckpt_dir = "checkpoints_v2"

# Load converter
converter = ToneColorConverter(f"{ckpt_dir}/converter/config.json", device=device)
converter.load_ckpt(f"{ckpt_dir}/converter/checkpoint.pth")

# Extract tone color from reference audio (any language)
target_se, _ = se_extractor.get_se(
    "reference_voice.wav",
    converter,
    vad=True
)

# Generate base TTS with MeloTTS (V2)
from melo.api import TTS

# Supported speed param: EN, FR, ES, ZH, JP, KR
tts_model = TTS(language="EN", device=device)
speaker_ids = tts_model.hps.data.spk2id
src_path = "base_tts.wav"
tts_model.tts_to_file(
    "Text to synthesize in English.",
    speaker_ids["EN-Default"],
    src_path,
    speed=1.0
)

# Apply tone color cloning
source_se = torch.load(f"{ckpt_dir}/base_speakers/ses/en-default.pth", map_location=device)
converter.convert(
    audio_src_path=src_path,
    src_se=source_se,
    tgt_se=target_se,
    output_path="cloned_output.wav",
    message="@MyShell"
)
```

**Cross-lingual:** generate base audio with `TTS(language="FR")`, apply same `target_se` extracted from any reference voice.

---

## 5. Piper

Fast offline neural TTS — no internet, no GPU required. Used in Home Assistant.

### Install

```bash
pip install piper-tts
python3 -m piper.download_voices fr_FR-siwis-medium   # → ~/.local/share/piper/voices/
```

### CLI

```bash
echo "Bonjour le monde" | piper \
  --model fr_FR-siwis-medium \
  --output_file out.wav

# List available voices: https://github.com/OHF-Voice/piper1-gpl/blob/main/docs/VOICES.md
```

### Python API

```python
import wave
from piper import PiperVoice
from piper.download import ensure_voice_exists, find_voice, get_voices

# Load voice (model must be downloaded first)
voice_path = "/path/to/fr_FR-siwis-medium.onnx"
voice = PiperVoice.load(voice_path)  # add use_cuda=True for GPU

with wave.open("output.wav", "wb") as wav_file:
    voice.synthesize_wav("Bonjour le monde.", wav_file)

# Streaming synthesis
for chunk in voice.synthesize("Long text here..."):
    # chunk.audio_int16_bytes, chunk.sample_rate, chunk.sample_width
    process_audio_chunk(chunk)

# Adjust synthesis parameters
from piper import SynthesisConfig
config = SynthesisConfig(
    length_scale=1.2,   # slower speech (>1 = slower)
    noise_scale=0.667,
    noise_w_scale=0.8,
)
voice.synthesize_wav("Text", wav_file, syn_config=config)
```

**French voices:** `fr_FR-siwis-medium` (best), `fr_FR-upmc-medium`. No Persian in Piper's official models.

---

## Persian TTS — Best Approaches

**Option 1: edge-tts (fastest, no GPU)**

```python
import asyncio, edge_tts

async def persian_tts(text: str, output: str = "output.mp3"):
    c = edge_tts.Communicate(text, "fa-IR-DilaraNeural")
    await c.save(output)

asyncio.run(persian_tts("سلام دنیا، این یک آزمایش است."))
```

**Option 2: F5-TTS cloning from fa-IR sample (GPU, best quality)**

```python
from f5_tts.api import F5TTS

tts = F5TTS()
# Use any native Persian speaker audio as reference
tts.infer(
    ref_file="native_persian_speaker.wav",   # 5–12s, clear speech
    ref_text="متن دقیق صدای مرجع",
    gen_text="هر متن فارسی که می‌خواهید تولید کنید",
    file_wave="persian_output.wav",
)
```

**Option 3: GPT-SoVITS with 1-min Persian recording** — highest similarity, requires training run.

---

## French TTS — Best Approaches

**edge-tts (no GPU, instant):**

```bash
edge-tts --voice fr-FR-DeniseNeural \
  --text "Bonjour, je suis votre assistant." \
  --write-media french.mp3
```

**Piper (offline, fast):**

```bash
pip install piper-tts
python3 -m piper.download_voices fr_FR-siwis-medium
echo "Bonjour le monde" | piper --model fr_FR-siwis-medium --output_file out.wav
```

**OpenVoice V2 (clone a specific French voice):**

- Generate base audio with `TTS(language="FR")`
- Apply `target_se` from any reference speaker
- Produces the target person's voice speaking French

---

## Batch Pipeline — Async Multi-file Generation

```python
import asyncio
from pathlib import Path
import edge_tts

async def generate_one(item: dict) -> str:
    """item: {text, voice, output}"""
    c = edge_tts.Communicate(item["text"], item["voice"])
    await c.save(item["output"])
    return item["output"]

async def batch_generate(items: list[dict], max_concurrent: int = 5) -> list[str]:
    semaphore = asyncio.Semaphore(max_concurrent)

    async def bounded(item):
        async with semaphore:
            return await generate_one(item)

    return await asyncio.gather(*[bounded(i) for i in items])

# Usage:
items = [
    {"text": "سلام دنیا",         "voice": "fa-IR-DilaraNeural", "output": "fa_01.mp3"},
    {"text": "Bonjour le monde",  "voice": "fr-FR-DeniseNeural", "output": "fr_01.mp3"},
    {"text": "Hello world",       "voice": "en-US-AriaNeural",   "output": "en_01.mp3"},
]
results = asyncio.run(batch_generate(items))
print(results)  # ['fa_01.mp3', 'fr_01.mp3', 'en_01.mp3']
```

**For F5-TTS batch (GPU):**

```python
from f5_tts.api import F5TTS

tts = F5TTS()  # load once

texts = ["First sentence.", "Second sentence.", "Third sentence."]
for i, text in enumerate(texts):
    tts.infer(
        ref_file="reference.wav",
        ref_text="Reference transcript.",
        gen_text=text,
        file_wave=f"output_{i:03d}.wav",
    )
```

## سرعتِ اندازه‌گیری‌شده روی مکِ M-series و Colab T4 (۲۰۲۶-۰۸-۲۴)

اعدادِ واقعی از یک bake-off ِ فارسی، نه تخمین. متنِ یکسان، همان هارنِس، RTF از `wall/audio`:

| engine | device | RTF | x_realtime |
|---|---|---|---|
| piper (VITS, NAR) | Mac M-series **CPU** | 0.029 | **35x** |
| edge-tts | شبکه (Azure) | 0.133 | 7.5x |
| piper | Colab **T4 GPU** | 0.341 | 2.9x |
| omnivoice (~600M, AR) | Colab T4 GPU | 1.165 | 0.86x |
| omnivoice | Mac CPU | 2.711 | 0.37x |
| dots.tts-mlx (2B, AR) | Mac MLX GPU | ~41 (با لودِ مدل) | 0.024x |

**دو قاعده‌ی عملی که از این اعداد درآمد:**

1. **Colab ِ رایگان برای TTS ِ کوچک ضدِ بهره‌وری است.** Piper روی T4 دوازده برابر کندتر از
   مکِ محلی شد، چون ONNX ِ Piper اصلاً GPU نمی‌خواهد و CPU ِ دوهسته‌ایِ کولب از M-series
   ضعیف‌تر است. قبل از فرستادنِ کار به کولب، RTF را روی **هر دو** محیط probe کن.
2. **تعدادِ پارامتر پیش‌بینی‌کننده‌ی سرعت نیست.** مدلِ اتورگرسیوِ کدک به ازای هر ثانیه صدا
   `نرخ فریم × تعداد codebook` گامِ متوالی می‌زند (مثلاً ۵۰×۸ = ۴۰۰ گام). گلوگاه پهنای‌باندِ
   حافظه است؛ مدلِ کوچک‌تر گامِ کمتری ندارد. NAR (VITS/flow-matching) این جریمه را ندارد.

**سخت‌افزار برای RTF<0.3:** OmniVoice ~۱٫۳GB VRAM (fp16)، dots ~۳–۷٫۵GB. RTX 3090/4090 کافی است؛
ارزان‌ترین اجاره‌ی ابری ≈ $۰٫۲–۰٫۴ بر ساعت (vast.ai / runpod). batching اثرِ زیاد دارد.

**کیفیت در برابر سرعت — تله‌ی Piper:** VITS حافظه‌ی بلندمدتِ نوایی ندارد، پس تن و لحن در طولِ
چند دقیقه **دریفت می‌کند**؛ برای دوبله‌ی طولانی ردّ می‌شود مگر با سنتزِ جمله‌به‌جمله و
`--length_scale 1.1 --noise_scale 0.333 --noise_w 0.6 --sentence_silence 0.25`. کلونِ صدا هم ندارد.

**مجوز — بررسی‌شده ۲۰۲۶-۰۸-۲۴:** تجاری‌مجاز = dots.tts، Kokoro، Matcha، MeloTTS، OpenVoice v2،
Chatterbox، Zonos، CosyVoice 2، Piper (همه Apache/MIT).
غیرتجاری ⇒ ردّ = F5-TTS، E2-TTS (CC-BY-NC)، XTTS-v2 (CPML)، Fish-Speech، Spark-TTS، StyleTTS2،
VibeVoice. مشروط = IndexTTS2، Higgs v2، Orpheus.

جزئیات و فایل‌های صوتی: `polycast/docs/benchmark/2026-08-24-fa-dub-bakeoff/`

## سقفِ حافظه — الزامی در هر اسکریپتِ تولیدِ صدا (حکمِ مالک ۲۰۲۶-۰۸-۲۴)

یک اجرای بی‌سقف روی مکِ M-series **بالای ۱۱ گیگابایت** حافظه‌ی یکپارچه گرفت و سیستم را به
هنگ برد. از این پس هر اسکریپتِ TTS/تبدیلِ صدا **باید** یک سقفِ صریح داشته باشد؛ بودجه‌ی
پیش‌فرض **۸ تا ۱۰ گیگابایت** (روی مکِ ۱۶ گیگ: ۸؛ روی ۳۲ گیگ به بالا: ۱۰).

**نکته‌ی کلیدی:** روی macOS هسته `RLIMIT_AS` را **اعمال نمی‌کند** — نه `ulimit -v` و نه
`resource.setrlimit(RLIMIT_AS)` جلوی چیزی را نمی‌گیرد (بی‌خطا اجرا می‌شود و نادیده گرفته
می‌شود). پس سقف باید در دو لایه ساخته شود: **knob ِ خودِ موتور** + **نگهبانِ فرایند**.

### لایه ۱ — knob ِ موتور (قبل از لودِ مدل)

```python
# MLX (dots.tts-mlx و هر مدلِ MLX) — نامِ تابع بینِ نسخه‌ها جابه‌جا شده،
# پس version-safe صدا بزن (mx.set_memory_limit جدید، mx.metal.set_memory_limit قدیمی):
import mlx.core as mx
GB = 1024 ** 3
(getattr(mx, "set_memory_limit", None) or mx.metal.set_memory_limit)(10 * GB)
(getattr(mx, "set_cache_limit",  None) or mx.metal.set_cache_limit)(2 * GB)
# بعد از هر chunk: (getattr(mx, "clear_cache", None) or mx.metal.clear_cache)()

# PyTorch MPS — این env باید *قبل از* import torch ست شود:
import os
os.environ.setdefault("PYTORCH_MPS_HIGH_WATERMARK_RATIO", "0.6")
import torch
torch.mps.set_per_process_memory_fraction(0.6)   # نسبت به recommendedMaxWorkingSetSize
torch.mps.empty_cache()                          # بعد از هر chunk
```

⚠️ هر دو نسبت (`HIGH_WATERMARK_RATIO` و `set_per_process_memory_fraction`) نسبت به
**recommendedMaxWorkingSetSize** ِ سیستم‌عامل‌اند، نه کلِ RAM — عدد را از روی همان حساب کن.

### لایه ۰ — اجرای هر کارِ inference از پشتِ `run-capped` (اجباری)

مستندکردنِ قاعده کافی نبود: اسکریپتی که مالک اجرا می‌کند اغلب **مالِ ما نیست**
(مثالِ اپ‌استریم، کولب، یک `inference.py` ِ دانلودی) و هیچ گاردی داخلش نداریم.
پس گارد باید **بیرونِ** فرایند باشد:

```bash
run-capped -- python aava_inference.py --text "سلام"      # سقفِ پیش‌فرض ۱۰GB
run-capped --limit-gb 12 --floor-gb 2 -- uv run infer.py   # مدلِ بزرگ‌تر
```

`bin/run-capped` (لینک‌شده در `~/.local/bin`) کلِ درختِ فرایند را هر ۰٫۲۵ ثانیه
می‌پاید و با **دو ماشه** می‌کشد: RSS ِ درخت از سقف رد شود، **یا** حافظه‌ی آزادِ
سیستم زیرِ کف بیفتد (این دومی حافظه‌ی Metal/MPS را هم می‌گیرد که در RSS کامل
شمرده نمی‌شود). خروجیِ ۱۳۷ یعنی گارد کشته است، نه اینکه اسکریپت کرش کرده.

### لایه ۱٫۵ — اولین چیزی که چک می‌کنی: `dtype`

**پرمصرف‌ترین باگ، همیشه یک خط است.** نمونه‌ی واقعی (۲۰۲۶-۰۸-۲۴، Aava TTS ِ فارسی
روی مکِ ۱۶GB): وزن‌ها روی HF در ۱۶ بیت ذخیره شده‌اند (۷٫۵۶GB برای ۳٫۸B پارامتر)،
ولی اسکریپتِ اپ‌استریم داشت

```python
dtype = torch.bfloat16 if device == "cuda" else torch.float32   # ← بمبِ حافظه
```

یعنی روی MPS همان وزن‌ها **fp32** بارگذاری می‌شدند: ۱۵٫۱GB فقط وزن، روی مکِ ۱۶GB
⇒ سیستم هنگ و ری‌استارت. فرضِ داخلِ کامنتِ اپ‌استریم («MPS از bf16 پشتیبانی
نمی‌کند») از torch 2.3 / macOS 14 به بعد **باطل** است.

**قاعده:** پیش از اجرای هر مدلِ محلی، این حساب را بکن —
`پارامتر × بایتِ dtype` (fp32=4، bf16/fp16=2، int8=1، int4=0.5) + ~۲۰٪ برای
KV-cache و اکتیویشن. اگر از بودجه رد شد، **اول dtype را عوض کن، بعد سقف را**.
روی مکِ ۱۶GB: مدلِ ≥۴B فقط کوانتیزه (MLX 4-bit ≈ ۲GB) عملی است؛ ۳-۴B در bf16
مرزی است و باید با `--limit-gb 12 --floor-gb 2` اجرا شود.

### لایه ۲ — نگهبانِ درون‌فرایندی (stdlib، بدون وابستگی)

```python
import os, signal, threading, time, resource

def ram_guard(limit_gb: float = 10.0, poll_s: float = 2.0) -> None:
    """اگر peak RSS از سقف رد شد، فرایند را با SIGTERM می‌کشد (macOS: ru_maxrss بر حسب بایت)."""
    limit = int(limit_gb * 1024 ** 3)
    def loop():
        while True:
            rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
            if os.uname().sysname != "Darwin":
                rss *= 1024                      # لینوکس: کیلوبایت
            if rss > limit:
                print(f"[ram-guard] {rss / 1024**3:.1f}GB > {limit_gb}GB — abort", flush=True)
                os.kill(os.getpid(), signal.SIGTERM)
            time.sleep(poll_s)
    threading.Thread(target=loop, daemon=True).start()

ram_guard(10)   # اولین خطِ main()
```

### قواعدِ همراه (بدونِ اینها سقف می‌شکند)

1. **صدا را در RAM انباشته نکن.** هر chunk را همان‌جا روی دیسک بنویس و آرایه را `del` کن؛
   الحاق را آخرِ کار با `ffmpeg concat` انجام بده، نه با یک لیستِ numpy در حافظه.
2. **هر لحظه یک مدل.** بینِ موتورها فرایندِ جدا بالا بیاور (`subprocess`) — آزادسازیِ
   حافظه‌ی Metal داخلِ یک پروسه قطعی نیست.
3. **دسته‌ای نه سراسری.** متنِ بلند را جمله‌به‌جمله بده؛ batch ِ بزرگ سقف را می‌شکند و
   روی AR سرعت هم نمی‌آورد.
4. **سقف را ثبت کن.** در sidecar ِ خروجی `environment.memory_limit` را بنویس (مثلاً
   `"mlx 10GB via set_memory_limit"`) و peak را در `notes` — قرارداد:
   `polycast/docs/NAMING_CONVENTION.md`.
5. **قبل از اجرای طولانی probe بزن:** ۱۰ ثانیه صدا بساز، peak را ببین، بعد کلِ کار را راه
   بینداز. dots int4 روی مک ۹٫۱GB peak داد — یعنی با سقفِ ۸GB اصلاً بالا نمی‌آید.

## صفِ تستِ بعدی — موتورهای تجاری‌مجاز (۲۰۲۶-۰۸-۲۴)

سه موتور برای بنچمارکِ سه‌زبانه (fa/en/fr) در نوبت‌اند؛ **هیچ‌کدام فارسی را رسماً پشتیبانی
نمی‌کنند** — این نکته طراحیِ تست را عوض می‌کند:

| موتور | مجوز | زبان‌های رسمی | معماری | حافظه |
|---|---|---|---|---|
| Zonos | Apache-2.0 | en, ja, zh, fr, de | AR (Transformer یا هیبریدِ Mamba2) | ≥۶GB، ۱۰GB توصیه |
| CosyVoice 2 | Apache-2.0 | zh, en, ja, ko, de, es, fr, it, ru | LLM + flow-matching ِ chunk-aware | ۶–۸GB (۰٫۵B) |
| OpenVoice v2 | MIT | پایه = MeloTTS: en, es, fr, zh, ja, ko | مبدلِ رنگِ صدا روی TTS ِ پایه | سبک |

**نتیجه‌ی معماری:** OpenVoice v2 مبدلِ **زبان‌مستقل** است — روی موجِ صدا کار می‌کند، پس
می‌تواند خروجیِ یک TTS ِ فارسیِ ثالث (Piper fa یا edge-tts fa-IR) را به صدای کلون‌شده تبدیل
کند. یعنی مسیرِ «Piper fa ِ سریع + OpenVoice v2» تنها زنجیره‌ی **کاملاً تجاری‌مجاز** برای
کلونِ صدای فارسی است. دو قید: مبدل فقط **تیمبر** را می‌آورد، لحن و prosody از موتورِ پایه
می‌آید (یعنی دریفتِ لحنِ Piper پابرجاست)، و هر نویز/آرتیفکتِ موتورِ پایه را تشدید می‌کند.
Zonos و CosyVoice 2 برای فارسی فقط به‌صورتِ cross-lingual (کیفیتِ نامعلوم) قابلِ آزمایش‌اند.

## تستِ اعداد — بُعدِ اجباریِ هر بنچمارک

خواندنِ عدد شایع‌ترین شکستِ TTS در دوبله است و در تستِ متنِ روایی دیده نمی‌شود. کنارِ
سناریوی روایی، همیشه بلوکِ اعداد را هم بگیر: اعدادِ اصلی/ترتیبی، هزارگان و میلیون، اعشار،
کسر، درصد، پول، تاریخ، ساعت، شماره‌ی تلفن (رقم‌به‌رقم نه عددی)، بازه، واحد، سال، منفی، و
برای فارسی **تله‌ی رقمِ لاتین در برابر رقمِ فارسی**. مجموعه‌ی فریزشده‌ی سه‌زبانه:
`polycast/docs/benchmark/numbers_v1.{fa,en,fr}.txt`.
