import 'package:dio/dio.dart';

import '../dto/task_dto.dart';

/// Hand-written REST client (S11). Replace with Retrofit when codegen gate passes.
class TaskApi {
  TaskApi(this._dio, {String? baseUrl}) {
    if (baseUrl != null) {
      _dio.options.baseUrl = baseUrl;
    }
  }

  final Dio _dio;

  Future<List<TaskDto>> listTasks() async {
    final response = await _dio.get<List<dynamic>>('/tasks');
    final data = response.data ?? [];
    return data
        .map((e) => TaskDto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(growable: false);
  }

  Future<TaskDto> createTask(TaskDto body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/tasks',
      data: body.toJson(),
    );
    return TaskDto.fromJson(response.data!);
  }
}
