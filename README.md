# pv


Python 3.14 project scaffold: `pyproject.toml` (hatchling, src layout),
ruff (lint + format), pytest, and a stdlib-`venv`-based workflow.

## Setup

```sh
make install   # creates .venv (python3.14 -m venv .venv) and installs -e ".[dev]"
```

## Everyday commands

| Command        | What it does                              |
|-----------------|--------------------------------------------|
| `make venv`     | create `.venv` with `python3.14`          |
| `make install`  | venv + `pip install -e ".[dev]"`          |
| `make lint`     | `ruff check .` (no changes)               |
| `make format`   | `ruff format .` (rewrite files)           |
| `make fix`      | `ruff check --fix .` (autofix lint)       |
| `make test`     | `pytest`                                   |
| `make check`    | lint + test — run before calling work done |
| `make clean`    | remove `.venv` and caches                 |

## Layout

```
pyproject.toml
Makefile
src/pv/          # package code
tests/           # pytest tests, mirrors src/pv/
.kiro/agents/    # python-planner, python-developer, python-checker
.kiro/skills/    # venv / packaging / typing / pytest / ruff skills
.kiro/hooks/     # auto-lint-on-save, block-manual-lint
```

## AI workflow (Kiro agents)

Three custom agents in `.kiro/agents/` split planning, implementation, and
verification:

- **python-planner** — reads the request + codebase, writes an ordered,
  testable task list to `TASKS.md`. Read-only against source; no shell.
- **python-developer** — implements tasks from `TASKS.md`, writes/updates
  code and tests, runs `make test`. Cannot run `ruff` itself.
- **python-checker** — runs `make check`, reads the output, and reports
  which `TASKS.md` items actually pass. Read + shell only, no write access.

### Linting is automatic, not agent-driven

Agents are blocked from invoking `ruff` directly (a `PreToolUse` hook,
`.kiro/hooks/block-manual-lint.json`, rejects any shell command containing
`ruff`). Instead:

- every saved `.py` file is auto-fixed and formatted by the
  `auto-lint-on-save` `PostFileSave` hook
  (`.kiro/hooks/scripts/auto_lint.sh`);
- on-demand checks go through `make lint` / `make format` / `make fix` /
  `make check`.

### Skills

Five skills in `.kiro/skills/` back the agents above and match this
project's actual stack:

1. `python-venv-workflow` — stdlib `venv` + pip workflow.
2. `python-packaging` — `pyproject.toml`, src layout, hatchling.
3. `python-typing` — Python 3.14 typing conventions (built-in generics,
   `X | None`, PEP 695 generics).
4. `python-testing-pytest` — pytest structure, fixtures, parametrize.
5. `python-linting-ruff` — ruff config and the automated lint/format flow.

### Suggested MCP servers (not installed)

Not configured here — add via `.kiro/settings/mcp.json` if you want them:

- **Context7** — current, version-pinned docs for whatever libraries you
  add (FastAPI, SQLAlchemy, pydantic, etc.) instead of relying on
  possibly-stale training data.
- **GitHub MCP** — drive issues/PRs/CI for this repo from the agent loop.
- **Jupyter MCP Server** — cell-level execute/inspect if any data/ML
  exploration work lands in this project.
- **Postgres/SQLite MCP (read-only mode)** — safe schema/query
  introspection if/when this grows a database layer.
- **Sentry MCP** — pull production errors/stack traces back into the
  agent loop once this ships somewhere.
