import '../../domain/task_draft.dart';
import '../../domain/task_model.dart';
import '../../domain/task_query.dart';
import '../task_repository.dart';

/// S06 stub — wire when user says "test supabase path".
class SupabaseTaskSource implements TaskSource {
  @override
  Future<TaskModel> create(TaskDraft draft) =>
      throw UnimplementedError('Enable S06 explicitly');

  @override
  Future<void> delete(String id) => throw UnimplementedError('Enable S06');

  @override
  Future<List<TaskModel>> list(TaskQuery query) =>
      throw UnimplementedError('Enable S06');

  @override
  Future<TaskModel> update(TaskModel task) =>
      throw UnimplementedError('Enable S06');
}
