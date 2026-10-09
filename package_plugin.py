#!/usr/bin/env python3
"""Build the Asset Store archive and verify its installable layout."""

from __future__ import annotations

import argparse
from pathlib import Path
import zipfile


ROOT = Path(__file__).resolve().parent
ADDON = ROOT / "addons" / "save_shape_check"
VERSION = "0.2.0"
OUTPUT = ROOT / "dist" / f"godot-save-shape-check-{VERSION}.zip"
REQUIRED = {
    "addons/save_shape_check/LICENSE",
    "addons/save_shape_check/README.md",
    "addons/save_shape_check/plugin.cfg",
    "addons/save_shape_check/plugin.gd",
    "addons/save_shape_check/save_shape_analyzer.gd",
    "addons/save_shape_check/save_shape_dock.gd",
}


def source_files() -> list[Path]:
    return sorted(path for path in ADDON.rglob("*") if path.is_file() and not path.name.endswith(".uid"))


def build(output: Path = OUTPUT) -> Path:
    output.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(output, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for path in source_files():
            info = zipfile.ZipInfo(path.relative_to(ROOT).as_posix())
            info.date_time = (2026, 1, 1, 0, 0, 0)
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o644 << 16
            archive.writestr(info, path.read_bytes())
    return output


def verify(path: Path) -> None:
    with zipfile.ZipFile(path) as archive:
        names = set(archive.namelist())
        missing = REQUIRED - names
        if missing:
            raise SystemExit(f"archive is missing required files: {sorted(missing)}")
        unexpected = [name for name in names if not name.startswith("addons/save_shape_check/")]
        if unexpected:
            raise SystemExit(f"archive contains files outside the add-on: {unexpected}")
        if any(name.endswith((".uid", ".DS_Store")) or "__pycache__" in name for name in names):
            raise SystemExit("archive contains generated files")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="build and verify the archive without extra output")
    args = parser.parse_args()
    output = build()
    verify(output)
    if not args.check:
        print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

