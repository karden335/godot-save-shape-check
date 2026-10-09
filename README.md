# Godot Save Shape Check — free edition

Compare representative JSON saves from released builds with the current shape before shipping an update. It reports removed paths and type changes as errors, and new paths that need safe defaults as warnings.

## Godot editor plugin

Install `addons/save_shape_check` in a Godot 4.4+ project, enable **Save Shape Check** under **Project > Project Settings > Plugins**, and use the new dock to select the current JSON fixture plus one or more fixtures from released builds. The editor plugin is implemented in GDScript and does not require Python.

The ready-to-install add-on archive is attached to each release. The repository also keeps the dependency-free command-line checker for local scripts and CI.

## Command line

```sh
python3 save_shape_check.py --current fixtures/current.json --old fixtures/v1.json fixtures/v2.json
```

Use `--json` for CI output and `--strict` to make warnings fail. Python 3.9+ is enough; the checker has no packages, network calls, telemetry or file writes.

This is a sample-based structural check. It does not run migration code, inspect encrypted or binary saves, compare every possible runtime value, or prove that gameplay still works. Keep real fixtures from each released version, back them up, and test the actual game update.

The full [Godot Save Compatibility Guard](https://karrden.itch.io/godot-save-compatibility-guard) kit ($7) adds sequential migration simulation, a matching Godot runtime helper, broken/fixed fixtures, integration tests and a release checklist.

MIT licensed. Independent community tool; not affiliated with or endorsed by the Godot Foundation.

AI disclosure: code and text were created with AI assistance and validated with automated Python and headless Godot tests plus editor startup QA.
