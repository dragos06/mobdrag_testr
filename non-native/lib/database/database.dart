import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class DeviceTables extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();
  BoolColumn get pendingSync => boolean().withDefault(const Constant(true))();
  BoolColumn get toDelete => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastModified => dateTime().withDefault(currentDateAndTime)();
  TextColumn get model => text().withLength(min: 1, max: 50)();
  TextColumn get os => text().withLength(min: 1, max: 30)();
  TextColumn get screenResolution => text().withLength(min: 1, max: 20)();
  IntColumn get status => integer()();
  TextColumn get usedBy => text().nullable().withLength(max: 50)();
  TextColumn get notes => text().nullable().withLength(max: 200)();
}

@DriftDatabase(tables: [DeviceTables])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Stream<List<DeviceTable>> watchAllDevices() {
    return (select(deviceTables)
      ..where((t) => t.toDelete.equals(false))
    ).watch();
  }

  Stream<DeviceTable?> watchDeviceById(int id) {
    return (select(deviceTables)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<DeviceTable?> getDeviceById(int id) {
    return (select(deviceTables)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertDevice(DeviceTablesCompanion entry) {
    return into(deviceTables).insert(entry);
  }

  Future<bool> updateDevice(DeviceTablesCompanion entry) {
    return update(deviceTables).replace(entry);
  }

  Future<int> deleteDevice(int id) {
    return (delete(deviceTables)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'devices.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}