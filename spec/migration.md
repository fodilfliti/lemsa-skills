# Migration playbook — **archived**

> **Active consumer work is the lab showcase only** (`spec/tasks/T20`–`T24`).  
> Do **not** migrate `kiwash`, `kiwash_provider`, or `lightnessword` as family tasks.

Those apps may remain personal/legacy codebases. Lemsa kits are proven in **`lemsa-skills` → `lab/`**, a full multi-model demo with swappable backends (mock / REST+Dio+Retrofit / Supabase / Firebase).

## What to run instead

| Task | Purpose |
| --- | --- |
| [T20](tasks/T20-lab-path-deps.md) | Path-deps kits; remove stubs |
| [T21](tasks/T21-lab-multi-model.md) | Multi-feature domain |
| [T22](tasks/T22-lab-backend-switch.md) | Four backends coded; one selected |
| [T23](tasks/T23-lab-full-kit-surface.md) | All kits visible in UI |
| [T24](tasks/T24-lab-recruiter-docs.md) | Recruiter README |

Kickoff prompt: [../prompts/phase-lab-showcase.md](../prompts/phase-lab-showcase.md).

## Historical notes (reference only)

Older drafts described migrating kiwash → kiwash_provider → lightnessword. That plan is **cancelled**. Patterns in those apps may still inform kit design, but agents must not open them to “finish the family.”

If you personally migrate a production app later, reuse kit skills — do not add it back as a `spec/tasks/Txx` unless the user explicitly reinstates it.
