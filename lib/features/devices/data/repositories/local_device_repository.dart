import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/device.dart';
import '../../domain/repositories/device_repository.dart';

/// Local Hive database implementation of DeviceRepository.
class LocalDeviceRepository implements DeviceRepository {
  static const String boxName = 'techvault_devices';
  Box? _box;

  Future<Box> _getBox() async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox(boxName);
    } else {
      _box = Hive.box(boxName);
    }
    return _box!;
  }

  @override
  Future<List<Device>> getDevices() async {
    final box = await _getBox();
    final List<Device> devices = [];
    for (var key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        try {
          final Map<String, dynamic> map = Map<String, dynamic>.from(
            data as Map,
          );
          devices.add(Device.fromJson(map));
        } catch (_) {
          // Silently ignore corrupted records
        }
      }
    }
    // Sort by createdAt descending (newest first)
    devices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return devices;
  }

  @override
  Future<Device?> getDeviceById(String id) async {
    final box = await _getBox();
    final data = box.get(id);
    if (data == null) return null;
    try {
      final Map<String, dynamic> map = Map<String, dynamic>.from(data as Map);
      return Device.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addDevice(Device device) async {
    final box = await _getBox();
    await box.put(device.id, device.toJson());
  }

  @override
  Future<void> updateDevice(Device device) async {
    final box = await _getBox();
    await box.put(device.id, device.toJson());
  }

  @override
  Future<void> deleteDevice(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
