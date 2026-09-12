# flutter_data_kit

Backend contracts, pagination, cache policy, and failure mapping. Backends are adapter packages.

## Repo layout (pub workspace)

```text
flutter_data_kit/                 # contract + PagedList + cacheFor
packages/
  flutter_data_kit_dio/
  flutter_data_kit_supabase/
  flutter_data_kit_firebase/      # later
  flutter_data_kit_drift/         # later
```

## Owns (core package)

- `PagedQuery`, `PagedState<T>`, `PagedList<T,Q>` mixin for `@riverpod` notifiers
- `PagedSource<T,Q>` interface
- `ref.cacheFor(Duration)` extension
- `Source` / `Repository` base patterns (throw `AppFailure`, never vendor types)
- `SyncQueue` interface (offline enqueue — used by controllers)

## Adapter packages

Each adapter owns **one mapper** and **source implementations**:

| Adapter | Mapper | Sources |
| --- | --- | --- |
| `_dio` | `FailureInterceptor` on Dio | REST endpoints via Retrofit or hand client |
| `_supabase` | `mapSupabase()` wrapper | Auth, Postgres tables, RPC, storage, realtime |
| `_firebase` | Firebase → `AppFailure` | Auth, Firestore, Storage, FCM |
| `_drift` | SQLite → `AppFailure` | Local tables, migrations, reactive queries |

Apps depend on `flutter_data_kit` + exactly the adapters they need. A Supabase app never resolves Firebase.

## Replaces in reference apps

- ~12 hand-written list notifiers (`ServiceListNotifier`, etc.)
- `MapDataModel` / `MapGetAllDataModel` untyped wrappers
- `unified_auth_remote_source.dart` + `const useSupabase`
- `reaxdb_dart`, `loon`, Isar remnants → `_drift`

## `list_updates` (from lemsa.yaml)

Documented in [../bridge.md](../bridge.md): `callback` (default), `pop_result`, `change_stream`.

## Invariants

- Vendor exception types never exported from adapter public API.
- Every public source method is wrapped or behind an interceptor (test enforced).
- Repositories throw; they do not return `Either<String,T>`.

## Tests

- Mapper table: each vendor error code → expected `AppFailure` subtype.
- `PagedList`: upsert/removeById/patch/loadMore/refresh/setQuery.
- `cacheFor`: failed fetch is not cached.
