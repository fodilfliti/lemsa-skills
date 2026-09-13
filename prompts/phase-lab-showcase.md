# Phase — Lab showcase (portfolio demo)

You are upgrading **`lab/`** inside the skills repo into a full Lemsa kit showcase.  
**Do not** migrate kiwash or lightnessword.

## Repo

`C:\Users\lemsa\Documents\apps\lemsa_packages\skills\`  
Work in `lab/`. Kits live in sibling folders under `lemsa_packages/`.

## Read first

1. `spec/lab.md`
2. `spec/tasks/README.md` — Phase 2 (T20–T24)
3. The **one** task you are claiming (`T20` … `T24`)
4. `spec/architecture.md`, `spec/errors.md`, `spec/bridge.md` as needed
5. Kit `AGENTS.md` / public barrels for packages you wire

## Active work = lab only

| Do | Don't |
| --- | --- |
| Path-deps all kits | Edit kiwash / lightnessword |
| Multi-model features | Publish lab |
| Four backends coded; one selected | Commit secrets |
| Recruiter README | Invent new kits |

## Backend switch (T22)

Implement all four as visible code:

1. `mock`
2. `rest` — Dio + Retrofit (+ `flutter_data_kit_dio`)
3. `supabase` — init + `flutter_data_kit_supabase`
4. `firebase` — init + `flutter_data_kit_firebase`

Select via `lemsa.yaml` / dart-define. Controllers stay vendor-free.

## Acceptance

Satisfy the claimed task’s **Done when**. `fvm flutter analyze` + `test` green on default mock.

## Out of scope

kiwash/lightnessword migration, publishing kits, unrelated refactors outside lab + task docs.
