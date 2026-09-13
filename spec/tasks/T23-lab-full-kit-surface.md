# T23 — Lab showcase: full kit surface (scale → app)

## Goal

Lab demonstrates **every** published/local Lemsa kit in one coherent UI — not a thin sandbox.

## Kit checklist (all required)

| Kit | Lab must show |
| --- | --- |
| `flutter_scale_kit` | Responsive layout / `.w` / breakpoints on list + form |
| `flutter_scale_theme_kit` | Light/dark tokens, themed components |
| `lemsa_core_kit` | `AppFailure` handling, extensions, `Disposables` via page_kit |
| `flutter_page_kit` | `PageData`, shells (`FormPage` / sheet or dialog), `PageAction`, `AsyncView` |
| `flutter_input_kit` | ≥3 semantic fields (e.g. email, password, money/date) |
| `flutter_data_kit` | `PagedList`, repository throw/`AppFailure` |
| Adapters | Active one from T22; others present in tree |
| `flutter_nav_kit` | `AutoPageNavigator`, AuthGuard / GuestGuard, typed routes |
| `flutter_app_kit` | `bootstrap`, `MaterialNotices`, secure session store, error zone → reporter |

## UX expectations

- Cold start → bootstrap → login (guest) → home shell with tabs or destinations
- Sign-out clears session **without** navigator calls in the controller (guard redirects)
- Forms: inline validation only; Notices for save/API failures
- Loading: read = AsyncView; write = keyed `busy`

## Read first

- [../architecture.md](../architecture.md)
- [../riverpod.md](../riverpod.md)
- Kit specs under [../kits/](../kits/)

## Blocked by

T20, T21, T22 (can overlap T21/T22 if coordinated).

## Done when

- [ ] Checklist above satisfied and listed in `lab/README.md`
- [ ] Example uses scale + theme together (companion recipe)
- [ ] At least one golden or widget smoke for login + one form
- [ ] analyze + test green

## Do not

- Reinvent kits inside lab
- Skip nav or app_kit “for speed”
- Migrate external apps
