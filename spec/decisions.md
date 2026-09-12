# Decisions

Record *why*. Update this file when the trade-off changes.

## D1 — Keep the `State` mixin; do not move to a Riverpod Notifier

**Choice:** the page controller stays `mixin XData<T extends StatefulWidget> on State<T>, PageData<T>`. Not a `Notifier`, not a plain class.

**Why:** it is the pattern that already exists in `lightnessword` and it keeps the form layer free of Riverpod, which is a deliberate goal — form state is ephemeral, dies with the page, and does not benefit from a provider's lifecycle. Extending by mixin is also how the codebase already composes behaviour (`FormDataMixin` + feature mixin).

**Cost, accepted:** tests need a widget rather than a plain constructor. Paid down by `PageHarness` (D6).

**Do not:** reintroduce `ref` into a controller, or add a Riverpod dependency to `flutter_page_kit`.

## D2 — Auto-dispose registry instead of hand-written `dispose()`

**Choice:** fields are created through `text()` / `flag()` / `items()` / `keep()`, which register a disposer. Only `PageData` overrides `dispose()`.

**Why:** hand-written dispose lists fail silently and cannot be enforced by review. `auth_data_mixin.dart` already leaks `isHide`. It also removes the mixin-application-order trap, where `with FormDataMixin, XData` and `with XData, FormDataMixin` behave differently.

**Do not:** allow a controller to construct a disposable directly.

## D3 — Typed throwable failures, not `Result` everywhere

**Choice:** `AppFailure` is a sealed class that `implements Exception`. Adapters throw it. Controllers catch it per step. `Result<T>` is offered only where the caller must branch on an expected outcome.

**Why:** `Result` at every layer forces manual unwrapping at every sequential await, which is the documented readability failure of the pattern. Throwing a *typed* failure keeps sequential code linear while still giving exhaustive `switch` and `on SpecificFailure catch` per-step recovery. The 2026 consensus is Result at the repository boundary, try/catch for pipelines — this takes both halves.

**Do not:** thread `Result` through a chain, or let a vendor exception escape an adapter.

## D4 — Riverpod is the only DI; `get_it` and `injectable` are removed

**Choice:** every dependency is a `@riverpod` provider. `ProviderScope(overrides: [...])` covers the pre-`runApp` case.

**Why:** two DI systems in one app means two lifecycles, two override stories, and no way to scope. Riverpod already gives test overrides and disposal. `lightnessword` currently carries `get_it` + `injectable` + `injectable_generator` + a generated config file to register what providers would express directly; `kiwash` uses `get_it` for three singletons.

**Do not:** keep a global service locator "just for `main()`". Override the provider instead.

## D5 — Session-scoping by dependency, not by an invalidation list

**Choice:** user-scoped providers watch the session's user id (or take it as a build parameter). Sign-out disposes them automatically.

**Why:** a manual "invalidate these on sign-out" list rots the first time someone adds a provider and forgets. Making the dependency explicit moves the guarantee into the type graph.

**Do not:** mark user data `keepAlive: true` and clean it up by hand.

## D6 — `PageHarness` instead of abandoning the mixin

**Choice:** `flutter_page_kit` ships a test harness that mounts a bare host widget and returns the controller.

**Why:** it removes the only real objection to D1. Without it, "the mixin is hard to test" would eventually push the design toward a Notifier and break the Riverpod-free rule.

## D7 — Actions as data, placement in the shell

**Choice:** controllers expose `List<PageAction>`; `ActionSlot.auto` decides bottom bar vs app bar vs inline vs FAB.

**Why:** the same form appears in both reference apps as a full screen, a bottom sheet, a dialog, and a `panara_dialogs` variant, rebuilt by hand each time. Making placement a shell concern means one controller serves all four. It also confines responsive branching to one place, which is what `flutter_scale_kit`'s own guidance reserves `SKResponsive` for — structure, not padding.

**Cost, accepted:** bespoke screens do not fit the shells. They build their own tree and call `controller.submit()` directly. That is documented, not a failure.

## D8 — Keyed busy map, not a page-wide `busy` bool

**Choice:** `run(key: ...)` with `busy.any` / `busy.of(key)`.

**Why:** one bool cannot express "the delete on row 3 is running while a photo uploads", and it makes the double-tap guard block unrelated actions. Records as keys (`('delete', id)`) give per-row spinners for free.

## D9 — Own Dart CLI, not Mason

