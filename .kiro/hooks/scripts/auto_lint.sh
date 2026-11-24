#!/bin/sh
# PostFileSave hook: automatically fix lint issues and format a saved .py file.
# Invoked as: auto_lint.sh <file-path>
set -eu

FILE="${1:-}"
if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
    exit 0
fi

if [ -x ".venv/bin/ruff" ]; then
    RUFF=".venv/bin/ruff"
elif command -v ruff >/dev/null 2>&1; then
    RUFF="ruff"
else
    # No ruff available (venv not created yet) - nothing to do.
    exit 0
fi

"$RUFF" check --fix --quiet "$FILE" || true
"$RUFF" format --quiet "$FILE" || true

exit 0
