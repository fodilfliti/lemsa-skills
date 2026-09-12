import 'package:auto_route/auto_route.dart';

/// Login-only — signed-in users go to `/home`.
class GuestGuard extends AutoRouteGuard {
  GuestGuard(this.isSignedIn);

  final bool Function() isSignedIn;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (isSignedIn()) {
      resolver.next(false);
      router.replaceNamed('/home');
      return;
    }
    resolver.next(true);
  }
}
