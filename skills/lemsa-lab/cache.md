# Local cache (Drift) — lab

Lab uses **cache-aside** with Drift as storage truth (S07).

## Stack

| Piece | Path |
| --- | --- |
| SQLite schema | `lab/lib/core/database/` — `TaskRows`, `SyncOutbox`, `CacheMeta` |
| Local store | `DriftTaskLocalStore` |
| Remote | `MockTaskSource` (`backend: mock`) |
| Orchestration | `CachedTaskRepository` |
| UI stream | `taskListStreamProvider` → Drift `watch()` |
| Sync | `taskSyncProvider.syncNow()` + pull-to-refresh |

## Flows to demo

1. **Sign in** → `sync()` pulls mock seed into SQLite.
2. **Profile → Simulate offline** → create task → **pending sync** badge on row + app bar.
3. **Profile → Sync now** or pull list → flushes outbox, replaces snapshot from remote.
4. **Sign out** → `deleteUserData()` wipes Drift (flutter_app_kit contract).

## Swap remote only

Override `mockTaskSourceProvider` — Drift + `CachedTaskRepository` unchanged.

## Do not

- Persist entity lists only in Riverpod (see `spec/invariants.md`).
- Skip outbox on writes when offline-first is enabled.
