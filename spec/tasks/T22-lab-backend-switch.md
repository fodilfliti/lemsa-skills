# T22 — Lab showcase: four backends (coded, manually selected)

## Goal

Prove adapters are **swappable**. Implement **four** API stacks as real code recruiters can open and compare. Runtime uses **one** selection (manual / `lemsa.yaml`) — others compile but are not the active source.

## The four stacks

| Id | Stack | What to show in code |
| --- | --- | --- |
| `mock` | In-memory | Default; no network; full CRUD for demos |
| `rest` | Dio + Retrofit (or Dio client + typed API) | `flutter_data_kit_dio`, FailureInterceptor, sample Retrofit interface **present** |
| `supabase` | Supabase Flutter | `flutter_data_kit_supabase`, `mapSupabase`, init hook via app_kit |
| `firebase` | Firebase Auth + Firestore (Storage optional) | `flutter_data_kit_firebase`, `mapFirebase`, init hook via app_kit |

## Selection (manual)

- Single switch: `lab/lemsa.yaml` `backend: mock | rest | supabase | firebase` (and matching `auth:`)
- OR a documented `--dart-define=LAB_BACKEND=…` / flavor — pick one, document in README
- Controllers/pages depend only on **repository interfaces** — never import Dio/Supabase/Firebase types
- Inactive backends: still in tree, clearly named (`*_source_rest.dart`, `*_source_supabase.dart`, …); DI/provider selects one

## Init (visible, skipped when not selected)

- `flutter_app_kit` bootstrap callbacks: `initSupabase` / `initFirebase` only run when that backend is selected
- Rest: no vendor init beyond Dio client factory
- Mock: no init
- Missing credentials: app still runs on **mock** with a logged warning — never crash cold start for recruiters

## Read first

- [../kits/flutter_data_kit.md](../kits/flutter_data_kit.md)
- [../errors.md](../errors.md) adapter zone
- [../lemsa-yaml.md](../lemsa-yaml.md)
- Sibling adapters under `../flutter_data_kit/packages/`

## Blocked by

T20. Prefer T13 adapters + firebase/drift packages available; if firebase/drift adapter incomplete, stub lab source behind the same interface and note blocker.

## Done when

- [ ] All four stacks exist as code under lab (or path-dep adapters + thin lab sources)
- [ ] Switching `backend` in config changes implementation **without** editing pages/controllers
- [ ] README section “Switch backend” with exact steps for recruiters
- [ ] Analyze/test green on default (`mock`)
- [ ] Optional: one test or script that asserts each source type implements the same contract

## Do not

- Require live Supabase/Firebase projects for CI default
- Commit real API keys — `.env.example` only
- Migrate kiwash / lightnessword
- Make Retrofit/Firebase the only path
