---
name: flutter-riverpod3
description: >
  Riverpod 3 with riverpod_generator in Lemsa apps. Use for @riverpod providers,
  Notifier/AsyncNotifier/StreamNotifier, AsyncView, session scoping, when NOT to
  use Riverpod (form layer), banning legacy providers, or migrating from 2.x.
license: MIT
metadata:
  author: fodilfliti
  version: "1.0.0"
---

# Flutter Riverpod 3 (Lemsa)

Floor versions: `hooks_riverpod` 3.4.2, `riverpod_generator` 4.0.8, `riverpod_lint` 3.1.8.

## When NOT to use Riverpod

Form state (controllers, TextEditingController, stepper, submit busy) lives in **page mixins**, not providers. If it would not survive a page pop, it is not a provider.

## Provider kinds

| Returns | Use for |
| --- | --- |
| Function `@riverpod T` | Stateless deps: repos, clients, navigator |
| Class `T` | Notifier: theme, filters |
| `Future<T>` | AsyncNotifier: load + mutate |
| `Stream<T>` | StreamNotifier: auth, chat, connectivity |

Parameters on `build()` replace `.family`.

## Banned

- `StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider`
- `import 'package:hooks_riverpod/legacy.dart'`
- `ProviderScope.containerOf(...)`
- Riverpod 3 mutations (submit state is in controller)
- `listenManual`

## DI

All deps are `@riverpod`. Pre-runApp:

```dart
ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)], child: App())
```

Remove get_it and injectable.

## Session

`@Riverpod(keepAlive: true) Stream<SessionState> session` feeds AuthGuard. User-scoped providers watch `sessionProvider.select((s) => s.userId)`.

## AsyncValue

Use `AsyncView` from flutter_page_kit. Unwrap `ProviderException` to get `AppFailure`.

## ref.listen

Only fire-once UI effects (toast, dialog). Never navigate; never copy provider state into controller fields.

## Migration 2→3

1. Pin exact versions
2. Run riverpod_lint dart fix
3. Replace legacy providers with @riverpod
4. Add custom_lint to analysis_options

## State equality

Use freezed on provider state classes — Riverpod 3 filters with `==`.

## File rule

One `state/<feature>_providers.dart` per feature — all @riverpod declarations there.
