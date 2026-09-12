# Phase migrate — kiwash pilot

You are migrating `C:\Users\lemsa\Documents\apps\qiwash_projects\kiwash` onto the Lemsa stack.

## Read first

1. `lemsa_packages/skills/spec/migration.md`
2. `lemsa_packages/skills/spec/architecture.md`
3. Install skills: `npx skills add` from lemsa_packages/skills (or path)

## Prerequisites

Path dependencies to built kits OR publish kits to pub.dev first.

Minimum for first slice: `lemsa_core_kit`, `flutter_page_kit`, `flutter_input_kit`, `flutter_data_kit` (+ dio adapter).

## Scope (one PR)

**Phase A + one vertical slice only** — pick auth (`sign_up_in_screen`) OR one list+form feature.

Do NOT rewrite entire lib/.

## Steps

1. Write `lemsa.yaml` from pubspec detection
2. Add `empty_catches: error`, riverpod_lint
3. Remove one `legacy.dart` import cluster
4. Migrate chosen screen to page + mixin + bridge
5. Replace one list notifier with PagedList
6. Remove `password_user` from prefs in migrated auth flow
7. One PageHarness test for migrated controller

## Acceptance

- [ ] Migrated feature works on mobile + web if it did before
- [ ] No new empty catches
- [ ] `dart analyze` no new errors in touched files

## Out of scope

- kiwash_provider, lightnessword
- Chat subsystem (535-line counter) — last
