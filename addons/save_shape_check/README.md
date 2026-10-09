# Save Shape Check

Save Shape Check is a Godot 4 editor plugin for comparing representative JSON saves from released builds with the current save shape before shipping an update.

It reports:

- removed fields and changed value types as errors;
- changed array item types as errors;
- new fields that need safe defaults as warnings.

## Use

1. Enable **Save Shape Check** in **Project > Project Settings > Plugins**.
2. Open the **Save Shape Check** dock.
3. Select one representative JSON fixture from the current build.
4. Select one or more JSON fixtures captured from released builds.
5. Run the compatibility check.

Files are read locally. The plugin makes no network requests, writes no project data, and includes no telemetry.

This is a sample-based structural check. It does not run migration code, inspect encrypted or binary saves, compare every runtime value, or prove that gameplay still works. Back up saves and test the actual exported update.

The optional [Godot Save Compatibility Guard](https://karrden.itch.io/godot-save-compatibility-guard) kit adds sequential migration simulation, a matching runtime helper, fixtures, tests and a release checklist.

MIT licensed. Independent community tool; not affiliated with or endorsed by the Godot Foundation.

