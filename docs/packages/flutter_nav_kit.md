# flutter_nav_kit

**Job:** **routing** — `PageNavigator` over auto_route, auth/guest guards, deep links, typed args.

**Not its job:** form fields, themes, repository logic.

## Why it exists

Reference apps mixed:

- `Navigator.push(MaterialPageRoute(...))`
- Large bootstrap helpers (`GoScreen`)
- Ad-hoc `pushAndRemoveUntil`
- Per-entity deep-link screens and web tab maps

Controllers need to navigate without importing auto_route (keeps page_kit / controllers testable). Guards should react to **session**, not call `nav` on sign-out manually.

## What it does exactly

| Piece | Purpose |
| --- | --- |
| `AutoPageNavigator` | Implements `PageNavigator` from page_kit |
| `AuthGuard` / `GuestGuard` | Read session; redirect |
| Guard helpers | Reevaluate / verdict types |
| `AuthSession` surface | What guards need from the app |
| Deep-link table | Declarative routes instead of one-off screens |
| Typed route args | Constructor / `@RoutePage` — no `Map<String,dynamic>` |
| Optional gen | Wrap/scan routes for router updates |

Controller code:

```dart
nav.pop();
nav.push(...);
nav.replaceAll(...);
// never Navigator.of(context) in controllers
```

Sign-out clears session / user data; **guards** redirect. Controllers do not navigate on logout as a side ritual.

## Architecture

```text
Controller → PageNavigator (interface in page_kit)
                    │
                    ▼
           AutoPageNavigator (this kit)
                    │
                    ▼
              auto_route stack
                    ▲
         AuthGuard / GuestGuard (sessionProvider)
```

Web: auto_route URLs replace hand-rolled `SystemNavigator.routeInformationUpdated` + tab index maps.

## Why this approach

| Choice | Why |
| --- | --- |
| Interface in page_kit, impl here | Controllers stay free of auto_route |
| Guards own auth redirects | Session graph drives nav (aligns with D5) |
| Typed args | Compile-time safety vs stringly maps |
| auto_route | Matches house stack skill; web URLs included |

## Depends on

`lemsa_core_kit`, `flutter_page_kit`, `auto_route` (+ Riverpod for guards as needed).

## Related

- Page navigator interface: [flutter_page_kit.md](flutter_page_kit.md)  
- Bootstrap wires router: [flutter_app_kit.md](flutter_app_kit.md)
