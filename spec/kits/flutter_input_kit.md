# flutter_input_kit

Semantic form fields and validators. Replaces `CustomTextField` (~40 params) and 15 `*InputWidget` wrappers.

## Owns

- `FieldSpec` — binds a controller/notifier to label, validator, keyboard, obscuring
- Semantic fields: `EmailField`, `PasswordField`, `PhoneField`, `MoneyField`, `DateField`, `CountryField`, `SearchField`, `AddressField`, etc.
- `Validators` — composable; return **error codes** (`String?`), never translated messages
- `ListField<T>` — dynamic rows (phones, names, countries) replacing `add_phones_widget.dart` pattern
- Optional schema gen: `dart run flutter_input_kit:gen fields from lib/features/<f>/controllers/<c>.dart`

## Depends on

`lemsa_core_kit`, `flutter_page_kit`, `flutter_scale_kit`, `flutter_scale_theme_kit`.

## Field API shape

```dart
EmailField(spec.email)   // spec comes from controller's Validatable
```

Fields take a `Validatable` or `TextEditingController` + `ValueListenable<bool> isValid` — not 40 optional constructor params.

## Validators / i18n (locked)

- Validators return **machine error codes** (`required`, `email`, `minLength`, …), never user-facing strings.
- Labels and `errorText` come from slang (or app mapper) **at the call site**. Fields do not call slang / `.tr()` internally.
- Align with `Validatable.errorCode` from `flutter_page_kit`.

## Invariants

- One visual language: corner-label variant is a `FieldStyle` enum, not a separate widget tree.
- Validators are pure functions; no `BuildContext`.

## Tests

- Golden or widget tests per field type (at least email + password + phone).
- Validator table tests mirroring old `ValidatorChecker` cases.
