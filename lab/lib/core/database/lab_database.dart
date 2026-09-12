import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'lab_database.g.dart';

@DriftDatabase(tables: [TaskRows, SyncOutbox, CacheMeta])
class LabDatabase extends _$LabDatabase {
  LabDatabase(super.executor);

  LabDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
      );

  /// Sign-out / account switch — wipe user tables (flutter_app_kit contract).
  Future<void> deleteUserData() async {
    await batch((b) {
      b.deleteWhere(taskRows, (_) => const Constant(true));
      b.deleteWhere(syncOutbox, (_) => const Constant(true));
      b.deleteWhere(cacheMeta, (_) => const Constant(true));
    });
  }

  Future<DateTime?> lastRemoteSync() async {
    final row = await (select(cacheMeta)
          ..where((t) => t.key.equals('tasks_last_sync')))
        .getSingleOrNull();
    return row?.valueAt;
  }

  Future<void> setLastRemoteSync(DateTime at) {
    return into(cacheMeta).insertOnConflictUpdate(
      CacheMetaCompanion.insert(key: 'tasks_last_sync', valueAt: at),
    );
  }
}

QueryExecutor openLabConnection({String? fileName}) {
  return LazyDatabase(() async {
    if (fileName == ':memory:') {
      return NativeDatabase.memory();
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, fileName ?? 'lab.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
