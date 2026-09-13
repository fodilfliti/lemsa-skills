# lab (lemsa lab showcase)

**Job:** portfolio / architecture **sandbox** inside the skills repo that path-depends the whole kit family and proves the approach end-to-end.

**Not its job:** a published pub package, or migrating production apps (kiwash / lightnessword are out of scope for lab).

Location: `skills/lab/` (same git remote as this docs tree: lemsa-skills).

## Why it exists

Kits alone do not show recruiters or new contributors **how an app feels**. Lab is the living sample:

- Multi-feature / multi-model UI
- Swappable backends (mock, REST/Dio, Supabase, Firebase) with one selected at a time
- Full surface of page / input / nav / app / scale / theme
- Recruiter-oriented README

Tasks T20–T24 in [`../../spec/tasks/`](../../spec/tasks/README.md) track that work.

## What it does exactly

| Concern | Approach |
| --- | --- |
| Dependencies | Path deps to sibling kits under `lemsa_packages/` |
| Architecture | feature_first layout from [architecture.md](../../spec/architecture.md) |
| Backends | All four coded; selection via `lemsa.yaml` / dart-define |
| Controllers | Vendor-free; adapters behind repositories |
| Docs | Explains the stack for humans reviewing the repo |

## Architecture role

```text
lab (app)
  ├── flutter_app_kit          boot
  ├── flutter_nav_kit          routes
  ├── flutter_page_kit         pages / controllers
  ├── flutter_input_kit        fields
  ├── flutter_data_kit + one adapter
  ├── flutter_scale_kit
  ├── flutter_scale_theme_kit
  └── lemsa_core_kit
```

Lab is the **consumer**, not a kit. Patterns proven here can later guide production apps; lab itself is not those apps.

## Why this approach

| Choice | Why |
| --- | --- |
| Showcase ≠ migrate | Keeps skills repo focused; no hostage to legacy code |
| Path deps | Exercises local kits before publish |
| Multi-backend coded | Proves adapter story without four separate sample apps |
| Same architecture.md rules | No “demo exception” architecture |

## Related

- Spec: [../../spec/lab.md](../../spec/lab.md)  
- Prompt: [../../prompts/phase-lab-showcase.md](../../prompts/phase-lab-showcase.md)  
- Family: [../family-map.md](../family-map.md)
