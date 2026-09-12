# Lemsa lab — architecture sandbox

Runnable proof for kit ideas and skills **before** they ship to pub.dev or `npx skills add`.

## What it is

| Path | Role |
| --- | --- |
| `lab/` | Flutter app — Task Tracker example, mock backend by default |
| `lab/spec/scenarios.md` | Scenario definitions S01–S12 |
| `spec/lab.md` | This file — why, promotion rules |
| `.beads/` + `bd` CLI | Runtime task graph for scenario execution |

The skills repo is **mostly docs**. `lab/` is the **only Dart** here until kits exist in sibling repos.

## Mock-first

Default `lab/lemsa.yaml` sets `backend: mock`. The lab proves **layer mapping** and **swappable adapters**, not live Supabase/Firebase.

When you say **“test supabase path”** (S06), an agent adds `SupabaseTaskSource` behind the same `TaskSource` contract — pages and controllers stay untouched.

## Promotion workflow

```text
idea → implement in lab/ → you review → promote?
  ├─ API pattern     → extract to kit repo (T10–T14)
  ├─ agent rule      → update skills/
  └─ design only     → update spec/
```

Rules:

1. Nothing publishes until the covering lab scenario passes (`fvm flutter analyze` + `fvm flutter test`).
2. Lab may use **path deps** to in-progress kits or **stubs** in `lab/lib/stubs/` until kits ship.
3. **“Test option X”** → `bd ready` → claim issue `Lab S0X` → read `lab/spec/scenarios.md` → implement → close bd issue.
4. Stubs are **deleted or replaced** on promotion — never copied into kit repos.

## Extract to `flutter_data_kit` (T13)

When T13 starts, promote from lab:

- `TaskSource` contract pattern → `PagedSource` / repository base in `flutter_data_kit`
- `MockTaskSource` → test fixture in kit repo
- Adapter stubs (`*_source_supabase.dart`, etc.) → respective adapter packages
- Remove duplicated stubs from `lab/lib/stubs/` as real kit imports land

## Task tracking

- **Durable spec:** `spec/tasks/Txx` + `lab/spec/scenarios.md`
- **Live execution:** Beads (`bd`) issues titled `Lab S01: …` through `Lab S12: …`

Agents use `bd` for status, not markdown TODO lists. Conservative git policy: track with bd; do not commit/push unless asked.

## CLI

From `lab/tool/lab_cli`:

```bash
fvm dart run lab_cli:lab feature tasks
fvm dart run lab_cli:lab scenario S04
fvm dart run lab_cli:lab adapter supabase
fvm dart run lab_cli:lab rest tasks
```

See [tasks/T06-lemsa-lab.md](tasks/T06-lemsa-lab.md).
