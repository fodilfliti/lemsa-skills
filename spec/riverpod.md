# The Riverpod layer

Riverpod 3, codegen only. Floor: `flutter_riverpod` / `hooks_riverpod` 3.4.2, `riverpod_annotation` 4.0.6, `riverpod_generator` 4.0.8, `riverpod_lint` 3.1.8.

Riverpod 3.0 has been stable since September 2025. An app on 2.x is a migration target, not a supported baseline.

## The dividing rule

**Would this state survive a page pop?**

- **Yes** → a provider. Session, current user, entity lists and pagination, cached entities, realtime streams, unread counters, theme mode, locale, connectivity, remote config, and all dependency injection.
- **No** → the controller mixin. Text controllers, focus nodes, form validity, stepper index, toggles, submit busy, submit failure.

No third home. Page-scoped providers overridden per route are not a pattern here — that is what the controller is for.

## Riverpod is the only DI

`get_it` and `injectable` are removed. Every dependency is a provider.

```dart
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError('overridden in main');

@Riverpod(keepAlive: true)
DebtRepository debtRepository(Ref ref) => DebtRepository(
  remote: ref.watch(debtSourceProvider),
  local: ref.watch(debtCacheProvider),
);
```

The pre-`runApp` case — something async that must exist before the first frame — is an override, not a service locator:

```dart
final prefs = await SharedPreferences.getInstance();
runApp(ProviderScope(
  overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  child: const App(),
));
```

Rationale in [decisions.md](decisions.md) D4. `kiwash` already uses this shape for `currentUserProvider`, so the pattern is familiar; it just needs to become the only one.

## Which provider kind

| Build returns | Generates | Use for |
| --- | --- | --- |
| `T` from a **function** | `Provider` | Stateless dependency: repository, client, navigator, mapper |
| `T` from a **class** | `Notifier` | Synchronous mutable state: theme mode, active filter, tab index |
| `Future<T>` | `AsyncNotifier` | Async load plus mutations: profile, settings, a single entity |
| `Stream<T>` | `StreamNotifier` | Realtime: auth changes, chat messages, connectivity |

Parameters on `build()` replace `.family`:

```dart
@riverpod
Future<DebtModel> debt(Ref ref, {required String id}) =>
    ref.watch(debtRepositoryProvider).byId(id);
```

## Banned

- `StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider`
- `import 'package:hooks_riverpod/legacy.dart'`
- `ProviderScope.containerOf(...)`, and any global `BuildContext` used to reach a container
- manual `Provider(...)` declarations where codegen would do

Migration markers in the reference apps: kiwash imports `legacy.dart` throughout, and lightnessword's `currentUserProvider` is a `ChangeNotifierProvider<UserNotifier>`. Both are converted, then a custom lint keeps them out.

## Session drives the router

```dart
@Riverpod(keepAlive: true)
class Session extends _$Session {
  @override
  Stream<SessionState> build() => ref.watch(authGatewayProvider).changes;
}
```

Fed by the auth adapter's stream (Supabase `onAuthStateChange`, Firebase `authStateChanges`). Read by an auto_route guard:

```dart
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this.ref);
  final Ref ref;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final signedIn = ref.read(sessionProvider).valueOrNull?.isSignedIn ?? false;
    signedIn ? resolver.next() : resolver.redirectUntil(const LoginRoute());
  }
}
```

This replaces the ~200-line `GoScreen` bootstrap in both reference apps and removes `Navigator.pushAndRemoveUntil` from inside the auth controller. Sign-out becomes a state change the router reacts to, so no screen navigates on sign-out.

## `AsyncView`

Both reference apps read `AsyncValue` by hand and routinely omit the error branch — kiwash's `dashboard_screen.dart` does `currentaddress.isLoading || currentaddress.isReloading` at roughly line 742, with no error case. One widget closes it, and it is the only place an app should destructure `AsyncValue`.

