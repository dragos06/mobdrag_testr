import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/device.dart';
import 'device_repository.dart';

class DriftDeviceRepository implements DeviceRepository {
  final AppDatabase _db;

  DriftDeviceRepository(this._db);

  @override
  Stream<List<Device>> getAll() {
    return _db.watchAllDevices().map((rows) {
      return rows.map((row) => _mapToDomain(row)).toList();
    });
  }

  @override
  Future<List<Device>> getPendingSyncDevices() async {
    final rows = await (_db.select(_db.deviceTables)
      ..where((t) => t.pendingSync.equals(true)))
        .get();
    return rows.map((row) => _mapToDomain(row)).toList();
  }

  @override
  Stream<Device?> watchById(int id) {
    return _db.watchDeviceById(id).map((row) {
      if (row == null) return null;
      return _mapToDomain(row);
    });
  }

  @override
  Future<Device?> getById(int id) async {
    final row = await _db.getDeviceById(id);
    if (row == null) return null;
    return _mapToDomain(row);
  }

  @override
  Future<Device> add(Device device) async {

    return _db.transaction(() async {

      if (device.serverId != null) {
        final existing = await getByServerId(device.serverId!);
        if (existing != null) {

          return existing;
        }
      }

      final companion = DeviceTablesCompanion(
        serverId: Value(device.serverId),
        model: Value(device.model),
        os: Value(device.os),
        screenResolution: Value(device.screenResolution),
        status: Value(device.status.index),
        usedBy: Value(device.usedBy),
        notes: Value(device.notes),
        pendingSync: Value(device.pendingSync),
        toDelete: Value(device.toDelete),
        lastModified: Value(DateTime.now()),
      );

      final id = await _db.insertDevice(companion);
      return device.copyWith(localId: id);
    });
  }

  @override
  Future<Device> update(Device device) async {
    final companion = DeviceTablesCompanion(
      id: Value(device.localId),
      serverId: Value(device.serverId),
      model: Value(device.model),
      os: Value(device.os),
      screenResolution: Value(device.screenResolution),
      status: Value(device.status.index),
      usedBy: Value(device.usedBy),
      notes: Value(device.notes),
      pendingSync: Value(device.pendingSync),
      toDelete: Value(device.toDelete),
      lastModified: Value(DateTime.now()),
    );

    await _db.updateDevice(companion);
    return device;
  }

  @override
  Future<void> delete(int id) async {
    await _db.deleteDevice(id);
  }

  Future<Device?> getByServerId(int serverId) async {
    final query = _db.select(_db.deviceTables)
      ..where((t) => t.serverId.equals(serverId))
      ..limit(1);

    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return _mapToDomain(row);
  }

  Device _mapToDomain(DeviceTable row) {
    return Device(
      localId: row.id,
      serverId: row.serverId,
      model: row.model,
      os: row.os,
      screenResolution: row.screenResolution,
      status: DeviceStatus.values[row.status],
      usedBy: row.usedBy,
      notes: row.notes,
      lastModified: row.lastModified,
      pendingSync: row.pendingSync,
      toDelete: row.toDelete,
    );
  }
}