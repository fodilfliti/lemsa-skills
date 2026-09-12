---
name: flutter-drift
description: >
  Drift local SQL in Lemsa apps. Use for local database, migrations, offline
  cache, replacing reaxdb/loon/isar/hive, or mirroring Postgres schemas.
license: MIT
metadata:
  author: fodilfliti
  version: "1.0.0"
---

# Flutter Drift (Lemsa)

Versions: `drift` 2.34.3, `drift_flutter` 0.3.1, optional `drift_postgres` 1.3.1 for server-side tooling.

## Role

Drift is **storage truth** for entities. Riverpod providers are reactive **views** over Drift queries — not the cache of record.

Scalars (theme, locale) stay in SharedPreferences. Tokens in secure storage.

## Setup

```yaml
dependencies:
  drift: ^2.34.3
  drift_flutter: ^0.3.1
  sqlite3_flutter_libs: any
dev_dependencies:
  drift_dev: ^2.34.3
  build_runner: ^2.16.0
```

## Patterns

- `@DriftDatabase` + DAOs
- `watch()` streams for UI via providers
- Versioned migrations with tests
- `deleteUserData()` on sign-out wipes user tables

## Postgres mirror

Use `drift_postgres` only when sharing query code with server Postgres — not required for typical mobile apps.

## Migration

- `reaxdb_dart` (lightnessword) → Drift table-by-table
- `loon` (kiwash chat cache) → Drift or keep until chat refactor

## Do not

- Store credentials in Drift unencrypted
- Use Riverpod Notifier persistence for entity lists
- Skip migration tests
