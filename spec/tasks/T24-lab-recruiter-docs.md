# T24 — Lab showcase: recruiter README + demo scenarios

## Goal

Make the lab self-explanatory for **recruiters / reviewers**: what to run, what to click, where to look for adapter switching, proof that packages compose.

## Deliverables

1. **`lab/README.md`** (human front page)
   - One-paragraph pitch: Lemsa kit family demo
   - Screenshots or GIF placeholders (paths documented)
   - “Run in 60 seconds” (`fvm flutter run` in `lab/`)
   - **Switch backend** table linking to T22
   - Map of features → kits used
   - Explicit: kiwash/lightnessword are **not** migrated; lab is the reference consumer

2. **`lab/spec/scenarios.md`**
   - Portfolio scenarios (S-portfolio-*) covering multi-model + backend switch + guards
   - Keep existing S01–S12 if still relevant; mark obsolete ones

3. **`skills/lemsa-lab/SKILL.md`**
   - Activation: showcase / recruiter demo / switch backend
   - Point agents at T20–T24, not app migrations

4. Optional: short `lab/doc/ARCHITECTURE.md` diagram (mermaid) of layers + adapters

## Blocked by

T23 (or T20–T22 if documenting incrementally — finish checklist when T23 done).

## Done when

- [ ] Recruiter can follow README without opening skills `spec/`
- [ ] Backend switch steps verified once on mock + at least one other stack (even if other needs env)
- [ ] Family `spec/lab.md` links to showcase README
- [ ] No remaining docs that say “migrate kiwash next” as active work

## Do not

- Add marketing fluff that contradicts kit invariants
- Commit secrets
- Implement new features here — docs/scenarios only unless gaps found
