---
name: lemsa-lab
description: >
  Work in the lemsa skills lab/ showcase app. Activate for recruiter demo,
  showcase, switch backend, portfolio scenarios, Task Tracker lab, or
  T20–T24 kit composition — not for migrating kiwash/lightnessword.
license: MIT
metadata:
  author: fodilfliti
  version: "2.0.0"
---

# Lemsa lab (showcase)

You are working in **`skills/lab/`** — the reference **consumer** of the Lemsa kit family.

Read [`lab/README.md`](../../lab/README.md) first for recruiters. Spec brain: [`spec/lab.md`](../../spec/lab.md). Tasks: T20–T24 under `spec/tasks/`.

## Before coding

1. Read `lab/lemsa.yaml` — default `backend: mock`
2. Prefer `fvm flutter` (lab pins Flutter ≥3.44)
3. Scenario catalog: `lab/spec/scenarios.md` (S-portfolio-* + S01–S12)

## Showcase triggers

| Phrase | Work |
| --- | --- |
| switch backend / LAB_BACKEND | T22 — `core/backend/`, task sources, README table |
| multi-model / projects / labels / inbox | T21 — feature folders + PagedList |
| kit surface / FormPage / EmailField | T23 — do not reinvent kits |
| recruiter README / demo script | T24 — docs only unless gaps |

## Classic scenarios (still valid)

| ID | Phrase | Proves |
| --- | --- | --- |
| S01 | test core failures | AppFailure |
| S02 | test page harness | PageHarness, busy |
| S03 | test task list flow | AsyncView list |
| S04 | test task form flow | PageData form |
| S05 | test mock backend | MockTaskSource |
| S06 | test supabase path | SupabaseTaskSource (explicit) |
| S07 | test drift path | CachedTaskRepository |
| S08 | test firebase path | FirebaseTaskSource (explicit) |
| S09 | test nav + auth guard | nav_kit guards |
| S10 | test i18n | slang |
| S11 | test retrofit path | RestTaskSource / Dio |
| S12 | test loon path | obsolete — prefer Drift |

## Rules

- **Mock-first:** CI and cold clone need no secrets.
- **Backend swap:** factory + provider only — never rewire pages/controllers for vendor SDKs.
- **Form layer never imports Riverpod.**
- Stubs under `lib/stubs/` are **gone** (T20) — import kits.
- Run `fvm flutter analyze` + `fvm flutter test` in `lab/` before claiming done.
- Do **not** migrate kiwash / lightnessword; lab is the showcase.

## Do / don't

- Do implement only the requested scenario/task delta
- Do use path kits under `lemsa_packages/`
- Don't commit `.env` secrets
- Don't invent new kits inside lab
