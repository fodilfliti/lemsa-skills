# Phase 2 — Build / finish flutter_page_kit

You are implementing **`flutter_page_kit`**. The user may have already created an empty (or scaffold) Flutter package at the path below — **do not recreate the repo**; finish, fix, and align it to this prompt and the skills-repo specs.

## Repo path

`C:\Users\lemsa\Documents\apps\lemsa_packages\flutter_page_kit\`

Sibling deps (path or published):

- `../lemsa_core_kit` — **required** (Phase 1). If missing, stop and tell the user to finish Phase 1 first.
- Reference shape: `../flutter_scale_kit`, `../flutter_scale_theme_kit` (FVM **3.35.7**, `spec/`, `skills/`, `AGENTS.md`, `example/`).

Design brain (read-only): `C:\Users\lemsa\Documents\apps\lemsa_packages\skills\spec\`

## Read first (mandatory)

1. `skills/spec/kits/flutter_page_kit.md` — scope + barrels
2. `skills/spec/architecture.md` — page layout, busy vs AsyncValue
3. `skills/spec/errors.md` — `run()` outer net, `AppFailure`, no messages in failures
4. `skills/spec/bridge.md` — page as bridge, callbacks / pop
5. `skills/spec/decisions.md` — **D1, D6, D7, D8, D15, D16**
6. Lab evidence (API proof, not copy-paste of paths):  
   `skills/lab/lib/stubs/page_kit.dart`, `notices.dart`, `page_navigator.dart`,  
   `skills/lab/lib/core/bridge/page_bridge.dart`

## Locked decisions (do not reopen)

| ID | Decision |
| --- | --- |
| D15 | **Two barrels, one package.** Main: `lib/flutter_page_kit.dart` (no Riverpod). Bridge: `lib/flutter_page_kit_riverpod.dart` only — `AsyncView`, `PageBridge`, `listenFailure`. Riverpod code only under `lib/src/riverpod/`. |
| D16 | **`Notices` interface in this package.** Material/snackbar impl is **out of scope** (app_kit later). Example may ship a tiny `ScaffoldMessenger` stub. |
| D1 | Controllers = `State` mixins. **No `ref` in controllers.** |
| — | Validators / `Validatable.errorCode` return **machine codes** (`required`, `minLength`, …), never translated strings. Full semantic fields wait for `flutter_input_kit`. |
| — | `PageNavigator` is an interface only — no auto_route here (`flutter_nav_kit`). |
| — | **Notices usage:** no snackbar/toast on field validation failure — only inline `errorText` via `validateForm` / `showFieldErrors`. Use `Notices` for submit outcomes, network/API failures, and other important writes (toggle done, sync, delete, …). |

Document this Notices rule in the package `spec/` and consumer skill so apps don’t toast “check the form”.

## Goal — implement

### Core barrel (`package:flutter_page_kit/flutter_page_kit.dart`)

- `PageData<T>` on `State<T>`: `text` / `flag` / `items` / `money` / `date`, `keep()`, `busy`, `failure`, `run(key:)`, `validateForm`, `showFieldErrors`, `validated` list
- `BusyTracker` — `busy.of(key)` (string or record keys)
- `Validatable` + `FieldText` (+ other field handles as in kit/lab)
- Minimal code validators only if needed for tests (`required`, `minLength`) — or accept `FieldValidator` typedef and leave rich validators to input_kit
- `PageScope<T>`
- `PageNavigator` interface (`pop`, `push`, … as in lab/bridge)
- `Notices` interface (`info`, `warn`, `error`, `success`, `showFailure` — skip `CancelledFailure`)
- `PageAction` + `ActionSlot`
- Shells: `FormPage`, `FormSheet`, `FormDialog`, `FormPanel` (pragmatic v1 OK; ~80% screens)
- `PageHarness` — mount host + `GlobalKey`, no `ProviderScope`
- CLI: `dart run flutter_page_kit:gen page …` following `flutter_scale_theme_kit` `generate_core.dart` pattern (logic free of Flutter/`dart:io` where possible)

### Riverpod barrel (`package:flutter_page_kit/flutter_page_kit_riverpod.dart`)

- `AsyncView<T>` — unwrap `ProviderException` to underlying `AppFailure`
- `PageBridge` on `ConsumerState` — default `nav` / `notices` getters (providers are **app-owned**; bridge takes them as abstract or via typed callbacks — do not hardcode lab provider names into the kit; document the expected provider types)
- `listenFailure` (or equivalent) for fire-once UI only

**Preferred bridge shape:** mixin that requires the page to supply `PageNavigator get nav` / `Notices get notices` **or** a documented pair of provider readers. Controllers stay Riverpod-free either way.

## pubspec

- SDK / Flutter floors match `lemsa_core_kit` / family (`^3.7.2`, Flutter `>=3.29.0` or per core kit)
- FVM **3.35.7**
- deps: `lemsa_core_kit` (path), `flutter_riverpod` (for riverpod barrel only — still listed in pubspec)
- analysis: `empty_catches: error`; very_good_analysis or family standard

## Tests required

- [ ] `PageHarness` mount + dispose (no leak)
- [ ] Independent busy keys: `'save'` vs `('delete', id)`
- [ ] Guard test: **no** `flutter_riverpod` import outside `lib/src/riverpod/`
- [ ] Riverpod test or example: `AsyncView` error branch
- [ ] `run()` captures `AppFailure` into `failure`, ignores `CancelledFailure` for display
- [ ] `validateForm` sets `showFieldErrors` and `errorCode` on invalid fields

## Example app

One form page: mixin controller + page using riverpod barrel + fake repo. Show busy on save, pop on success, notices on failure. No Drift / no real backend.

## Acceptance checklist

- [ ] `fvm flutter analyze` clean
- [ ] `fvm flutter test` green
- [ ] Main barrel import compiles **without** needing Riverpod in a pure harness test
- [ ] `spec/` in this package (README, package.md, invariants) + `AGENTS.md`
- [ ] Consumer skill stub: `skills/flutter-page-kit/SKILL.md`
- [ ] `gen page` emits compilable stubs (or document partial CLI if shells land first — prefer both)

## If the scaffold already exists

1. Diff current tree vs this prompt + kit md.
2. Fix layout, barrels, deps, and APIs — **do not** leave lab-style absolute slang imports in the package.
3. Delete or relocate anything that violates D15/D16.
4. Keep user-added LICENSE / README branding if present; overwrite incorrect architecture.

## Out of scope

- `flutter_input_kit` semantic widgets
- auto_route / guards (`flutter_nav_kit`)
- Material snackbar production impl (`flutter_app_kit`)
- Drift / data_kit
- Migrating kiwash / lab to path-depend this package (optional follow-up only if user asks)

## Workflow

Use `fvm flutter` / `fvm dart` inside the package. Do **not** run `flutter upgrade` on the shared SDK. Do **not** publish unless asked. Do **not** ask clarifying questions unless `lemsa_core_kit` is missing or pub name `flutter_page_kit` is taken on pub.dev.
