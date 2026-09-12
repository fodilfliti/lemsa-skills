import '../../domain/task_draft.dart';
import '../../domain/task_model.dart';
import '../../domain/task_query.dart';
import '../task_repository.dart';

/// S08 stub — wire when user says "test firebase path".
class FirebaseTaskSource implements TaskSource {
  @override
  Future<TaskModel> create(TaskDraft draft) =>
      throw UnimplementedError('Enable S08 explicitly');

  @override
  Future<void> delete(String id) => throw UnimplementedError('Enable S08');

  @override
  Future<List<TaskModel>> list(TaskQuery query) =>
      throw UnimplementedError('Enable S08');

  @override
  Future<TaskModel> update(TaskModel task) =>
      throw UnimplementedError('Enable S08');
}
