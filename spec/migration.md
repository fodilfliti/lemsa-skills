# Migration playbook

Move the three reference apps onto the family. **Do not migrate all three at once.** Each app is a separate branch and a separate PR-sized effort.

## Order (revised)

| Order | App | Why |
| --- | --- | --- |
| 1 | `kiwash` | Already Riverpod 3 + `flutter_scale_kit`. Lowest friction. Proves the stack. |
| 2 | `kiwash_provider` | Copy-paste twin. Cherry-pick kiwash's migration commits. |
| 3 | `lightnessword` | Riverpod 2.6 + screenutil + ReaxDB + dual Firebase/Supabase. Largest lift. |

Earlier plan said `kiwash_provider` first; kiwash is strictly ahead on versions and is the better pilot.

## Per-app baseline

| | kiwash | kiwash_provider | lightnessword |
| --- | --- | --- | --- |
| Riverpod | 3.0.3 | 2.6.1 | 2.6.1 |
| Scale | scale_kit 1.5.2 | screenutil | screenutil |
| Backend | Firebase + REST Dio | same | Supabase + Firebase hybrid |
| Local DB | Loon (chat) | same | ReaxDB |
| i18n | easy_localization | same | same |
| Nav | imperative | same | same |
| Page controller | fat screens | same | `*DataMixin` (keep, refactor) |

## Phase A — Contract (every app)

1. Add `lemsa.yaml` at app root (run `lemsa-flutter` ask-once ritual).
2. Add `.cursor/rules/lemsa-flutter.mdc` or install skills: `npx skills add fodilfliti/skills`.
3. Promote `empty_catches: error` in `analysis_options.yaml`.
4. Add `riverpod_lint` + `custom_lint` if missing.

## Phase B — Dependencies (batch by category)

Do one category per commit. Pin exact versions during Riverpod migration.

| From | To | Notes |
| --- | --- | --- |
| `hooks_riverpod` 2.x | 3.4.2 + generator 4.0.8 | Run `riverpod_lint` dart fix first |
| `legacy.dart` imports | remove | Replace StateNotifierProvider etc. |
| `get_it` + `injectable` | `@riverpod` providers | Delete `injection.config.dart` last |
| `flutter_screenutil` | `flutter_scale_kit` | Follow scale_kit skill merge recipe with theme_kit |
| `easy_localization` | `slang` | Migrate keys incrementally; keep old until cutover |
| `reaxdb_dart` / `loon` | `drift` | Schema + one feature at a time |
| imperative Navigator | `auto_route` + `flutter_nav_kit` | Router first, then screen-by-screen |
| `dartz` + `fpdart` | `lemsa_core_kit` Result | One feature at a time |
| Dio untyped maps | typed models at adapter boundary | With `flutter_data_kit_dio` |

## Phase C — Architecture (feature-by-feature)

Pick one vertical slice (auth or one CRUD feature). Apply the full stack:

1. `domain/` + `data/` + `state/debt_providers.dart`
2. Refactor screen → `*_page.dart` + `*_form_data.dart` mixin
3. Replace `*DataProvider` → `PageScope<T>`
4. Replace inputs → `flutter_input_kit` fields
5. Wire bridge getters on the page
6. Delete empty catches; add per-step recovery
7. Add harness test for the controller

Repeat per feature. Do not big-bang rewrite `lib/`.

## Security (mandatory, any phase)

- Remove `password_user` from SharedPreferences → secure storage or token-only remember-me.
- Move hardcoded keys (kiwash Stripe, Maps) to env/flavors.
- Sign-out: providers + `deleteUserData()` + secure wipe — no navigation in sign-out.

## lightNess-specific notes

- Keep the mixin pattern; do not rewrite to Notifier controllers.
- `auth_data_mixin.dart` is the first migration target (login/signup).
- `DebtDataMixin` / `ProfileDataMixin`: split by role after bridge works on a smaller feature.
- Supabase is primary backend per current code; retire Firebase paths feature-by-feature after adapter exists.

## kiwash-specific notes

- Consolidate ~12 list notifiers into `PagedList` first — highest line-count win.
- Chat (`unseen_message_counter_provider.dart`, 535 lines): use `change_stream` mechanism; migrate last.
- `WebRouteHelper` deleted when auto_route web URLs work.

## Definition of done (per app)

- [ ] `lemsa.yaml` committed and complete
- [ ] No `legacy.dart`, no `get_it`, no empty catches
- [ ] All new screens use page kit + input kit
- [ ] Router + guards replace GoScreen bootstrap
- [ ] No plaintext passwords in prefs
- [ ] At least one harness test per migrated feature
- [ ] CI: `dart analyze` + `flutter test` green

## Out of scope for migration PRs

- Rewriting every feature before shipping Phase B deps
- Publishing new kits to pub.dev (use path deps from `lemsa_packages/` during migration)
- Fixing typos in old folder names unless the feature is already touched
