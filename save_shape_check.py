#!/usr/bin/env python3
"""Compare released JSON save shapes with a current representative fixture."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys
from typing import Any


def kind(value: Any) -> str:
    if value is None: return "null"
    if isinstance(value, bool): return "boolean"
    if isinstance(value, (int, float)): return "number"
    if isinstance(value, str): return "string"
    if isinstance(value, list): return "array"
    if isinstance(value, dict): return "object"
    raise TypeError(type(value).__name__)


def esc(value: str) -> str:
    return value.replace("~", "~0").replace("/", "~1")


def compare(old: Any, current: Any, path: str = "") -> list[dict[str, str]]:
    display = path or "/"
    old_kind, current_kind = kind(old), kind(current)
    if old_kind != current_kind:
        return [{"severity": "ERROR", "code": "TYPE_CHANGED", "path": display,
                 "message": f"type changed from {old_kind} to {current_kind}"}]
    findings: list[dict[str, str]] = []
    if isinstance(old, dict):
        old_keys, current_keys = set(old), set(current)
        for key in sorted(old_keys - current_keys):
            findings.append({"severity": "ERROR", "code": "REMOVED_PATH",
                             "path": f"{path}/{esc(key)}", "message": "released field is absent from current fixture"})
        for key in sorted(current_keys - old_keys):
            findings.append({"severity": "WARNING", "code": "ADDED_PATH",
                             "path": f"{path}/{esc(key)}", "message": "released fixture lacks the current field; add a safe default"})
        for key in sorted(old_keys & current_keys):
            findings.extend(compare(old[key], current[key], f"{path}/{esc(key)}"))
    elif isinstance(old, list) and old and current:
        before, after = {kind(item) for item in old}, {kind(item) for item in current}
        if before != after:
            findings.append({"severity": "ERROR", "code": "ARRAY_ITEM_TYPES_CHANGED", "path": display,
                             "message": f"array item types changed from {sorted(before)} to {sorted(after)}"})
        elif before == {"object"} and after == {"object"}:
            findings.extend(compare(old[0], current[0], f"{display.rstrip('/')}/*"))
    return findings


def read(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise ValueError(f"{path}: {exc}") from exc


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--current", required=True, type=Path)
    parser.add_argument("--old", required=True, type=Path, nargs="+")
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--strict", action="store_true", help="Fail on added fields as well as breaking changes")
    args = parser.parse_args(argv)
    try:
        current = read(args.current)
        reports = [{"fixture": str(path), "findings": compare(read(path), current)} for path in args.old]
    except ValueError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2
    errors = sum(item["severity"] == "ERROR" for report in reports for item in report["findings"])
    warnings = sum(item["severity"] == "WARNING" for report in reports for item in report["findings"])
    if args.json:
        print(json.dumps({"reports": reports, "summary": {"errors": errors, "warnings": warnings}}, indent=2))
    else:
        for report in reports:
            print(f"FIXTURE {report['fixture']}")
            if not report["findings"]: print("  PASS: no structural changes detected")
            for item in report["findings"]:
                print(f"  {item['severity']} {item['code']} {item['path']}: {item['message']}")
        print(f"SUMMARY: {len(reports)} fixture(s), {errors} error(s), {warnings} warning(s)")
    return 2 if errors else (1 if args.strict and warnings else 0)


if __name__ == "__main__":
    sys.exit(main())
