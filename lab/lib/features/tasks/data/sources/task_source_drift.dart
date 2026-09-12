import '../../domain/task_draft.dart';
import '../../domain/task_model.dart';
import '../../domain/task_query.dart';
import '../task_repository.dart';

/// S07 — local cache lives in [DriftTaskLocalStore]; remote stays [MockTaskSource].
///
/// Swap `taskRepositoryProvider` only for REST/Supabase adapters — not this file.
class DriftTaskSource implements TaskSource {
  @override
  Future<TaskModel> create(TaskDraft draft) =>
      throw UnsupportedError('Use CachedTaskRepository + DriftTaskLocalStore');

  @override
  Future<void> delete(String id) =>
      throw UnsupportedError('Use CachedTaskRepository');

  @override
  Future<List<TaskModel>> list(TaskQuery query) =>
      throw UnsupportedError('Use CachedTaskRepository.watchTasks stream');

  @override
  Future<TaskModel> update(TaskModel task) =>
      throw UnsupportedError('Use CachedTaskRepository');
}
