import 'dart:developer' as developer;

import 'package:lemsa_core_kit/lemsa_core_kit.dart';
import 'package:redact/redact.dart';

/// App-owned logger with redact (lemsa.yaml `logging.redact: true`).
///
/// Kit [AppLogger] has no redact hook — keep this thin wrapper in lab.
class AppLogger {
  AppLogger({this.redactEnabled = true}) : _redactor = Redactor();

  final bool redactEnabled;
  final Redactor _redactor;

  void info(String message, {Map<String, Object?>? data}) {
    _log('INFO', message, data);
  }

  void warning(String message, {Object? error}) {
    _log('WARN', message, {'error': error});
  }

  void failure(AppFailure failure, {String? context}) {
    _log('FAIL', context ?? 'failure', {'type': failure.runtimeType.toString()});
  }

  void _log(String level, String message, Map<String, Object?>? data) {
    final buffer = StringBuffer('$level: ');
    buffer.write(_scrub(message));
    if (data != null && data.isNotEmpty) {
      buffer.write(' ${_scrub(data.toString())}');
    }
    developer.log(buffer.toString(), name: 'lemsa_lab');
  }

  String _scrub(String text) {
    if (!redactEnabled) {
      return text;
    }
    return _redactor.redact(text).text;
  }
}

final appLogger = AppLogger();
