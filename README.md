# Godot Save Shape Check — free edition

Compare representative JSON saves from released builds with the current shape before shipping an update. It reports removed paths and type changes as errors, and new paths that need safe defaults as warnings.

```sh
python3 save_shape_check.py --current fixtures/current.json --old fixtures/v1.json fixtures/v2.json
```

Use `--json` for CI output and `--strict` to make warnings fail. Python 3.9+ is enough; the checker has no packages, network calls, telemetry or file writes.

This is a sample-based structural check. It does not run migration code, inspect encrypted or binary saves, compare every possible runtime value, or prove that gameplay still works. Keep real fixtures from each released version, back them up, and test the actual game update.

The full Godot Save Compatibility Guard kit adds sequential migration simulation, a matching Godot runtime helper, broken/fixed fixtures, integration tests and a release checklist.

MIT licensed. Independent community tool; not affiliated with or endorsed by the Godot Foundation.
