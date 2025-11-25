import '../models/device.dart';
import './device_repository.dart';

class InMemoryDeviceRepository implements DeviceRepository {
  final List<Device> _devices = [];
  int _nextId = 1;

  InMemoryDeviceRepository() { seed(); }

  @override
  List<Device> getAll() => List.unmodifiable(_devices);

  @override
  Device add(Device device) {
    final newDevice = device.copyWith(localId: _nextId++);
    _devices.add(newDevice);
    return newDevice;
  }

  @override
  Device update(Device device) {
    final index = _devices.indexWhere((d) => d.localId == device.localId);
    if (index != -1) _devices[index] = device;
    return device;
  }

  @override
  void delete(int id) {
    _devices.removeWhere((d) => d.localId == id);
  }

  void seed() {
    add(
      Device(
        localId: 0,
        model: 'Pixel 7',
        os: 'Android 14',
        screenResolution: '2400x1080',
        status: DeviceStatus.available,
      ),
    );
    add(
      Device(
        localId: 0,
        model: 'iPhone 15',
        os: 'iOS 17',
        screenResolution: '2796x1290',
        status: DeviceStatus.inUse,
        usedBy: 'John Doe',
      ),
    );
    add(
      Device(
        localId: 0,
        model: 'Galaxy S23',
        os: 'Android 14',
        screenResolution: '2340x1080',
        status: DeviceStatus.retired,
      ),
    );
  }
}
