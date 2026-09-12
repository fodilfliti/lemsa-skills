---
name: flutter-slang
description: >
  slang 4 typed i18n for Lemsa Flutter apps. Use for translations, migrating
  from easy_localization, adding locales, or replacing .tr() string keys.
license: MIT
metadata:
  author: fodilfliti
  version: "1.0.0"
---

# Flutter slang (Lemsa)

Versions: `slang` / `slang_flutter` 4.19.0, `slang_build_runner`.

## Setup

```yaml
# pubspec
dependencies:
  slang_flutter: ^4.19.0
dev_dependencies:
  slang: ^4.19.0
  slang_build_runner: ^4.19.0
  build_runner: ^2.16.0
```

Input: `lib/i18n/` JSON or YAML per locale (`en.i18n.json`, `fr.i18n.json`).

## Usage

```dart
import 'package:myapp/i18n/strings.g.dart';

Text(t.debt.form.title)
LocaleSettings.setLocale(AppLocale.fr);
```

## Migration from easy_localization

1. Export keys from `assets/translations/*.json`
2. Flatten to slang files (keep snake_case keys)
3. Replace `'key_msg'.tr()` → `t.keyMsg` incrementally
4. Remove easy_localization when last `.tr()` is gone

## Failure messages

Map `AppFailure` → string in app-owned `failureText()` using `t.errors.*` — failures carry no message field.

## Codegen

```bash
dart run slang
dart run build_runner watch  # if using build_runner integration
```

## Do not

- Hardcode user-visible English in controllers
- Put `.tr()` inside flutter_input_kit field widgets — pass labels from page
