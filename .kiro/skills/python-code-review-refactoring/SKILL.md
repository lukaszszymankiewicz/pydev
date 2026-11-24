---
name: python-code-review-refactoring
description: >
  Spot code smells and refactor Python safely: reducing nesting, avoiding
  mutable default arguments, preferring composition over inheritance, and
  keeping changes behavior-preserving. Use when reviewing a diff/PR, or
  when code works but is hard to read, test, or extend.
---

## Instructions

Smells to flag, in rough priority order:

1. **Mutable default arguments** — `def f(items=[]):` shares one list
   across every call that doesn't pass `items`. Use `None` as the default
   and create the mutable value inside the function body.
2. **Deep nesting (3+ levels of `if`/`for`)** — flatten with early
   returns/`continue`, or extract the inner block into a named helper
   function. Nesting depth correlates directly with how hard a function
   is to reason about.
3. **God objects/functions** — a class or function doing too many
   unrelated things is a sign it should split along its actual
   responsibilities. If you can't describe what it does in one sentence
   without "and", it's probably doing too much.
4. **Deep inheritance chains for code reuse** — Python favors composition
   and duck typing. Prefer a class that *holds* a collaborator and
   delegates, or a plain function, over inheriting just to reuse a method.
   Reserve inheritance for genuine is-a relationships with shared
   behavior/interface, and prefer `Protocol`/ABCs over deep concrete
   hierarchies.
5. **Primitive obsession** — passing around loose tuples/dicts for
   structured data that always travels together. A `@dataclass` (or
   `NamedTuple`) makes the shape explicit and typo-proof.
6. **Premature abstraction** — a single implementation wrapped in an
   interface/factory "for future flexibility" that has no second
   implementation yet. Don't generalize until there's a second concrete
   use case; it's easier to extract an abstraction later than to unwind
   a wrong one now.
7. **Refactor in behavior-preserving steps.** Before changing structure,
   make sure there's a test covering the current behavior (add one if
   missing). Refactor in small steps, re-running tests after each step,
   rather than rewriting a large chunk and hoping it still works.
8. **Don't mix refactoring with behavior changes in the same diff** when
   avoidable — it makes the diff hard to review and hard to bisect if
   something breaks.
