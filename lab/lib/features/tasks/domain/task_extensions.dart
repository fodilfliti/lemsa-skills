import 'task_draft.dart';
import 'task_model.dart';
import 'task_with_meta.dart';

extension TaskModelX on TaskModel {
  bool get isDone => status == TaskStatus.done;

  bool get isPending => status == TaskStatus.pending;

  TaskDraft toDraft() => TaskDraft(title: title);
}

extension TaskWithMetaX on TaskWithMeta {
  bool get isDone => task.isDone;

  bool get needsSync => syncStatus != TaskSyncStatus.synced;
}
