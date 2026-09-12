import 'package:flutter_test/flutter_test.dart';

import 'package:lemsa_lab/core/database/lab_database.dart';
import 'package:lemsa_lab/features/tasks/data/cached_task_repository.dart';
import 'package:lemsa_lab/features/tasks/data/local/drift_task_local_store.dart';
import 'package:lemsa_lab/features/tasks/data/sources/mock_task_source.dart';
import 'package:lemsa_lab/features/tasks/domain/task_draft.dart';
import 'package:lemsa_lab/features/tasks/domain/task_query.dart';
import 'package:lemsa_lab/features/tasks/domain/task_with_meta.dart';

void main() {
  group('CachedTaskRepository', () {
    late LabDatabase db;
    late MockTaskSource remote;
    late CachedTaskRepository repo;

    setUp(() {
      db = LabDatabase.memory();
      remote = MockTaskSource(delay: Duration.zero, seed: const []);
      repo = CachedTaskRepository(
        remote: remote,
        local: DriftTaskLocalStore(db),
        db: db,
        isOffline: () => remote.forceOffline,
      );
    });

    tearDown(() => db.close());

    test('sync pulls remote seed into drift', () async {
      remote = MockTaskSource(delay: Duration.zero);
      repo = CachedTaskRepository(
        remote: remote,
        local: DriftTaskLocalStore(db),
        db: db,
        isOffline: () => false,
      );

      final snapshot = await repo.sync(forceRemote: true);
      expect(snapshot.pulledCount, greaterThanOrEqualTo(2));

      final cached = await repo.list(const TaskQuery());
      expect(cached.length, greaterThanOrEqualTo(2));
      expect(cached, isNotEmpty);
      expect(cached.every((t) => t.syncStatus == TaskSyncStatus.synced), isTrue);
    });

    test('offline create stays pending in cache', () async {
      remote.forceOffline = true;

      final created =
          await repo.create(const TaskDraft(title: 'Offline task'));
      expect(created.id.startsWith('local-'), isTrue);

      final cached = await repo.list(const TaskQuery());
      expect(cached.any((t) => t.task.title == 'Offline task'), isTrue);
      final pending = cached.firstWhere((t) => t.task.title == 'Offline task');
      expect(pending.syncStatus, TaskSyncStatus.pending);
      expect(await repo.pendingSyncCount(), greaterThan(0));
    });

    test('flush outbox after back online', () async {
      remote.forceOffline = true;
      await repo.create(const TaskDraft(title: 'Queued'));
      remote.forceOffline = false;

      final snapshot = await repo.sync(forceRemote: true);
      expect(snapshot.flushedCount, 1);
      expect(await repo.pendingSyncCount(), 0);
    });

    test('deleteUserData clears tables', () async {
      await repo.sync(forceRemote: true);
      await db.deleteUserData();
      final cached = await DriftTaskLocalStore(db).readTasks(const TaskQuery());
      expect(cached, isEmpty);
    });
  });
}
