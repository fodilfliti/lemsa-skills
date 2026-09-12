import '../domain/task_draft.dart';
import '../domain/task_model.dart';
import '../domain/task_query.dart';
import '../domain/task_with_meta.dart';
import '../../../stubs/failures.dart';

/// Snapshot after a cache sync pass (remote pull + outbox flush).
class SyncSnapshot {
  const SyncSnapshot({
    required this.pulledCount,
    required this.flushedCount,
    required this.pendingCount,
    required this.lastSyncAt,
    this.offline = false,
  });

  final int pulledCount;
  final int flushedCount;
  final int pendingCount;
  final DateTime? lastSyncAt;
  final bool offline;

  SyncSnapshot copyWith({
    int? pulledCount,
    int? flushedCount,
    int? pendingCount,
    DateTime? lastSyncAt,
    bool? offline,
  }) {
    return SyncSnapshot(
      pulledCount: pulledCount ?? this.pulledCount,
      flushedCount: flushedCount ?? this.flushedCount,
      pendingCount: pendingCount ?? this.pendingCount,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      offline: offline ?? this.offline,
    );
  }
}

abstract class TaskSource {
  Future<List<TaskModel>> list(TaskQuery query);

  Future<TaskModel> create(TaskDraft draft);

  Future<TaskModel> update(TaskModel task);

  Future<void> delete(String id);
}

abstract class TaskRepository {
  Stream<List<TaskWithMeta>> watchTasks(TaskQuery query);

  Future<List<TaskWithMeta>> list(TaskQuery query);

  Future<TaskModel> create(TaskDraft draft);

  Future<TaskModel> update(TaskModel task);

  Future<void> delete(String id);

  Future<SyncSnapshot> sync({bool forceRemote = false});

  Future<int> pendingSyncCount();
}

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._source);

  final TaskSource _source;

  @override
  Stream<List<TaskWithMeta>> watchTasks(TaskQuery query) {
    throw UnimplementedError('Use CachedTaskRepository');
  }

  @override
  Future<List<TaskWithMeta>> list(TaskQuery query) async {
    final tasks = await _source.list(query);
    return tasks
        .map((t) => TaskWithMeta(task: t, syncStatus: TaskSyncStatus.synced))
        .toList(growable: false);
  }

  @override
  Future<TaskModel> create(TaskDraft draft) {
    if (draft.title.trim().isEmpty) {
      throw const ValidationFailure('title');
    }
    return _source.create(draft);
  }

  @override
  Future<TaskModel> update(TaskModel task) => _source.update(task);

  @override
  Future<void> delete(String id) => _source.delete(id);

  @override
  Future<SyncSnapshot> sync({bool forceRemote = false}) async {
    throw UnimplementedError('Use CachedTaskRepository');
  }

  @override
  Future<int> pendingSyncCount() async => 0;
}
