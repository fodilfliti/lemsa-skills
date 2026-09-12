# lemsa_core_kit

Primitives every other kit shares. No Flutter widgets beyond what `flutter/foundation.dart` needs.

## Owns

- `AppFailure` sealed hierarchy + `AuthReason`
- `Result<T>` / `Ok` / `Err` + `Result.guard`
- `Disposables` + `keep()`
- `AppReporter` interface + `NoOpReporter`
- `Change<T>` sealed (`Created`, `Updated`, `Deleted`)
- String / bool / date / num extensions (replacing per-app `*_extention.dart`)
- `AppLogger` thin wrapper over `dart:developer`

## Must not depend on

`dio`, `supabase_flutter`, `firebase_*`, `drift`, `flutter_riverpod`, `hooks_riverpod`, `auto_route`.

## Public barrel

`lib/lemsa_core_kit.dart` — only export.

## Invariants

- `AppFailure` carries **no message string**. Localization happens at the render site.
- `CancelledFailure` is never reported and never shown.
- `Result` is for branching, not for threading through sequential awaits.

## Tests

- Exhaustive switch on every `AppFailure` subclass compiles.
- `AppFailure` has no `message` field (lint/test guard).
- `Disposables` disposes in reverse registration order.

## Consumer skill

Ship `skills/lemsa-core-kit/` in the kit repo when published. Not in this skills repo.
