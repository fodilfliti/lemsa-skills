# T11 — flutter_page_kit

## Goal

Build `flutter_page_kit` per kit spec + [phase-2 prompt](../../prompts/phase-2-flutter-page-kit.md).

## Read first

- [../kits/flutter_page_kit.md](../kits/flutter_page_kit.md)
- [../decisions.md](../decisions.md) D15, D16
- [../../prompts/phase-2-flutter-page-kit.md](../../prompts/phase-2-flutter-page-kit.md)

## Blocked by

T10 (`lemsa_core_kit`).

## Done when

- PageHarness test passes
- `gen page` emits compilable stub (or shells + harness first with CLI noted)
- No riverpod imports outside `lib/src/riverpod/`
- Main barrel usable without Riverpod; riverpod barrel has AsyncView test/example

## Do not

- Put Material Notices production impl or auto_route here.
- Teach or generate “warn snackbar on validateForm fail” — inline field errors only.
