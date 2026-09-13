# Installable skills

Each folder is one Agent Skill (`SKILL.md` + optional reference files).

**Download from GitHub** (this repo): [https://github.com/fodilfliti/lemsa-skills](https://github.com/fodilfliti/lemsa-skills)

## Install all (recommended)

Includes stack skills **and** bundled `flutter-scale-kit` + `flutter-scale-theme-kit`:

```bash
npx skills add fodilfliti/lemsa-skills
```

## Install one

```bash
npx skills add fodilfliti/lemsa-skills --skill lemsa-flutter
npx skills add fodilfliti/lemsa-skills --skill flutter-scale-kit
npx skills add fodilfliti/lemsa-skills --skill flutter-scale-theme-kit
```

## Scale / theme from their GitHub repos

Canonical sources (re-copy into this repo when they change — see each `SOURCE.md`):

```bash
npx skills add fodilfliti/flutter_scale_kit --skill flutter-scale-kit
npx skills add fodilfliti/flutter_scale_theme_kit --skill flutter-scale-theme-kit
```

| Skill | Load when |
| --- | --- |
| [lemsa-flutter](lemsa-flutter/) | Any Lemsa app work — **start here** |
| [flutter-scale-kit](flutter-scale-kit/) | Responsive size (`ScaleKitBuilder`, `.w` / `.sp`) — **bundled** |
| [flutter-scale-theme-kit](flutter-scale-theme-kit/) | Look / tokens (`STTheme`, `context.st`) — **bundled** |
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

Design rationale lives in `../spec/` — not loaded by npx skills copy; skills are self-contained.
