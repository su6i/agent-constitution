---
title: "015LanguageSelection: Language Selection Policy"
description: Python is the default language for every project; Rust or Go are permitted only for a profiled hot path, never by default or by preference.
location: rules/015-language-selection.md
agent_priority: High
last_updated: 2026-08-09
---

# Language Selection Policy

Owner ruling 2026-08-09 (D-028), on the standing question of when a
performance-sensitive module earns a rewrite outside Python:

> هرجایی دیدی مثلاً اگر عمدهٔ کد را با پایتون بنویسیم و فقط بخشی از کد را با
> Rust بنویسیم به ۹۰ درصد سرعت و دقت می‌رسیم، این کار را بکن؛ خوانایی پایتون
> به نظرم بالاتر از Rust است.

Translation of the operative clause: default to Python; carve out a Rust (or
Go) core only where profiling shows it earns most of the available speed —
readability is the tiebreaker, not a coin flip.

<!-- digest:start -->

## Default Language: Python

Python is the default for every project — ML/inference, CLI glue, orchestration,
services, scripts, the entire application "glue". No project starts in Rust or
Go on the strength of a general performance belief; Python is the baseline
until a specific module is measured and found wanting.

## Mandatory Gate: Profile First, Rewrite Second

**No module moves to Rust or Go without a profiling number that justifies it.**

1. Ship the module in Python first.
2. Profile it under a realistic load (`cProfile`/`py-spy` for CPU,
   `memory_profiler` for RAM, wall-clock for latency-sensitive paths).
3. Only if the profile shows the module is the actual bottleneck — not a
   guess, not "Rust is faster in general" — does a rewrite proposal go in a WO.
4. The WO that proposes the rewrite **must carry the profiling numbers** (rule
   070 §Mandatory Body — a WO without evidence is incomplete) and must justify
   the ongoing cost of maintaining two languages in one codebase (build
   tooling, CI matrix, the pool of people who can review both, FFI surface
   area). No profiling number, no rewrite — this is non-negotiable, not a
   style preference.

Guessing which module is "obviously" slow and rewriting it anyway violates
`rules/025-research-first.md` in the same way as guessing an API flag: find
the number before writing the fix.

## Which Language for Which Job

| Language | When | Examples |
|---|---|---|
| **Python** | Default. ML/inference, glue, orchestration, CLIs, services where the bottleneck is I/O or an external call, not CPU. | Almost everything |
| **Rust** | Low-latency / real-time paths where the profiled bottleneck is CPU-bound Python and the workload tolerates a compiled, memory-safe core. | Cueprompt's live-latency path, real-time audio processing |
| **Go** | Network-facing services or concurrent CLIs where the bottleneck is concurrency/throughput, not raw numerical CPU work. | DevOps tooling, concurrent network utilities |

This table is a starting classification, not a substitute for the profiling
gate above — a candidate module still needs its own number before a rewrite
is approved, even when it matches a row here by description.

## FFI Boundary (Mandatory When a Rewrite Is Approved)

A rewritten module is a *hot core* wrapped by the existing Python system, not
a wholesale language migration:

- **Rust →Python:** `PyO3` + `maturin`. The Rust crate exposes a narrow,
  typed Python-callable surface; Python remains the caller and the glue.
- **Go → Python:** `cgo` bindings, or — when `cgo`'s build complexity isn't
  worth it — a separate Go binary invoked as a subprocess/service with a
  defined I/O contract (stdin/stdout, HTTP, or a small RPC). Prefer the
  separate-binary route unless the call frequency makes process/RPC overhead
  the new bottleneck.

The Python side keeps ownership of orchestration, tests, and CI entry points.
A hot core does not get to redefine the project's primary language.

<!-- digest:end -->

## Why This Rule Exists

Without a gate, "Rust is faster" becomes a standing justification for
rewriting anything, and a codebase accumulates languages nobody profiled the
need for. The gate keeps the ~90%-of-the-speed-for-~10%-of-the-code trade the
owner asked for: pay the two-language maintenance cost only where the number
says it buys something real.
