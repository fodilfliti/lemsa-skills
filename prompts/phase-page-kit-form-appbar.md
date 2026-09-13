# Phase — FormPage scaffold chrome: optional AppBar + themed / image backgrounds

You are updating **`flutter_page_kit`** (and documenting theme touchpoints) so form scaffolds support:

1. Optional AppBar + custom header (back + title + trailing save)
2. Platform-style back icons (iOS / Android / default)
3. **Background color underlay + optional light/dark background images** (shaped PNGs with transparency)

## Repos

| Path | Role |
| --- | --- |
| `C:\Users\lemsa\Documents\apps\lemsa_packages\flutter_page_kit\` | **Implement** (FormPage / scaffold shells) |
| `C:\Users\lemsa\Documents\apps\lemsa_packages\skills\spec\kits\flutter_page_kit.md` | Lock API |
| `C:\Users\lemsa\Documents\apps\lemsa_packages\flutter_scale_theme_kit\` | Read only unless a tiny public helper is clearly needed — theme already exposes `background` → `scaffoldBackgroundColor` |
| `C:\Users\lemsa\Documents\apps\lightnessword\lib\core\widgets\bg_widget.dart` | **Reference pattern** (kiwash source is missing locally; this is the same idea) |

## Read first

1. `flutter_page_kit/lib/src/shells/form_page.dart`
2. `lightnessword/.../bg_widget.dart` — Stack + image / solid color
3. Theme: `STThemeDataFactory` sets `scaffoldBackgroundColor: ext.background`; apps use `context.st.background`
4. Previous AppBar requirements (still in scope below)

## Reference: how the old apps did it

`Bgwidget` (lightnessword):

```dart
Stack(
  children: [
    SizedBox.expand(
      child: isSimpleBg
          ? Container(color: Colors.white)           // solid underlay
          : Assets.images.loginBgX.image(fit: ...), // decorative image
    ),
    SafeArea(child: child),
  ],
);
```

Gaps to fix in the kit version:

- Solid color was hardcoded `Colors.white` — must come from **theme background** or an explicit override (light + dark).
- No **dark-mode image** pair — need `backgroundImage` + `backgroundImageDark` (or a small `FormBackground` config).
- Shaped images with **transparent** regions must show the underlay color through the PNG, not a second opaque layer fighting the image.

## Part 1 — Optional AppBar + back style (still required)

```dart
enum FormBackStyle { platform, android, ios }

FormPage(
  showAppBar: true,              // default true
  header: Widget?,               // used when showAppBar: false
  leadingStyle: FormBackStyle.platform,
  onBack: VoidCallback?,
  title: '...',
  ...
)
```

| Case | Behaviour |
| --- | --- |
| `showAppBar: true` | Current AppBar; leading per `FormBackStyle` |
| `showAppBar: false` + `header` | Custom top: `[back] text …… [Save]` |
| `showAppBar: false`, no header | Body-only chrome; caller owns top |

When AppBar is off, do not dump `ActionSlot.appBar` into a missing bar — save goes in `header` or bottom.

## Part 2 — Scaffold background (new)

Add a small immutable config (name can be `FormBackground` / `PageScaffoldBackground`):

```dart
class FormBackground {
  const FormBackground({
    this.color,                 // underlay; null → Theme.scaffoldBackgroundColor
    this.colorDark,             // optional; if null and dark, use color or theme dark scaffold
    this.image,                 // light (or any) DecorationImage / ImageProvider
    this.imageDark,             // used when Brightness.dark
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  final Color? color;
  final Color? colorDark;
  final ImageProvider? image;
  final ImageProvider? imageDark;
  final BoxFit fit;
  final AlignmentGeometry alignment;
}
```

Wire on `FormPage` (and only other scaffold shells if trivial — **FormPage required**):

```dart
FormPage(
  background: FormBackground(
    color: null, // → Theme.of(context).scaffoldBackgroundColor
                 //   (theme kit already maps this from tokens.background)
    // OR explicit: color: context.st.background, colorDark: ...
    image: AssetImage('assets/auth_bg.png'),
    imageDark: AssetImage('assets/auth_bg_dark.png'),
    fit: BoxFit.cover,
  ),
  ...
)
```

### Paint order (important for transparency)

```text
Scaffold(
  backgroundColor: resolvedUnderlayColor,  // ALWAYS set — shows through PNG holes
  body: Stack(
    fit: StackFit.expand,
    children: [
      if (resolvedImage != null)
        Positioned.fill(
          child: Image(
            image: resolvedImage,
            fit: fit,
            alignment: alignment,
            // no opaque Container behind the Image inside the Stack —
            // Scaffold color is the underlay
          ),
        ),
      // then: optional header / column with form content
      Column( ... existing form body ... ),
    ],
  ),
)
```

Resolution rules:

1. **Underlay color:** `background.color` / `colorDark` by brightness → else `Theme.of(context).scaffoldBackgroundColor` (do **not** hardcode white).
2. **Image:** `imageDark` when `Theme.brightness == dark` and provided; else `image`; else no image layer.
3. App must be able to pass **only color** (no image), **only image** (theme color under transparent parts), or **both**.
4. Keyboard insets: optional nicety from `Bgwidget` (pad/shift image when `viewInsets.bottom` > 0) — implement if cheap; do not block Done.

### Theme package note

`flutter_scale_theme_kit` already sets `scaffoldBackgroundColor` from token `background`.  
**Do not** force FormPage to import theme_kit. Document:

- Default underlay = Material `ThemeData.scaffoldBackgroundColor`
- Apps on theme_kit get that for free via generated theme
- For a one-off page color without changing global theme, pass `FormBackground(color: …, colorDark: …)`

Only touch theme_kit if you add a documented helper like reading extras — prefer **not** to.

## Example screens

**Auth with shaped PNG (transparent edges):**

```dart
FormPage(
  showAppBar: false,
  header: Row(
    children: [
      IconButton(/* ios back */, onPressed: () => Navigator.maybePop(context)),
      Text('Sign in'),
      const Spacer(),
      TextButton(onPressed: onSave, child: Text('Save')),
    ],
  ),
  background: FormBackground(
    // underlay shows through transparent parts of the art
    color: const Color(0xFFF5F0E8),
    colorDark: const Color(0xFF1A1510),
    image: AssetImage('assets/auth_shape_light.png'),
    imageDark: AssetImage('assets/auth_shape_dark.png'),
  ),
  child: ...,
)
```

**Normal form, theme background only:** omit `background` → today’s look.

## Tests

- Default: no `FormBackground` → scaffold uses theme background; AppBar present
- `showAppBar: false` + `header` → no AppBar; header visible
- `FormBackStyle.ios` / `.android` leading when can pop
- `FormBackground(color: Colors.red)` → Scaffold `backgroundColor` is red (find by widget)
- Light vs dark: with `image` + `imageDark`, pump under light/dark Theme → correct ImageProvider (or golden/smoke)
- Existing example / gen / tests still compile

## Do not

- Hardcode `Colors.white` underlays
- Put Riverpod in core barrel
- Depend page_kit → scale_theme_kit
- Migrate lab / kiwash / lightnessword (reference only)
- Commit / publish unless asked

## Done when

- [ ] Optional AppBar + header + FormBackStyle
- [ ] `FormBackground` with color / colorDark / image / imageDark + correct paint order
- [ ] Defaults to theme scaffold background
- [ ] Spec + README/API docs updated
- [ ] `fvm flutter analyze` + `test` green in `flutter_page_kit`

## Out of scope

Lab T20–T24, other kits’ feature work, full Cupertino navigation rewrite.
