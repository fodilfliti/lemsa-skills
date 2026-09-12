---
name: flutter-autoroute
description: >
  auto_route 11 with typed routes, guards, and web URLs in Lemsa apps. Use for
  navigation setup, @RoutePage, AuthGuard, deep links, replacing Navigator.push
  or GoScreen bootstrap.
license: MIT
metadata:
  author: fodilfliti
  version: "1.0.0"
---

# Flutter auto_route (Lemsa)

Versions: `auto_route` 11.1.0, `auto_route_generator` 10.6.0.

## Setup

- `@AutoRouterConfig()` app router
- `MaterialApp.router` with `routerConfig`
- Route args via constructor params on `@RoutePage()` widgets

## Guards

`AuthGuard` reads `sessionProvider` — signed out → `LoginRoute`. Sign-out does **not** call Navigator; session change triggers redirect.

## PageNavigator

Controllers call `nav.push<R>(route)`, `nav.pop(result)` via `PageNavigator` (`flutter_page_kit` + `flutter_nav_kit`) — never raw `Navigator` or `context.router` in mixins.

Pages wire `@override PageNavigator get nav => ref.read(navigatorProvider)` — or mix in `PageBridge` on form pages.

Typed return: `final saved = await nav.push<TaskModel>(AddTaskRoute())`.

## Notices

Controllers call `notices.showFailure(failure)` via `Notices` (`flutter_app_kit`) — never `ScaffoldMessenger` in mixins. Use app-owned `failureText(AppFailure)` + slang.

## Web

Use auto_route web paths — delete hand-rolled `WebRouteHelper` tab-index maps.

## Deep links

One table mapping URI → route; delete per-entity `*_deep_link_screen.dart` stubs over time.

## Codegen

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Do not

- Pass untyped `Map` route args
- Navigate from ref.listen on auth state
- Keep GoScreen bootstrap once guards work
