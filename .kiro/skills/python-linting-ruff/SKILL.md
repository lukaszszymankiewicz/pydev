---
name: python-linting-ruff
description: >
  Understand this project's ruff lint/format configuration and how
  linting is automated, without ever invoking ruff directly in shell. Use
  when a save-time autofix looks unexpected, or when deciding whether to
  adjust rule selection in pyproject.toml.
---

## Instructions

Ruff is configured in `[tool.ruff]` / `[tool.ruff.lint]` /
`[tool.ruff.format]` in `pyproject.toml` (`target-version = "py314"`,
100-char lines, rule sets `E, W, F, I, N, UP, B, C4, SIM, RUF`).

**Agents must not run `ruff` directly** — a `PreToolUse` hook
(`.kiro/hooks/block-manual-lint.json`) blocks any shell command containing
the word `ruff`. Linting/formatting happens two ways instead:

1. Automatically on save: the `auto-lint-on-save` `PostFileSave` hook
   (`.kiro/hooks/scripts/auto_lint.sh`) runs `ruff check --fix` then
   `ruff format` on every `.py` file right after it's written.
2. On demand, via Makefile targets: `make lint` (check only, no changes),
   `make format` (rewrite via formatter), `make fix` (autofix lint
   violations), `make check` (lint + test — the gate before calling a task
   done).

If you need to change *what* is linted (not *whether* it's blocked
manually), edit `[tool.ruff.lint].select` / `.ignore` /
`[tool.ruff.lint.per-file-ignores]` in `pyproject.toml`, then verify with
`make lint`. Don't add blanket `# noqa` comments to silence a rule across
a whole file — scope ignores to the specific line or rule in
`pyproject.toml`.
