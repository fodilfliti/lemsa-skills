import 'package:auto_route/auto_route.dart';

/// Requires signed-in session — redirects to `/login` when absent.
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this.isSignedIn);

  final bool Function() isSignedIn;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (isSignedIn()) {
      resolver.next(true);
      return;
    }
    resolver.next(false);
    router.replaceNamed('/login');
  }
}
