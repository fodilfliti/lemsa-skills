# Lemsa Skills

Agent Skills and design specs for the `lemsa_packages` Flutter family.

This repo is mostly documentation and Agent Skills, plus an internal **`lab/`** Flutter sandbox for architecture proof.

## Install the skills

```bash
npx skills add fodilfliti/skills
```

One skill only:

```bash
npx skills add fodilfliti/skills --skill lemsa-flutter
```

Works with any agent that follows the [Agent Skills spec](https://agentskills.io) — Cursor, Claude Code, Codex, Copilot, OpenCode, Windsurf and others.

Then, in a Flutter app:

> Set up this project the Lemsa way.

The `lemsa-flutter` skill asks once for the project's backend, storage and i18n choices, writes `lemsa.yaml` at the app root, and never asks again. Every other skill reads that file first.

## What is in here

| Path | Holds |
| --- | --- |
| `skills/lemsa-flutter/` | Master skill. The architecture, the `lemsa.yaml` contract, and routing to the right kit |
| `skills/lemsa-lab/` | Work in the skills repo `lab/` sandbox |
| `skills/lemsa-pub-deps/` | Dependency versions and compatibility gate |
| `skills/lemsa-package-author/` | Scaffolds a new `flutter_*_kit` repo in the house style |
| `skills/flutter-riverpod3/` | Riverpod 3 rules, including when *not* to use Riverpod |
| `skills/flutter-autoroute/` | Routes, guards, deep links, web URLs |
| `skills/flutter-slang/` | Typed i18n, key naming, migration off `easy_localization` |
| `skills/flutter-drift/` | Local SQL, migrations, mirroring a server Postgres schema |
| `skills/flutter-supabase/` | Supabase conventions, composed with the official Supabase skill |
| `skills/flutter-firebase/` | Firebase auth, Firestore, messaging, storage conventions |
| `skills/flutter-dio/` | Dio client, interceptor stack, failure mapping |
| `spec/` | The durable design brain: why each kit exists and what it must never do |
| `prompts/` | Self-contained kickoff prompts, one per build phase |
| `lab/` | Internal Flutter sandbox (Task Tracker) — see `spec/lab.md` |

Per-package usage skills live in their own repos (`flutter_scale_kit/skills/`, `flutter_scale_theme_kit/skills/`, and so on) and install the same way.

## The family

| Package | Owns | Status |
| --- | --- | --- |
| [flutter_scale_kit](https://pub.dev/packages/flutter_scale_kit) | Responsive size | Published |
| [flutter_scale_theme_kit](https://pub.dev/packages/flutter_scale_theme_kit) | Look and theme tokens | Published |
| `lemsa_core_kit` | `AppFailure`, `Result`, `Disposables`, extensions, logging | Planned |
| `flutter_page_kit` | Page controllers, shells, actions, loading | Planned |
| `flutter_input_kit` | Semantic form fields and validators | Planned |
| `flutter_data_kit` | Backend adapters, pagination, failure mapping | Planned |
| `flutter_nav_kit` | auto_route conventions and guards | Planned |
| `flutter_app_kit` | Bootstrap, env and flavors, secure storage | Planned |

## License

MIT
