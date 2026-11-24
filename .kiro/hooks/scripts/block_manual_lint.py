#!/usr/bin/env python3
"""PreToolUse guard: agents must not invoke ruff directly from the shell.

Linting/formatting is handled automatically by:
  - the `auto-lint-on-save` PostFileSave hook (formats + autofixes on every
    *.py write), and
  - the `make lint` / `make format` / `make fix` / `make check` targets,
    which agents should use instead of calling `ruff` by hand.

Reads the V3 PreToolUse hook payload on stdin:
    {"hook_event_name": "PreToolUse", "tool_name": "execute_bash",
     "tool_input": {"command": "..."}, ...}
"""

import json
import re
import sys


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        return 0

    command = str(payload.get("tool_input", {}).get("command", ""))

    if re.search(r"\bruff\b", command):
        sys.stderr.write(
            "Blocked: do not run `ruff` directly.\n"
            "Use `make lint` (check only), `make format` / `make fix` "
            "(rewrite files), or `make check` (lint + test) instead.\n"
            "Note: *.py files are also auto-linted/formatted on save by the "
            "auto-lint-on-save hook.\n"
        )
        return 2

    return 0


if __name__ == "__main__":
    sys.exit(main())
