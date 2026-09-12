# flutter_nav_kit

`PageNavigator` implementation over auto_route, guards, deep links.

## Owns

- `AutoPageNavigator` implementing `PageNavigator` from `flutter_page_kit`
- `AuthGuard`, `GuestGuard` reading `sessionProvider`
- `@AutoRouterConfig` app router template
- Deep-link table (replaces `*_deep_link_screen.dart` + `WebRouteHelper` tab map)
- Typed route args (constructor params → `@RoutePage` classes)

## Depends on

`lemsa_core_kit`, `flutter_page_kit`, `auto_route`.

## Replaces

- `Navigator.push(MaterialPageRoute(...))` everywhere
- `GoScreen` ~200-line bootstrap
- `GetAppContext.push` / `pushAndRemoveUntil`
- Per-entity deep link screens

## Web

auto_route web URLs replace hand-rolled `SystemNavigator.routeInformationUpdated` + tab index maps.

## Invariants

- Controllers call `nav.pop()`, `nav.push()`, `nav.replaceAll()` — never `Navigator` directly.
- Sign-out performs no navigation; session change triggers guard redirect.
- Route args are typed classes, not `Map<String,dynamic>`.

## Generator

`dart run flutter_nav_kit:gen routes` — scans `@RoutePage` classes, updates router (wraps `auto_route_generator`).

## Tests

- Guard redirects when session signed out.
- Deep-link table resolves known URIs to routes.
