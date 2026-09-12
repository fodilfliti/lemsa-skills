# Scaffold checklist

## Files to create

| File | Purpose |
| --- | --- |
| `spec/README.md` | Memory map + truth order |
| `spec/package.md` | What the package is, layers, public API |
| `spec/invariants.md` | Must-not-break rules |
| `spec/decisions.md` | Why trade-offs |
| `spec/tasks/README.md` | Txx build order |
| `AGENTS.md` | Agent instructions for this repo |
| `STRATEGY.md` | Pointer to spec/ |
| `llms.txt` | Machine summary |
| `.cursor/rules/<kit>.mdc` | alwaysApply session rules |
| `skills/<name>/SKILL.md` | Consumer install skill |
| `README.md` | Human front page — not agent memory |
| `CHANGELOG.md` | User-visible changes |
| `LICENSE` | MIT |
| `analysis_options.yaml` | very_good_analysis + empty_catches error |

## FVM

`.fvmrc`:

```json
{ "flutter": "3.35.7" }
```

## CI (minimal)

```yaml
# .github/workflows/analyze.yml
on: [push, pull_request]
jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.35.7'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```

## Consumer skill frontmatter

```yaml
name: flutter-page-kit   # kebab-case
description: >           # activation trigger, not summary
  Use flutter_page_kit for ...
license: MIT
metadata:
  author: fodilfliti
  version: "0.0.1"
  homepage: https://pub.dev/packages/flutter_page_kit
```

## Workspace exception

Only `flutter_data_kit` uses pub workspaces for adapters. All other kits: one repo, one package.
