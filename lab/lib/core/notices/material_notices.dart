import 'package:flutter/material.dart';

import '../../core/failures/failure_text.dart';
import '../../stubs/failures.dart';
import '../../stubs/notices.dart';

/// Default [Notices] — snackbars via root [ScaffoldMessengerState].
///
/// Holds the [GlobalKey] (not a snapshot of [currentState]) so the first
/// notice after cold start still finds the messenger.
class MaterialNotices implements Notices {
  MaterialNotices(this._messengerKey);

  final GlobalKey<ScaffoldMessengerState> _messengerKey;

  void _show(String message, {Color? background}) {
    if (message.isEmpty) {
      return;
    }
    final messenger = _messengerKey.currentState;
    if (messenger == null) {
      return;
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  void info(String message) => _show(message);

  @override
  void warn(String message) =>
      _show(message, background: Colors.orange.shade800);

  @override
  void error(String message) => _show(message, background: Colors.red.shade800);

  @override
  void success(String message) =>
      _show(message, background: Colors.green.shade800);

  @override
  void showFailure(AppFailure? failure) {
    if (failure == null || failure is CancelledFailure) {
      return;
    }
    error(failureText(failure));
  }
}
