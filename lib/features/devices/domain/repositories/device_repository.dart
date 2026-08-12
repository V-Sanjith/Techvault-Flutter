import '../models/device.dart';

/// Abstract contract for Device data persistence.
abstract class DeviceRepository {
  Future<List<Device>> getDevices();
  Future<Device?> getDeviceById(String id);
  Future<void> addDevice(Device device);
  Future<void> updateDevice(Device device);
  Future<void> deleteDevice(String id);
}
