# flutter_page_kit

Page controller mixins, shells, loading, and the page generator. **Core barrel is Riverpod-free.**

## Owns

- `PageData<T>` — `text()`, `flag()`, `items()`, `money()`, `date()`, keyed `busy`, `failure`, `run(key:)`, `validateForm`, `showFieldErrors`
- `Validatable` — `isValid` + **`errorCode`** (machine code, never a translated string)
- `FieldText` / `FieldFlag` / … — field handles; validators return **error codes**
- `BusyTracker` — `busy.of(key)`
- `PageScope<T>` — replaces hand-copied `*DataProvider` InheritedWidgets
- `PageNavigator` interface — navigation without importing auto_route
- `Notices` interface — toast/snackbar API (`info` / `warn` / `error` / `success` / `showFailure`); **no Material impl here** (that ships in `flutter_app_kit`)
- `PageAction` + `ActionSlot` — actions as data, shell decides placement
- Shells: `FormPage`, `FormSheet`, `FormDialog`, `FormPanel`
- `PageHarness` — test mount without `ProviderScope`
- `dart run flutter_page_kit:gen page <feature>/<name>`

### Riverpod bridge (same package, second barrel)

Export **only** from `lib/flutter_page_kit_riverpod.dart` (never from `lib/flutter_page_kit.dart`):

- `AsyncView` — exhaustive `AsyncValue` switch, unwraps `ProviderException` → `AppFailure`
- `PageBridge` mixin — default `nav` + `notices` via `ref.read` on `ConsumerState`
- `ref.listenFailure` extension (fire-once UI effects only)

Riverpod source lives under `lib/src/riverpod/` only. See [../decisions.md](../decisions.md) D15.

## Depends on

- Runtime (core barrel): `lemsa_core_kit` only
- Runtime (riverpod barrel): `lemsa_core_kit` + `flutter_riverpod` (declared in this package's pubspec)

## Loading contract

- Read loading → not this kit (provider + `AsyncView` in the app).
- Write loading → keyed `busy.of(key)`.
- Presentation rules documented in [../architecture.md](../architecture.md).

## Generator output

For `gen page debt/add --form --steps 3 --edit DebtModel`:

- `controllers/debt_form_data.dart` — mixin stub + `submit()` skeleton
- `pages/add_debt_page.dart` — `ConsumerState` + bridge getter stubs
- `widgets/debt_*_step.dart` — one per step
- `test/debt_form_harness_test.dart` — empty harness test

## Invariants

- **No** `import` of `flutter_riverpod` / `hooks_riverpod` outside `lib/src/riverpod/`.
- Main barrel does **not** export the riverpod barrel.
- Controllers never import `pages/` or `state/`.
- `run()` is the outer net; inner per-step `try/catch` is expected.
- Field validators return **codes** (`required`, `minLength`, …), never user-facing strings.
- `Notices.showFailure` skips `CancelledFailure`; message mapping is injected by the app/Material impl (kits never call slang).
- Field validation failures are **inline only** (`showFieldErrors` / `errorText`). Do not call `Notices` for “form invalid”. Use `Notices` for submit success/failure, network errors, and other important writes.
- Shells serve ~80% form/list screens; bespoke screens opt out.

## Lab reference (evidence, not copy-paste)

`skills/lab/lib/stubs/page_kit.dart`, `notices.dart`, `page_navigator.dart` and `lab/lib/core/bridge/page_bridge.dart` prove the API. Promote the contract; do not ship lab paths or slang imports inside this package.

## Tests

- `PageHarness` mounts and disposes without leak (add/remove listener count).
- `busy.of('save')` independent of `busy.of(('delete', id))`.
- Grep/test: no riverpod import outside `lib/src/riverpod/`.
- Riverpod example or test: `AsyncView` renders error branch when `AsyncValue` has error.
