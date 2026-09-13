import 'package:dio/dio.dart';
import 'package:flutter_data_kit_dio/flutter_data_kit_dio.dart';

import '../../domain/task_draft.dart';
import '../../domain/task_model.dart';
import '../../domain/task_query.dart';
import '../task_repository.dart';

/// REST adapter via Dio + [runDio] / [FailureInterceptor].
///
/// Uses JSONPlaceholder public API so recruiters can run `rest` without keys.
/// Create maps to a local echo (JSONPlaceholder POST returns the body).
class RestTaskSource implements TaskSource {
  RestTaskSource({Dio? dio})
      : _dio = dio ??
            buildDioClient(
              baseUrl: 'https://jsonplaceholder.typicode.com',
            );

  final Dio _dio;

  @override
  Future<List<TaskModel>> list(TaskQuery query) {
    return runDio(() async {
      final response = await _dio.get<List<dynamic>>('/todos');
      final rows = response.data ?? const [];
      return rows.take(30).map((raw) {
        final map = raw as Map<String, dynamic>;
        return TaskModel(
          id: '${map['id']}',
          title: map['title'] as String? ?? '',
          status: (map['completed'] as bool? ?? false)
              ? TaskStatus.done
              : TaskStatus.pending,
        );
      }).where((t) {
        if (query.status != null && t.status != query.status) {
          return false;
        }
        return true;
      }).toList(growable: false);
    });
  }

  @override
  Future<TaskModel> create(TaskDraft draft) {
    return runDio(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/todos',
        data: {
          'title': draft.title.trim(),
          'completed': false,
          'userId': 1,
        },
      );
      final map = response.data ?? const <String, dynamic>{};
      return TaskModel(
        id: '${map['id'] ?? DateTime.now().microsecondsSinceEpoch}',
        title: draft.title.trim(),
      );
    });
  }

  @override
  Future<TaskModel> update(TaskModel task) {
    return runDio(() async {
      await _dio.put<Map<String, dynamic>>(
        '/todos/${task.id}',
        data: {
          'id': int.tryParse(task.id) ?? 1,
          'title': task.title,
          'completed': task.status == TaskStatus.done,
          'userId': 1,
        },
      );
      return task;
    });
  }

  @override
  Future<void> delete(String id) {
    return runDio(() async {
      await _dio.delete<void>('/todos/$id');
    });
  }
}
