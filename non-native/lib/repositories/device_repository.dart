import 'package:mobdrag_testr/models/device.dart';

abstract class DeviceRepository {
  
  Stream<List<Device>> getAll();

  Stream<Device?> watchById(int id);
  
  Future<Device?> getById(int id);

  Future<Device> add(Device device);

  Future<Device> update(Device device);

  Future<void> delete(int id);

  Future<List<Device>> getPendingSyncDevices();
}