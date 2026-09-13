# Lemsa Skills

Agent Skills and design specs for the `lemsa_packages` Flutter family.

This repo is mostly documentation and Agent Skills, plus an internal **`lab/`** Flutter sandbox for architecture proof.

**GitHub:** [https://github.com/fodilfliti/lemsa-skills](https://github.com/fodilfliti/lemsa-skills)

## Install skills from GitHub

Works with any agent that follows the [Agent Skills spec](https://agentskills.io) — Cursor, Claude Code, Codex, Copilot, OpenCode, Windsurf, and others.

### Recommended — one install (includes scale + theme)

Scale and theme consumer skills are **bundled** in this repo under `skills/flutter-scale-kit` and `skills/flutter-scale-theme-kit` (canonical copies still live in their kit repos).

```bash
npx skills add fodilfliti/lemsa-skills
```

That pulls from GitHub: `https://github.com/fodilfliti/lemsa-skills`.

One skill only:

```bash
npx skills add fodilfliti/lemsa-skills --skill lemsa-flutter
npx skills add fodilfliti/lemsa-skills --skill flutter-scale-kit
npx skills add fodilfliti/lemsa-skills --skill flutter-scale-theme-kit
```

### Also install from the published kit repos (optional / keep in sync)

If you only need size/look, or want the skill straight from the package repo:

```bash
npx skills add fodilfliti/flutter_scale_kit --skill flutter-scale-kit
npx skills add fodilfliti/flutter_scale_theme_kit --skill flutter-scale-theme-kit
```

| Skill | GitHub |
| --- | --- |
| Family + stack + lab + **bundled** scale/theme | [fodilfliti/lemsa-skills](https://github.com/fodilfliti/lemsa-skills) |
| `flutter-scale-kit` (canonical) | [fodilfliti/flutter_scale_kit](https://github.com/fodilfliti/flutter_scale_kit) → `skills/flutter-scale-kit` |
| `flutter-scale-theme-kit` (canonical) | [fodilfliti/flutter_scale_theme_kit](https://github.com/fodilfliti/flutter_scale_theme_kit) → `skills/flutter-scale-theme-kit` |

### Manual clone (no npx)

```bash
git clone https://github.com/fodilfliti/lemsa-skills.git
# Point your agent at lemsa-skills/skills/  (and optionally clone the two kit repos for canonical skill sources)
```

Then, in a Flutter app:

> Set up this project the Lemsa way.

The `lemsa-flutter` skill asks once for the project's backend, storage and i18n choices, writes `lemsa.yaml` at the app root, and never asks again. Every other skill reads that file first.

## Understand the packages (humans)

Detailed guides — what each kit does, architecture, and why this approach:

- [docs/README.md](docs/README.md) — index  
- [docs/why-this-approach.md](docs/why-this-approach.md) — design rationale  
- [docs/family-map.md](docs/family-map.md) — dependency graph  
- [docs/packages/](docs/packages/README.md) — one file per kit  

Agent rules stay in [`spec/`](spec/README.md).

## What is in here

| Path | Holds |
| --- | --- |
| `docs/` | Human package explanations and architecture rationale |
| `skills/lemsa-flutter/` | Master skill. The architecture, the `lemsa.yaml` contract, and routing to the right kit |
| `skills/flutter-scale-kit/` | **Bundled** from [flutter_scale_kit](https://github.com/fodilfliti/flutter_scale_kit) — responsive size |
| `skills/flutter-scale-theme-kit/` | **Bundled** from [flutter_scale_theme_kit](https://github.com/fodilfliti/flutter_scale_theme_kit) — look / tokens |
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
| `lab/` | Internal Flutter showcase — see `spec/lab.md` |

Other kit consumer skills (page, input, data, …) ship in their own GitHub repos under `skills/` when published.

## The family

| Package | Owns | Status |
| --- | --- | --- |
| [flutter_scale_kit](https://pub.dev/packages/flutter_scale_kit) | Responsive size | Published |
| [flutter_scale_theme_kit](https://pub.dev/packages/flutter_scale_theme_kit) | Look and theme tokens | Published |
| [lemsa_core_kit](https://github.com/fodilfliti/lemsa_core_kit) | `AppFailure`, `Result`, `Disposables`, extensions, logging | Local |
| [flutter_page_kit](https://github.com/fodilfliti/flutter_page_kit) | Page controllers, shells, actions, loading | Local |
| [flutter_input_kit](https://github.com/fodilfliti/flutter_input_kit) | Semantic form fields and validators | Local |
| [flutter_data_kit](https://github.com/fodilfliti/flutter_data_kit) | Backend adapters, pagination, failure mapping | Local |
| [flutter_nav_kit](https://github.com/fodilfliti/flutter_nav_kit) | auto_route conventions and guards | Local |
| [flutter_app_kit](https://github.com/fodilfliti/flutter_app_kit) | Bootstrap, env and flavors, secure storage | Local |

## License

MIT
