# flutter_scale_kit

**Job:** responsive **size** — scale widths, heights, fonts, and breakpoints from a design canvas to real devices.

**Not its job:** colors, typography tokens as a design system, themes, forms, or backends.

Status: **published** on pub.dev. Sibling of `flutter_scale_theme_kit`.

## Why it exists

Reference apps mixed ScreenUtil / ad-hoc `MediaQuery` math with theme colors. That couples layout scaling to look, and every screen invents its own padding rules.

This package owns **only** the size problem so:

- Theme work does not drag in scaling opinions.
- Apps that only need `16.w` / `SKResponsive` can depend on one small package.
- Scaling strategy is centralized (`ScaleManager`) instead of scattered helpers.

## What it does exactly

- Design-size based scaling (width / height / font / radius helpers via extensions).
- Device / orientation detection and responsive builders (`SKResponsive`, breakpoints).
- Caching of scaled values where safe for rebuild performance.
- Optional scaled primitive widgets (button, card, app bar) as convenience — not a full component library.
- `ScaleKitBuilder` (or equivalent init) at the app root so descendants share one scale context.

Typical usage:

```dart
padding: EdgeInsets.all(16.w),
fontSize: 14.sp,
child: SKResponsive(
  mobile: ...,
  tablet: ...,
),
```

## Architecture

```text
ScaleKitBuilder / init
        │
        ▼
  ScaleManager (+ strategy, cache, device detector)
        │
        ├── extensions on num / BuildContext / TextStyle
        └── responsive widgets / builders
```

- **Core** (`lib/src/core/`): math, enums, cache, device metrics — no Material opinions beyond Flutter.
- **Extensions**: ergonomic API (`*.w`, context helpers).
- **Widgets**: structural responsiveness (when to swap layout), not decoration.

Does **not** import any other Lemsa kit.

## Why this approach

| Choice | Why |
| --- | --- |
| Separate from theme kit | Size ≠ look; publish/version independently |
| Flutter-only deps | Usable outside the rest of the family |
| Central scale manager | One source of truth vs per-widget MediaQuery hacks |
| Responsive for **structure** | Padding uses scale; layout swaps use breakpoints (see page shells) |

## Depends on

Flutter SDK only.

## Related

- Theme tokens: [flutter_scale_theme_kit.md](flutter_scale_theme_kit.md)  
- Family map: [../family-map.md](../family-map.md)  
- Kit repo `spec/` for implementation detail
