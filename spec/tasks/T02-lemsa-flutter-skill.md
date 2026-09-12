# T02 — lemsa-flutter master skill

## Goal

Ship the installable `lemsa-flutter` skill agents load inside consumer Flutter apps.

## Read first

- [../lemsa-yaml.md](../lemsa-yaml.md)
- [../architecture.md](../architecture.md)
- [../../flutter_scale_kit/skills/flutter-scale-kit/SKILL.md](../../flutter_scale_kit/skills/flutter-scale-kit/SKILL.md) — format reference

## Files

- `skills/lemsa-flutter/SKILL.md`
- `skills/lemsa-flutter/init.md`
- `skills/lemsa-flutter/routing.md`
- `skills/lemsa-flutter/architecture.md`

## Steps

1. Frontmatter: `name`, `description` as activation trigger.
2. Body: ask-once ritual, defaults, read `lemsa.yaml` first.
3. Split detail into sibling files (<500 lines total in SKILL.md).
4. Cross-skill loads expressed in prose only (no file links to spec/).

## Done when

`npx skills add . --skill lemsa-flutter` structure validates. Description mentions setup, lemsa.yaml, page controller, riverpod.

## Do not

Paste full spec/ into the skill.
