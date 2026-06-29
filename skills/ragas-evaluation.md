---
title: "RAGAS Evaluation"
description: Reference-free RAG evaluation with RAGAS — compatibility fixes for RAGAS 0.4.x, DeepSeek reasoning models, and qdrant-client 1.18+
location: skills/ragas-evaluation.md
agent_priority: Standard
last_updated: 2026-06-10
---

# Skill: RAGAS Evaluation

Reference-free evaluation of RAG systems using [RAGAS](https://docs.ragas.io).
Covers setup, known compatibility issues, and workarounds discovered in production.

**Related Skills:**

- [LLM & ML Workflow](llm-ml-workflow.md) — LLM backend configuration
- [Multi-RAG Orchestration](multi-rag-orchestration.md) — RAG pipeline design

---

## 1. Metrics (reference-free — no ground truth needed)

| Metric | What it measures |
| --- | --- |
| `faithfulness` | Claims in the answer are supported by retrieved context |
| `answer_relevancy` | Answer actually addresses the question |

Drop `context_precision` unless you have a `reference` column in your dataset.

---

## 2. Setup Pattern

```python
# ── Must patch BEFORE importing ragas ────────────────────────────────────────
import sys
from types import ModuleType
if "langchain_community.chat_models.vertexai" not in sys.modules:
    shim = ModuleType("langchain_community.chat_models.vertexai")
    shim.ChatVertexAI = object
    sys.modules["langchain_community.chat_models.vertexai"] = shim
# ─────────────────────────────────────────────────────────────────────────────

import warnings
from datasets import Dataset
from ragas import evaluate
with warnings.catch_warnings():
    warnings.simplefilter("ignore", DeprecationWarning)
    from ragas.metrics import faithfulness, answer_relevancy  # legacy API — not collections
```

---

## 3. LLM Backend: DeepSeek (OpenAI-compatible)

### Critical: llm_factory returns InstructorLLM, not LangchainLLMWrapper

```python
from ragas.llms import llm_factory
from openai import OpenAI

client = OpenAI(api_key=DEEPSEEK_API_KEY, base_url="https://api.deepseek.com/v1")
ragas_llm = llm_factory(DEEPSEEK_MODEL, client=client)

# REQUIRED for reasoning models (deepseek-v4-flash, deepseek-v4-pro):
# InstructorLLM stores API params in model_args — default max_tokens=1024
# causes reasoning tokens to exhaust the budget before output is written.
ragas_llm.model_args["max_tokens"] = 8192
```

**Why `llm_factory` and not `LangchainLLMWrapper` directly:**
DeepSeek rejects `n > 1` with HTTP 400. `llm_factory` intercepts RAGAS's internal
`n=3` requests and reduces them to `n=1`. `LangchainLLMWrapper` does not do this.

### DeepSeek reasoning model token behaviour

Reasoning models (deepseek-v4-flash, deepseek-v4-pro) use chain-of-thought internally.
Reasoning tokens count against the same `max_tokens` budget as output tokens.
With the default `max_tokens=1024`, the model thinks for ~800-1000 tokens and has
no room left for the JSON output → truncation → retry loop → slow evaluation.
`max_tokens=8192` gives enough room for both.

---

## 4. LLM Backend: Gemini

```python
from ragas.llms import llm_factory
from google import genai

client = genai.Client(api_key=GEMINI_API_KEY)
ragas_llm = llm_factory(GEMINI_MODEL, client=client)
# No max_tokens patch needed — Gemini is not a reasoning model
```

---

## 5. Embeddings: Local (sentence-transformers)

Avoid cloud embedding APIs for RAGAS — they add latency and cost.
Use local sentence-transformers instead:

```python
from ragas.embeddings import LangchainEmbeddingsWrapper
from langchain_huggingface import HuggingFaceEmbeddings

ragas_emb = LangchainEmbeddingsWrapper(
    HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")
)
```

Set these env vars to suppress noisy warnings:

```python
os.environ["TRANSFORMERS_VERBOSITY"] = "error"
os.environ["HF_HUB_OFFLINE"] = "1"  # if model already cached
```

---

## 6. Running Evaluation

```python
faithfulness.llm            = ragas_llm
answer_relevancy.llm        = ragas_llm
answer_relevancy.embeddings = ragas_emb

dataset = Dataset.from_dict({
    "question": [...],
    "answer":   [...],
    "contexts": [[...], ...],  # list of lists
})

result = evaluate(dataset, metrics=[faithfulness, answer_relevancy])

# Extract scores — EvaluationResult has no .items(), use .to_pandas()
df = result.to_pandas()
skip = {"question", "answer", "contexts", "user_input", "response", "retrieved_contexts"}
scores = {
    col: float(df[col].dropna().mean())
    for col in df.columns
    if col not in skip and df[col].dropna().mean() == df[col].dropna().mean()  # not NaN
}
```

---

## 7. qdrant-client 1.18+ API Change

`.search()` was removed. Use `.query_points()`:

```python
# Old (broken in 1.18+):
hits = client.search(collection_name=..., query_vector=..., limit=k)

# New:
response = client.query_points(
    collection_name=collection,
    query=vector,          # embedding list
    limit=top_k,
    query_filter=filter,
    with_payload=True,
)
for hit in response.points:   # <-- .points not the response itself
    text = hit.payload["text"]
    score = hit.score
```

---

## 8. Dataset Format

```python
# Minimum required columns:
{
    "question": ["What is X?", ...],
    "answer":   ["X is ...", ...],
    "contexts": [["context1", "context2"], ...],  # retrieved passages per question
}
# Do NOT include "reference" unless you want context_precision (requires ground truth)
```

---

## 9. Expected Scores (SemanticForest-RAG baseline)

| Run | Questions | Model | faithfulness | answer_relevancy |
| ----- | ----------- | ------- | --- | --- |
| 2026-06-10 | 3 | deepseek-v4-flash | 0.9167 | 0.9340 |
| 2026-06-10 | 12 | deepseek-v4-flash | 1.0000 | 0.8429 |
| 2026-06-10 | 3 | deepseek-v4-flash (patched) | 0.8839 | 0.9570 |
