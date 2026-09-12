# Phase 1 — Build lemsa_core_kit

You are building the `lemsa_core_kit` Flutter package.

## Repo path

Create at: `C:\Users\lemsa\Documents\apps\lemsa_packages\lemsa_core_kit\`

Sibling reference packages: `flutter_scale_kit`, `flutter_scale_theme_kit` (copy their repo shape: spec/, skills/, AGENTS.md, .fvmrc 3.35.7, example/, doc/).

## Read first (mandatory)

From the skills repo `spec/`:

1. `kits/lemsa_core_kit.md` — scope
2. `errors.md` — AppFailure + Result contract
3. `invariants.md` — global rules
4. `decisions.md` D3, D13

Use `lemsa-package-author` skill checklist if present.

## Goal

Ship a published-quality foundation package with:

- Sealed `AppFailure` hierarchy (`implements Exception`, no message field)
- `Result<T>` with `Ok`, `Err`, `Result.guard`
- `Disposables` + `keep()` registry
- `Change<T>` sealed types
- `AppReporter` + `NoOpReporter`
- Extension methods (string/bool/date/num) matching reference app needs
- `AppLogger` wrapper

## Invariants

- **No** dependency on: dio, supabase, firebase, drift, riverpod, auto_route
- SDK: `^3.7.2`, Flutter `>=3.29.0`
- Public barrel: `lib/lemsa_core_kit.dart` only
- `empty_catches: error` in analysis_options (very_good_analysis base)

## Tests required

- Exhaustive switch on all `AppFailure` subtypes compiles
- Test that `Disposables` disposes in reverse order
- `Result.guard` maps thrown `AppFailure` to `Err`

## Acceptance

- [ ] `fvm flutter analyze` clean
- [ ] `fvm flutter test` green
- [ ] spec/ folder with README, package.md, invariants.md
- [ ] AGENTS.md + skills/lemsa-core-kit/SKILL.md (consumer usage stub)
- [ ] Verify pub.dev name `lemsa_core_kit` still free; note 0.0.1 reserve

## Out of scope

- Widgets, Riverpod, code generators beyond json if needed
- Migrating any reference app

Do not ask clarifying questions unless pub.dev name is taken.
