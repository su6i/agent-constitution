---
title: "015LanguageSelection: Language Selection Policy"
description: Python is the default language for every project; Rust or Go earn adoption only via a written, defensible benefit — a profiled hot path, or a distribution/reliability/install win — never by default or by preference.
location: rules/015-language-selection.md
agent_priority: High
last_updated: 2026-08-10
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

Owner ruling 2026-08-10 widens this: the payoff from Rust was never only
RAM/CPU — smaller binaries, genuine cross-platform distribution, higher
reliability, and faster/easier installation are real benefits in their own
right. Use Rust or Go **whenever either kind of benefit is real and
defensible for the specific module** — the CPU/RAM gate below, OR the
distribution/reliability/install case in §Broader Adoption Criteria. The
owner's other constraint from D-028 is unchanged: **the bulk of the code
stays Python because Python readability is higher**; widening the
justification set is not a default switch to Rust/Go, and the decision must
still be argued, never assumed.

<!-- digest:start -->

## Default Language: Python

Python is the default for every project — ML/inference, CLI glue, orchestration,
services, scripts, the entire application "glue". No project starts in Rust or
Go on the strength of a general performance belief; Python is the baseline
until a specific module is measured and found wanting.

## Mandatory Gate: Justify First, Rewrite Second

**No module moves to Rust or Go without a concrete, written justification —
either a profiling number (performance), or a named distribution/
reliability/install benefit specific to that module (§Broader Adoption
Criteria below). "Rust/Go is generally better" is never sufficient on either
axis.**

1. Ship the module in Python first.
2. If the candidate reason is performance: profile it under a realistic load
   (`cProfile`/`py-spy` for CPU, `memory_profiler` for RAM, wall-clock for
   latency-sensitive paths). If the candidate reason is distribution,
   reliability, or install friction: name the specific benefit and state why
   Python's normal packaging (`uv`, a venv, PyInstaller) does not already
   cover it for this module's actual deployment target.
3. Only if the profile shows the module is the actual bottleneck, or the
   named non-performance benefit is real and specific to this module — not a
   guess, not "Rust is faster/smaller/more reliable in general" — does a
   rewrite proposal go in a WO.
4. The WO that proposes the rewrite **must carry the evidence** — the
   profiling numbers, or the specific distribution/reliability/install
   argument (rule 070 §Mandatory Body — a WO without evidence is incomplete)
   — and must justify the ongoing cost of maintaining two languages in one
   codebase (build tooling, CI matrix, the pool of people who can review
   both, FFI surface area). No evidence, no rewrite — this is
   non-negotiable, not a style preference.

Guessing which module is "obviously" slow, or "obviously" worth shipping as a
binary, and rewriting it anyway violates `rules/025-research-first.md` in the
same way as guessing an API flag: find the number, or name the specific
benefit, before writing the fix.

## Broader Adoption Criteria (Owner Ruling 2026-08-10)

D-028 gated Rust/Go adoption on one dimension: a profiled CPU-bound hot path.
This widens the criteria to the dimensions the owner named — a module can
justify Rust/Go through **any** of these, argued in the WO, not assumed:

- **Distribution:** a single static binary vs. shipping a Python interpreter
  plus a venv plus a dependency tree onto the target machine.
- **Reliability:** a compiled, statically-typed core that cannot fail at
  runtime on a missing or mismatched dependency the way an interpreted script
  can.
- **Cross-platform packaging:** one cross-compiled binary per OS/arch,
  instead of packaging a Python environment separately for each.
- **Install friction:** a single executable (or `curl | tar`) vs. a
  `uv`/venv setup step on the user's own machine.

**The bulk of the code still stays Python.** Most glue, orchestration, and
ML/inference code has no distribution story that Python doesn't already
serve fine — nobody ships a dependency-free binary of a one-off internal
script, and the readability trade from D-028 still holds. What changed is
the *set of arguments* that can justify a rewrite, not a default preference
for Rust/Go; a module still needs its own case, written into the WO, before
the gate above lets it move. The FFI boundary below is unchanged regardless
of which argument justified the rewrite — a module adopted for distribution
reasons still gets wrapped by Python the same way one adopted for CPU reasons
does (§FFI Boundary: **PyO3 + `maturin`** for Rust, `cgo`/separate-binary for
Go).

## Which Language for Which Job

| Language | When | Examples |
|---|---|---|
| **Python** | Default. ML/inference, glue, orchestration, CLIs, services where the bottleneck is I/O or an external call, not CPU. | Almost everything |
| **Rust** | Low-latency / real-time paths where the profiled bottleneck is CPU-bound Python and the workload tolerates a compiled, memory-safe core. | Cueprompt's live-latency path, real-time audio processing |
| **Go** | Network-facing services or concurrent CLIs where the bottleneck is concurrency/throughput, not raw numerical CPU work. | DevOps tooling, concurrent network utilities |

This table is a starting classification, not a substitute for the gate
above — a candidate module still needs its own evidence (a profiling number,
or a specific distribution/reliability/install argument) before a rewrite is
approved, even when it matches a row here by description.

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

Without a gate, "Rust is faster" (or "Rust ships a smaller binary") becomes a
standing justification for rewriting anything, and a codebase accumulates
languages nobody argued the need for. The gate keeps the trade the owner
asked for either way — ~90%-of-the-speed-for-~10%-of-the-code on the
performance axis, or a specific, stated distribution/reliability/install win
on the other: pay the two-language maintenance cost only where the evidence
says it buys something real.
