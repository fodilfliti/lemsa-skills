# lemsa_lab

Internal architecture sandbox — **Task Tracker** mock app.

## Run

```bash
cd lab
flutter pub get
flutter analyze
flutter test
flutter run
```

## Config

- [`lemsa.yaml`](lemsa.yaml) — project contract (`backend: mock` by default)
- [`spec/scenarios.md`](spec/scenarios.md) — S01–S12 scenario catalog

## CLI

```bash
cd tool/lab_cli
dart pub get
dart run lab_cli:lab feature my_feature
dart run lab_cli:lab scenario S04
dart run lab_cli:lab adapter supabase
```

## bd (Beads)

From repo root (after `npm i -g @beads/bd` or `brew install beads`):

```bash
bd init --quiet
bash scripts/seed-lab-bd.sh
```

## Codegen

After i18n, routes, or Drift schema changes:

```powershell
# Windows (from lab/)
.\scripts\post-change.ps1
```

```bash
# macOS / Linux
bash scripts/post-change.sh
```

Or step by step: `codegen` → `verify` (same folder).

Uses `dart run slang` + `build_runner` (auto_route + drift_dev). Default providers stay hand-written where noted below.
