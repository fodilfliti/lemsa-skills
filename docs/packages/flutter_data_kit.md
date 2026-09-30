# flutter_data_kit (+ adapters)

**Job:** **data contracts**, pagination, cache helpers, and repository patterns that never leak vendor types into UI.

**Not its job:** widgets, Riverpod providers (apps declare those), or bundling every backend into one package.

## Why it exists

Apps had:

- ~12 hand-rolled list notifiers with the same paging bugs
- Untyped map wrappers (`MapDataModel`)
- Dio/Supabase/Firebase exceptions bubbling into screens
- Offline/sync ideas stuck inside one app’s private code

Core data_kit defines the **shape**. Adapters implement **one** backend each so a Supabase app never resolves Firebase (and vice versa).

## Repo layout

```text
flutter_data_kit/                    # contracts only
packages/
  flutter_data_kit_dio/
  flutter_data_kit_supabase/
  flutter_data_kit_firebase/
  flutter_data_kit_drift/
```

One git repo, multiple pub packages (workspace). Decision D12.

## What the core package does

| Piece | Purpose |
| --- | --- |
| `DataSource` / `CrudSource` patterns | Read/write contracts |
| `Repository` base guidance | Orchestrates sources; throws `AppFailure` |
| `PagedQuery` / `PagedState` / `PagedResult` | Typed paging vocabulary |
| `PagedSource<T,Q>` | Backend paging contract |
| `PagedList` mixin | Shared notifier behavior for lists |
| `cacheFor` | `ref.cacheFor(Duration)` extension |
| `SyncQueue` interface | Offline enqueue for controllers |
| `Identifiable` | Common id surface for upserts |

Adapters **must** map vendor errors → `AppFailure`. Vendor types stop at the adapter boundary.

## Adapter packages

| Package | Mapper | Implements |
| --- | --- | --- |
| `flutter_data_kit_dio` | Dio interceptor / failure map | REST (often Retrofit); bearer token hook; 401 refresh + replay (`AuthRetryInterceptor`) |
| `flutter_data_kit_supabase` | `mapSupabase()` | Auth helpers (session stream, access-token reader, sign-in/out), tables, RPC, storage, realtime |
| `flutter_data_kit_firebase` | Firebase → `AppFailure` | Auth helpers (session stream, ID-token reader, sign-in/out), Firestore, Storage, FCM |
| `flutter_data_kit_drift` | SQLite → `AppFailure` | Local tables, migrations, reactive queries |

## Mixed backends: auth from one provider, data from REST

Common setup: Firebase **or** Supabase handles sign-in, your own REST API
serves the data. The Dio adapter never imports an auth SDK — it takes a
`TokenReader` callback, and each auth adapter ships a matching reader:

```dart
final auth = FirebaseAuth.instance;           // or Supabase.instance.client.auth
final api = buildDioClient(
  baseUrl: env.apiBaseUrl,
  readToken: firebaseIdTokenReader(auth),      // supabaseAccessTokenReader(auth)
  refreshToken: firebaseIdTokenReader(auth, forceRefresh: true),
  onUnauthorized: () => unawaited(signOutFirebase(auth)),
);
```

On a 401 the client force-refreshes once (shared by concurrent requests),
replays the request, and only then gives up with
`AuthFailure(AuthReason.expired)` + `onUnauthorized`. The session stream
(`watchFirebaseSession` / `watchSupabaseSession`) feeds nav_kit's
`AuthSession`, so `AuthGuard` redirects without screen code.

Why not a hand-written token cache (reference apps)? Both SDKs already cache
and refresh tokens; custom timers leaked and hid errors.

App `pubspec` example:

```yaml
dependencies:
  flutter_data_kit: ^…
  flutter_data_kit_supabase: ^…   # only what you need
```

## Architecture in a feature

```text
pages / state (@riverpod)
        │
        ▼
  FeatureRepository
        │
        ▼
  FeatureSource (interface in app or kit patterns)
        │
        ▼
  SupabaseFeatureSource / DioFeatureSource / …
        │
        ▼
  Vendor SDK
```

Domain models stay in `features/*/domain/` — no I/O. Drift is the chosen local SQL (D11); prefs for scalars; secure storage for secrets (app_kit).

## Why this approach

| Choice | Why |
| --- | --- |
| Contract vs adapters | Optional backends; clean dependency graphs |
| Shared PagedList | Delete duplicated list notifiers |
| Throw AppFailure in adapters | UI never switches on DioException (errors.md) |
| Workspace for adapters | Contract change = one coordinated release |
| Drift over Isar/Hive/ReaxDB | Typed SQL, web, migrations, Postgres kinship (D11) |

## Depends on

- Core: `lemsa_core_kit` (+ Riverpod types only where paging mixins need them — keep vendor-free).
- Adapters: core data_kit + one vendor SDK each.

## Related

- Errors: [../../spec/errors.md](../../spec/errors.md)  
- Riverpod lifetimes: [../../spec/riverpod.md](../../spec/riverpod.md)  
- Lab multi-backend: [lab.md](lab.md)
