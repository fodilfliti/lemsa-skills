import '../../domain/task_draft.dart';
import '../../domain/task_model.dart';
import '../../domain/task_query.dart';
import '../mappers/task_mapper.dart';
import '../task_repository.dart';
import '../api/task_api.dart';

/// S11 REST adapter — enable when user says "test retrofit path".
class RestTaskSource implements TaskSource {
  RestTaskSource(this._api);

  final TaskApi _api;

  @override
  Future<List<TaskModel>> list(TaskQuery query) async {
    final dtos = await _api.listTasks();
    return dtos.map(taskFromDto).where((t) {
      if (query.status != null && t.status != query.status) {
        return false;
      }
      return true;
    }).toList(growable: false);
  }

  @override
  Future<TaskModel> create(TaskDraft draft) async {
    final dto = await _api.createTask(
      taskToDto(
        TaskModel(
          id: '',
          title: draft.title,
        ),
      ),
    );
    return taskFromDto(dto);
  }

  @override
  Future<TaskModel> update(TaskModel task) =>
      throw UnimplementedError('REST update — extend S11');

  @override
  Future<void> delete(String id) =>
      throw UnimplementedError('REST delete — extend S11');
}
