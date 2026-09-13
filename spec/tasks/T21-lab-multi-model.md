# T21 — Lab showcase: multi-model domain

## Goal

Expand lab beyond a single Task Tracker into a **portfolio-scale** domain so recruiters see how kits compose across many models and features.

## Read first

- [../architecture.md](../architecture.md)
- [../bridge.md](../bridge.md)
- [lab/spec/scenarios.md](../../lab/spec/scenarios.md)

## Blocked by

T20.

## Suggested domain (agent may refine, keep ≥4 entities)

| Area | Models / features |
| --- | --- |
| Work | Task, Project (or Board), Label/Tag |
| People | Profile / User settings |
| Comms | Notice/Inbox item or Comment |
| Media | Attachment metadata (optional) |

Each feature uses: repository + `PagedList` where lists exist, `PageData` form, semantic inputs from `flutter_input_kit`, `Change` apply where lists update.

## Done when

- [ ] ≥4 persisted/domain models with clear folders under `lab/lib/features/`
- [ ] ≥2 list screens with pagination/refresh via data_kit patterns
- [ ] ≥2 form flows (create/edit) with page_kit + input_kit
- [ ] Shared session/profile surface using app_kit + nav guards
- [ ] Tests: at least one PageHarness + one repository/paged test per major feature
- [ ] Scenarios catalog updated (`lab/spec/scenarios.md`) for new flows

## Do not

- Hardcode a single backend inside controllers
- Add slang English into kits (lab may use slang for UI strings)
- Touch kiwash / lightnessword
