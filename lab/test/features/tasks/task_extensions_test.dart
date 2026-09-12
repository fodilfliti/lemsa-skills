import 'package:flutter_test/flutter_test.dart';

import 'package:lemsa_lab/features/tasks/domain/task_draft.dart';
import 'package:lemsa_lab/features/tasks/domain/task_extensions.dart';
import 'package:lemsa_lab/features/tasks/domain/task_model.dart';
import 'package:lemsa_lab/features/tasks/domain/task_with_meta.dart';

void main() {
  test('TaskModel isDone / toDraft', () {
    const pending = TaskModel(id: '1', title: 'Write spec');
    const done = TaskModel(id: '2', title: 'Ship', status: TaskStatus.done);

    expect(pending.isDone, isFalse);
    expect(pending.isPending, isTrue);
    expect(done.isDone, isTrue);
    expect(pending.toDraft(), isA<TaskDraft>());
    expect(pending.toDraft().title, 'Write spec');
  });

  test('TaskWithMeta needsSync', () {
    const task = TaskModel(id: '1', title: 'Cached');
    const pending = TaskWithMeta(
      task: task,
      syncStatus: TaskSyncStatus.pending,
    );
    const synced = TaskWithMeta(
      task: task,
      syncStatus: TaskSyncStatus.synced,
    );

    expect(pending.needsSync, isTrue);
    expect(synced.needsSync, isFalse);
    expect(pending.isDone, isFalse);
  });
}
