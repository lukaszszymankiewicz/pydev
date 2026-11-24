PYTHON  ?= python3.14
VENV    := .venv
BIN     := $(VENV)/bin

.PHONY: help venv install test lint format fix check clean

help:
	@echo "Targets:"
	@echo "  make venv     - create .venv with $(PYTHON) (uses the stdlib venv module)"
	@echo "  make install  - create venv (if needed) and install package + dev deps"
	@echo "  make lint     - run ruff check (no changes)"
	@echo "  make format   - run ruff format (rewrites files)"
	@echo "  make fix      - run ruff check --fix (autofix lint issues)"
	@echo "  make test     - run pytest"
	@echo "  make check    - lint + test (use before considering a task done)"
	@echo "  make clean    - remove venv and caches"

$(VENV)/bin/python:
	$(PYTHON) -m venv $(VENV)

venv: $(VENV)/bin/python

install: venv
	$(BIN)/pip install --upgrade pip
	$(BIN)/pip install -e ".[dev]"

lint: venv
	$(BIN)/ruff check .

format: venv
	$(BIN)/ruff format .

fix: venv
	$(BIN)/ruff check --fix .

test: venv
	$(BIN)/pytest

check: lint test

clean:
	rm -rf $(VENV) .pytest_cache .ruff_cache
	find . -type d -name "__pycache__" -exec rm -rf {} +