```dart
AsyncView(
  value: ref.watch(debtListProvider),
  data: (debts) => DebtListView(debts),
  empty: () => EmptyState(t.debt.none),   // optional
)
```

Requirements on the implementation:

- Exhaustive `switch` over `AsyncValue`, so error cannot be skipped.
- Distinguish `isLoading` (no data yet → skeleton) from `hasValue && isReloading` (keep the data, show a subtle indicator). This is the decision both apps make by hand at each call site.
- Unwrap Riverpod 3's `ProviderException` to reach the underlying `AppFailure` before rendering, because provider errors now arrive wrapped.
- Surface `AsyncValue.retrying` in the retry affordance, since Riverpod 3 retries automatically and a second manual retry button is misleading.
- `empty` is optional and defaults to rendering `data` with an empty collection.

## `ref.listen`, narrowed

Rule: **`watch` to render, `listen` to do.** Four categories, three of which resolve away.

| Category | Verdict |
| --- | --- |
| Navigation on state change | **Deleted** — the router guard handles it |
| Copying provider state into local state | **Banned** — you wanted `ref.watch` at the render site |
| Provider reacting to provider | **Moves** into the Notifier's `build()`, out of the widget |
| Fire-once UI effect | **Kept** — toast, dialog, haptics, scroll-to-top, closing a sheet, refresh on push |

### Error ownership

This is what makes most listeners disappear rather than relocate:

- An **action's** failure belongs to the caller of the action — the controller's `failure`, rendered by `FormPage`.
- A **provider's** failure belongs to that provider's renderer — `AsyncView` inline, `listenFailure` in the background.

No case where both compete to display one error.

Worked example. Today's login listener:

```dart
ref.listen(authNotifierProvider, (previous, next) {
  next.maybeWhen(
    orElse: () => null,
    authenticated: (_) async => await goToHomeF(),
    unauthenticated: (message) => error.value = message ?? "",
  );
});
```

Four defects in five lines: navigating from a listener double-pushes if the provider emits twice; the async callback has no `mounted` check; `error.value = message` gives two objects ownership of one truth; `orElse: () => null` is noise. Under this contract the whole block is deleted — `AuthGuard` redirects, and `submit()`'s own `failure` renders the wrong-password message.

### The one helper

`flutter_page_kit` ships exactly one, because unwrapping `ProviderException` is the step everyone misses:

```dart
ref.listenFailure(debtSyncProvider, notices);
```

Everything else is plain `ref.listen` under three rules: declared in `build()` (never `initState` — `riverpod_lint` enforces this), `mounted` checked before any async continuation, and the callback performs an effect rather than assigning state.

`listenManual` is a deliberate non-tool. It needs manual disposal, which is the leak class this design removes. If you want it, the listener belongs in a Notifier.

## State lifetime

Riverpod does **not** solve persistence. Provider state dies with the process regardless of `keepAlive`. "Keep alive" and "keep data" are separate problems.

### Three tiers

**App lifetime — `@Riverpod(keepAlive: true)`.** Deliberately tiny and enumerable: session, connectivity, theme mode, locale, remote config, and the stateless dependency providers. Recreating a Dio client per screen is wasteful, which is why repositories and clients are keepAlive.

Invariant: nothing keepAlive may hold user data in memory. A repository with an in-memory cache that lives forever is how one user's data reaches the next.

**Session lifetime.** Resolved by **dependency**, not by a hand-maintained invalidation list:

```dart
@Riverpod(keepAlive: true)
Future<UserProfile> currentUser(Ref ref) {
  final userId = ref.watch(sessionProvider.select((s) => s.valueOrNull?.userId));
  if (userId == null) throw const AuthFailure(AuthReason.signedOut);
  return ref.watch(userRepositoryProvider).byId(userId);
}
```

Sign-out rebuilds it, and everything downstream rebuilds too. Nothing has to be remembered when a new provider is added. Rationale in D5.

**Page lifetime — autoDispose, the codegen default.** Lists, detail fetches, search results. Most providers belong here.

