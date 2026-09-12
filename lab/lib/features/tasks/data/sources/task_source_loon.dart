import '../../domain/task_draft.dart';
import '../../domain/task_model.dart';
import '../../domain/task_query.dart';
import '../task_repository.dart';

/// S12 stub — add `loon` to pubspec only when user explicitly asks.
class LoonTaskSource implements TaskSource {
  @override
  Future<TaskModel> create(TaskDraft draft) =>
      throw UnimplementedError('Enable S12 and add loon dep');

  @override
  Future<void> delete(String id) => throw UnimplementedError('Enable S12');

  @override
  Future<List<TaskModel>> list(TaskQuery query) =>
      throw UnimplementedError('Enable S12');

  @override
  Future<TaskModel> update(TaskModel task) =>
      throw UnimplementedError('Enable S12');
}
