import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/lab_database.dart';
import '../../domain/task_model.dart';
import '../../domain/task_query.dart';
import '../../domain/task_with_meta.dart';

/// Drift-backed local cache + outbox — storage truth for tasks in lab.
class DriftTaskLocalStore {
  DriftTaskLocalStore(this._db);

  final LabDatabase _db;

  Stream<List<TaskWithMeta>> watchTasks(TaskQuery query) {
    final q = _db.select(_db.taskRows);
    if (query.status != null) {
      final statusWire =
          query.status == TaskStatus.done ? 'done' : 'pending';
      q.where((row) => row.status.equals(statusWire));
    }
    q.orderBy([(row) => OrderingTerm.desc(row.updatedAt)]);
    return q.watch().map(_mapRows);
  }

  Future<List<TaskWithMeta>> readTasks(TaskQuery query) async {
    final q = _db.select(_db.taskRows);
    if (query.status != null) {
      final statusWire =
          query.status == TaskStatus.done ? 'done' : 'pending';
      q.where((row) => row.status.equals(statusWire));
    }
    q.orderBy([(row) => OrderingTerm.desc(row.updatedAt)]);
    return _mapRows(await q.get());
  }

  Future<void> replaceRemoteSnapshot(List<TaskModel> remote) async {
    await _db.transaction(() async {
      final remoteIds = remote.map((t) => t.id).toSet();
      final localPending = await (_db.select(_db.taskRows)
            ..where((r) => r.syncStatus.equals('pending')))
          .get();
      final keepPending =
          localPending.where((r) => !remoteIds.contains(r.id)).toList();

      await _db.delete(_db.taskRows).go();

      for (final task in remote) {
        await _db.into(_db.taskRows).insert(
              _companion(task, TaskSyncStatus.synced),
            );
      }
      for (final row in keepPending) {
        await _db.into(_db.taskRows).insert(row);
      }
    });
  }

  Future<void> upsertLocal(
    TaskModel task, {
    required TaskSyncStatus syncStatus,
  }) {
    return _db.into(_db.taskRows).insertOnConflictUpdate(
          _companion(task, syncStatus),
        );
  }

  Future<void> replaceLocalId(String localId, TaskModel remote) async {
    await _db.transaction(() async {
      await (_db.delete(_db.taskRows)..where((r) => r.id.equals(localId)))
          .go();
      await _db.into(_db.taskRows).insert(
            _companion(remote, TaskSyncStatus.synced),
          );
      await (_db.delete(_db.syncOutbox)
            ..where((o) => o.entityId.equals(localId)))
          .go();
    });
  }

  Future<void> enqueueCreate(TaskModel optimistic) {
    return _db.into(_db.syncOutbox).insert(
          SyncOutboxCompanion.insert(
            operation: 'create',
            entityId: optimistic.id,
            payloadJson: jsonEncode(optimistic.toJson()),
          ),
        );
  }

  Future<void> enqueueUpdate(TaskModel task) {
    return _db.into(_db.syncOutbox).insert(
          SyncOutboxCompanion.insert(
            operation: 'update',
            entityId: task.id,
            payloadJson: jsonEncode(task.toJson()),
          ),
        );
  }

  Future<void> enqueueDelete(String id) {
    return _db.into(_db.syncOutbox).insert(
          SyncOutboxCompanion.insert(
            operation: 'delete',
            entityId: id,
            payloadJson: jsonEncode({'id': id}),
          ),
        );
  }

  Future<List<SyncOutboxData>> pendingOutbox() {
    return (_db.select(_db.syncOutbox)
          ..orderBy([(o) => OrderingTerm.asc(o.createdAt)]))
        .get();
  }

  Future<void> removeOutboxEntry(int id) {
    return (_db.delete(_db.syncOutbox)..where((o) => o.id.equals(id))).go();
  }

  Future<int> pendingCount() async {
    final outbox = await _db.select(_db.syncOutbox).get();
    final pendingRows = await (_db.select(_db.taskRows)
          ..where((r) => r.syncStatus.equals('pending')))
        .get();
    return outbox.length + pendingRows.length;
  }

  TaskRowsCompanion _companion(TaskModel task, TaskSyncStatus sync) {
    return TaskRowsCompanion.insert(
      id: task.id,
      title: task.title,
      status: task.status == TaskStatus.done ? 'done' : 'pending',
      syncStatus: Value(sync.wire),
      updatedAt: Value(DateTime.now()),
    );
  }

  List<TaskWithMeta> _mapRows(List<TaskRow> rows) {
    return rows
        .map(
          (row) => TaskWithMeta(
            task: TaskModel(
              id: row.id,
              title: row.title,
              status:
                  row.status == 'done' ? TaskStatus.done : TaskStatus.pending,
            ),
            syncStatus: TaskSyncStatus.parse(row.syncStatus),
          ),
        )
        .toList(growable: false);
  }
}
