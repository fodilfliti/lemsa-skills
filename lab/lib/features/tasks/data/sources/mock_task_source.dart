import 'dart:math';

import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import '../../domain/task_draft.dart';
import '../../domain/task_model.dart';
import '../../domain/task_query.dart';
import '../task_repository.dart';

/// In-memory backend — default for lab (`backend: mock`).
///
/// Simulates a slow/flaky API so UI busy locks and snackbars are testable.
class MockTaskSource implements TaskSource {
  MockTaskSource({
    List<TaskModel>? seed,
    this.delay = const Duration(milliseconds: 900),
    this.failRate = 0,
    Random? random,
  }) : _random = random ?? Random() {
    _store.addAll(seed ?? _defaultSeed);
  }

  /// Artificial latency (like a real HTTP round-trip).
  Duration delay;

  /// 0.0–1.0 chance each call throws [NetworkFailure] (when online).
  double failRate;

  /// Lab hook — simulates unreachable remote (profile offline toggle).
  bool forceOffline = false;

  /// When true, next mutating/list call fails once then clears.
  bool failNext = false;

  final Random _random;
  final List<TaskModel> _store = [];

  static final _defaultSeed = [
    const TaskModel(id: '1', title: 'Review architecture'),
    const TaskModel(
      id: '2',
      title: 'Run lab scenarios',
      status: TaskStatus.done,
    ),
  ];

  void _ensureOnline() {
    if (forceOffline) {
      throw const NetworkFailure();
    }
  }

  Future<void> _wait() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
  }

  void _maybeFail() {
    if (failNext) {
      failNext = false;
      throw const NetworkFailure();
    }
    if (failRate > 0 && _random.nextDouble() < failRate) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<TaskModel>> list(TaskQuery query) async {
    _ensureOnline();
    await _wait();
    _maybeFail();
    return _store.where((t) {
      if (query.status != null && t.status != query.status) {
        return false;
      }
      return true;
    }).toList(growable: false);
  }

  @override
  Future<TaskModel> create(TaskDraft draft) async {
    _ensureOnline();
    await _wait();
    _maybeFail();
    final task = TaskModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: draft.title.trim(),
    );
    _store.add(task);
    return task;
  }

  @override
  Future<TaskModel> update(TaskModel task) async {
    _ensureOnline();
    await _wait();
    _maybeFail();
    final index = _store.indexWhere((t) => t.id == task.id);
    if (index < 0) {
      throw const NotFoundFailure('task');
    }
    _store[index] = task;
    return task;
  }

  @override
  Future<void> delete(String id) async {
    _ensureOnline();
    await _wait();
    _maybeFail();
    final index = _store.indexWhere((t) => t.id == id);
    if (index < 0) {
      throw const NotFoundFailure('task');
    }
    _store.removeAt(index);
  }
}
