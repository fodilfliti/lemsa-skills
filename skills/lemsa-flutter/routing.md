# Routing — which kit for what

| Need | Package / skill |
| --- | --- |
| Responsive size, SK widgets, tokens | `flutter_scale_kit` + its skill |
| Theme, `context.st`, colors | `flutter_scale_theme_kit` + its skill |
| AppFailure, Result, Disposables | `lemsa_core_kit` |
| Page mixin, FormPage, busy, run() | `flutter_page_kit` |
| EmailField, Validators | `flutter_input_kit` |
| PagedList, Dio/Supabase adapters | `flutter_data_kit` + `_dio` / `_supabase` |
| PageNavigator, AuthGuard | `flutter_nav_kit` |
| bootstrap, secure storage, flavors | `flutter_app_kit` |
| @riverpod rules | `flutter-riverpod3` skill |
| Routes, deep links | `flutter-autoroute` skill |
| Translations | `flutter-slang` skill |
| Local SQL | `flutter-drift` skill |

## Codegen

| Output | Tool |
| --- | --- |
| Providers | `riverpod_generator` + build_runner |
| Routes | `auto_route_generator` |
| i18n | `slang_build_runner` |
| Drift | `drift_dev` |
| Models | `freezed` + `json_serializable` |
| Page scaffold | `dart run flutter_page_kit:gen page ...` |

## When to skill vs package

- **Package** — runtime API you import in Dart
- **Skill** — conventions for a third-party package (Riverpod, Supabase) or cross-cutting rules
- **Spec** (in skills repo) — why; agents editing kits read spec, app agents read skills

## Pub names (verified free)

`lemsa_core_kit`, `flutter_page_kit`, `flutter_input_kit`, `flutter_data_kit`, `flutter_nav_kit`, `flutter_app_kit`

Taken — do not use: `flutter_core_kit`, `flutter_form_kit`, `flutter_base_kit`
