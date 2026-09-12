---
name: lemsa-package-author
description: >
  Scaffold a new lemsa_packages Flutter kit repo (flutter_*_kit or lemsa_*_kit)
  with spec/, skills/, AGENTS.md, FVM, example, and CI. Use when creating a new
  kit package, bootstrapping lemsa_core_kit, flutter_page_kit, or extending the
  family.
license: MIT
metadata:
  author: fodilfliti
  version: "1.0.0"
---

# Lemsa package author

Scaffold a new kit repo sibling to `flutter_scale_kit`. Read [scaffold.md](scaffold.md) for the full checklist.

## Before creating

1. Check pub.dev name is free: `https://pub.dev/packages/<name>`
2. Confirm dependency rules — page_kit has no riverpod; core has no dio/supabase/firebase/drift
3. Read the kit design in the skills repo `spec/kits/<name>.md` if it exists

## Repo shape

```text
<kit_name>/
  lib/<kit_name>.dart          # public barrel only
  lib/src/...
  bin/generate.dart            # optional CLI
  lib/generate_core.dart       # CLI core — no dart:io
  spec/README.md               # truth order
  spec/package.md
  spec/invariants.md
  spec/decisions.md
  spec/tasks/T00..Tnn.md
  skills/<kebab-name>/SKILL.md # consumer skill
  AGENTS.md
  .cursor/rules/*.mdc
  llms.txt
  .fvmrc                       # 3.35.7
  example/
  doc/
  test/
  .github/workflows/analyze.yml
```

Copy patterns from `flutter_scale_kit` and `flutter_scale_theme_kit`.

## pubspec template

- SDK `^3.7.2`, Flutter `>=3.29.0`
- Minimal runtime deps — justify each in spec/decisions.md
- dev: flutter_test, very_good_analysis, build_runner only if codegen needed

## After scaffold

1. Empty analyze-clean barrel
2. Placeholder test
3. Reserve pub name with 0.0.1 when ready to publish
4. Update skills repo `spec/package.md` family table

## Do not

- Import another kit's `example/`
- Add riverpod to flutter_page_kit lib/
- Use Mason — use `dart run <kit>:gen` pattern instead
