# Agent instructions — Lemsa Skills

This repo is **documentation and agent skills**, with one exception: **`lab/`** is a Flutter sandbox for architecture proof. Everything else has no root `pubspec.yaml`.

It holds three products:

1. **`spec/`** — the durable design brain for the whole `lemsa_packages` family. Why each kit exists, what it must never do, and the task list for building it.
2. **`skills/`** — installable Agent Skills (`npx skills add fodilfliti/skills`) that other IDEs and agents load *inside consumer Flutter apps*.
3. **`lab/`** — internal Flutter app (Task Tracker) to validate patterns before kit extraction. See `spec/lab.md`.

## Load context

1. Read `spec/README.md`, then the spec file that matches the task (`architecture.md`, `errors.md`, `riverpod.md`, `bridge.md`, `lemsa-yaml.md`, `kits/<kit>.md`).
2. Building a kit? Read `spec/tasks/README.md` and pick **one** `Txx-*.md`.
3. Working in `lab/`? Read `spec/lab.md`, `lab/spec/scenarios.md`, load skill `lemsa-lab`. Use `bd` for task state.
4. Delegating a phase to a fresh chat? Hand it the matching file from `prompts/`. Those are self-contained on purpose.
5. Do **not** ingest `README.md` as working memory. It is the repo's front page for humans.

## Working rules

- `spec/` holds the **why**. `skills/` holds the **rules an agent follows**. State a rule once: rationale in spec, instruction in the skill. Do not paste rationale into a skill.
- Skills must be **self-contained**. `npx skills add` copies a skill directory into a consumer app, so a skill may never link to `spec/` or to another skill's files. Cross-skill dependencies are expressed as "load skill X" in prose.
- Follow the [Agent Skills spec](https://agentskills.io/specification): `SKILL.md` with `name` + `description` frontmatter, body under ~500 lines, detail pushed into sibling reference files that are opened only when needed.
- `description` is an **activation trigger**, not a summary. Name the tasks and the phrases a user would say.
- Every kit named in `spec/kits/` must exist in the family map in `spec/package.md`. Adding a kit means updating that map, the dependency rules, and `spec/tasks/`.
- When a decision changes, update `spec/decisions.md` in the same change. When a rule changes, update the skill that enforces it in the same change.

## The family

Sibling folders under `C:\Users\lemsa\Documents\apps\lemsa_packages\`, one git repo each:

- `flutter_scale_kit` — size. Published.
- `flutter_scale_theme_kit` — look. Published.
- `lemsa_core_kit`, `flutter_page_kit`, `flutter_input_kit`, `flutter_data_kit`, `flutter_nav_kit`, `flutter_app_kit` — planned. See `spec/kits/`.

Each kit repo keeps its own `spec/` for internals and its own `skills/<kit-name>/` for consumer usage. **This** repo holds only cross-kit design and the stack skills that belong to no single kit.

## Flutter SDK

Edit `lab/` with FVM Flutter **3.35.7** (`fvm flutter` / `fvm dart` inside `lab/`). Other paths here are docs-only. Never run `flutter upgrade` or `flutter channel` on `C:\Users\lemsa\Documents\flutter`.

## Beads (`bd`) — lab task tracking

Use **`bd`** for lab scenario execution state (not markdown TODOs):

```bash
bd ready --json              # unblocked lab issues
bd update <id> --claim       # before coding
bd close <id> --reason "…"   # after analyze + test green
```

Conservative policy: do **not** commit, push, or `bd dolt push` unless the user asks.

<!-- BEGIN BEADS INTEGRATION -->
When working on `lab/` scenarios, run `bd prime` at session start. Match issue titles `Lab S0X: …` to `lab/spec/scenarios.md`. Create follow-ups with `bd create --deps discovered-from:<parent-id>`.
<!-- END BEADS INTEGRATION -->

## Out of scope unless asked

Writing kit implementation code here, publishing anything to pub.dev, and editing the reference apps (`lightnessword`, `kiwash`, `kiwash_provider`). The migration playbook in `spec/migration.md` describes those edits; it does not perform them.
