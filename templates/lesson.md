# Lesson Template

Copy this file to `_memory/lessons/<YYYY-MM-DD>-<slug>.md` when closing a WO
per `rules/080-knowledge-capture.md` §5. The header below is machine-parseable
by `bin/distill-lessons.sh` — keep the field names and the terminating `---`
exactly as shown; everything after `---` is free-form prose for the named
sections.

Adapted from hermes-academy's `Lesson` schema (MIT, filed HARVEST-IDEAS in
`_memory/REFERENCE-REPOS.md`) with every human-learner field removed: no XP,
no streak, no quiz, no progress file. The consumer of this file is the next
agent, not a person leveling up.

```
lesson_id: <YYYY-MM-DD>-<slug>
date: <YYYY-MM-DD>
repo: <repo-name>
wo: <wo-id>
pattern_id: <short-machine-tag, e.g. commit-ai-attribution-trailer>
mechanical: <true|false>
guard_check: <file:regex:n, or "n/a" when mechanical is false>
rule: <one imperative line the next worker must follow — self-contained>
---
```

- `rule` is the single line that gets injected verbatim into
  `_memory/WORKER-RULES.md` when this pattern promotes. Write it as a standing
  order to the next worker, complete on its own: that file is the only thing a
  delegation prompt receives — the lesson itself is never injected, so a rule
  that says "see the lesson" delivers nothing.
- `pattern_id` is the grouping key the distiller counts occurrences on. Two
  lessons describing the same recurring defect must use the *same*
  `pattern_id`, verbatim — a new tag per lesson makes every pattern look
  like a singleton and nothing ever promotes.
- `mechanical: true` means a script can decide pass/fail without judgment
  (a regex, an exit code, a file existing). `mechanical: false` means only a
  reviewer can tell — the distiller will promote the pattern as **advisory**
  prose in `WORKER-RULES.md` instead of a guard line.
- `guard_check` is the `wo_guard.sh --once <file>:<regex>:<n>` spec that
  would have caught this exact defect, written as if the pattern had already
  been enforced. The distiller copies this into the promoted rule verbatim —
  do not leave it vague ("something that checks for X"); write the literal
  spec you would run.

## Problem

What broke, in the terms the next agent will search for.

## Investigation

How the root cause was found — commands run, files inspected, false leads
ruled out.

## Solution

The concrete fix that was applied.

## Why This Works

The mechanism, not just the patch — why this class of fix generalizes.

## Common Mistakes

The wrong fixes that look plausible but do not actually solve it.

## Alternative Solutions

Other approaches considered, and why this one was chosen over them.

## Before vs After

The smallest before/after snippet or command output that makes the fix
undeniable.

## Commands Used

The exact commands run, in order — copy-pasteable, not paraphrased.

## Files Modified

Every file touched, one per line, absolute path.
