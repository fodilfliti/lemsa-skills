# Strategy

Design intent and architecture live in **`spec/`** (agents). Long-form human explanation lives in **`docs/`**.

- **Humans / why:** [docs/README.md](docs/README.md) — package guides, family map, approach
- Agent brain: [spec/README.md](spec/README.md)
- Cross-kit architecture: [spec/architecture.md](spec/architecture.md)
- Project contract: [spec/lemsa-yaml.md](spec/lemsa-yaml.md)
- Per-kit designs (short): [spec/kits/README.md](spec/kits/README.md)
- Tasks for agents: [spec/tasks/README.md](spec/tasks/README.md)
- Phase kickoff prompts: [prompts/README.md](prompts/README.md)

One sentence per layer: `flutter_scale_kit` = size. `flutter_scale_theme_kit` = look. `flutter_page_kit` = page logic. `flutter_input_kit` = fields. `flutter_data_kit` = backends. `flutter_nav_kit` = routes. `flutter_app_kit` = boot. `lemsa_core_kit` = the primitives all of them share.

The two rules that shape every kit: **the form layer never imports Riverpod**, and **state that would not survive a page pop never goes in a provider**.
