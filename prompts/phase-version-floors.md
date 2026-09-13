# Phase — Align Flutter 3.35 + caret dependency floors

You are applying the **Flutter + dependency policy** across all finished Lemsa kits so consumer apps on Flutter **3.35 → 3.47+** do not hit version conflicts with Drift, Riverpod, build_runner, Dio, etc.

**Packages are already implemented.** This phase is **pubspec / FVM / CI alignment only** — no feature work.

## Parent workspace

`C:\Users\lemsa\Documents\apps\lemsa_packages\`

## Read first (required)

1. `skills/spec/package.md` — section **Flutter + dependency policy** + version floor table  
2. Each kit’s root `pubspec.yaml` (and nested packages under workspaces)

## Kits in scope (sibling folders)

Apply to every published/local kit under the parent workspace, including nested packages:

| Path | Notes |
| --- | --- |
| `flutter_scale_kit` | already published — still align constraints |
| `flutter_scale_theme_kit` | already published — still align constraints |
| `lemsa_core_kit` | |
| `flutter_page_kit` | |
| `flutter_input_kit` | |
| `flutter_data_kit` | + `packages/*` (dio, supabase, drift, firebase, …) |
| `flutter_app_kit` | |
| `flutter_nav_kit` | |
| `skills/lab` | app consumer — may pin Flutter via FVM; deps still `^` where path-deps kits |

**Out of scope:** kiwash, lightnessword, inventing new APIs, bumping package **version** numbers / publishing (unless user asks).

## Rules (must follow)

### 1. Flutter / Dart `environment:`

Every **library** kit:

```yaml
environment:
  sdk: ^3.7.2
  flutter: ">=3.35.0"
```

- **Do not** use `flutter: ^3.35.0` or any Flutter **upper** bound (`<3.48`, etc.).
- Pure Dart packages (if any): keep `sdk` only; no flutter key unless needed.

### 2. Third-party deps → caret floors

For every dependency listed in `skills/spec/package.md` version floor table:

- Write **`^min`** (e.g. `drift: ^2.34.3`), never an exact pin in library kits.
- If a kit already has a **higher** caret that still satisfies the floor (e.g. `^2.35.0` when floor is `2.34.3`), keep it only if analyze/tests pass; otherwise set to table `^min`.
- If a kit uses a package **not** in the table, use `^` with the lowest version that matches current used APIs; note it in the summary.
- **No** `dependency_overrides` in published / publishable kits.
- **No** adding `pubspec.lock` to library packages (apps like `lab` may keep lockfiles).

### 3. Inter-kit deps

Sibling kits: `package_name: ^x.y.z` matching current kit version (pre-1.0 carets are tight — keep siblings aligned).

### 4. FVM / CI only pin 3.35.7

- `.fvmrc` / `.fvm/fvm_config.json` / CI workflow: Flutter **3.35.7**
- Do **not** put `3.35.7` as the only allowed Flutter in library `environment.flutter`

### 5. Verify per kit (or workspace)

From each kit (or workspace root), with FVM:

```text
fvm flutter pub get
fvm flutter pub upgrade
fvm flutter pub downgrade   # must still resolve
fvm flutter analyze
fvm flutter test            # if tests exist
```

If `pub downgrade` fails, widen or fix conflicting constraints — do not leave exact pins.

## Done when

- [ ] Every in-scope kit `environment` matches policy  
- [ ] Floored third-party deps use `^min` from `package.md` (or documented exception)  
- [ ] No `dependency_overrides` in library kits  
- [ ] FVM/CI pin is 3.35.7 where present  
- [ ] `pub get` + `analyze` (+ `test` if present) green on each touched kit  
- [ ] Short summary: files changed + any packages not in the floor table  

## Do not

- Rewrite features, rename APIs, or “upgrade to latest” floors beyond the table unless required to resolve  
- Commit or publish unless the user asks  
- Touch apps outside `skills/lab` and the kits listed above  
