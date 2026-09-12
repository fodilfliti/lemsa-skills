# Init — lemsa.yaml

## Ask-once ritual

Trigger when `lemsa.yaml` is missing and you are about to write app code or set up the project.

One message, recommend defaults, accept "defaults":

```text
Setting this project up the Lemsa way. Reply with numbers, or "defaults".

1. Backend        — a) supabase (recommended)  b) firebase  c) rest  d) hybrid
2. Local database — a) drift (recommended)     b) none
3. i18n           — a) slang (recommended)     b) easy_localization  c) none
4. Navigation     — a) auto_route (recommended) b) navigator
5. UI style       — a) design_system (recommended) b) drop_in  c) extensions  d) hybrid
```

## Detect from pubspec before asking

- `supabase_flutter` → backend supabase
- `firebase_core` + firestore → firebase; both → hybrid
- `dio`/`retrofit` without supabase/firebase → rest
- `drift` → local.db drift; `reaxdb_dart`/`loon`/`isar` → note migration
- `slang` → i18n slang; `easy_localization` → note migration
- `auto_route` → nav auto_route
- `flutter_screenutil` → note scale_kit migration

## Write lemsa.yaml

Include resolved defaults:

```yaml
version: 1
architecture: feature_first
naming: lemsa
backend: supabase
auth: supabase
state: riverpod3
forms: page_kit
nav: auto_route
i18n: slang
style: design_system
local:
  kv: shared_preferences
  secure: flutter_secure_storage
  db: drift
list_updates: callback
action_slot: auto
codegen:
  runner: build_runner
  gen_cli: true
flavors: []
```

Add dependencies implied by choices in the same change.

## Bootstrap order (main.dart)

1. WidgetsFlutterBinding
2. Env / dotenv
3. Firebase and/or Supabase init (per backend)
4. SharedPreferences → ProviderScope override
5. ScaleKitBuilder + theme merge (if scale kits in pubspec)
6. MaterialApp.router

Use `flutter_app_kit` `bootstrap()` when the app depends on it.

## FVM

Kit repos and new apps pin Flutter **3.35.7** via FVM. Use `fvm flutter` / `fvm dart`.
