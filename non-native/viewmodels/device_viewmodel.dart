import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../repositories/device_repository.dart';
import '../models/device.dart';

class DeviceViewModel extends ChangeNotifier {
  final DeviceRepository repository;

  List<Device> _devices = [];
  List<Device> get devices => _devices;

  DeviceViewModel({required this.repository}) {
    _devices = repository.getAll();
  }

  void addDevice(Device device) {
    final newDevice = repository.add(device);
    _devices = [..._devices, newDevice];
    notifyListeners();
  }

  void updateDevice(Device device) {
    repository.update(device);
    _devices = _devices.map((d) => d.localId == device.localId ? device : d).toList();
    notifyListeners();
  }

  void deleteDevice(int id) {
    repository.delete(id);
    _devices = _devices.where((d) => d.localId != id).toList();
    notifyListeners();
  }

  Device? getById(int id) => _devices.firstWhereOrNull((d) => d.localId == id);
}