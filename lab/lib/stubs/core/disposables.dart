import 'package:flutter/foundation.dart';

/// Registry of [ChangeNotifier]s. Stub until [lemsa_core_kit] ships.
///
/// [PageData] is the only mixin that should call [dispose]. Feature
/// mixins must not override `dispose()` to clean fields.
class Disposables {
  final List<ChangeNotifier> _owned = [];

  /// Registers [value] for dispose. Returns [value] for `late final` fields.
  R keep<R extends ChangeNotifier>(R value) {
    if (!_owned.contains(value)) {
      _owned.add(value);
    }
    return value;
  }

  /// Disposes in reverse registration order. Safe to call twice.
  void dispose() {
    for (final item in _owned.reversed) {
      item.dispose();
    }
    _owned.clear();
  }

  int get debugLength => _owned.length;
}
