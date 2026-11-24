---
name: python-testing-pytest
description: >
  Write and run tests for this project with pytest (fixtures, parametrize,
  test layout, assertions). Use when adding tests for new/changed behavior
  or when diagnosing a failing/flaky test run.
---

## Instructions

Tests live under `tests/`, mirroring `src/pv/`'s structure
(`src/pv/foo/bar.py` → `tests/foo/test_bar.py`). Config lives in
`[tool.pytest.ini_options]` in `pyproject.toml` (`testpaths = ["tests"]`).

1. Run the suite: `make test` (wraps `.venv/bin/pytest`). For a single
   file or test during iteration: `.venv/bin/pytest tests/test_x.py -k name`.
2. One behavior per test; name tests for what they assert
   (`test_<unit>_<condition>_<expected>`), not implementation details.
3. Use plain `assert` statements (pytest rewrites them for readable
   failure output) — don't reach for `unittest`-style `self.assertEqual`.
4. Use `@pytest.mark.parametrize` for the same assertion across multiple
   inputs instead of copy-pasted near-identical test functions.
5. Use fixtures (in the test module or a shared `conftest.py`) for setup
   that's reused across tests (e.g. temp dirs via the built-in `tmp_path`
   fixture) — avoid module-level mutable state.
6. A failing test is a specification, not an obstacle: fix the
   implementation to satisfy it, don't loosen the assertion unless the
   assertion was actually wrong.
7. New code paths (new functions, branches, error cases) need tests before
   a task is considered done — this is checked by the `python-checker`
   agent via `make check`.
