---
name: lemsa-lab
description: >
  Work in the lemsa skills lab/ sandbox. Use bd for task state, mock-first
  backends, layer mapping, scenario S01-S12. Activate for test scenario,
  test option, lab architecture, Task Tracker, or promoting patterns before kits.
license: MIT
metadata:
  author: fodilfliti
  version: "1.0.0"
---

# Lemsa lab

You are validating Lemsa architecture in **`lab/`** before patterns ship to kit repos or installable skills.

Read [layers.md](layers.md) for the import matrix. Read [bridge.md](bridge.md) for `PageNavigator`, `Notices`, and `failureText`. Read [page-data.md](page-data.md) for `text()` / validators / `fieldErrorText` and dispose rules. Read [cache.md](cache.md) for Drift cache-aside.

## Before coding

1. `bd ready --json` — pick unblocked issue titled `Lab S0X: …`
2. `bd update <id> --claim`
3. Read `lab/lemsa.yaml` — default `backend: mock`
4. Read scenario scope in `lab/spec/scenarios.md` (or embedded list below)

## Scenario triggers

| ID | Phrase | Proves |
| --- | --- | --- |
| S01 | test core failures | AppFailure, per-step catch |
| S02 | test page harness | PageHarness, keyed `busy.of`, LemsaLoader, field registry |
| S03 | test task list flow | domain → repo → provider → AsyncView |
| S04 | test task form flow | `text()` / `validateForm`, bridge, submit upsert |
| S05 | test mock backend | MockTaskSource, provider swap |
| S06 | test supabase path | SupabaseTaskSource (explicit only) |
| S07 | test drift path | DriftTaskSource (explicit only) |
| S08 | test firebase path | FirebaseTaskSource (explicit only) |
| S09 | test nav + auth guard | auto_route + session mock |
| S10 | test i18n | slang keys |
| S11 | test retrofit path | Retrofit + DTO + mapper |
| S12 | test loon path | Loon cache (explicit only) |

## Rules

- **Mock-first:** default backend is in-memory mock; add real adapters only when scenario or user requests.
- **Backend swap:** new `*TaskSource` + one `@riverpod` override — never rewire pages/controllers.
- **Form layer never imports Riverpod.** Controllers use mixins + abstract getters.
- **DTOs stay in data/** — controllers see domain models only.
- Use **`LemsaLoader`** (`loading_indicator`), not `CircularProgressIndicator`.
- Run `fvm flutter analyze` and `fvm flutter test` in `lab/` before `bd close` — or `bash scripts/post-change.sh` / `.\scripts\post-change.ps1` (codegen + analyze + test).
- Follow-ups: `bd create --deps discovered-from:<parent-id>` — not markdown TODOs.

## When done

```bash
bd close <id> --reason "analyze+test green"
```

Do **not** commit, push, or `bd dolt push` unless the user asks.

## Also load

- `lemsa-pub-deps` — when adding/upgrading lab dependencies
- `lemsa-flutter` — consumer rules that also apply in lab

## Do / don't

- Do implement only the scenario delta
- Do use stubs in `lab/lib/stubs/` until real kits exist
- Do lock form inputs + pop while `busy.of('save')` (see [page-data.md](page-data.md))
- Don't add Loon unless S12 or user says "use loon"
- Don't add Supabase/Firebase credentials to the repo
- Don't build `EmailField` / `PageAction` in lab — wire `TextField` + `FilledButton` until those kits exist
