---
name: python-error-handling
description: >
  Design exception hierarchies, decide when to catch vs propagate errors,
  and use context managers for reliable cleanup. Use when writing code
  that can fail (I/O, parsing, external calls) or when reviewing
  try/except blocks that look too broad or too narrow.
---

## Instructions

1. **Catch only what you can handle.** `except Exception:` (or bare
   `except:`) swallowing everything is almost always wrong — it hides bugs
   (typos, `AttributeError`, `KeyError`) alongside the expected failure.
   Catch the specific exception type(s) you actually expect and know how
   to recover from.
2. **Let unexpected errors propagate.** If you can't meaningfully recover
   (retry, fall back, return a sensible default), don't catch it — let it
   crash loudly with its real traceback. Catching-and-re-raising-generic
   destroys the original context.
3. **Define custom exceptions for your domain**, derived from a common
   base (e.g. `class ConfigError(Exception): ...`,
   `class MissingKeyError(ConfigError): ...`). Callers can then catch at
   the right granularity (`except ConfigError` for "any config problem",
   or the specific subclass for one case) instead of parsing string
   messages.
4. **Preserve the cause when wrapping:** `raise NewError(...) from original`
   keeps the original traceback visible instead of hiding it.
5. **Use context managers (`with`, `contextlib.contextmanager`,
   `contextlib.suppress`) for anything that must be cleaned up** — file
   handles, locks, connections, temp state. Don't rely on `finally`
   blocks scattered through a function when a `with` block expresses the
   same guarantee more clearly.
6. **Fail fast on programmer errors, fail soft on expected ones.** Invalid
   internal state (an assertion, a contract violation) should raise
   immediately and loudly. Expected failure modes (a file not found, a
   network timeout, bad user input) should be handled explicitly with a
   clear error message or a documented recovery path.
7. **Validate inputs at the boundary**, not deep inside internal helpers.
   Raise with a clear, specific message at the point where bad data
   enters the system, so the stack trace points at the actual problem
   instead of some unrelated internal line that merely choked on it.
