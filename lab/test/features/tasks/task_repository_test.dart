import 'package:flutter_test/flutter_test.dart';

import 'package:lemsa_lab/features/tasks/data/mappers/task_mapper.dart';
import 'package:lemsa_lab/features/tasks/data/sources/mock_task_source.dart';
import 'package:lemsa_lab/features/tasks/data/task_repository.dart';
import 'package:lemsa_lab/features/tasks/domain/task_draft.dart';
import 'package:lemsa_lab/features/tasks/domain/task_model.dart';
import 'package:lemsa_lab/features/tasks/domain/task_query.dart';
import 'package:lemsa_lab/stubs/failures.dart';

void main() {
  group('MockTaskSource', () {
    late MockTaskSource source;
    late TaskRepositoryImpl repo;

    setUp(() {
      source = MockTaskSource(delay: Duration.zero);
      repo = TaskRepositoryImpl(source);
    });

    test('lists seed tasks', () async {
      final tasks = await repo.list(const TaskQuery());
      expect(tasks.length, greaterThanOrEqualTo(2));
    });

    test('create maps draft to model', () async {
      final task = await repo.create(const TaskDraft(title: 'Mapper test'));
      expect(task.title, 'Mapper test');
      expect(task.id, isNotEmpty);
    });

    test('validation failure on empty title', () {
      expect(
        () => repo.create(const TaskDraft(title: '  ')),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });

  group('task_mapper', () {
    test('round trip status', () {
      const model = TaskModel(id: '1', title: 'x', status: TaskStatus.done);
      final dto = taskToDto(model);
      final back = taskFromDto(dto);
      expect(back.status, TaskStatus.done);
    });
  });
}
