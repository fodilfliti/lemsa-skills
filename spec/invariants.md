# Invariants

Break these and the family stops composing. Every kit's own `spec/invariants.md` inherits this file and may add to it, never contradict it.

## The form layer is Riverpod-free

`flutter_page_kit` and every `*Data` mixin built on it must not import `flutter_riverpod`, `hooks_riverpod`, or `riverpod_annotation`. Controllers reach services through **abstract getters**; the page supplies them.

Consequence: a controller is unit-testable with plain fakes and no `ProviderScope`. If a controller needs `ref`, the design is wrong — either the dependency belongs in a getter, or the state belongs in a provider.

Banned everywhere, in app code and kit code: `ProviderScope.containerOf(...)`, and any global `BuildContext` singleton used to reach a container.

## Page-pop test decides where state lives

Would this state survive a page pop?

- **Yes** → a Riverpod provider. Session, current user, lists, cached entities, realtime streams, counters, theme mode, locale, connectivity, remote config, and all DI.
- **No** → the controller mixin. Text controllers, focus nodes, validity, stepper index, toggles, submit busy, submit failure.

There is no third home. In particular, page-scoped Riverpod providers overridden per route are not a pattern here.

## Nothing is disposed by hand

Anything with a `dispose()` that a controller creates must be created through a `Disposables` helper (`text()`, `flag()`, `items()`, `keep()`). `PageData.dispose()` walks the registry.

Rationale in [decisions.md](decisions.md) D2. The concrete bug: `lightnessword/lib/features/auth/presentation/controllers/auth_data_mixin.dart` disposes sixteen objects by hand and misses `isHide`, created at line 27.

Corollary: mixin application order must not affect disposal. Only `PageData` overrides `dispose()`.

## Vendor exceptions stop at the adapter

Only `flutter_data_kit_*` packages may import `DioException`, `PostgrestException`, `AuthException`, `FirebaseException`, or `SqliteException`. Each adapter owns exactly one mapper that converts them into a sealed `AppFailure` and throws it.

Above that line, every failure is an `AppFailure`. A vendor type reaching a controller or a widget is a bug in the adapter.

## `try`/`catch` is kept; empty `catch` is banned

`AppFailure implements Exception`, so sequential steps read naturally and each step keeps its own recovery. Nested `try`/`catch` inside one action is expected.

`empty_catches` is promoted to an **error** in every kit's `analysis_options.yaml`. A caught failure is either handled, rethrown, or reported — never dropped.

## `Result<T>` is for branching, not for plumbing

Return `Result<T>` only where the caller must branch on an expected outcome. Do not thread `Result` through a chain of sequential awaits; unwrapping at every step is exactly the readability failure that made the pattern unpopular. `Result.guard()` converts a throwing call into a `Result` at the one place that needs it.

## Actions are data; shells place them

A controller exposes `List<PageAction> get actions` and never decides where they render. Placement belongs to the shell (`ActionSlot`), which is the only thing allowed to branch on `context.isMobile` / `isTablet` / `isDesktop`.

Consequence: the same controller mounts as `FormPage`, `FormSheet`, `FormDialog`, or `FormPanel` unchanged.

## Loading has three owners, never one flag

- Read loading belongs to the provider feeding that region, rendered by `AsyncView`. Regions load and fail independently.
- Write loading belongs to the controller, **keyed** (`busy.of('save')`, `busy.of(('delete', id))`). A single page-wide bool is banned because it makes one action block an unrelated one.
- Blocking overlays are opt-in per action, never the default.

Never block to navigate. Push the destination and let it render its own skeleton.

## Riverpod: no legacy APIs

Banned: `StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider`, and `import 'package:hooks_riverpod/legacy.dart'`. All providers are declared with `@riverpod` codegen. Parameters on `build()` replace `.family`.

Provider state classes need real value equality (freezed or equivalent) because Riverpod 3 filters notifications with `==`.

## `keepAlive` is enumerable

The list of `@Riverpod(keepAlive: true)` providers in an app must fit on one screen and is recorded in the app's own docs. Nothing `keepAlive` may hold user data in memory — that is how state leaks across sign-out.

User-scoped state is session-scoped **by dependency** (watch the session's user id), not by a hand-maintained invalidation list.

## Providers are caches, not storage

Provider state dies with the process regardless of `keepAlive`. Anything that must survive a restart goes to Drift (entities), `shared_preferences` (scalars), or `flutter_secure_storage` (tokens and credentials).

Credentials are never written to `shared_preferences`. Both reference apps currently store `password_user` in plaintext there; that is the anti-pattern this rule exists for.

## Sign-out clears three layers

Providers (automatic, via session dependency), local database (`deleteUserData()`), and secure storage. Sign-out performs **no navigation** — the router reacts to the session change.

## Skills are self-contained

`npx skills add` copies one directory. A `SKILL.md` may not link to `spec/`, to the repo root, or to another skill's files. Cross-skill needs are expressed in prose.

## Generation stays testable

A kit's `gen` CLI keeps parse/emit logic in a Flutter-free, `dart:io`-free core library. Only `bin/` touches the filesystem.

Generated files are never edited by hand and never overwrite a user's hand-written file without an explicit flag.

## Tests to extend when you touch

This repo has no tests. When a rule here changes, the test that enforces it lives in the affected kit repo — add or adjust it there in the same change, and note it in that kit's `spec/`.
