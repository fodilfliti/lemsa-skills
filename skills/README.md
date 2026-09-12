# Installable skills

Each folder is one Agent Skill (`SKILL.md` + optional reference files).

Install all:

```bash
npx skills add fodilfliti/skills
```

Install one:

```bash
npx skills add fodilfliti/skills --skill lemsa-flutter
```

| Skill | Load when |
| --- | --- |
| [lemsa-flutter](lemsa-flutter/) | Any Lemsa app work — **start here** |
| [lemsa-lab](lemsa-lab/) | Work in skills repo `lab/` sandbox |
| [lemsa-pub-deps](lemsa-pub-deps/) | Add/upgrade dependencies, version checks |
| [lemsa-package-author](lemsa-package-author/) | Creating a new kit repo |
| [flutter-riverpod3](flutter-riverpod3/) | Providers, state, migration off 2.x |
| [flutter-autoroute](flutter-autoroute/) | Routes, guards, deep links |
| [flutter-slang](flutter-slang/) | i18n |
| [flutter-drift](flutter-drift/) | Local SQL |
| [flutter-supabase](flutter-supabase/) | Supabase backend |
| [flutter-firebase](flutter-firebase/) | Firebase backend |
| [flutter-dio](flutter-dio/) | REST + Dio |

Per-package consumer skills live in each kit repo (`flutter_scale_kit/skills/`, etc.).

Design rationale lives in `../spec/` — not loaded by npx skills copy; skills are self-contained.
