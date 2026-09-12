# PageData — field registry (lab)

Lab stub: `lab/lib/stubs/page_kit.dart` until `flutter_page_kit` ships. Core helpers: `lab/lib/stubs/core/`.

## Create fields only through factories

Never construct `TextEditingController()` / `ValueNotifier` in a `*Data` mixin. Never override `dispose()` on a feature mixin — only `PageData` disposes.

```dart
mixin DebtFormData<T extends StatefulWidget> on State<T>, PageData<T> {
  late final title = text();
  late final amount = money();
  late final done = flag();
  late final due = date();
  late final tags = items<String>();
  late final focus = keep(FocusNode());

  @override
  List<Validatable> get validated => [title];

  Future<void> submit() async {
    if (!await validateForm()) return;
    await run(key: 'save', action: () async { /* ... */ });
  }
}
```

`text({String? initial, List<FieldValidator>? validators})` — named args (Dart cannot mix optional positional + named). Default validators: `[Validators.required]`.

```dart
errorText: showFieldErrors
    ? fieldErrorText(title.errorCode, n: 3)
    : null,
```

Cross-field: a custom `Validatable` in the controller that reads two handles (password/confirm, date range, …). Put it in `validated`. Show its `errorCode` on the dependent field.

```dart
late final title = text(
  validators: [Validators.required, Validators.minLength(3)],
);
late final titleConfirm = text();
late final titlesMatch = TitleConfirmMatch(title, titleConfirm);

@override
List<Validatable> get validated => [title, titleConfirm, titlesMatch];
```

## Validators

`lab/lib/stubs/validators.dart` until `flutter_input_kit` ships.

- Return **codes** (`required`, `minLength`, `email`, `passwordMismatch`). Never `t.*` / `.tr()` / `BuildContext`.
- Compose with `Validators.all(value, rules)` — first failure wins.
- App maps codes in `fieldErrorText` (`lab/lib/core/failures/field_error_text.dart`) using `t.validation.*`.

`PageAction` / `ActionSlot` (form shells) replace per-page `FilledButton` busy wiring later. Do not build those in lab until `flutter_page_kit` shells exist.

## Busy

Prefer `busy.of('save')` and `busy.of(('delete', id))`. `busy.isRunning(key)` is an alias. `busy.any` is page-wide. Never one bool for every write.

While `busy.of('save')`:

- primary button `onPressed: null`
- `TextField.enabled: false`
- `onSubmitted` only if `!saving`
- `PopScope(canPop: !saving)` on form pages

```dart
final saving = busy.of('save'); // alias: busy.isRunning('save')

PopScope(
  canPop: !saving,
  child: Scaffold(
    body: Column(
      children: [
        TextField(
          controller: title.controller,
          enabled: !saving,
          textInputAction: TextInputAction.done,
          onSubmitted: saving ? null : (_) => submit(),
        ),
        FilledButton(
          onPressed: saving ? null : submit,
          child: Text(t.save),
        ),
      ],
    ),
  ),
);
```

`run(key:)` already ignores a second tap while that key is running. Still null the button and disable fields so the IME cannot submit twice.

## Tests

```dart
final key = GlobalKey<_HostState>();
final harness = await PageHarness.mount(
  pumpWidget: tester.pumpWidget,
  host: _Host(key: key, /* fakes */),
  key: key,
);
```

`PageHarness` does not import Riverpod. Controllers stay unit-testable with fakes.

## Extensions (core stub)

Import `package:lemsa_lab/stubs/core/extensions.dart` for `isNullOrEmpty`, `text`, `toDoubleValue` / `toIntValue`, `isZero`, `isTrue` / `isFalse`, `nonNullsList`, `toDate`. Domain helpers for repeated model logic live next to the model (`task_extensions.dart`).

## Do / don't

- Do use `text(validators: …)` and `Validators.all` — codes only
- Do map codes with `fieldErrorText` + `t.validation.*` at the page
- Do list fields in `validated` and call `validateForm` before submit
- Do lock fields, the primary button, IME submit, and pop while `busy.of('save')`
- Don't put `t.*` / `.tr()` in `Validators` or `FieldText`
- Don't import Riverpod in a controller
- Don't hand-dispose controllers
- Don't put state that survives a page pop in the mixin
- Don't add `EmailField` / `PageAction` here — those ship with `flutter_input_kit` / page-kit shells
