import '../../domain/task_model.dart';
import '../dto/task_dto.dart';

TaskModel taskFromDto(TaskDto dto) {
  return TaskModel(
    id: dto.id,
    title: dto.title,
    status: dto.status == 'done' ? TaskStatus.done : TaskStatus.pending,
  );
}

TaskDto taskToDto(TaskModel model) {
  return TaskDto(
    id: model.id,
    title: model.title,
    status: model.status == TaskStatus.done ? 'done' : 'pending',
  );
}
