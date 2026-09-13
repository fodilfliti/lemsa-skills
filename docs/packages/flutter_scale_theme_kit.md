# flutter_scale_theme_kit

**Job:** the **look** — design tokens (color, radius, type, shadows, components) resolved into Flutter `ThemeData` / extensions.

**Not its job:** responsive width/height math (that is `flutter_scale_kit`).

Status: **published** on pub.dev.

## Why it exists

Without a token layer, apps hardcode `Color(0xFF…)` and `BorderRadius.circular(12)` in dozens of widgets. Changing brand means a global search. Theme and scale were also tangled in older setups.

This kit:

- Declares tokens once (JSON / Dart IR → generated theme code).
- Ships a CLI (`dart run flutter_scale_theme_kit:gen` / `generate_core`) so themes stay code-generated and consistent.
- Stays independent of scaling so a non-scaled app can still use tokens.

## What it does exactly

- Token model: colors, typography, radius, shadows, component slots, extras.
- Resolve tokens into `STTheme` / `ThemeData` factories and context accessors.
- Light/dark (and mode) handling via theme scope.
- Generator scans / emits typed theme APIs so call sites stay `context.st…` style rather than magic strings.

## Architecture

```text
tokens (JSON / Dart)
        │
        ▼
   generate_core (CLI)
        │
        ▼
  STTheme / STColorScheme / extensions
        │
        ▼
  MaterialApp theme / ThemeExtension
```

- **`lib/src/tokens/`** — raw token types.
- **`lib/src/theme/`** — resolution, scope, ThemeData factory.
- **`lib/src/generate/`** — IR, emit, scan (used by bin CLI).

Does **not** import `flutter_scale_kit` or other Lemsa kits.

## Why this approach

| Choice | Why |
| --- | --- |
| Own CLI, not Mason | Proven in this package; version-locks with emitted API (D9) |
| Separate from scale | Apps can theme without accepting scale strategy |
| Generated accessors | Prevents drift between design JSON and Dart |

## Depends on

Flutter SDK only (plus whatever the generator needs as dev tooling in that repo).

## Related

- Size: [flutter_scale_kit.md](flutter_scale_kit.md)  
- Inputs use both: [flutter_input_kit.md](flutter_input_kit.md)
