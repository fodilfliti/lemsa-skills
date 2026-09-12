# `lemsa.yaml` — the project contract

One file at the app root. An agent reads it **first**, asks **once** if it is missing, writes it, and never asks again.

This generalizes `scale_kit.yaml`, which works for exactly that reason: the interrogation happens once per project instead of once per session.

## Why one file instead of one per kit

Seven kits would mean seven config files and seven interrogations on a new project. A single file with per-kit sections keeps the ritual to one exchange. See [decisions.md](decisions.md) D10.

`scale_kit.yaml` / `.scalekit.yaml` stay supported. If both exist, `lemsa.yaml`'s `style:` wins and the agent should offer to fold the old file in.

## Full schema

Every key is optional. Omitted keys take the default in the third column. A written file should contain the resolved values, not the omissions.

```yaml
# lemsa.yaml — written by the lemsa-flutter skill. Edit freely; agents read this.
version: 1

architecture: feature_first     # feature_first | layer_first
naming: lemsa                   # file/class suffix conventions, see architecture.md

backend: supabase               # supabase | firebase | rest | hybrid | mock
auth: supabase                  # supabase | firebase | rest | none

state: riverpod3                # data/state layer only — never the form layer
forms: page_kit                 # page_kit | plain
nav: auto_route                 # auto_route | navigator
i18n: slang                     # slang | easy_localization | none
style: design_system            # design_system | drop_in | extensions | hybrid

local:
  kv: shared_preferences        # shared_preferences | none
  secure: flutter_secure_storage # flutter_secure_storage | none
  db: drift                     # drift | none | loon (loon only when user asks)

logging:
  redact: true                  # scrub PII via redact package before logs

ui:
  loading: loading_indicator    # loading_indicator | material
  loading_type: lineScale       # Indicator.* name from loading_indicator

list_updates: callback          # callback | pop_result | change_stream
action_slot: auto               # auto | bottom_bar | app_bar | inline | fab

codegen:
  runner: build_runner          # riverpod/auto_route/slang/drift/freezed generators
  gen_cli: true                 # allow `dart run <kit>:gen ...` scaffolding
  http: retrofit                # retrofit | hand_dio
  models: copy_with_extension   # copy_with_extension | manual | freezed

flavors: [dev, staging, prod]   # [] when the app has none
```

## Key ownership

A kit reads only the keys it owns, plus `version` and `architecture`. Reading someone else's key couples two packages that are supposed to be independent.

| Key | Owner | Read also by |
| --- | --- | --- |
| `version` | `lemsa-flutter` | all |
| `architecture`, `naming` | `lemsa-flutter` | all |
| `backend`, `auth` | `flutter_data_kit` | `flutter-supabase`, `flutter-firebase`, `flutter-dio` |
| `state` | `flutter-riverpod3` | `flutter_data_kit`, `flutter_nav_kit` |
| `forms` | `flutter_page_kit` | `flutter_input_kit` |
| `nav` | `flutter_nav_kit` | `flutter_page_kit` (for `PageNavigator` wiring) |
| `i18n` | `flutter-slang` | `flutter_input_kit` (field labels), `lemsa_core_kit` (failure messages) |
| `style` | `flutter_scale_kit` | `flutter_scale_theme_kit`, `flutter_input_kit` |
| `local.*` | `flutter_app_kit` | `flutter-drift`, `flutter_data_kit` |
| `list_updates` | `flutter_data_kit` | `flutter_page_kit` |
| `action_slot` | `flutter_page_kit` | — |
| `logging.redact` | `lemsa_core_kit` | `lemsa-flutter` |
| `ui.loading`, `ui.loading_type` | `lemsa-flutter` | `flutter_page_kit` |
| `codegen.*` | `lemsa-flutter` | all |
| `flavors` | `flutter_app_kit` | — |

## The ask-once ritual

Trigger it when the agent is about to set a project up, or is about to write the first file that depends on a missing key. Do not trigger it for a read-only question.

Ask in **one** message, recommend defaults, and accept "defaults" as an answer:

```text
Setting this project up the Lemsa way. Reply with numbers, or just "defaults".

1. Backend        — a) supabase (recommended)  b) firebase  c) rest  d) hybrid
2. Local database — a) drift (recommended)     b) none
3. i18n           — a) slang (recommended)     b) easy_localization  c) none
4. Navigation     — a) auto_route (recommended) b) navigator
5. UI style       — a) design_system (recommended) b) drop_in  c) extensions  d) hybrid
```

Everything else takes its default without asking: `architecture: feature_first`, `state: riverpod3`, `forms: page_kit`, `local.kv: shared_preferences`, `local.secure: flutter_secure_storage`, `list_updates: callback`, `action_slot: auto`, `codegen.runner: build_runner`.

If the user skips or says "defaults", write the recommended row and say plainly which values were assumed. Then write the file **before** writing any code.

## Detection before asking

Read `pubspec.yaml` first and pre-fill. Asking about a choice already visible in the manifest wastes the one exchange you get.

- `supabase_flutter` present → `backend: supabase`
- `firebase_core` + `cloud_firestore` present → `backend: firebase`
- both present → `backend: hybrid`, and mention that the adapter split resolves it
- `dio` or `retrofit` present with no Supabase/Firebase → `backend: rest`
- `drift` present → `local.db: drift`; `reaxdb_dart`, `loon`, `isar` or `hive` present → `local.db: none` plus a migration note
- `slang` present → `i18n: slang`; `easy_localization` present → `i18n: easy_localization` plus a migration note
- `auto_route` present → `nav: auto_route`
- `flutter_screenutil` present → note the `flutter_scale_kit` migration; do not silently set `style`

## Rules for agents

- Read the file before the first code edit in a session. Cache it for the session; do not re-read per file.
- Never ask about a key the file already answers.
- Never write a key the user did not choose and that has no default. Add the key with its default instead, so the file stays complete.
- When a value forces a dependency (`i18n: slang` needs `slang`, `slang_flutter`, `slang_build_runner`), add the dependency in the same change and say so.
- When a value conflicts with `pubspec.yaml` (file says `drift`, manifest has `reaxdb_dart`), the file states intent and the manifest states reality. Surface the gap, do not silently "fix" either.
- On `version` mismatch, migrate the file forward and record the change in the app's own docs.

## Versioning

`version: 1` is the current schema. A new required key, a renamed key, or a changed default bumps it. Adding an optional key with a backward-compatible default does not. The `lemsa-flutter` skill owns the migration from one version to the next.
