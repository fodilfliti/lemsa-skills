import 'dart:convert';

import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import '../../../core/database/lab_database.dart';
import '../domain/task_draft.dart';
import '../domain/task_model.dart';
import '../domain/task_query.dart';
import '../domain/task_with_meta.dart';
import 'local/drift_task_local_store.dart';
import 'task_repository.dart';

/// Cache-aside repository: Drift is storage truth, [TaskSource] is remote.
///
/// - Read: local [watchTasks] stream; [sync] pulls remote + flushes outbox.
/// - Write: optimistic local row + outbox entry, then remote when online.
class CachedTaskRepository implements TaskRepository {
  /// Public param names (`remote`, `local`, …) keep call sites stable across
  /// analyzer versions that disagree on `this._field` named formals.
  CachedTaskRepository({
    required TaskSource remote,
    required DriftTaskLocalStore local,
    required bool Function() isOffline,
    required LabDatabase db,
  }) {
    _remote = remote;
    _local = local;
    _isOffline = isOffline;
    _db = db;
  }

  late final TaskSource _remote;
  late final DriftTaskLocalStore _local;
  late final bool Function() _isOffline;
  late final LabDatabase _db;

  @override
  Stream<List<TaskWithMeta>> watchTasks(TaskQuery query) =>
      _local.watchTasks(query);

  @override
  Future<List<TaskWithMeta>> list(TaskQuery query) async {
    final cached = await _local.readTasks(query);
    if (_isOffline()) {
      return cached;
    }
    try {
      await sync(forceRemote: true);
      return await _local.readTasks(query);
    } on AppFailure {
      if (cached.isNotEmpty) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<TaskModel> create(TaskDraft draft) async {
    if (draft.title.trim().isEmpty) {
      throw const ValidationFailure({'title': 'invalid'});
    }

    final optimistic = TaskModel(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      title: draft.title.trim(),
    );

    await _local.upsertLocal(optimistic, syncStatus: TaskSyncStatus.pending);
    await _local.enqueueCreate(optimistic);

    if (_isOffline()) {
      return optimistic;
    }

    try {
      final remote = await _remote.create(draft);
      await _local.replaceLocalId(optimistic.id, remote);
      return remote;
    } on NetworkFailure {
      // Online but API failed (flaky/demo) — roll back optimistic row and surface error.
      await (_db.delete(_db.taskRows)
            ..where((r) => r.id.equals(optimistic.id)))
          .go();
      await (_db.delete(_db.syncOutbox)
            ..where((o) => o.entityId.equals(optimistic.id)))
          .go();
      rethrow;
    }
  }

  @override
  Future<TaskModel> update(TaskModel task) async {
    final previous = await _local.readTasks(const TaskQuery());
    TaskModel? before;
    for (final e in previous) {
      if (e.task.id == task.id) {
        before = e.task;
        break;
      }
    }

    await _local.upsertLocal(task, syncStatus: TaskSyncStatus.pending);
    await _local.enqueueUpdate(task);

    if (_isOffline()) {
      return task;
    }

    try {
      final remote = await _remote.update(task);
      await _local.upsertLocal(remote, syncStatus: TaskSyncStatus.synced);
      await (_db.delete(_db.syncOutbox)..where((o) => o.entityId.equals(task.id)))
          .go();
      return remote;
    } on NetworkFailure {
      if (before != null) {
        await _local.upsertLocal(before, syncStatus: TaskSyncStatus.synced);
      }
      await (_db.delete(_db.syncOutbox)..where((o) => o.entityId.equals(task.id)))
          .go();
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    await _local.enqueueDelete(id);
    await (_db.delete(_db.taskRows)..where((r) => r.id.equals(id))).go();

    if (_isOffline()) {
      return;
    }

    try {
      await _remote.delete(id);
      await (_db.delete(_db.syncOutbox)..where((o) => o.entityId.equals(id)))
          .go();
    } on NetworkFailure {
      // Outbox keeps delete — will flush on next sync.
    }
  }

  @override
  Future<SyncSnapshot> sync({bool forceRemote = false}) async {
    var flushed = 0;
    var pulled = 0;

    if (!_isOffline()) {
      flushed = await _flushOutbox();
      try {
        final remote = await _remote.list(const TaskQuery());
        pulled = remote.length;
        await _local.replaceRemoteSnapshot(remote);
        await _db.setLastRemoteSync(DateTime.now());
      } on NetworkFailure {
        final pending = await pendingSyncCount();
        return SyncSnapshot(
          pulledCount: 0,
          flushedCount: flushed,
          pendingCount: pending,
          lastSyncAt: await _db.lastRemoteSync(),
          offline: true,
        );
      }
    }

    final pending = await pendingSyncCount();
    return SyncSnapshot(
      pulledCount: pulled,
      flushedCount: flushed,
      pendingCount: pending,
      lastSyncAt: await _db.lastRemoteSync(),
      offline: _isOffline(),
    );
  }

  @override
  Future<int> pendingSyncCount() => _local.pendingCount();

  Future<int> _flushOutbox() async {
    var count = 0;
    final entries = await _local.pendingOutbox();
    for (final entry in entries) {
      try {
        switch (entry.operation) {
          case 'create':
            final json =
                jsonDecode(entry.payloadJson) as Map<String, dynamic>;
            final draft = TaskDraft(title: json['title'] as String);
            final remote = await _remote.create(draft);
            await _local.replaceLocalId(entry.entityId, remote);
          case 'update':
            final json =
                jsonDecode(entry.payloadJson) as Map<String, dynamic>;
            final remote = await _remote.update(TaskModel.fromJson(json));
            await _local.upsertLocal(remote, syncStatus: TaskSyncStatus.synced);
          case 'delete':
            await _remote.delete(entry.entityId);
        }
        await _local.removeOutboxEntry(entry.id);
        count++;
      } on NetworkFailure {
        break;
      }
    }
    return count;
  }
}
