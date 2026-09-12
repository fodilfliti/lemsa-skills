# Phase 4 — Build flutter_data_kit workspace

## Repo path

`C:\Users\lemsa\Documents\apps\lemsa_packages\flutter_data_kit\`

Use Dart pub workspaces:

```text
flutter_data_kit/
packages/flutter_data_kit_dio/
packages/flutter_data_kit_supabase/
```

## Read first

1. `skills/spec/kits/flutter_data_kit.md`
2. `skills/spec/errors.md` (adapter zone)
3. `skills/spec/bridge.md` (PagedList, Change)

## Goal

**Core:**

- `PagedQuery`, `PagedState`, `PagedList` mixin
- `ref.cacheFor(Duration)` extension
- Repository/source base types throwing AppFailure

**flutter_data_kit_dio:**

- `buildDioClient` + FailureInterceptor
- Token interceptor hook (Firebase JWT — app supplies callback)

**flutter_data_kit_supabase:**

- `mapSupabase()` wrapper
- Example source for one table CRUD

## Reference apps

- kiwash: `lib/utils/dio_client.dart`, `lib/services/api_service.dart`
- lightnessword: `supabase_auth_remote_source.dart`, unified auth pattern

Replace untyped maps with typed models at boundary.

## Acceptance

- [ ] Mapper unit tests per backend
- [ ] PagedList fake source integration test
- [ ] Workspace resolves; supabase app does not pull firebase

## Out of scope

- firebase and drift adapters (stub packages/README only)
