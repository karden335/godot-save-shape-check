# Godot Asset Store submission — v0.2.0

This file contains the reviewed listing data for the official Godot Asset Store. It does not mean the asset has been submitted.

## Listing

- **Name:** Godot Save Shape Check
- **Summary:** Compare released JSON save fixtures with the current save shape before shipping a Godot update.
- **Asset type:** Addon
- **License:** MIT
- **Source:** https://github.com/karden335/godot-save-shape-check
- **Minimum Godot version:** 4.4
- **Maximum Godot version:** leave empty
- **Version:** 0.2.0
- **Tags:** Save Games, JSON, Compatibility, QA, Editor Tool, Testing
- **Archive:** `dist/godot-save-shape-check-0.2.0.zip`
- **Thumbnail:** `media/icon.png`

## Detailed description

Godot Save Shape Check is a local editor plugin for comparing representative JSON saves from released builds with the current save shape before shipping an update.

Choose one current fixture and one or more released fixtures in the Save Shape Check dock. Removed fields, changed value types and changed array item types are reported as errors. New fields are reported as warnings so you can add safe defaults.

The plugin reads local files only. It has no network requests, uploads, telemetry, service account or package dependencies. Example fixtures are included.

This is a sample-based structural check. It does not run migration code, inspect encrypted or binary saves, compare every runtime value, or prove that gameplay still works. Back up saves and test the actual exported update.

The repository also includes a dependency-free Python CLI and GitHub Action for CI. An optional paid migration kit is available at https://karrden.itch.io/godot-save-compatibility-guard.

Independent community tool; not affiliated with or endorsed by the Godot Foundation.

## AI usage disclosure

Code and listing text were created with AI assistance. The release was checked with four Python unit tests, six headless GDScript analyzer tests, a headless end-to-end dock test, deterministic archive validation and Godot editor startup QA on Godot 4.4.1 and 4.7.2.

## Review checklist

- [x] Add-on works without paid dependencies.
- [x] `LICENSE` and `README.md` are inside the add-on folder.
- [x] Archive contains only `addons/save_shape_check/`.
- [x] Source repository has a root MIT license and `.gitignore`.
- [x] English name and description use full sentences.
- [x] AI assistance is disclosed.
- [x] No pop-up or in-editor advertisement for the paid version.
- [x] Godot 4.4.1 and 4.7.2 load the enabled plugin and pass the analyzer and dock tests.
- [ ] Publisher has signed in to the Godot account system.
- [ ] Listing has been submitted for manual review.
