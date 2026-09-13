# Lemsa Lab — kit family showcase

Portfolio demo of the **Lemsa Flutter kits** composing into one app: responsive UI, typed failures, page controllers, semantic inputs, paged data, swappable backends, navigation guards, and app bootstrap.

> **Not** a migration of kiwash / lightnessword. This lab is the reference consumer.

## Run in 60 seconds

```bash
cd skills/lab
fvm flutter pub get
fvm flutter run
```

Default backend is **mock** (no secrets). Sign in with the prefilled email/password, then explore **Tasks · Projects · Labels · Inbox · Profile**.

## Screenshots

| Path | Capture |
| --- | --- |
| `doc/screenshots/login.png` | Login (guest guard) |
| `doc/screenshots/tasks.png` | Task list + sync |
| `doc/screenshots/projects.png` | Paged projects |

*(Place PNGs under `doc/screenshots/` when filming the demo.)*

## Switch backend (T22)

One compile-time switch — **do not edit pages/controllers**.

| Backend | How | Notes |
| --- | --- | --- |
| `mock` | default / `--dart-define=LAB_BACKEND=mock` | In-memory; CI default |
| `rest` | `--dart-define=LAB_BACKEND=rest` | Dio + `FailureInterceptor` → JSONPlaceholder |
| `supabase` | `--dart-define=LAB_BACKEND=supabase` | Adapter present; falls back to mock without `.env` |
| `firebase` | `--dart-define=LAB_BACKEND=firebase` | Adapter present; falls back to mock without credentials |

Also keep `lemsa.yaml` `backend:` in sync for humans (runtime uses dart-define / default mock).

```bash
fvm flutter run --dart-define=LAB_BACKEND=rest
```

Copy [`.env.example`](.env.example) → `.env` only when trying live supabase/firebase. **Never commit secrets.**

Sources live under `lib/features/tasks/data/sources/` (`mock_`, `task_source_rest`, `_supabase`, `_firebase`). DI: `taskRemoteSourceProvider` + `TaskSourceFactory`.

## Features → kits

| Feature | Kits shown |
| --- | --- |
| Login | `flutter_app_kit` bootstrap, `flutter_input_kit` Email/Password, `flutter_page_kit` FormPage, `flutter_nav_kit` GuestGuard |
| Tasks | `lemsa_core_kit` AppFailure, Drift cache, `AsyncView`, Notices |
| Projects | `flutter_data_kit` PagedList, MoneyField/DateField, FormPage |
| Labels / Inbox | PagedList + PageData inline create |
| Profile | session wipe, theme switch (`scale_theme_kit`), backend label |
| Scale + theme | `ScaleKitBuilder` + `STTheme` / mode switch |

## Kit surface checklist (T23)

- [x] `flutter_scale_kit` — `.w` / padding on lists & forms
- [x] `flutter_scale_theme_kit` — light/dark + `STThemeModeSwitch`
- [x] `lemsa_core_kit` — AppFailure, extensions, Disposables via PageData
- [x] `flutter_page_kit` — PageData, FormPage, PageAction, AsyncView
- [x] `flutter_input_kit` — EmailField, PasswordField, MoneyField, DateField
- [x] `flutter_data_kit` — PagedList / PagedSource
- [x] Adapters — mock active; rest/supabase/firebase in tree
- [x] `flutter_nav_kit` — AutoPageNavigator, Auth/Guest guards
- [x] `flutter_app_kit` — bootstrap, MaterialNotices, secure session, init hooks

## Verify

```bash
fvm flutter analyze
fvm flutter test
```

## Scenarios

See [`spec/scenarios.md`](spec/scenarios.md) (S01–S12 + portfolio scenarios).

## Codegen

```powershell
.\scripts\post-change.ps1
```
