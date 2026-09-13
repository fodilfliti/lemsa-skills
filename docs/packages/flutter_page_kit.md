# flutter_page_kit

**Job:** page **controllers**, shells, busy/failure for writes, notices API, and the Riverpod **bridge** widgets — without putting Riverpod inside form logic.

**Not its job:** text field widgets (input_kit), routes (nav_kit), repositories (data_kit).

## Why it exists

`lightnessword` already had `*_data_mixin` controllers — the right instinct — but they imported screens, leaked disposables, and could not be tested without the full tree. Other apps pushed everything into Riverpod Notifiers, including field text that dies on pop.

This kit productizes the good pattern and removes the bad couplings.

## What it does exactly

### Core barrel — `package:flutter_page_kit/flutter_page_kit.dart` (Riverpod-free)

| Piece | Purpose |
| --- | --- |
| `PageData` | `text()` / `flag()` / `items()` / `money()` / `date()`, keyed `busy`, `failure`, `run(key:)`, form validate |
| `Validatable` | `isValid` + **`errorCode`** (machine code, never translated string) |
| Field handles | Controllers registered for auto-dispose |
| `BusyTracker` | `busy.of(key)` / `busy.any` — per-action spinners |
| `PageAction` + `ActionSlot` | Actions as data; shell places them (bar / FAB / inline) |
| Shells | `FormPage`, `FormSheet`, `FormDialog`, `FormFlow` |
| `FormPage` chrome | Optional AppBar (`showAppBar`, `header`), `FormBackStyle` (platform / android / ios), `FormBackground` (underlay + light/dark images for transparent art) |
| `PageNavigator` | Interface only — no auto_route import |
| `Notices` | Interface only — Material impl lives in app_kit (D16) |
| `PageScope` | Replaces hand-copied InheritedWidget providers |
| `PageHarness` | Test mount without `ProviderScope` |
| CLI | `dart run flutter_page_kit:gen page …` |

### Riverpod barrel — `package:flutter_page_kit/flutter_page_kit_riverpod.dart`

| Piece | Purpose |
| --- | --- |
| `AsyncView` | Exhaustive `AsyncValue` UI; unwraps failures to `AppFailure` |
| `PageBridge` | Default `nav` / `notices` via `ref.read` on `ConsumerState` |
| `listenFailure` | Fire-once UI effects only |

Controllers and harness tests import the **core** barrel only (D15).

## Architecture

```text
                    ┌─────────────────────┐
                    │  pages/ ConsumerState │  ← only place with Riverpod + controller
                    └──────────┬──────────┘
           implements getters  │  with PageData + FeatureData
                    ┌──────────▼──────────┐
                    │  controllers/*Data   │  ← no riverpod import
                    └──────────┬──────────┘
                               │ uses abstract repos / nav / notices
                    ┌──────────▼──────────┐
                    │  providers / shells  │
                    └─────────────────────┘
```

Loading split:

- **Read** loading → provider + `AsyncView` (app).
- **Write** loading → `busy.of(key)` on the controller.

## Why this approach

| Choice | Why |
| --- | --- |
| Mixin on `State`, not Notifier | Ephemeral form state; Riverpod-free tests (D1) |
| Auto-dispose registry | Hand dispose lists leak (D2) |
| Keyed busy | One bool blocks unrelated actions (D8) |
| Actions as data | Same controller → page / sheet / dialog (D7) |
| Second barrel, not second package | One version stream; safe default import (D15) |
| Notices interface here | Controllers stay Material-free; app supplies impl (D16) |

## Depends on

- Core barrel: `lemsa_core_kit`
- Riverpod barrel: + `flutter_riverpod`

## Related

- Bridge how-to: [../../spec/bridge.md](../../spec/bridge.md)  
- Fields: [flutter_input_kit.md](flutter_input_kit.md)  
- Nav impl: [flutter_nav_kit.md](flutter_nav_kit.md)
