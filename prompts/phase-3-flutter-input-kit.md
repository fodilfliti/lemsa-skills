# Phase 3 — Build flutter_input_kit

## Repo path

`C:\Users\lemsa\Documents\apps\lemsa_packages\flutter_input_kit\`

## Depends on

`lemsa_core_kit`, `flutter_page_kit`, `flutter_scale_kit`, `flutter_scale_theme_kit`

## Read first

`skills/spec/kits/flutter_input_kit.md`

## Goal

- `Validators` replacing `ValidatorChecker` core rules
- Semantic fields: Email, Password, Phone, Money, Date, Country, Search, General
- `ListField<T>` for dynamic rows
- Fields use scale_kit + theme_kit styling

## Reference (read only)

- `lightnessword/lib/core/widgets/inputs/`
- `kiwash/lib/widgets/inputs/`

Match behaviour, not API surface.

## Acceptance

- [ ] Widget tests for email/password/phone
- [ ] example/ demo form
- [ ] analyze + test green

## Out of scope

- Full 15 field parity in v1 — ship core 6, stub the rest
