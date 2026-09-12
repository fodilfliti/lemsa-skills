import 'dart:io';

/// Testable CLI core — no Flutter dependency.
class LabCliCore {
  const LabCliCore({required this.labRoot});

  final String labRoot;

  String featurePath(String name) => '$labRoot/lib/features/$name';

  List<String> featureFolders(String name) => [
        '$name/domain',
        '$name/data/sources',
        '$name/data/dto',
        '$name/data/mappers',
        '$name/data/api',
        '$name/state',
        '$name/controllers',
        '$name/pages',
        '$name/widgets',
      ].map((p) => '${featurePath(name)}/$p'.replaceAll('$name/', '')).toList();

  String scenarioSpecPath(String id) => '$labRoot/spec/scenarios.md';

  String adapterFile(String feature, String backend) =>
      '$labRoot/lib/features/$feature/data/sources/task_source_$backend.dart';

  String restScaffoldNote(String feature) =>
      'Scaffold REST for $feature: api/, dto/, mappers/, task_source_rest.dart';

  Future<int> scaffoldFeature(String name) async {
    final base = Directory(featurePath(name));
    final folders = [
      'domain',
      'data/sources',
      'data/dto',
      'data/mappers',
      'data/api',
      'state',
      'controllers',
      'pages',
      'widgets',
    ];
    for (final folder in folders) {
      await Directory('${base.path}/$folder').create(recursive: true);
    }
    return 0;
  }

  Future<int> scaffoldAdapter(String feature, String backend) async {
    final file = File(adapterFile(feature, backend));
    if (file.existsSync()) {
      return 0;
    }
    await file.parent.create(recursive: true);
    await file.writeAsString('''
import '../../domain/task_draft.dart';
import '../../domain/task_model.dart';
import '../../domain/task_query.dart';
import '../task_repository.dart';

/// Stub adapter — implement when scenario enabled.
class ${_adapterClass(backend)} implements TaskSource {
  @override
  Future<List<TaskModel>> list(TaskQuery query) =>
      throw UnimplementedError('Enable $backend adapter');

  @override
  Future<TaskModel> create(TaskDraft draft) =>
      throw UnimplementedError('Enable $backend adapter');

  @override
  Future<TaskModel> update(TaskModel task) =>
      throw UnimplementedError('Enable $backend adapter');

  @override
  Future<void> delete(String id) =>
      throw UnimplementedError('Enable $backend adapter');
}
''');
    return 0;
  }

  String _adapterClass(String backend) {
    return switch (backend) {
      'supabase' => 'SupabaseTaskSource',
      'firebase' => 'FirebaseTaskSource',
      'drift' => 'DriftTaskSource',
      'rest' => 'RestTaskSource',
      'loon' => 'LoonTaskSource',
      _ => '${backend[0].toUpperCase()}${backend.substring(1)}TaskSource',
    };
  }
}
