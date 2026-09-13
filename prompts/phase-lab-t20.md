# Phase — Lab T20 only (path-deps + retire local duplicates)

You are claiming **T20 only**. Do not start T21–T24 in this chat.

## Repo

- Skills / lab: `C:\Users\lemsa\Documents\apps\lemsa_packages\skills\`
- Work only in: `lab/` (+ update `spec/lab.md` when done)
- Kits (siblings): `C:\Users\lemsa\Documents\apps\lemsa_packages\<kit>/`

## Read first

1. `spec/tasks/T20-lab-path-deps.md` — **Done when** is the checklist
2. `spec/lab.md`
3. `spec/architecture.md`, `spec/bridge.md`, `spec/errors.md` as needed
4. Public barrels of kits you wire (`lib/<package>.dart`)

## Current lab reality (fix before editing)

Lab is a Task Tracker sandbox that still **reimplements** kit pieces locally and does **not** path-depend the family:

- `pubspec.yaml` has pub `flutter_scale_kit` / `flutter_scale_theme_kit` only — missing path deps on core, page, input, data (+ adapters), nav, app
- Local duplicates to replace with kits, e.g.:
  - `lib/core/notices/material_notices.dart` → `flutter_app_kit`
  - `lib/core/nav/auto_page_navigator.dart` → `flutter_nav_kit`
  - `lib/core/bridge/page_bridge.dart` → page_kit riverpod barrel
  - failure / disposables / loader patterns → `lemsa_core_kit` / `flutter_page_kit`
- Keep feature UI working; prefer kit APIs over inventing new ones

## Do (T20)

1. Add **path** dependencies in `lab/pubspec.yaml` to:

   - `lemsa_core_kit`
   - `flutter_page_kit`
   - `flutter_input_kit`
   - `flutter_data_kit`
   - at least adapters needed to keep current sources compiling (e.g. `flutter_data_kit_dio`, `_supabase`, `_firebase`, `_drift` as required)
   - `flutter_nav_kit`
   - `flutter_app_kit`
   - `flutter_scale_kit` (path or keep pub if published — prefer path `../flutter_scale_kit` for family consistency)
   - `flutter_scale_theme_kit` (same)

2. Delete or empty lab copies of failures / `PageData` / `Disposables` / `Notices` / `PageNavigator` (and Material notices / auto navigator) once imports point at kits.

3. Wire bootstrap toward `flutter_app_kit` where it fits without rewriting the whole product (T23 owns full surface polish).

4. Default backend stays **mock** — no secrets required. Do not implement multi-model (T21) or backend-switch UX (T22) beyond what compile needs.

5. `fvm flutter pub get` → `analyze` → `test` green in `lab/`.

6. Update `spec/lab.md`: lab is the showcase consumer using path kits, not a stub host.

## Do not

- Migrate kiwash / lightnessword
- Publish lab or kits
- Commit / push unless asked
- Invent new kits
- Expand into T21–T24 scope (multi-model, four-backend polish, recruiter README)

## Done when

Every checkbox in `spec/tasks/T20-lab-path-deps.md` **Done when** is true. Summarize files changed + any kit API gaps you had to paper over.
