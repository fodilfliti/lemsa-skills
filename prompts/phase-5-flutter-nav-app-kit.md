# Phase 5 — Build flutter_nav_kit + flutter_app_kit

## Repos

- `C:\Users\lemsa\Documents\apps\lemsa_packages\flutter_nav_kit\`
- `C:\Users\lemsa\Documents\apps\lemsa_packages\flutter_app_kit\`

## Read first

- `skills/spec/kits/flutter_nav_kit.md`
- `skills/spec/kits/flutter_app_kit.md`
- `skills/spec/riverpod.md` (Session + AuthGuard)

## Goal

**flutter_nav_kit:**

- `AutoPageNavigator implements PageNavigator`
- AuthGuard on sessionProvider
- Example router with login + home + one form route

**flutter_app_kit:**

- `bootstrap()` phased init
- SecureSessionStore (no plaintext passwords)
- `deleteUserData()` hook
- Notices interface

## Example app

Combine both kits + page_kit + core_kit: cold start → login guard → one FormPage.

## Acceptance

- [ ] Sign-out changes session; guard redirects without Navigator in controller
- [ ] analyze + test green on both packages

## Out of scope

- Full deep-link table for kiwash entities
- Flavors CI templates
