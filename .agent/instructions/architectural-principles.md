# Architectural Principles (The "Arix" Way)

All development on the Arix project must strictly adhere to the following principles. No exceptions.

## 1. CLI First
- Every new feature or piece of logic must originate in the **CLI** or **Core** layer.
- It is forbidden to implement a feature in the Web UI or Telegram Bot that is not first available via the CLI.
- The CLI is the primary "source of truth" for system logic.

## 2. API as Infrastructure
- The **FastAPI** layer must be a one-to-one reflection of the system's capabilities.
- If a command exists in the CLI, a corresponding endpoint must exist in the API.
- All interfaces (Web, Telegram) interact through the shared `ArixEngine` in `core/engine.py`.

## 3. Modular Core
- Intent routing, retrieval, and response generation must remain decoupled from the delivery interface.
- Local processing (ChromaDB, BGE-M3) is the default; external API calls are auxiliary.

## 4. Singleton Heavy Objects
- Any object that loads ML models (BGE-M3, GraphAgent) MUST use the Singleton pattern.
- All shared singletons live in `src/arix/core/singletons.py`.
- NEVER instantiate `GraphAgent`, `RetrievalAgent`, or ML models inside request handlers.
- Reference: `from arix.core.singletons import get_graph_agent`

## 5. Config-Driven, Zero Hardcoding
- All model names (Gemini, DeepSeek, BGE-M3) are read from `config.yaml` via `settings`.
- Use `settings.get_executor_model()`, `settings.get_vision_model()`, `settings.get_architect_model()`.
- NEVER write `model="gemini-1.5-flash"` or `model="deepseek-chat"` anywhere in code.
- When adding a new provider, add it to `config.yaml` and handle it in `core/config.py`.

## 6. Error Resilience
- Every agent method must have a try/except with a meaningful fallback.
- API rate limits (429, RESOURCE_EXHAUSTED) must be caught and return a user-friendly message.
- System should NEVER crash due to a missing file, missing API key, or network error.

## 7. Multi-Language from Day One
- All user-facing strings must be in `src/arix/core/i18n/` (en, fa, tr).
- Never hardcode a user-facing string directly in response code.
- `lang` is always passed per-query, never stored as a global engine state.

## 8. Memory Budget (CRITICAL after 2026-02-20 RAM incident)
- Bot interface: max 1 `ArixEngine` instance (not one per language).
- BM25 is disabled until Qdrant migration — do NOT re-enable on ChromaDB.
- `IngestionAgent` (loads BGE-M3) must use lazy initialization in watchers.
- Always check `docs/fa/roadmap/ROADMAP.md` Phase sections before changing retrieval architecture.