### The middle ground

"Dispose, but not on every back-navigation" ships as a helper in `flutter_data_kit`:

```dart
@riverpod
Future<DebtModel> debt(Ref ref, {required String id}) async {
  final debt = await ref.watch(debtRepositoryProvider).byId(id);
  ref.cacheFor(const Duration(minutes: 5));
  return debt;
}
```

`cacheFor` wraps `ref.keepAlive()` plus a `Timer` plus `ref.onDispose(timer.cancel)`. Placement **after** the await matters: a failed fetch must not be cached, which is the bug a bare `keepAlive: true` gives you.

The `onCancel` / `onResume` variant disposes N seconds after the last listener leaves — better when the concern is a quick back-and-forth rather than a fixed freshness window.

### Persistence routing

If it must survive a restart, it is not provider state:

| Data | Home |
| --- | --- |
| Entities, lists, anything queried | Drift — the provider is a reactive view over it |
| Scalars: theme, locale, onboarding, last tab | `shared_preferences` |
| Tokens, refresh tokens, credentials | `flutter_secure_storage` |

Riverpod 3's built-in Notifier persistence is acceptable for a scalar or two. Entities route through Drift so there is one source of truth and one migration story.

Credentials never go to `shared_preferences`. Both reference apps currently write `password_user` there in plaintext.

### Sign-out clears three layers

Today's `signOut()` clears one:

```dart
ref.read(currentUserProvider.notifier).update(null);
await ref.read(authNotifierProvider.notifier).signOut();
Navigator.pushAndRemoveUntil(...);
```

Provider state is nulled while the local database is untouched and prefs still hold `email_user` / `password_user`. On a shared device the next person signs in and sees the previous user's cache.

Replacement, one function:

1. Providers — automatic, via the session dependency.
2. Local database — `deleteUserData()`.
3. Secure storage — drop tokens.

No navigation. The router reacts to the session change.

### keepAlive governance

The list of keepAlive providers lives in the app's own docs and stays short enough to read at a glance. Additions need a written reason.

Ungoverned it spreads by copy-paste until every screen's data is immortal, which is where kiwash's `@Riverpod(keepAlive: true)` chat providers and `ChangeNotifierProvider<UserNotifier>` already sit.

## Two explicit non-choices

**No Riverpod 3 mutations.** They are a real codegen feature for tracking an operation's pending and error state, but `submit()` lives in the controller and already owns `busy` and `failure`. Using both gives one button two sources of truth.

**No client-side filtering once a list is paginated.** Push the filter into the query so the source refetches. lightnessword's `filteredDebtListProvider` combines `debtListProvider` + `selectedRoleDebtProvider` + `searchDebtProvider` client-side, which is correct only while the whole list is in memory — on a paginated list it searches page 1 of 40.

## Riverpod 3 consequence

Providers now filter notifications with `==`, so provider state classes need real value equality. Use freezed on provider state, including `PagedList`'s state. Kiwash's hand-written `copyWith` classes such as `ServiceState` have no `==` and would either over-notify or, worse, appear to work until a rebuild is skipped.

## File organization

One `state/` folder per feature holding only provider declarations, nothing else. Every provider in the app is then greppable in one pass and `build_runner` output is predictable.

```text
lib/features/debt/state/debt_providers.dart
```

In the reference apps providers live in `providers/`, `providers/state/`, `providers/services/local/` and `data/datasources/remote/` simultaneously, which is why nobody can count them.

## Tooling

- `riverpod_lint` + `custom_lint` in `dev_dependencies`, wired through `analysis_options.yaml`.
- `riverpod_lint` ships `dart fix` migration helpers — use them for the 2.x → 3.x pass before hand-editing.
- Do not upgrade `riverpod` without upgrading `riverpod_generator` in lockstep. A 3.x runtime with a 2.x generator emits code referencing removed `Ref` subtypes and fails to compile confusingly.
- Pin exact versions during a migration, relax to carets after.
