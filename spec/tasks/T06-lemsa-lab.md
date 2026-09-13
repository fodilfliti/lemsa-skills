# T06 — Lemsa lab sandbox

## Goal

Bootstrap `lab/` Flutter sandbox, lab CLI, bd scenario graph, and lab skills inside this repo.

## Read first

- [../lab.md](../lab.md)
- [../architecture.md](../architecture.md)
- [../../lab/spec/scenarios.md](../../lab/spec/scenarios.md) (after bootstrap)

## Blocked by

T05 (prompts exist).

## Files

- `lab/` — Flutter app + `lemsa.yaml` + stubs
- `lab/tool/lab_cli/` — scaffold CLI
- `lab/spec/scenarios.md`
- `spec/lab.md`
- `skills/lemsa-lab/`, `skills/lemsa-pub-deps/`
- `.beads/`, `.cursor/rules/beads.mdc` (via `bd setup cursor`)

## Steps

1. Add `spec/lab.md`, update `AGENTS.md`, `spec/package.md`, `spec/lemsa-yaml.md`.
2. Create `skills/lemsa-lab/` and `skills/lemsa-pub-deps/`.
3. Scaffold `lab/` with FVM 3.35.7, Task Tracker feature, mock backend.
4. Implement `lab_cli` commands: `create`, `feature`, `scenario`, `adapter`, `rest`, `link-kit`.
5. `bd init --quiet`, `bd setup cursor`, seed S01–S12 with dependencies.
6. S03–S04 vertical slice green; S06–S08, S11–S12 as opt-in stubs.

## Done when

- `fvm flutter analyze` and `fvm flutter test` pass in `lab/`.
- All twelve scenario entries exist in `lab/spec/scenarios.md`.
- `bd list` shows Lab S01–S12 with correct blockers.
- Skills index lists `lemsa-lab` and `lemsa-pub-deps`.

## Do not

- Publish `lab/` to pub.dev.
- Add real Supabase/Firebase credentials to the repo.
- Edit reference apps (`kiwash`, `lightnessword`) — **out of scope**; use lab showcase T20–T24 instead.
- Migrate production apps as family tasks (see [../migration.md](../migration.md)).
