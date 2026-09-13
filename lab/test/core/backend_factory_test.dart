import 'package:flutter_test/flutter_test.dart';
import 'package:lemsa_lab/core/backend/lab_backend.dart';
import 'package:lemsa_lab/core/backend/task_source_factory.dart';
import 'package:lemsa_lab/features/tasks/data/sources/mock_task_source.dart';
import 'package:lemsa_lab/features/tasks/data/sources/task_source_firebase.dart';
import 'package:lemsa_lab/features/tasks/data/sources/task_source_rest.dart';
import 'package:lemsa_lab/features/tasks/data/sources/task_source_supabase.dart';
import 'package:lemsa_lab/features/tasks/data/task_repository.dart';

void main() {
  group('TaskSourceFactory', () {
    const factory = TaskSourceFactory();

    test('mock → MockTaskSource', () {
      final source = factory.create(
        backend: LabBackend.mock,
        supabaseReady: false,
        firebaseReady: false,
      );
      expect(source, isA<MockTaskSource>());
      expect(source, isA<TaskSource>());
    });

    test('rest → RestTaskSource', () {
      final source = factory.create(
        backend: LabBackend.rest,
        supabaseReady: false,
        firebaseReady: false,
      );
      expect(source, isA<RestTaskSource>());
    });

    test('supabase without secrets → SupabaseTaskSource fallback', () {
      final source = factory.create(
        backend: LabBackend.supabase,
        supabaseReady: false,
        firebaseReady: false,
      );
      expect(source, isA<SupabaseTaskSource>());
    });

    test('firebase without secrets → FirebaseTaskSource fallback', () {
      final source = factory.create(
        backend: LabBackend.firebase,
        supabaseReady: false,
        firebaseReady: false,
      );
      expect(source, isA<FirebaseTaskSource>());
    });
  });

  test('LabBackend.parse covers aliases', () {
    expect(LabBackend.parse('dio'), LabBackend.rest);
    expect(LabBackend.parse('SUPABASE'), LabBackend.supabase);
    expect(LabBackend.parse('nope'), LabBackend.mock);
  });
}
