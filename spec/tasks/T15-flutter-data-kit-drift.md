# T15 — flutter_data_kit_drift adapter

## Goal

Implement `packages/flutter_data_kit_drift` inside the `flutter_data_kit` workspace (persistent SyncQueue, local sources, `mapDrift`).

## Read first

- [../kits/flutter_data_kit.md](../kits/flutter_data_kit.md)
- [../errors.md](../errors.md)
- [../decisions.md](../decisions.md) D11
- Family prompt: use agent prompt for drift (parallel with nav/lab OK)

## Blocked by

T13.

## Done when

- [ ] Package in workspace with mapper + Drift SyncQueue + tests
- [ ] Core remains drift-free
- [ ] `skills/spec/package.md` status updated

## Do not

- Separate GitHub repo for drift
- Migrate kiwash / lightnessword
