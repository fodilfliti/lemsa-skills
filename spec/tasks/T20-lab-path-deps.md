# T20 — Lab showcase: path-deps + retire stubs

## Goal

Turn `lab/` into the **only** consumer migration target: depend on real Lemsa kits via path, remove `lab/lib/stubs/` as kits replace them.

## Read first

- [../lab.md](../lab.md)
- [../package.md](../package.md)
- [T06-lemsa-lab.md](T06-lemsa-lab.md) (prior sandbox — do not redo)

## Blocked by

T10–T14 kit packages exist locally with `lib/` (core, page, input, data+adapters, nav, app). Drift/firebase adapters may still be stubbed — use mock/dio/supabase first if needed.

## Done when

- [x] `lab/pubspec.yaml` path-depends on: `lemsa_core_kit`, `flutter_page_kit`, `flutter_input_kit`, `flutter_data_kit` (+ chosen adapters), `flutter_nav_kit`, `flutter_app_kit`, `flutter_scale_kit`, `flutter_scale_theme_kit`
- [x] Lab stubs for failures / PageData / Disposables / Notices / PageNavigator deleted or reduced to zero for shipped kits
- [x] `fvm flutter analyze` + `fvm flutter test` green in `lab/`
- [x] `spec/lab.md` updated: lab is the showcase app, not a stub host

**Status:** done (path-deps + stub retirement landed in lab).

## Do not

- Migrate `kiwash` or `lightnessword` (out of family scope)
- Publish lab to pub.dev
- Commit/push unless user asks
