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
| [T05](T05-prompts.md) | T01 | Phase kickoff prompts for kit builds |
| [T06](T06-lemsa-lab.md) | T05 | Lab sandbox, CLI, bd scenarios, lab skills |

## Phase 1+ — Kit packages (each in its own repo)

| Task | Blocked by | Summary |
| --- | --- | --- |
| [T10](T10-lemsa-core-kit.md) | T05 | Build `lemsa_core_kit` |
| [T11](T11-flutter-page-kit.md) | T10 | Build `flutter_page_kit` |
| [T12](T12-flutter-input-kit.md) | T11 | Build `flutter_input_kit` |
| [T13](T13-flutter-data-kit.md) | T10 | Build `flutter_data_kit` + dio + supabase adapters |
| [T14](T14-flutter-nav-app-kit.md) | T11, T13 | Build `flutter_nav_kit` + `flutter_app_kit` |

App migration tasks live in [../migration.md](../migration.md), not here.

Use [../prompts/](../prompts/) when delegating T10+ to a fresh chat.
