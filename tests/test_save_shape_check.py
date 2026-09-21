from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
FIXTURES = ROOT / "fixtures"
if not FIXTURES.exists():
    FIXTURES = ROOT.parent / "samples/fixtures"
SPEC = importlib.util.spec_from_file_location("save_shape_check", ROOT / "save_shape_check.py")
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)


class SaveShapeCheckTests(unittest.TestCase):
    def setUp(self) -> None:
        self.current = json.loads((FIXTURES / "current.json").read_text())
        self.v1 = json.loads((FIXTURES / "v1.json").read_text())

    def test_identical_fixture_passes(self) -> None:
        self.assertEqual([], MODULE.compare(self.current, self.current))

    def test_breaking_and_additive_changes_are_separate(self) -> None:
        findings = MODULE.compare(self.v1, self.current)
        errors = {item["code"] for item in findings if item["severity"] == "ERROR"}
        warnings = {item["code"] for item in findings if item["severity"] == "WARNING"}
        self.assertEqual({"REMOVED_PATH"}, errors)
        self.assertEqual({"ADDED_PATH"}, warnings)

    def test_cli_reports_breaks_as_exit_two(self) -> None:
        process = subprocess.run([
            sys.executable, str(ROOT / "save_shape_check.py"),
            "--current", str(FIXTURES / "current.json"),
            "--old", str(FIXTURES / "v1.json"), "--json",
        ], capture_output=True, text=True, check=False)
        self.assertEqual(2, process.returncode)
        self.assertGreater(json.loads(process.stdout)["summary"]["errors"], 0)

    def test_invalid_json_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            broken = Path(directory) / "broken.json"
            broken.write_text("{", encoding="utf-8")
            process = subprocess.run([
                sys.executable, str(ROOT / "save_shape_check.py"),
                "--current", str(FIXTURES / "current.json"),
                "--old", str(broken),
            ], capture_output=True, text=True, check=False)
            self.assertEqual(2, process.returncode)
            self.assertIn("ERROR:", process.stderr)


if __name__ == "__main__":
    unittest.main()
