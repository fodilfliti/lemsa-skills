import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lemsa_lab/core/database/lab_database.dart';
import 'package:lemsa_lab/features/tasks/data/sources/mock_task_source.dart';
import 'package:lemsa_lab/features/tasks/domain/task_model.dart';
import 'package:lemsa_lab/features/tasks/domain/task_query.dart';
import 'package:lemsa_lab/features/tasks/state/task_providers.dart';

void main() {
  test('taskRemoteSourceProvider can be overridden (S05)', () async {
    final db = LabDatabase.memory();
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        labDatabaseProvider.overrideWithValue(db),
        taskRemoteSourceProvider.overrideWithValue(
          MockTaskSource(
            delay: Duration.zero,
            seed: [const TaskModel(id: 'x', title: 'Override')],
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final list = await container.read(taskRepositoryProvider).list(
          const TaskQuery(),
        );
    expect(list.single.task.title, 'Override');
  });
}
