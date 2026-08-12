import 'package:flutter_test/flutter_test.dart';
import 'package:techvault/features/devices/domain/models/device.dart';
import 'package:techvault/features/devices/domain/models/device_category.dart';
import '../helpers/in_memory_device_repository.dart';

void main() {
  group('InMemoryDeviceRepository Unit Tests', () {
    late InMemoryDeviceRepository repository;

    setUp(() {
      repository = InMemoryDeviceRepository();
    });

    test('addDevice and getDevices returns sorted list', () async {
      final dev1 = Device(
        id: '1',
        name: 'MacBook Pro',
        category: DeviceCategory.laptop,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );
      final dev2 = Device(
        id: '2',
        name: 'iPhone 15',
        category: DeviceCategory.smartphone,
        createdAt: DateTime(2026, 2, 1),
        updatedAt: DateTime(2026, 2, 1),
      );

      await repository.addDevice(dev1);
      await repository.addDevice(dev2);

      final list = await repository.getDevices();
      expect(list.length, 2);
      expect(list.first.id, '2'); // Newest first
    });

    test('getDeviceById returns correct device', () async {
      final dev1 = Device(
        id: '100',
        name: 'Sony Headphones',
        category: DeviceCategory.headphones,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.addDevice(dev1);
      final match = await repository.getDeviceById('100');
      expect(match, isNotNull);
      expect(match!.name, 'Sony Headphones');
    });

    test('deleteDevice removes device', () async {
      final dev1 = Device(
        id: '200',
        name: 'Keychron K2',
        category: DeviceCategory.keyboard,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.addDevice(dev1);
      await repository.deleteDevice('200');
      final list = await repository.getDevices();
      expect(list.isEmpty, isTrue);
    });
  });
}
