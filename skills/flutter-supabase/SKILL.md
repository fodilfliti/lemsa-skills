---
name: flutter-supabase
description: >
  Supabase Flutter in Lemsa apps. Use for auth, Postgres tables, RPC, storage,
  realtime, or flutter_data_kit_supabase adapters. Composes with official Supabase
  agent skills when available.
license: MIT
metadata:
  author: fodilfliti
  version: "1.0.0"
---

# Flutter Supabase (Lemsa)

Version: `supabase_flutter` 2.17.2.

Also install official Supabase agent skills when available: `npx skills add supabase/agent-skills`.

## Init

```dart
await Supabase.initialize(url: env.supabaseUrl, anonKey: env.supabaseAnonKey);
```

Env via flutter_app_kit — never hardcode keys.

## Data access

Use `flutter_data_kit_supabase`:

- `mapSupabase(() async { ... })` on every public source method
- Throws `AppFailure` — never `PostgrestException` above adapter

## Auth

Auth adapter exposes `Stream<SessionState>` for Riverpod session provider. Do not navigate on auth callbacks — guard handles it.

## RLS

Assume RLS is enforced server-side. Client does not bypass; handle `PermissionFailure`.

## Realtime

Subscribe in repository or StreamNotifier — not in controller mixins.

## lightnessword note

Primary backend is Supabase; Firebase paths are legacy — migrate feature-by-feature.

## Do not

- Import supabase in controller mixins
- Return Either<String,T> — use AppFailure
- Store service role key in the app
