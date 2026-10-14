# Godot Asset Store submission — v0.2.0

This file contains the reviewed listing data submitted to the official Godot Asset Store for manual moderation on 2026-10-14. The authenticated Overview reports `Asset Status: Pending`.

## Listing

- **Name:** Godot Save Shape Check
- **Summary:** Compare released JSON save fixtures with the current save shape before shipping a Godot update.
- **Asset type:** Addon
- **License:** MIT
- **Source:** https://github.com/karden335/godot-save-shape-check
- **Minimum Godot version:** 4.4
- **Maximum Godot version:** leave empty
- **Version:** 0.2.0
- **Tags:** Save System, Editor Tool, Testing, JSON, Compatibility
- **Archive:** `dist/godot-save-shape-check-0.2.0.zip`
- **Thumbnail:** `media/store-thumbnail.jpg` (1280×720, 16:9, 86.6 KB)

## Detailed description

Godot Save Shape Check is a local editor plugin for comparing representative JSON saves from released builds with the current save shape before shipping an update.

Choose one current fixture and one or more released fixtures in the Save Shape Check dock. Removed fields, changed value types and changed array item types are reported as errors. New fields are reported as warnings so you can add safe defaults.

The plugin reads local files only. It has no network requests, uploads, telemetry, service account or package dependencies. Example fixtures are included.

This is a sample-based structural check. It does not run migration code, inspect encrypted or binary saves, compare every runtime value, or prove that gameplay still works. Back up saves and test the actual exported update.

The repository also includes a dependency-free Python CLI and GitHub Action for CI. An optional paid migration kit is available at https://karrden.itch.io/godot-save-compatibility-guard.

Independent community tool; not affiliated with or endorsed by the Godot Foundation.

## AI usage disclosure

Code and listing text used AI assistance. Verified with 4 Python tests, 6 headless GDScript tests, an end-to-end dock test, archive validation, and Godot editor startup on 4.4.1 and 4.7.2.

## Review checklist

- [x] Add-on works without paid dependencies.
- [x] `LICENSE` and `README.md` are inside the add-on folder.
- [x] Archive contains only `addons/save_shape_check/`.
- [x] Source repository has a root MIT license and `.gitignore`.
- [x] Store thumbnail is a 1280×720 JPEG (16:9) below the 600 KB limit.
- [x] English name and description use full sentences.
- [x] AI assistance is disclosed.
- [x] No pop-up or in-editor advertisement for the paid version.
- [x] Godot 4.4.1 and 4.7.2 load the enabled plugin and pass the analyzer and dock tests.
- [x] Publisher `Karrden` (`karrden`) is signed in and the asset Draft exists.
- [x] Required listing fields, thumbnail, source URL, AI disclosure and five tags are saved.
- [x] Stable version 0.2.0 is uploaded with minimum Godot 4.4 and no maximum.
- [x] Listing has been submitted for manual review; current asset status is `Pending`.
