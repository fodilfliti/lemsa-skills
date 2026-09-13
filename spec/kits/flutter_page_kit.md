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
- `FormBackground` — color / colorDark underlay + image / imageDark for `FormPage`
- `PageHarness` — test mount without `ProviderScope`
- `dart run flutter_page_kit:gen page <feature>/<name>`

### FormPage chrome

- `showAppBar` (default `true`) — when `false`, `Scaffold.appBar` is null; optional `header` sits above the body (caller builds back + title + Spacer + Save).
- `FormBackStyle` (`platform` | `android` | `ios`) — AppBar leading when `showAppBar` is true. Leading only when the route can pop or `onBack` is set. `platform` uses Flutter’s adaptive `BackButton`; `android` / `ios` use `Icons.arrow_back` / `Icons.arrow_back_ios`.
- `onBack` — optional; otherwise `Navigator.maybePop`.
- When `showAppBar: false`, **`ActionSlot.appBar` is ignored** (debug assert). Put Save in `header` or use `ActionSlot.bottomBar` / `inline`. `title` is ignored when the AppBar is off.
- `FormBackground` — optional underlay + light/dark images. Paint order: `Scaffold.backgroundColor` (underlay through PNG holes) → optional `Image` → form content. Null `color` / `colorDark` → `Theme.scaffoldBackgroundColor` (theme kits already map tokens there; **no** page_kit → theme_kit dependency). Color-only, image-only, or both are valid. Omit `background` for today’s theme-only look.

```dart
FormPage(
  showAppBar: false,
  title: '',
  header: Row(
    children: [
      IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Navigator.maybePop(context)),
      Text('Edit task'),
      const Spacer(),
      TextButton(onPressed: controller.submit, child: Text('Save')),
    ],
  ),
  background: FormBackground(
    color: const Color(0xFFF5F0E8),
    colorDark: const Color(0xFF1A1510),
    image: AssetImage('assets/auth_shape_light.png'),
    imageDark: AssetImage('assets/auth_shape_dark.png'),
  ),
  child: ...,
)

FormPage(
  title: 'Edit task',
  leadingStyle: FormBackStyle.ios,
  actions: [PageAction(id: 'save', label: 'Save', slot: ActionSlot.appBar, onPressed: ...)],
  child: ...,
)
```

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
- `FormPage`: AppBar present/absent, `header` when AppBar off, `FormBackStyle.ios` / `.android` leading when route can pop; `FormBackground` underlay color + light/dark image selection.
- Grep/test: no riverpod import outside `lib/src/riverpod/`.
- Riverpod example or test: `AsyncView` renders error branch when `AsyncValue` has error.
