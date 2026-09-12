import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/widgets/lemsa_loader.dart';
import 'core/disposables.dart';
import 'core/extensions.dart';
import 'failures.dart';
import 'validators.dart';

/// Stub until [flutter_page_kit] AsyncView ships.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    required this.value,
    required this.data,
    required this.error,
    this.loading,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function(AppFailure failure) error;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (d) => data(d),
      error: (e, _) {
        if (e is AppFailure) {
          return error(e);
        }
        return error(UnknownFailure(e));
      },
      loading: () => Center(child: loading ?? const LemsaLoader()),
    );
  }
}

/// Keyed busy tracker for write operations.
class BusyTracker {
  final Set<Object> _running = {};

  /// Preferred read: `busy.of('save')` / `busy.of(('delete', id))`.
  bool of(Object key) => _running.contains(key);

  bool isRunning(Object key) => of(key);

  bool get any => _running.isNotEmpty;

  void start(Object key) => _running.add(key);

  void stop(Object key) => _running.remove(key);
}

/// Field that can participate in [PageData.validateForm].
abstract interface class Validatable {
  bool get isValid;

  /// Machine code (`required`, `minLength`, …). Never a translated string.
  String? get errorCode;
}

/// Text field handle. Bind with `TextField(controller: title.controller)`.
class FieldText implements Validatable {
  FieldText(
    this.controller, {
    List<FieldValidator>? validators,
  }) : validators = validators ?? [Validators.required];

  final TextEditingController controller;
  final List<FieldValidator> validators;

  String get value => controller.text;

  @override
  String? get errorCode => Validators.all(value, validators);

  @override
  bool get isValid => errorCode == null;
}

/// Bool flag handle. Bind with `value: done.value`.
class FieldFlag {
  FieldFlag(this.notifier);

  final ValueNotifier<bool> notifier;

  bool get value => notifier.value;

  set value(bool next) => notifier.value = next;
}

/// Money handle: text input + num parse via core extensions.
class FieldMoney implements Validatable {
  FieldMoney(this.controller);

  final TextEditingController controller;

  String get text => controller.text;

  num get value => text.toDoubleValue;

  @override
  String? get errorCode => null;

  @override
  bool get isValid => errorCode == null;
}

/// Optional date handle.
class FieldDate {
  FieldDate(this.notifier);

  final ValueNotifier<DateTime?> notifier;

  DateTime? get value => notifier.value;

  set value(DateTime? next) => notifier.value = next;
}

/// List handle.
class FieldItems<E> {
  FieldItems(this.notifier);

  final ValueNotifier<List<E>> notifier;

  List<E> get value => List<E>.unmodifiable(notifier.value);

  set value(List<E> next) => notifier.value = List<E>.of(next);
}

/// Page controller mixin. Stub until [flutter_page_kit] PageData ships.
///
/// Only this mixin overrides [dispose] — feature mixins must not.
mixin PageData<T extends StatefulWidget> on State<T> {
  final Disposables _disposables = Disposables();
  final BusyTracker busy = BusyTracker();
  AppFailure? failure;

  /// Set by [validateForm]. Pages show `errorText` only after a submit attempt.
  bool showFieldErrors = false;

  List<Validatable> get validated => const [];

  FieldText text({String? initial, List<FieldValidator>? validators}) {
    return FieldText(
      keep(TextEditingController(text: initial.text)),
      validators: validators,
    );
  }

  FieldFlag flag([bool initial = false]) {
    return FieldFlag(keep(ValueNotifier<bool>(initial)));
  }

  FieldMoney money([num? initial]) {
    final seed = initial == null ? '' : '$initial';
    return FieldMoney(keep(TextEditingController(text: seed)));
  }

  FieldDate date([DateTime? initial]) {
    return FieldDate(keep(ValueNotifier<DateTime?>(initial)));
  }

  FieldItems<E> items<E>([List<E>? initial]) {
    return FieldItems<E>(
      keep(ValueNotifier<List<E>>(List<E>.of(initial ?? <E>[]))),
    );
  }

  /// Register an arbitrary [ChangeNotifier] (focus nodes, animation, …).
  R keep<R extends ChangeNotifier>(R value) => _disposables.keep(value);

  Future<bool> validateForm() async {
    showFieldErrors = true;
    final ok = validated.every((field) => field.isValid);
    if (!ok) {
      failure = const ValidationFailure('form');
    }
    if (mounted) {
      setState(() {});
    }
    return ok;
  }

  Future<void> run({
    required Object key,
    required Future<void> Function() action,
  }) async {
    if (busy.of(key)) {
      return;
    }
    busy.start(key);
    failure = null;
    if (mounted) {
      setState(() {});
    }
    try {
      await action();
    } on AppFailure catch (e) {
      if (e is CancelledFailure) {
        return;
      }
      failure = e;
    } catch (e) {
      failure = UnknownFailure(e);
    } finally {
      busy.stop(key);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _disposables.dispose();
    super.dispose();
  }
}

/// Test harness stub until [flutter_page_kit] PageHarness ships.
///
/// Pass `tester.pumpWidget` and a [GlobalKey] whose widget is [host].
class PageHarness<C extends State<StatefulWidget>> {
  PageHarness._(this.controller);

  final C controller;

  static Future<PageHarness<C>> mount<C extends State<StatefulWidget>>({
    required Future<void> Function(Widget widget) pumpWidget,
    required Widget host,
    required GlobalKey<C> key,
  }) async {
    await pumpWidget(MaterialApp(home: host));
    final state = key.currentState;
    if (state == null) {
      throw StateError(
        'PageHarness.mount: key.currentState is null. '
        'Use the same GlobalKey on [host].',
      );
    }
    return PageHarness._(state);
  }
}
