import 'dart:developer' as developer;

import '../../features/tasks/data/sources/mock_task_source.dart';
import '../../features/tasks/data/sources/task_source_firebase.dart';
import '../../features/tasks/data/sources/task_source_rest.dart';
import '../../features/tasks/data/sources/task_source_supabase.dart';
import '../../features/tasks/data/task_repository.dart';
import 'lab_backend.dart';

/// Builds the active [TaskSource] for [LabBackend.current].
///
/// Controllers never call this — providers do. Missing secrets fall back to
/// mock with a logged warning (never crash cold start).
class TaskSourceFactory {
  const TaskSourceFactory();

  TaskSource create({
    required LabBackend backend,
    required bool supabaseReady,
    required bool firebaseReady,
  }) {
    switch (backend) {
      case LabBackend.mock:
        return MockTaskSource();
      case LabBackend.rest:
        return RestTaskSource();
      case LabBackend.supabase:
        if (!supabaseReady) {
          developer.log(
            'LAB_BACKEND=supabase but credentials missing — using mock',
            name: 'lemsa_lab',
          );
          return SupabaseTaskSource(clientConfigured: false);
        }
        return SupabaseTaskSource(clientConfigured: true);
      case LabBackend.firebase:
        if (!firebaseReady) {
          developer.log(
            'LAB_BACKEND=firebase but credentials missing — using mock',
            name: 'lemsa_lab',
          );
          return FirebaseTaskSource(clientConfigured: false);
        }
        return FirebaseTaskSource(clientConfigured: true);
    }
  }
}
