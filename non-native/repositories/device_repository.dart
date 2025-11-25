import 'package:mobdrag_testr/models/device.dart';

abstract class DeviceRepository {
  List<Device> getAll();
  Device add(Device device);
  Device update(Device device);
  void delete(int id);
}