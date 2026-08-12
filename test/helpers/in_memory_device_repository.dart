import 'package:techvault/features/devices/domain/models/device.dart';
import 'package:techvault/features/devices/domain/repositories/device_repository.dart';

/// In-memory mock implementation of DeviceRepository for fast unit & widget testing.
class InMemoryDeviceRepository implements DeviceRepository {
  final Map<String, Device> _devices = {};

  @override
  Future<List<Device>> getDevices() async {
    final list = _devices.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<Device?> getDeviceById(String id) async {
    return _devices[id];
  }

  @override
  Future<void> addDevice(Device device) async {
    _devices[device.id] = device;
  }

  @override
  Future<void> updateDevice(Device device) async {
    _devices[device.id] = device;
  }

  @override
  Future<void> deleteDevice(String id) async {
    _devices.remove(id);
  }
}
