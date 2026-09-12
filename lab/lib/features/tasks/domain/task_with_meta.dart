import 'task_model.dart';

/// Sync state for a cached task row (local Drift metadata).
enum TaskSyncStatus {
  synced,
  pending,
  failed;

  static TaskSyncStatus parse(String raw) => switch (raw) {
        'pending' => TaskSyncStatus.pending,
        'failed' => TaskSyncStatus.failed,
        _ => TaskSyncStatus.synced,
      };

  String get wire => switch (this) {
        TaskSyncStatus.synced => 'synced',
        TaskSyncStatus.pending => 'pending',
        TaskSyncStatus.failed => 'failed',
      };
}

/// Domain task + local cache/sync metadata for list UI.
class TaskWithMeta {
  const TaskWithMeta({required this.task, required this.syncStatus});

  final TaskModel task;
  final TaskSyncStatus syncStatus;
}
