---
name: lemsa-flutter
description: >
  Set up and build Flutter apps the Lemsa way. Read lemsa.yaml first; if missing,
  ask once and write it. Use for new features, page controllers (*Data mixins),
  Riverpod 3 state/, backend adapters, auto_route, slang i18n, flutter_scale_kit
  + theme_kit, form shells, or when the user says Lemsa architecture / lemsa.yaml /
  page kit / migrate to my stack.
license: MIT
metadata:
  author: fodilfliti
  version: "1.0.0"
---

# Lemsa Flutter (consumer)

You are implementing apps using the Lemsa package family and architecture — not building the kits themselves unless asked.

Read sibling files only when needed:

- First-time setup → [init.md](init.md)
- Which package for what → [routing.md](routing.md)
- Folder layout and rules → [architecture.md](architecture.md)

Also load when the task touches them (install separately if missing):

- `flutter-scale-kit` / `flutter-scale-theme-kit` — if pubspec lists them
- `flutter-riverpod3` — any provider or state question
- `flutter-autoroute` — navigation
- `flutter-slang` — translations
- `flutter-drift` — local SQL
- `flutter-supabase` / `flutter-firebase` / `flutter-dio` — backend
- `lemsa-pub-deps` — adding or upgrading pub dependencies

## Check first

1. Read `lemsa.yaml` at the app root.
2. If missing → run the ask-once ritual in [init.md](init.md), write the file, then proceed.
3. Read `scale_kit.yaml` / `.scalekit.yaml` for UI style if present.

## The two rules (non-negotiable)

1. **Page-pop test:** state that survives a page pop → Riverpod. Ephemeral form state → controller mixin. No third home.
2. **Form layer never imports Riverpod.** The page is the bridge via abstract getters.

## Default stack

| Concern | Default |
| --- | --- |
| Size | `flutter_scale_kit` + `ScaleKitBuilder` |
| Look | `flutter_scale_theme_kit` + merge `createResponsiveTextTheme` |
| Forms | `flutter_page_kit` mixins + `flutter_input_kit` fields |
| State | Riverpod 3 codegen only — no legacy providers |
| Nav | `auto_route` + `flutter_nav_kit` `PageNavigator` |
| i18n | `slang` typed `t.*` |
| Local DB | Drift; prefs for scalars; secure storage for tokens |
| Errors | `AppFailure` from `lemsa_core_kit`; per-step try/catch in controllers |
| Loading | `loading_indicator` via `LemsaLoader` — not raw `CircularProgressIndicator` |

## New feature checklist

1. `lib/features/<name>/domain/` — models, drafts, queries
2. `data/` — source + repository (throws AppFailure)
3. `state/<name>_providers.dart` — all `@riverpod` here
4. `controllers/<name>_form_data.dart` — mixin, no riverpod
5. `pages/<name>_page.dart` — ConsumerState + bridge getters
6. Route in app router
7. slang keys for user-visible strings

Generate scaffold: `dart run flutter_page_kit:gen page <feature>/<name>` when the CLI exists.

## Do / don't

- Do use `LemsaLoader` / `loading_indicator` for read and write loading states
- Do use `PageScope<T>` instead of hand-copied `*DataProvider`
- Do use `run(key:)` + keyed `busy` for writes; `AsyncView` per region for reads
- Do declare `List<PageAction> actions` — shells place buttons
- Do use `onSaved()` callback to upsert lists (default `list_updates: callback`)
- Don't use `ProviderScope.containerOf(GetAppContext.context!)`
- Don't empty `catch (e) {}`
- Don't put passwords in SharedPreferences
- Don't use `StateNotifierProvider`, `ChangeNotifierProvider`, or `legacy.dart`
- Don't navigate from `ref.listen` — router guard handles session
- Don't import `lib/index.dart` mega-barrel in new code — explicit imports

## After setup

Follow `lemsa.yaml` for backend, nav, i18n, and style. When in doubt, [routing.md](routing.md).
