import 'package:drift/drift.dart';

/// Local cache row — includes sync metadata not exposed on wire [TaskModel].
class TaskRows extends Table {
  TextColumn get id => text()();

  TextColumn get title => text().withLength(min: 1, max: 512)();

  TextColumn get status => text().withLength(min: 1, max: 16)();

  /// synced | pending | failed
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Offline write queue — flushed when remote is reachable.
class SyncOutbox extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get operation => text().withLength(min: 1, max: 16)();

  TextColumn get entityId => text()();

  TextColumn get payloadJson => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class CacheMeta extends Table {
  TextColumn get key => text()();

  DateTimeColumn get valueAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
