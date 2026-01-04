import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/device.dart';
import '../service/device_api_service.dart';
import 'device_repository.dart';
import 'drift_device_repository.dart';

class SyncDeviceRepository implements DeviceRepository {
  final DriftDeviceRepository _localRepo;
  final DeviceApiService _apiService;
  final Set<int> _tempIgnoreIds = {};

  SyncDeviceRepository(this._localRepo, this._apiService) {
    _initSync();
  }

  void _initSync() {

    Connectivity().onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        print('[SYNC] Online detected. Syncing pending items...');
        _syncUpstream();
      }
    });

    _apiService.socketStream.listen((event) async {
      try {
        switch (event['type']) {
          case 'connection_restored':
            print('[SYNC] Server connection restored. Resyncing everything...');
            await _syncUpstream();
            await _fetchFromServer();
            break;
          case 'add':
            final sDev = Device.fromJson(event['data']);
            if (sDev.serverId != null && _tempIgnoreIds.contains(sDev.serverId)) return;
            final existing = await _localRepo.getByServerId(sDev.serverId!);
            if (existing == null) await _localRepo.add(sDev);
            break;
          case 'update':
            final sDev = Device.fromJson(event['data']);
            final existing = await _localRepo.getByServerId(sDev.serverId!);
            if (existing != null) {
              await _localRepo.update(sDev.copyWith(localId: existing.localId));
            }
            break;
          case 'delete':
            final sId = event['id'] as int;
            final existing = await _localRepo.getByServerId(sId);
            if (existing != null) await _localRepo.delete(existing.localId);
            break;
        }
      } catch (e) {
        print('[SYNC] WebSocket sync error: $e');
      }
    });


    _fetchFromServer();
  }

  Future<void> _syncUpstream() async {
    final pendingDevices = await _localRepo.getPendingSyncDevices();
    if (pendingDevices.isEmpty) return;

    print('[SYNC] Found ${pendingDevices.length} pending items to sync.');

    for (final dev in pendingDevices) {
      try {

        if (dev.toDelete) {
          if (dev.serverId != null) {
            await _apiService.deleteDevice(dev.serverId!);
          }
          await _localRepo.delete(dev.localId);
        }
        else {
          if (dev.serverId == null) {
            final serverDev = await _apiService.createDevice(dev);
            if (serverDev.serverId != null) _addToIgnore(serverDev.serverId!);

            await _localRepo.update(serverDev.copyWith(
              localId: dev.localId,
              pendingSync: false,
            ));
          } else {

            try {
              final serverDev = await _apiService.updateDevice(dev);
              await _localRepo.update(serverDev.copyWith(
                  localId: dev.localId,
                  pendingSync: false
              ));
            } on SyncConflictException catch (e) {

              await _localRepo.update(e.serverDevice.copyWith(
                  localId: dev.localId,
                  pendingSync: false,
                  toDelete: false
              ));
            }
          }
        }
      } catch (e) {
        print('[SYNC] Failed to sync device ${dev.model}: $e');
      }
    }
  }

  Future<void> _fetchFromServer() async {
    try {
      final serverDevices = await _apiService.fetchDevices();
      for (final sDev in serverDevices) {
        final existing = await _localRepo.getByServerId(sDev.serverId!);
        if (existing != null) {
          await _localRepo.update(sDev.copyWith(localId: existing.localId));
        } else {
          await _localRepo.add(sDev);
        }
      }
    } catch (e) {
      print('[SYNC] Offline mode active');
    }
  }

  void _addToIgnore(int id) {
    _tempIgnoreIds.add(id);
    Future.delayed(const Duration(seconds: 5), () => _tempIgnoreIds.remove(id));
  }

  @override
  Stream<List<Device>> getAll() => _localRepo.getAll();

  @override
  Stream<Device?> watchById(int id) => _localRepo.watchById(id);

  @override
  Future<Device?> getById(int id) => _localRepo.getById(id);

  @override
  Future<List<Device>> getPendingSyncDevices() => _localRepo.getPendingSyncDevices();

  @override
  Future<Device> add(Device device) async {
    try {
      final serverDevice = await _apiService.createDevice(device);

      if (serverDevice.serverId != null) _addToIgnore(serverDevice.serverId!);

      return await _localRepo.add(serverDevice);
    } catch (e) {

      if (e is ServerException) {
        print('[SYNC] Server rejected add: ${e.message}');
        rethrow;
      }

      if (e.toString().contains("Validation")) rethrow;

      print('[SYNC] Offline Add: $e');
      return await _localRepo.add(device.copyWith(pendingSync: true));
    }
  }

  @override
  Future<Device> update(Device device) async {
    try {
      if (device.serverId != null) {
        try {
          final serverDevice = await _apiService.updateDevice(device);
          return await _localRepo.update(serverDevice.copyWith(localId: device.localId));
        } on SyncConflictException catch (e) {

          print('[SYNC] Conflict on update. Overwriting with server data.');
          await _localRepo.update(e.serverDevice.copyWith(localId: device.localId));
          return e.serverDevice;
        }
      }
      throw Exception("Device not synced yet");
    } catch (e) {

      if (e is ServerException) {
        print('[SYNC] Server rejected update: ${e.message}');
        rethrow;
      }

      if (e.toString().contains("Validation")) rethrow;

      print('[SYNC] Offline Update: $e');
      return await _localRepo.update(device.copyWith(pendingSync: true));
    }
  }

  @override
  Future<void> delete(int id) async {
    final device = await _localRepo.getById(id);
    if (device == null) return;

    if (device.serverId == null) {
      await _localRepo.delete(id);
      return;
    }

    try {
      await _apiService.deleteDevice(device.serverId!);

      await _localRepo.delete(id);
    } catch (e) {

      if (e is ServerException) {
        print('[SYNC] Server rejected delete: ${e.message}');
        rethrow;
      }

      print('[SYNC] Offline Delete: $e');
      await _localRepo.update(device.copyWith(
          toDelete: true,
          pendingSync: true
      ));
    }
  }
}