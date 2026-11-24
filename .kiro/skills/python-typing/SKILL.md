---
name: python-typing
description: >
  Apply modern Python 3.14 type-hinting conventions consistently across
  the codebase. Use when writing or reviewing function/class signatures,
  or when deciding how to type generics, optionals, and unions.
---

## Instructions

Target is Python 3.14 only (`requires-python = ">=3.14"`) — always use the
modern syntax, never the legacy `typing` equivalents:

1. Built-in generics: `list[int]`, `dict[str, int]`, `tuple[int, ...]`,
   `set[str]` — not `typing.List`/`Dict`/`Tuple`/`Set`.
2. Unions and optionals: `int | None`, `str | bytes` — not
   `typing.Optional[int]` / `typing.Union[str, bytes]`.
3. Generic functions/classes: use PEP 695 syntax
   (`def first[T](items: list[T]) -> T: ...`, `class Box[T]: ...`) instead
   of `TypeVar` + `Generic[T]` boilerplate, unless a `TypeVar` with bounds/
   constraints needs to be shared across multiple signatures.
4. Every new public function, method, and `@dataclass` field gets a type
   hint. Private helpers (leading underscore) should still be typed unless
   trivially obvious (e.g. `self`).
5. Use `collections.abc` types (`Iterable`, `Mapping`, `Sequence`,
   `Callable`) for parameters when only read access / calling is needed —
   reserve concrete types (`list`, `dict`) for return values and fields
   you construct.
6. Ruff's `UP` (pyupgrade) rules enforce most of this automatically on
   save via the `auto-lint-on-save` hook — if a diff keeps getting rewritten
   to modern syntax, that's the autofix working as intended, not a bug.
