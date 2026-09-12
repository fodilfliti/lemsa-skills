# flutter_app_kit

App bootstrap, env/flavors, secure storage, global error zone.

## Owns

- `bootstrap()` phases: dotenv → Firebase/Supabase init → prefs → ProviderScope overrides → runApp
- Typed env via `envied` or `flutter_dotenv` wrapper (pick one at bootstrap)
- Flavor config (`dev` / `staging` / `prod`) wired to `--dart-define` or native flavors
- `SecureSessionStore` — tokens only, never passwords in prefs
- `deleteUserData()` — Drift wipe + secure storage clear (called from sign-out)
- `Notices` interface (toast/snackbar) + **Material default impl** (`ScaffoldMessenger`); interface itself lives in `flutter_page_kit` (D16)
- `FlutterError.onError` / `PlatformDispatcher.onError` → `AppReporter`

## Depends on

`lemsa_core_kit` only (runtime). Optional hooks for data_kit adapters at app level.

## Replaces

- Scattered init in `main.dart` across three apps
- `password_user` / `email_user` in SharedPreferences
- Hardcoded API keys in source (kiwash Stripe/Maps) → env/flavors

## Bootstrap shape

```dart
Future<void> main() async {
  await bootstrap(AppConfig(
    initFirebase: true,
    initSupabase: false,
    flavors: Flavor.current,
  ));
}
```

## Invariants

- Secrets never committed; `.env` in `.gitignore`, example env checked in.
- Sign-out calls `deleteUserData()` — three layers per [../riverpod.md](../riverpod.md).
- Bootstrap is idempotent and testable (each phase overridable in tests).

## Tests

- Bootstrap with fakes completes without network.
- `deleteUserData()` clears prefs keys listed in spec.
