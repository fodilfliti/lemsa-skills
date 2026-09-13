# Agent memory map

This folder is the **durable brain** for the whole `lemsa_packages` family. It is not user documentation. Do not copy `README.md` here.

For humans (what each package does and **why**): see [`../docs/`](../docs/README.md).

| File | Read when |
| --- | --- |
| [package.md](package.md) | Starting anything: what this repo is, the family map, dependency rules |
| [architecture.md](architecture.md) | Writing app code: folder layout, naming, the two dividing rules |
| [lemsa-yaml.md](lemsa-yaml.md) | Setting up a project, or adding a config key |
| [errors.md](errors.md) | Anything touching failures, try/catch, or `Result` |
| [riverpod.md](riverpod.md) | Choosing a provider kind, a state lifetime, or a listener |
| [bridge.md](bridge.md) | Wiring a page controller to providers, lists, or navigation |
| [kits/README.md](kits/README.md) | Designing or building one package |
| [migration.md](migration.md) | Moving an existing app onto the family |
| [invariants.md](invariants.md) | Before changing a rule that other kits rely on |
| [decisions.md](decisions.md) | Changing a trade-off, or wondering why one was made |
| [tasks/README.md](tasks/README.md) | Ready to build — pick one `Txx` |
| [lab.md](lab.md) | Working in `lab/` sandbox or promoting patterns |

## Truth order

1. **`spec/`** — design intent, invariants, and why. This repo has no code, so spec is the top of the tree.
2. **Published kit code** in `../flutter_scale_kit/lib` and `../flutter_scale_theme_kit/lib` — implementation truth for the two shipped packages.
3. **Each kit's own `spec/`** — internals of that package, which override this folder on package-local questions.
4. **`skills/`** — the enforcement surface. If a skill and this folder disagree, this folder wins and the skill is the bug.
5. **Codebase Memory MCP** — code graph for the reference apps. Useful for "where is this pattern today", never a substitute for design intent.

When a kit's code and this folder disagree, decide which is intentional, then fix the other in the same change.

## Reference apps

Three apps motivated this design and are the migration targets. They are **evidence, not style guides** — most of what is described here is a correction of what they do.

| App | State | Notable |
| --- | --- | --- |
| `../../kiwash` | Riverpod 3.0.3, `flutter_scale_kit ^1.5.2` | Most modern. Fat screens, ~12 duplicated list notifiers, `legacy.dart` imports |
| `../../kiwash_provider` | Riverpod 2.6, `flutter_screenutil` | Copy-paste twin of kiwash |
| `../../lightnessword` | Riverpod 2.6, `flutter_screenutil` | Has the original `*_data_mixin.dart` page-controller idea |

## Consumer apps (other IDEs)

Agents working *inside* a Flutter app load `skills/`, not this folder. `npx skills add fodilfliti/skills`. Those skills are usage rules; this folder is why the rules exist.
