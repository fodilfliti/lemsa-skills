import 'package:flutter/material.dart';

import '../domain/task_extensions.dart';
import '../domain/task_model.dart';
import '../domain/task_with_meta.dart';
import '../../../i18n/strings.g.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.item,
    this.onToggleDone,
    this.busy = false,
    super.key,
  });

  final TaskWithMeta item;
  final VoidCallback? onToggleDone;
  final bool busy;

  TaskModel get task => item.task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: busy ? null : onToggleDone,
      title: Text(
        task.title,
        style: task.isDone
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Theme.of(context).disabledColor,
              )
            : null,
      ),
      subtitle: _syncSubtitle(),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.needsSync) _syncIcon(),
          if (busy)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            IconButton(
              tooltip: task.isDone ? t.tasks.markPending : t.tasks.markDone,
              onPressed: onToggleDone,
              icon: Icon(
                task.isDone ? Icons.check_circle : Icons.circle_outlined,
              ),
            ),
        ],
      ),
    );
  }

  Widget? _syncSubtitle() {
    return switch (item.syncStatus) {
      TaskSyncStatus.synced => null,
      TaskSyncStatus.pending => Text(t.tasks.pendingSync),
      TaskSyncStatus.failed => Text(t.tasks.syncFailed),
    };
  }

  Widget _syncIcon() {
    return switch (item.syncStatus) {
      TaskSyncStatus.pending => const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.cloud_upload_outlined, size: 18),
        ),
      TaskSyncStatus.failed => const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.cloud_off_outlined, size: 18, color: Colors.red),
        ),
      TaskSyncStatus.synced => const SizedBox.shrink(),
    };
  }
}
