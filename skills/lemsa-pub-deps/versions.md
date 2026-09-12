# Version floor (Lemsa stack)

Checked 2026-09-01. Search pub.dev for patches only when user asks or adding a new package.

## Core stack

| Package | Version | Min Dart |
| --- | --- | --- |
| Flutter (FVM) | 3.35.7 | — |
| `hooks_riverpod` / `flutter_riverpod` | 3.4.2 | — |
| `riverpod_annotation` | 4.0.6 | — |
| `riverpod_generator` | 4.0.8 | — |
| `riverpod_lint` | 3.1.8 | — |
| `auto_route` | 11.1.0 | — |
| `auto_route_generator` | 10.6.0 | — |
| `slang` / `slang_flutter` | 4.19.0 | — |
| `drift` | 2.34.3 | — |
| `supabase_flutter` | 2.17.2 | — |
| `dio` | 5.11.0 | — |
| `build_runner` | 2.16.0 | — |
| `freezed` | 4.0.1 | — |
| `json_serializable` | 6.14.1 | — |
| `json_annotation` | 4.9.0 | — |

## Codegen / UI additions

| Package | Version | Min Dart | Notes |
| --- | --- | --- | --- |
| `retrofit` | 4.10.0 | 3.8 | Pin 4.6.0 if FVM Dart is 3.7.x |
| `retrofit_generator` | 10.6.0 | — | Pair with build_runner 2.16.0 |
| `copy_with_extension` | 17.0.0 | 3.7 | Drop per-file if analyzer conflict |
| `copy_with_extension_gen` | 17.0.0 | 3.7 | Shares graph with riverpod_generator |
| `loading_indicator` | 4.0.2 | — | Default loading UI |
| `redact` | 0.1.0 | PII scrub before logs |

## Opt-in only

| Package | Version | When |
| --- | --- | --- |
| `loon` | 5.6.1 | User says "use loon" or S12 — never default |

## Compatibility gate

Run after any codegen dependency change:

```bash
fvm dart pub get
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter analyze
```

| Conflict | Action |
| --- | --- |
| copy_with_extension_gen vs riverpod_generator | Remove `@CopyWith()` on conflicting class; hand copyWith or freezed |
| retrofit 4.10 vs Dart 3.7 | Pin `retrofit: 4.6.0` |
| build_runner OOM | Narrow `build.yaml` targets |

## Lemsa family (path during dev)

`flutter_scale_kit`, `flutter_scale_theme_kit` — pub.dev. Others — sibling path deps under `apps/lemsa_packages/` until published.
