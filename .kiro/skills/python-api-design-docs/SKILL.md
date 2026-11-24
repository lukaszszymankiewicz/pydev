---
name: python-api-design-docs
description: >
  Design clean public Python interfaces and write useful docstrings:
  minimal surface area, explicit over implicit, semantic versioning, and
  backward-compatibility discipline. Use when adding a new public
  function/class/module, or when deciding what to expose vs keep private.
---

## Instructions

1. **Keep the public surface minimal.** Default to `_leading_underscore`
   for anything not meant to be used outside its module/package. Every
   public name is a promise to callers — don't expose implementation
   details "just in case" they're useful later.
2. **Explicit over implicit.** Prefer named keyword arguments for
   anything non-obvious (`resize(image, width=800, height=600)` over
   positional `resize(image, 800, 600)`), and avoid functions that behave
   differently based on hidden global/module state.
3. **Design for the caller, not the implementation.** A good signature
   reads naturally at the call site. If a function needs 5+ parameters or
   several of them are usually `None`, consider a config object/dataclass
   or splitting into smaller functions.
4. **Write docstrings that explain *why* and *what*, not a restatement of
   the code.** Follow one consistent style (Google or NumPy) across the
   project. At minimum, document: what it does, parameters and their
   types/units/constraints, return value, and exceptions it can raise.
   Skip docstrings only for truly self-evident private helpers.
5. **Treat the public API as a backward-compatibility contract.** Once
   released, don't change a public function's behavior, parameter order,
   or return type without a deprecation path. Use `warnings.warn(...,
   DeprecationWarning)` for one release cycle before removing something.
6. **Follow semantic versioning deliberately:** patch = bug fixes only,
   minor = backward-compatible additions, major = breaking changes. A
   breaking change to a public name should bump the major version, full
   stop — don't let it slip in as a "minor improvement."
7. **New public functions/classes need a docstring and a type-annotated
   signature before being considered done** — both are part of the
   interface, not optional polish.
