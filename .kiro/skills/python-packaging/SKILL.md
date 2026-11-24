---
name: python-packaging
description: >
  Understand and extend this project's packaging setup (pyproject.toml,
  src layout, hatchling build backend, dependency declarations). Use when
  adding dependencies, new modules/sub-packages, or when packaging/import
  errors occur (e.g. "ModuleNotFoundError: pv").
---

## Instructions

This project uses the **src layout** (PEP 621, `pyproject.toml`-only — no
`setup.py`/`setup.cfg`):

```
pyproject.toml
src/pv/__init__.py
tests/
```

1. Build backend is `hatchling`. The importable package name is `pv`
   (`src/pv/`); `[tool.hatch.build.targets.wheel].packages = ["src/pv"]`
   tells hatchling what to ship.
2. New sub-packages go under `src/pv/<subpackage>/` with their own
   `__init__.py`. Mirror the structure under `tests/` for their tests.
3. Runtime dependencies go in `[project.dependencies]`; dev-only tools
   (ruff, pytest, etc.) go in `[project.optional-dependencies].dev`. Pin
   exact versions (`"package==X.Y.Z"`), not open ranges — this keeps the
   environment reproducible without a separate lockfile.
4. After editing `pyproject.toml`, re-run `make install`
   (`pip install -e ".[dev]"`) so the editable install and dependency set
   pick up the change.
5. `requires-python = ">=3.14"` is intentional — don't add dependencies or
   syntax that requires an older/incompatible Python, and don't lower this
   bound without checking why it was raised.
6. If imports of `pv` fail despite the venv being active, confirm the
   editable install exists: `.venv/bin/pip show pv`. Re-run
   `pip install -e ".[dev]"` if it's missing or stale.
