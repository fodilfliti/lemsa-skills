# Lab agent instructions

You are in **`lemsa_lab`** — the skills repo architecture sandbox, not a consumer app.

1. Read `lemsa.yaml` and `spec/scenarios.md`.
2. Use `bd` for task state (`bd ready`, `bd update --claim`, `bd close`).
3. Load skill **`lemsa-lab`** (from parent `skills/lemsa-lab/`).
4. Default backend is **mock** — swap adapters only for explicit scenarios.
5. Run `fvm flutter analyze` and `fvm flutter test` before closing bd issues.

Stubs in `lib/stubs/` stand in for unpublished kits until T10+ ships.
