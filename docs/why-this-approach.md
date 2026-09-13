# Why this approach

## What went wrong in the reference apps

Three real apps (`kiwash`, `kiwash_provider`, `lightnessword`) motivated the family. They work, but the same pain repeats:

| Pain | What it looked like | Kit that fixes it |
| --- | --- | --- |
| Fat screens | Login/list screens own UI, validation, navigation, and API calls | `flutter_page_kit` + `flutter_input_kit` |
| Untestable forms | Mixins import screens; forms need `ProviderScope` to unit-test | Page controllers are Riverpod-free + `PageHarness` |
| Two DI systems | `get_it` + Riverpod (+ injectable) | Riverpod only (`flutter_app_kit` overrides) |
| Copy-paste lists | ~12 nearly identical list notifiers | `PagedList` in `flutter_data_kit` |
| Backend leaks | Dio/Supabase/Firebase types in UI | Adapters throw `AppFailure` only |
| Secrets in prefs | Email/password in SharedPreferences | `SecureSessionStore` in `flutter_app_kit` |
| Size ≠ theme | ScreenUtil + ad-hoc colors everywhere | `scale_kit` vs `scale_theme_kit` split |
| Config sprawl | Hardcoded keys, flavor chaos | One `lemsa.yaml` + env/flavors |
| Nav soup | `MaterialPageRoute`, GoScreen, deep-link screens | `flutter_nav_kit` + guards |

The kits are not a “framework for frameworks.” Each package owns **one job** so an app can take only what it needs (e.g. scale alone, or full stack).

## Design principles

### 1. Split by lifetime, not by “clean architecture” folders alone

Ephemeral form state (text fields, busy flags, field errors) dies with the route. Session and server-backed state outlive the route. Mixing them in one Notifier creates dispose bugs and forces Riverpod into every form test.

→ Controllers for ephemeral. Providers for durable. See [architecture.md](../spec/architecture.md).

### 2. Controllers stay Riverpod-free

A controller declares **abstract getters** (`DebtRepository get debts`). The page’s `ConsumerState` supplies them with `ref.read`. Tests mount `PageHarness` and pass fakes — no `ProviderScope` required for form logic.

→ Decision [D1](../spec/decisions.md), bridge [bridge.md](../spec/bridge.md).

### 3. Failures are typed and localizable at the edge

Adapters catch vendor errors and throw `AppFailure` subclasses with **no user-facing message string**. UI / slang maps codes at render time. Sequential writes stay as linear `try/catch`, not nested `Result` unwraps.

→ [errors.md](../spec/errors.md), decision D3.

### 4. Backend is a plugin, not a core dependency

`flutter_data_kit` defines contracts (`Source`, `PagedSource`, repository patterns). Dio, Supabase, Firebase, and Drift live in **adapter packages**. A Supabase app never downloads Firebase.

→ Decision D12, [flutter_data_kit](packages/flutter_data_kit.md).

### 5. Size and look are separate products

Responsive scaling (`*.w`, breakpoints) is not theme tokens (colors, radius, typography). Coupling them forces theme apps to take scaling opinions and vice versa. Both are published and Flutter-only.

→ [flutter_scale_kit](packages/flutter_scale_kit.md), [flutter_scale_theme_kit](packages/flutter_scale_theme_kit.md).

### 6. One project contract: `lemsa.yaml`

Ask once (backend, storage, i18n, list update style). Kits and skills read that file instead of re-interrogating. Generators (`dart run <kit>:gen`) are package-owned CLIs, not Mason bricks.

→ [lemsa-yaml.md](../spec/lemsa-yaml.md), decision D9/D10.

### 7. Spec is the brain; README is the brochure

Cross-kit rules live in `spec/`. Each kit’s publishable README stays short. Agent skills enforce usage. This `docs/` folder is the long-form **why** for people.

→ Decision D13.

## How an app is supposed to look

```text
lib/
  main.dart                 → flutter_app_kit bootstrap
  app.dart                  → ProviderScope > ScaleKit > MaterialApp.router
  core/                     → theme, scale tokens, router, env, failures mapping
  features/<name>/
    domain/                 → models, drafts, queries (no I/O)
    data/                   → source contract + adapter + repository
    state/                  → @riverpod only
    controllers/            → *Data mixins (no riverpod)
    pages/                  → UI + bridge (ConsumerState)
    widgets/
```

Vertical slice of one feature: page bridges controller ↔ providers; repository talks to a source; adapter talks to the vendor SDK.

## What we deliberately do *not* do

| Avoid | Reason |
| --- | --- |
| Result everywhere | Unreadable sequential pipelines |
| get_it + Riverpod | Two lifecycles, two override stories |
| Form Notifiers for every field | Wrong lifetime; hard to test |
| One mega “lemsa_ui” package | Forces unused deps; blocks pub publishing per concern |
| Mason as primary generator | Stale CLI; cannot read `lemsa.yaml` / pubspec well |
| Firebase (or any backend) in core | Pollutes every consumer’s dependency graph |

## Compatibility stance

Kits target **Flutter ≥ 3.44** (see current floors in [package.md](../spec/package.md)). Third-party floors (Drift, Riverpod, Dio, …) use **caret minimums** so apps on 3.44 through newer Flutter (e.g. 3.47) can still resolve. CI pins FVM per that spec (currently **3.47.2**).

## Where to go next

1. [family-map.md](family-map.md) — who depends on whom  
2. [packages/README.md](packages/README.md) — per-kit deep dives  
3. [../spec/decisions.md](../spec/decisions.md) — numbered ADRs (D1–D16+)
