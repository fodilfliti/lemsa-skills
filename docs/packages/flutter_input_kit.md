# flutter_input_kit

**Job:** semantic **form fields** and **validators** that bind to page_kit field handles — one visual language, no 40-parameter mega widgets.

**Not its job:** page lifecycle, repositories, routing.

## Why it exists

Reference apps shipped `CustomTextField` with ~40 optional params and fifteen `*InputWidget` wrappers (email, phone, money…) that each reimplemented padding, labels, and error display. Validators returned translated strings, so i18n and validation were glued together.

## What it does exactly

| Piece | Purpose |
| --- | --- |
| `FieldSpec` | Binds label, keyboard, obscure, validator to a `Validatable` / controller |
| Semantic fields | `EmailField`, `PasswordField`, `PhoneField`, `MoneyField`, `DateField`, `CountryField`, `SearchField`, `AddressField`, … |
| `ListField<T>` | Dynamic rows (phones, names) without copy-paste add/remove UI |
| `Validators` | Pure functions → **error codes** (`required`, `email`, `minLength`, …) |
| `FieldStyle` | Visual variants (e.g. corner label) as enum — not parallel widget trees |
| Optional gen | Schema/gen from controller declarations |

Usage shape:

```dart
EmailField(spec.email)   // spec from controller Validatable
```

Fields do **not** call slang / `.tr()` internally. The page (or a thin mapper) turns `errorCode` into localized `errorText`.

## Architecture

```text
PageData / FeatureData
    │  FieldText / Validatable (errorCode)
    ▼
FieldSpec  ──►  EmailField / PasswordField / …
    │
Validators (pure, no BuildContext)
```

Depends on scale + theme so fields share spacing and look with the rest of the app, and on page_kit for `Validatable` alignment.

## Why this approach

| Choice | Why |
| --- | --- |
| Semantic widgets | Call site says *what*, not 40 knobs |
| Error codes, not strings | i18n stays at the edge; validators stay pure |
| One FieldStyle enum | Avoids duplicate trees for “corner label” vs default |
| ListField | Kills add_phones_widget-style duplication |

## Depends on

`lemsa_core_kit`, `flutter_page_kit`, `flutter_scale_kit`, `flutter_scale_theme_kit`.

## Related

- Controller side: [flutter_page_kit.md](flutter_page_kit.md)  
- Agent kit design: [../../spec/kits/flutter_input_kit.md](../../spec/kits/flutter_input_kit.md)
