import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/backend/lab_backend.dart';
import '../../../core/backend/task_source_factory.dart';
import '../../../core/database/lab_database.dart';
import '../../auth/state/session_provider.dart';
import '../data/cached_task_repository.dart';
import '../data/local/drift_task_local_store.dart';
import '../data/sources/mock_task_source.dart';
import '../data/task_repository.dart';
import '../domain/task_model.dart';
import '../domain/task_query.dart';
import '../domain/task_with_meta.dart';

/// Profile toggle — forces [MockTaskSource.forceOffline] for cache demos.
class OfflineModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
    final remote = ref.read(taskRemoteSourceProvider);
    if (remote is MockTaskSource) {
      remote.forceOffline = value;
    }
  }
}

final offlineModeProvider =
    NotifierProvider<OfflineModeNotifier, bool>(OfflineModeNotifier.new);

/// Profile toggle — random NetworkFailure while online (~40%).
class FlakyApiNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
    final remote = ref.read(taskRemoteSourceProvider);
    if (remote is MockTaskSource) {
      remote.failRate = value ? 0.4 : 0;
    }
  }
}

final flakyApiProvider =
    NotifierProvider<FlakyApiNotifier, bool>(FlakyApiNotifier.new);

final labDatabaseProvider = Provider<LabDatabase>((ref) {
  ref.keepAlive();
  final db = LabDatabase(openLabConnection());
  ref.onDispose(() => db.close());
  return db;
});

final taskLocalStoreProvider = Provider<DriftTaskLocalStore>((ref) {
  return DriftTaskLocalStore(ref.watch(labDatabaseProvider));
});

/// Active remote source selected by [LabBackend.current] (T22).
final taskRemoteSourceProvider = Provider<TaskSource>((ref) {
  return const TaskSourceFactory().create(
    backend: LabBackend.current,
    supabaseReady: false,
    firebaseReady: false,
  );
});

/// Kept for tests / profile demos that cast to [MockTaskSource].
final mockTaskSourceProvider = Provider<MockTaskSource>((ref) {
  final remote = ref.watch(taskRemoteSourceProvider);
  if (remote is MockTaskSource) {
    return remote;
  }
  return MockTaskSource(delay: Duration.zero);
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final remote = ref.watch(taskRemoteSourceProvider);
  return CachedTaskRepository(
    remote: remote,
    local: ref.watch(taskLocalStoreProvider),
    db: ref.watch(labDatabaseProvider),
    isOffline: () {
      final source = ref.read(taskRemoteSourceProvider);
      final forced =
          source is MockTaskSource ? source.forceOffline : false;
      return ref.read(offlineModeProvider) || forced;
    },
  );
});

/// Drift [watch] stream — storage truth surfaced to UI.
final taskListStreamProvider = StreamProvider<List<TaskWithMeta>>((ref) {
  return ref.watch(taskRepositoryProvider).watchTasks(const TaskQuery());
});

final taskSyncProvider =
    AsyncNotifierProvider<TaskSyncNotifier, SyncSnapshot>(TaskSyncNotifier.new);

class TaskSyncNotifier extends AsyncNotifier<SyncSnapshot> {
  @override
  Future<SyncSnapshot> build() async {
    if (ref.read(sessionProvider) == null) {
      return const SyncSnapshot(
        pulledCount: 0,
        flushedCount: 0,
        pendingCount: 0,
        lastSyncAt: null,
      );
    }
    return ref.read(taskRepositoryProvider).sync(forceRemote: true);
  }

  Future<SyncSnapshot> syncNow() async {
    state = const AsyncLoading();
    try {
      final snapshot =
          await ref.read(taskRepositoryProvider).sync(forceRemote: true);
      state = AsyncData(snapshot);
      return snapshot;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

/// Toggle done / pending on a task (list UI).
class TaskActions {
  TaskActions(this._ref);

  final Ref _ref;

  TaskRepository get _repo => _ref.read(taskRepositoryProvider);

  Future<TaskModel> toggleDone(TaskModel task) {
    final next = task.copyWith(
      status: task.status == TaskStatus.done
          ? TaskStatus.pending
          : TaskStatus.done,
    );
    return _repo.update(next);
  }
}

final taskActionsProvider = Provider<TaskActions>(TaskActions.new);

/// Legacy upsert for pop-result path — Drift stream usually updates first.
final taskListProvider =
    AsyncNotifierProvider<TaskListNotifier, List<TaskModel>>(TaskListNotifier.new);

class TaskListNotifier extends AsyncNotifier<List<TaskModel>> {
  @override
  Future<List<TaskModel>> build() async {
    final items =
        await ref.read(taskRepositoryProvider).list(const TaskQuery());
    return items.map((e) => e.task).toList(growable: false);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final items =
          await ref.read(taskRepositoryProvider).list(const TaskQuery());
      return items.map((e) => e.task).toList(growable: false);
    });
  }

  void upsert(TaskModel task) {
    state.whenData((list) {
      final index = list.indexWhere((t) => t.id == task.id);
      final next = [...list];
      if (index >= 0) {
        next[index] = task;
      } else {
        next.insert(0, task);
      }
      state = AsyncData(next);
    });
  }
}
