import 'failures.dart';

/// Toasts / snackbars — stub until [flutter_app_kit] ships.
///
/// Controllers call [error], [showFailure], etc.; pages supply via `ref.read(noticesProvider)`.
abstract class Notices {
  void info(String message);

  void warn(String message);

  void error(String message);

  void success(String message);

  /// Maps [AppFailure] through app-owned `failureText()` — skips [CancelledFailure].
  void showFailure(AppFailure? failure);
}
