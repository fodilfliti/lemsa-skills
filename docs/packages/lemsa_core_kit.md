# lemsa_core_kit

**Job:** shared **primitives** every other kit and app feature can import without pulling UI frameworks or backends.

**Not its job:** widgets, Riverpod, Dio/Supabase/Firebase/Drift, navigation.

## Why it exists

Reference apps each reinvented:

- Error types with embedded English strings
- Ad-hoc `Result` / try patterns
- Dispose lists that leak (`isHide`, controllers)
- Copy-pasted `*_extention.dart` helpers

`lemsa_core_kit` is the single place for those primitives so page/data/nav kits speak the same language. The `lemsa_` prefix exists because `flutter_core_kit` / `core_kit` names were taken on pub.dev.

## What it does exactly

| Type / area | Role |
| --- | --- |
| `AppFailure` (sealed) + `AuthReason` | Typed failures; **no** `message` field — localize at UI |
| `Result` / `Ok` / `Err` / `Result.guard` | Branching outcomes only — not every await |
| `Disposables` + `keep()` | Register disposers; dispose in reverse order |
| `Change<T>` (`Created` / `Updated` / `Deleted`) | List upsert vocabulary |
| `AppReporter` / `NoOpReporter` | Crash/analytics hook without a vendor |
| `AppLogger` | Thin `dart:developer` wrapper |
| Extensions | string / bool / date / num / list — replace per-app helpers |

## Architecture

```text
lib/lemsa_core_kit.dart          ← single public barrel
lib/src/
  failure/   result/   disposables/
  change/    reporter/ logging/
  extensions/
```

Layer rules for consumers:

- Domain and adapters may import core.
- Core must never import a kit above it.

## Why this approach

| Choice | Why |
| --- | --- |
| Failures without messages | Same failure → many languages; slang at edge (errors.md) |
| Throw `AppFailure`, Result only for branches | Linear async code (D3) |
| No Riverpod / backends | Keeps core usable in pure Dart tests and CLI cores |
| `Disposables` | Auto-registry beats hand `dispose()` lists (feeds page_kit D2) |

## Depends on

Flutter foundation only (no Material widgets requirement beyond what foundation needs).

## Must never depend on

`dio`, `supabase_flutter`, `firebase_*`, `drift`, `flutter_riverpod`, `auto_route`.

## Related

- Errors contract: [../../spec/errors.md](../../spec/errors.md)  
- Used by every higher kit — see [../family-map.md](../family-map.md)
