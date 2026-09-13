# Lemsa packages — human docs

This folder explains **what each package does**, **how they fit together**, and **why this architecture exists**.

It is for humans (developers, reviewers, recruiters). Agents still treat [`../spec/`](../spec/README.md) as the source of truth for rules and invariants.

| Start here | Purpose |
| --- | --- |
| [why-this-approach.md](why-this-approach.md) | Problems we solved and the design principles |
| [family-map.md](family-map.md) | All packages, dependency graph, who owns what |
| [packages/](packages/README.md) | One detailed guide per kit |

## Quick mental model

```text
SIZE          → flutter_scale_kit
LOOK          → flutter_scale_theme_kit
PRIMITIVES    → lemsa_core_kit
PAGE LOGIC    → flutter_page_kit   (no Riverpod in controllers)
FIELDS        → flutter_input_kit
DATA CONTRACT → flutter_data_kit   (+ dio / supabase / firebase / drift adapters)
ROUTES        → flutter_nav_kit
BOOT          → flutter_app_kit
SHOWCASE      → lab/ (this skills repo)
```

Two rules that shape everything:

1. **Would this state survive a page pop?** Yes → Riverpod provider. No → page controller mixin.
2. **The form layer never imports Riverpod.** The page is the bridge.

Deep design: [`../spec/architecture.md`](../spec/architecture.md), [`../spec/decisions.md`](../spec/decisions.md).
