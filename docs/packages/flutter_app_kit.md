# flutter_app_kit

**Job:** **application bootstrap** — env/flavors, secure storage, global error zone, Material `Notices`, and the ordered startup sequence.

**Not its job:** feature pages, field widgets, or being a dumping ground for business logic.

## Why it exists

`main.dart` files across apps each reinvented:

- Firebase/Supabase init order
- dotenv / hardcoded keys
- SharedPreferences holding passwords
- Incomplete sign-out (tokens left behind, Drift not wiped)
- Uncaught errors with no reporter

This kit turns boot into a **phased, testable** API and owns the Material implementation of notices so page_kit stays Material-light (D16).

## What it does exactly

| Piece | Purpose |
| --- | --- |
| `bootstrap` / `AppConfig` | Ordered init: env → optional Firebase/Supabase → prefs → overrides → `runApp` |
| `AppEnv` / flavors | `dev` / `staging` / `prod` via dart-define or native flavors |
| `SecureSessionStore` | Tokens/secrets only — never passwords in prefs |
| Shared prefs helper | Non-secret scalars |
| `deleteUserData()` | Secure clear + hook for Drift wipe on sign-out |
| `MaterialNotices` | Implements page_kit `Notices` via `ScaffoldMessenger` |
| Error zone | `FlutterError` / `PlatformDispatcher` → `AppReporter` |

Shape:

```dart
Future<void> main() async {
  await bootstrap(AppConfig(
    initFirebase: true,
    initSupabase: false,
    // flavors / env …
  ));
}
```

## Architecture

```text
main()
  → bootstrap(AppConfig)
       → load env / flavor
       → init backends (optional hooks)
       → prefs + secure store
       → ProviderScope overrides (navigator, notices, reporter, …)
       → install error zone
       → runApp(root)
```

App root typically:

`ProviderScope` → scale/theme → `MaterialApp.router` (nav_kit).

## Why this approach

| Choice | Why |
| --- | --- |
| Phased bootstrap | Deterministic order; less “works on my machine” init |
| Secure store for secrets | Fixes prefs-password anti-pattern |
| `deleteUserData` on sign-out | Three layers cleaned (see riverpod.md) |
| Notices impl here | Controllers depend on interface; Material stays at edge (D16) |
| Riverpod overrides in boot | No get_it for “just main” (D4) |

## Depends on

`lemsa_core_kit`, `flutter_page_kit` (for `Notices`). Optional app-level hooks for data adapters — not hard Firebase deps inside core if avoidable; prefer config flags.

## Related

- Notices interface: [flutter_page_kit.md](flutter_page_kit.md)  
- Session / sign-out: [../../spec/riverpod.md](../../spec/riverpod.md)  
- Showcase wiring: [lab.md](lab.md)
