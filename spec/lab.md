# Lemsa lab — architecture sandbox + **portfolio showcase**

Runnable proof for kit ideas **and** the recruiter-facing demo that uses the whole family.

**Start here for humans:** [`lab/README.md`](../lab/README.md)

## What it is

| Path | Role |
| --- | --- |
| `lab/` | Flutter **showcase app** — multi-model product surface, swappable backends |
| [`lab/README.md`](../lab/README.md) | Recruiter front page — run, switch backend, kit map |
| `lab/spec/scenarios.md` | Scenario definitions (sandbox + portfolio) |
| `spec/lab.md` | This file — why, promotion, showcase rules |
| `.beads/` + `bd` CLI | Optional runtime task graph for scenarios |

The skills repo is **mostly docs**. `lab/` is the **only Dart app** here. Sibling kit repos hold publishable packages.

## Showcase goals (T20–T24) — implemented

1. Path-depend **all** Lemsa kits (scale, theme, core, page, input, data+adapters, nav, app).
2. Multiple domain models / features (Task, Project, Label, Inbox + Profile/session).
3. **Four backends in code** — `mock`, `rest` (Dio), `supabase`, `firebase` — selected via `--dart-define=LAB_BACKEND=…`.
4. Pages never import vendor SDKs; DI/`TaskSourceFactory` picks the source.
5. Init hooks for Supabase/Firebase only when selected; missing credentials fall back to mock.

## Mock-first CI

Default `lab/lemsa.yaml` and unset dart-define → `backend: mock`. Cold clone works without secrets.

## Promotion workflow

```text
idea → implement in lab/ → you review → promote?
  ├─ API pattern     → extract to kit repo
  ├─ agent rule      → update skills/
  └─ design only     → update spec/
```

Rules:

1. Nothing publishes until `fvm flutter analyze` + `fvm flutter test` pass in `lab/`.
2. Lab uses **path deps** to kits.
3. Stubs are deleted when kits land — never copied into kit repos.
4. **kiwash / lightnessword are not active migration targets** — archived; lab is the reference consumer.

## Out of scope

- Migrating `kiwash` / `lightnessword` (see [migration.md](migration.md) — archived).
- Publishing `lab/` to pub.dev.

## Task tracking

- Showcase: [T20](tasks/T20-lab-path-deps.md)–[T24](tasks/T24-lab-recruiter-docs.md)
- Early sandbox: [T06](tasks/T06-lemsa-lab.md)

## CLI

From `lab/tool/lab_cli` (if present):

```bash
fvm dart run lab_cli:lab feature <name>
fvm dart run lab_cli:lab adapter supabase
```
