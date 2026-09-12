/// Navigation without auto_route — stub until [flutter_page_kit] ships.
///
/// Controllers call [pop] / [push]; pages supply an impl via `ref.read(navigatorProvider)`.
abstract class PageNavigator {
  /// Typed push — `await nav.push<TaskModel>(AddTaskRoute())`.
  Future<R?> push<R>(Object route);

  /// Typed pop — `nav.pop(saved)` or `nav.pop()` to dismiss.
  void pop<R>([R? result]);

  /// Clear stack and show routes — e.g. login → home after sign-in.
  void replaceAll(List<Object> routes);

  /// Clear stack and navigate by path — e.g. `/home` after sign-in.
  void replaceNamed(String path);

  bool get canPop;
}
