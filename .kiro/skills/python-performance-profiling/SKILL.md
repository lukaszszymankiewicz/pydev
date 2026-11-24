---
name: python-performance-profiling
description: >
  Profile before optimizing, recognize common Python performance pitfalls,
  and judge when optimization is (and isn't) worth doing. Use when code
  is reported slow, before making any "this will be faster" change, or
  when reviewing a performance-motivated diff.
---

## Instructions

1. **Measure before changing anything.** Never optimize from intuition.
   Use `cProfile`/`profile` for CPU time
   (`python -m cProfile -s cumulative script.py`), `timeit` for
   micro-benchmarking a specific snippet, and `tracemalloc` or
   `memory_profiler` for memory. Find the actual hot spot — it's usually
   not where you'd guess.
2. **Fix algorithmic complexity before micro-optimizing.** An O(n²) loop
   replaced with an O(n) approach (e.g. a `set`/`dict` lookup instead of
   scanning a `list` repeatedly) dwarfs any constant-factor tuning.
   Profile to find *which* function dominates, then check its complexity
   first.
3. **Common Python-specific pitfalls to check for:**
   - String concatenation in a loop (`s += x`) — use `"".join(parts)`
     instead; each `+=` on a string allocates a new string.
   - Repeated attribute/dict lookups inside a hot loop — bind to a local
     variable outside the loop if the value doesn't change per iteration.
   - Building a full list when a generator would do — if the result is
     only iterated once, a generator avoids materializing it all in
     memory.
   - `list.append` in a loop instead of a list/dict/set comprehension —
     comprehensions are typically faster and clearer for simple
     transformations.
   - Using a `list` for membership testing (`x in big_list`) instead of a
     `set`/`dict` — list membership is O(n); set/dict membership is O(1).
4. **Know when NOT to optimize.** If the profiled cost is a few
   milliseconds in a path that runs rarely, leave it — readability and
   correctness outrank speed there. Reserve optimization effort for
   measured hot paths (high call frequency, large inputs, or user-facing
   latency).
5. **Re-profile after the change** to confirm it actually helped and
   didn't just move the bottleneck elsewhere or regress correctness.
6. **Keep a benchmark/test alongside risky optimizations** (e.g. one that
   asserts output equivalence) so a "faster" rewrite can't silently
   change behavior.
