# Godot Save Shape Check v0.2.0

The free checker now includes an installable Godot editor plugin.

## Included

- Save Shape Check editor dock for selecting current and released JSON fixtures.
- Local GDScript analyzer with no Python or package dependency.
- Clear errors for removed fields, changed types and changed array item types.
- Warnings for newly added fields that need safe defaults.
- Example fixtures and an add-on-only archive for direct installation.
- Existing dependency-free Python CLI and GitHub Action remain available for CI.

## Install

Extract `godot-save-shape-check-0.2.0.zip` into the root of a Godot 4.4+ project. Enable **Save Shape Check** under **Project > Project Settings > Plugins**, then open the Save Shape Check dock.

## Verification

- 4 Python unit tests.
- 6 headless GDScript analyzer tests.
- Headless end-to-end dock flow, including invalid JSON.
- Deterministic archive layout validation.
- Headless Godot editor startup with the plugin enabled.
- The GDScript tests and editor startup passed on Godot 4.4.1 and 4.7.2.

Files stay local. This release has no network requests, telemetry, service account or package dependency.

AI disclosure: code and text were created with AI assistance, then checked using the tests and editor startup steps listed above.
