# Implementation tasks

Pick **one** `Txx-*.md`. Do not skip **Read first**. Do not start a later task before its blockers are done.

Done = spec updated if behaviour changed, and the task's **Done when** section is satisfied.

## Phase 0 — This repo (skills)

| Task | Blocked by | Summary |
| --- | --- | --- |
| [T00](T00-brain-lock.md) | — | Spec is source of truth; do not rewrite unless asked |
| [T01](T01-skills-repo.md) | T00 | Bootstrap skills repo structure |
| [T02](T02-lemsa-flutter-skill.md) | T01 | Master consumer skill |
| [T03](T03-package-author-skill.md) | T01 | Meta skill for new kit repos |
| [T04](T04-stack-skills.md) | T01 | Riverpod, auto_route, slang, drift, supabase, firebase, dio |
| [T05](T05-prompts.md) | T01 | Phase kickoff prompts for kit builds + lab showcase |
| [T06](T06-lemsa-lab.md) | T05 | Early lab sandbox (stubs) — superseded for product by T20+ |

## Phase 1 — Kit packages (sibling repos / data_kit workspace)

| Task | Blocked by | Summary |
| --- | --- | --- |
| [T10](T10-lemsa-core-kit.md) | T05 | Build `lemsa_core_kit` |
| [T11](T11-flutter-page-kit.md) | T10 | Build `flutter_page_kit` |
| [T12](T12-flutter-input-kit.md) | T11 | Build `flutter_input_kit` |
| [T13](T13-flutter-data-kit.md) | T10 | Build `flutter_data_kit` + dio + supabase |
| [T14](T14-flutter-nav-app-kit.md) | T11, T13 | Build `flutter_nav_kit` + `flutter_app_kit` |
| [T15](T15-flutter-data-kit-drift.md) | T13 | `flutter_data_kit_drift` adapter (workspace) |
| [T16](T16-flutter-data-kit-firebase.md) | T13 | `flutter_data_kit_firebase` adapter (workspace) |

## Phase 2 — Lab showcase (only consumer to “migrate”)

**Do not migrate kiwash / lightnessword.** The lab is the full demo app for recruiters and kit proof.

| Task | Blocked by | Summary |
| --- | --- | --- |
| [T20](T20-lab-path-deps.md) | T10–T14 | Path-deps all kits; retire lab stubs |
| [T21](T21-lab-multi-model.md) | T20 | Multi-feature / multi-model domain |
| [T22](T22-lab-backend-switch.md) | T20 | Four backends coded; one selected manually |
| [T23](T23-lab-full-kit-surface.md) | T20–T22 | Scale → app kits all visible in UI |
| [T24](T24-lab-recruiter-docs.md) | T23 | Recruiter README + scenarios |

Use [../prompts/](../prompts/) when delegating to a fresh chat. Lab showcase kickoff: [../../prompts/phase-lab-showcase.md](../../prompts/phase-lab-showcase.md).

Historical note: app migration playbooks in [../migration.md](../migration.md) are **archived / not active work**.