**Choice:** `dart run <kit>:gen ...` per kit.

**Why:** `mason_cli` is at 0.1.3 (Nov 2025) and near-dormant, needs a separate global install, and a brick cannot read `pubspec.yaml` or `lemsa.yaml` to decide what to emit. A package-owned CLI version-locks with the API the generated code imports. The pattern is already proven in `flutter_scale_theme_kit/bin/generate.dart`.

**Do not:** add `build_runner` to a kit unless the ecosystem requires it (riverpod, auto_route, slang, drift, freezed, json_serializable).

## D10 — One `lemsa.yaml`, not one config file per kit

**Choice:** a single root file with per-kit sections. `scale_kit.yaml` stays supported for back-compat.

**Why:** the ask-once/write-once ritual is the reason `scale_kit.yaml` works, and it is worth generalizing. Seven separate config files would mean seven interrogations on a new project.

**Do not:** let a kit read a key it does not own. Ownership is listed in [lemsa-yaml.md](lemsa-yaml.md).

## D11 — Drift for local SQL; retire ReaxDB, Loon, Isar, Hive

**Choice:** Drift is the local database. `shared_preferences` for scalars, `flutter_secure_storage` for secrets.

**Why:** SQL-first with codegen matches a Postgres server background, queries are typed and reactive, migrations are testable, and it works on web. `drift_postgres` lets the same typed query code target the server. As of 2026 Isar and classic Hive are stalled and depend on community forks; `reaxdb_dart` (lightnessword) and `loon` (kiwash) are single-app dead ends.

**Do not:** use Riverpod's built-in Notifier persistence for entities. Scalars only, if at all.

## D12 — Separate repos per kit, adapters excepted

**Choice:** one git repo per package, mirroring `flutter_scale_kit`. `flutter_data_kit` plus its adapters share one repo via pub workspaces.

**Why:** separate repos keep each package's issues, releases and CI independent, matching the existing published pair. Adapters are the exception because they are version-locked to the contract they implement — five repos for one contract change is coordination cost with no benefit.

## D13 — Agent memory is spec + rules, not README

**Choice:** inherited from `flutter_scale_kit` D7. `spec/` is the brain, `skills/` is the enforcement surface, `README.md` is for humans.

**Why:** READMEs are long, promotional, and duplicate recipes. Spec is short, structured, and versioned so every agent, session and machine sees the same thing.

## D14 — `ref.listen` narrowed, not removed

**Choice:** `ref.listen` survives only for fire-once UI effects. Navigation moves to the router guard, state-copying is banned, provider-to-provider reactions move into the Notifier's `build()`.

**Why:** the error-ownership rule (an action's failure belongs to the controller, a provider's failure belongs to its renderer) removes the most common reason people write a listener at all. `login_screen.dart`'s listener has four defects in five lines and simply disappears under this rule rather than being rewritten.

## D15 — Riverpod bridge is a second barrel, not a second package

**Choice:** `flutter_page_kit` ships two public libraries:

- `package:flutter_page_kit/flutter_page_kit.dart` — Riverpod-free (`PageData`, shells, `PageNavigator`, `Notices` interface, `PageHarness`, …)
- `package:flutter_page_kit/flutter_page_kit_riverpod.dart` — `AsyncView`, `PageBridge`, `listenFailure`; only this tree may import `flutter_riverpod`

**Why:** `AsyncView` and `PageBridge` need Riverpod types, but D1 forbids Riverpod in the form layer. A separate package would force a third version stream for one mixin. A second barrel keeps one release while preserving `import 'package:flutter_page_kit/flutter_page_kit.dart'` as the safe default for controllers and harness tests.

**Do not:** export the riverpod barrel from the main barrel, or put `AsyncView` in the core `lib/src/` tree.

## D16 — `Notices` interface lives in `flutter_page_kit`; Material impl in `flutter_app_kit`

**Choice:** Controllers depend on an abstract `Notices` (info/warn/error/success/showFailure) owned by `flutter_page_kit`. The ScaffoldMessenger implementation ships later in `flutter_app_kit` (and may be stubbed in the page_kit example).

**Why:** every form controller needs toasts on day one of page_kit; waiting for app_kit would leave a permanent lab stub. Kits still never localize — `showFailure` maps via an app-injected `failureText` (or the app calls `error(failureText(f))`).

**Do not:** put slang or hardcoded English inside any `Notices` implementation that ships in a kit.
