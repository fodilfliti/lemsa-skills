---
name: lemsa-pub-deps
description: >
  Check pub.dev versions, compatibility, and Lemsa stack floors when adding or
  upgrading dependencies. Use for latest version of X, check pub versions,
  retrofit riverpod conflict, copy_with_extension, migrate packages, or new
  pubspec entries. Not for routine feature work with a locked pubspec.
license: MIT
metadata:
  author: fodilfliti
  version: "1.0.0"
---

# Lemsa pub dependencies

Load **only** when adding, upgrading, or choosing packages — not every session.

Read [versions.md](versions.md) for the full floor table and compatibility matrix.

## Workflow

1. Read `pubspec.yaml` and `pubspec.lock` — never guess pinned versions.
2. Lemsa family packages: **path** deps during lab/kit dev; pub.dev when publishing.
3. Compare against floor table in `versions.md`.
4. Search pub.dev or `dart pub add package:^x` only if package is new or user asked for latest.
5. Run **compatibility gate** when codegen is touched:
   - `fvm dart pub get`
   - `fvm dart run build_runner build --delete-conflicting-outputs`
   - `fvm flutter analyze`
6. On conflict: drop `@CopyWith()` per-file, or pin older retrofit if Dart SDK < 3.8.
7. Update `versions.md` and propose bump to project docs after confirming.

## Defaults

| Concern | Package | Notes |
| --- | --- | --- |
| HTTP REST | retrofit + dio + json_serializable | DTO at boundary, mapper to domain |
| Domain copyWith | copy_with_extension | Drop on analyzer conflict |
| Provider state == | freezed | Riverpod 3 filters with == |
| Loading UI | loading_indicator | LemsaLoader wrapper |
| Log PII scrub | redact | Before AppLogger / export |
| Local DB | drift | Loon only when user explicitly asks |

## Banned for new apps

- Riverpod 2.x legacy providers, `legacy.dart`
- Mason for scaffolding (use kit-owned CLI)
- get_it / injectable (Riverpod DI only)
- retrofit in pubspec with zero generated usage

## Do / don't

- Do verify FVM Dart SDK vs package min SDK before adding retrofit 4.10+
- Do run build_runner after adding generators
- Don't search pub.dev on every feature edit
- Don't add loon unless user explicitly requests
