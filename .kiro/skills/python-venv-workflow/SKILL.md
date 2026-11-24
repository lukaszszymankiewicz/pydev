---
name: python-venv-workflow
description: >
  Create, activate, and manage this project's virtual environment with the
  stdlib `venv` module and pip. Use when setting up the dev environment,
  installing dependencies, or troubleshooting "command not found" /
  "module not found" issues caused by the wrong interpreter being active.
---

## Instructions

This project pins virtual environments to the stdlib `venv` module (not
`uv venv`, not `virtualenv`), created with Python 3.14.

1. Create the venv: `python3.14 -m venv .venv` (or `make venv`).
2. Activate it: `source .venv/bin/activate` (zsh/bash) — or just call
   binaries directly via `.venv/bin/python`, `.venv/bin/pytest`,
   `.venv/bin/ruff` without activating, which is safer inside scripts/CI.
3. Install the project in editable mode with dev extras:
   `.venv/bin/pip install -e ".[dev]"` (or `make install`, which also
   creates the venv if missing).
4. Never install packages into the system/Homebrew Python. If
   `pip install` is being run and `which python` doesn't point into
   `.venv/bin/`, stop and activate/target the venv explicitly first.
5. To add a new dependency: add it to `pyproject.toml`
   (`[project.dependencies]` or `[project.optional-dependencies].dev`) with
   a pinned version, then re-run `make install`. Don't `pip install` ad hoc
   without recording it in `pyproject.toml`.
6. `.venv/` is git-ignored — it must be reproducible from `pyproject.toml`
   alone. If something only works because of a manually-installed package,
   that's a bug in `pyproject.toml`.
