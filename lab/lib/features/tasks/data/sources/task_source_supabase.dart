import 'package:flutter_data_kit_supabase/flutter_data_kit_supabase.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import '../../domain/task_draft.dart';
import '../../domain/task_model.dart';
import '../../domain/task_query.dart';
import '../task_repository.dart';
import 'mock_task_source.dart';

/// Supabase-shaped source. Without a live client, delegates to [MockTaskSource]
/// while still demonstrating [mapSupabase] at the boundary.
class SupabaseTaskSource implements TaskSource {
  SupabaseTaskSource({
    MockTaskSource? fallback,
    this.clientConfigured = false,
  }) : _fallback = fallback ?? MockTaskSource(delay: Duration.zero);

  final MockTaskSource _fallback;
  final bool clientConfigured;

  Future<T> _wrap<T>(Future<T> Function() body) {
    if (!clientConfigured) {
      return body();
    }
    return mapSupabase(body);
  }

  @override
  Future<List<TaskModel>> list(TaskQuery query) {
    return _wrap(() {
      if (!clientConfigured) {
        return _fallback.list(query);
      }
      throw const StorageFailure(cause: 'Supabase table not wired');
    });
  }

  @override
  Future<TaskModel> create(TaskDraft draft) {
    return _wrap(() {
      if (!clientConfigured) {
        return _fallback.create(draft);
      }
      throw const StorageFailure(cause: 'Supabase table not wired');
    });
  }

  @override
  Future<TaskModel> update(TaskModel task) {
    return _wrap(() {
      if (!clientConfigured) {
        return _fallback.update(task);
      }
      throw const StorageFailure(cause: 'Supabase table not wired');
    });
  }

  @override
  Future<void> delete(String id) {
    return _wrap(() {
      if (!clientConfigured) {
        return _fallback.delete(id);
      }
      throw const StorageFailure(cause: 'Supabase table not wired');
    });
  }
}
