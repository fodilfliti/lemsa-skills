import 'package:auto_route/auto_route.dart';

import '../../stubs/page_navigator.dart';

/// [PageNavigator] over auto_route — stub until [flutter_nav_kit] ships.
class AutoPageNavigator implements PageNavigator {
  AutoPageNavigator(this._router);

  final StackRouter _router;

  @override
  bool get canPop => _router.canPop();

  @override
  Future<R?> push<R>(Object route) {
    return _router.push<R>(route as PageRouteInfo<dynamic>);
  }

  @override
  void pop<R>([R? result]) {
    if (_router.canPop()) {
      _router.maybePop<R>(result);
    }
  }

  @override
  void replaceAll(List<Object> routes) {
    _router.replaceAll(routes.cast<PageRouteInfo<dynamic>>());
  }

  @override
  void replaceNamed(String path) {
    _router.replaceNamed(path);
  }
}
