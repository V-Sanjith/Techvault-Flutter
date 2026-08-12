import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/repositories/local_device_repository.dart';
import '../../domain/models/device.dart';
import '../../domain/models/device_category.dart';
import '../../domain/models/warranty_status.dart';
import '../../domain/repositories/device_repository.dart';

/// Provider for the DeviceRepository implementation.
final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return LocalDeviceRepository();
});

/// StateNotifier to manage the state and actions for devices list.
class DeviceListNotifier extends StateNotifier<AsyncValue<List<Device>>> {
  final DeviceRepository _repository;

  DeviceListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadDevices();
  }

  Future<void> loadDevices() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getDevices();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addDevice(Device device) async {
    try {
      await _repository.addDevice(device);
      await NotificationService().scheduleWarrantyReminder(device);
      await loadDevices();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateDevice(Device device) async {
    try {
      await _repository.updateDevice(device);
      await NotificationService().scheduleWarrantyReminder(device);
      await loadDevices();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteDevice(String id) async {
    try {
      await _repository.deleteDevice(id);
      await loadDevices();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Main provider for the list of devices.
final devicesNotifierProvider =
    StateNotifierProvider<DeviceListNotifier, AsyncValue<List<Device>>>((ref) {
      final repository = ref.watch(deviceRepositoryProvider);
      return DeviceListNotifier(repository);
    });

/// Search query state provider.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Category filter state provider.
final categoryFilterProvider = StateProvider<DeviceCategory?>((ref) => null);

/// Filtered device list based on search query and category filter.
final filteredDevicesProvider = Provider<List<Device>>((ref) {
  final devicesAsync = ref.watch(devicesNotifierProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final category = ref.watch(categoryFilterProvider);

  return devicesAsync.maybeWhen(
    data: (list) {
      return list.where((device) {
        final matchesQuery =
            query.isEmpty ||
            device.name.toLowerCase().contains(query) ||
            (device.brand?.toLowerCase().contains(query) ?? false) ||
            (device.model?.toLowerCase().contains(query) ?? false) ||
            (device.serialNumber?.toLowerCase().contains(query) ?? false);

        final matchesCategory = category == null || device.category == category;

        return matchesQuery && matchesCategory;
      }).toList();
    },
    orElse: () => [],
  );
});

/// Container for computed Dashboard metrics.
class DashboardMetrics {
  final int totalDevices;
  final double totalPurchaseValue;
  final int activeWarranties;
  final int expiringSoonWarranties;
  final int expiredWarranties;
  final int noWarranties;
  final List<Device> recentDevices;

  DashboardMetrics({
    required this.totalDevices,
    required this.totalPurchaseValue,
    required this.activeWarranties,
    required this.expiringSoonWarranties,
    required this.expiredWarranties,
    required this.noWarranties,
    required this.recentDevices,
  });
}

/// Computed Dashboard metrics provider.
final dashboardMetricsProvider = Provider<DashboardMetrics>((ref) {
  final devicesAsync = ref.watch(devicesNotifierProvider);
  final list = devicesAsync.value ?? [];

  double totalVal = 0.0;
  int active = 0;
  int expiringSoon = 0;
  int expired = 0;
  int noWarr = 0;

  for (final dev in list) {
    if (dev.purchasePrice != null) {
      totalVal += dev.purchasePrice!;
    }

    switch (dev.warrantyStatus) {
      case WarrantyStatus.active:
        active++;
        break;
      case WarrantyStatus.expiringSoon:
        expiringSoon++;
        break;
      case WarrantyStatus.expired:
        expired++;
        break;
      case WarrantyStatus.noWarranty:
        noWarr++;
        break;
    }
  }

  return DashboardMetrics(
    totalDevices: list.length,
    totalPurchaseValue: totalVal,
    activeWarranties: active,
    expiringSoonWarranties: expiringSoon,
    expiredWarranties: expired,
    noWarranties: noWarr,
    recentDevices: list.take(4).toList(),
  );
});

/// Warranty grouping provider.
final warrantyGroupingProvider = Provider<Map<WarrantyStatus, List<Device>>>((
  ref,
) {
  final devicesAsync = ref.watch(devicesNotifierProvider);
  final list = devicesAsync.value ?? [];

  final Map<WarrantyStatus, List<Device>> groups = {
    WarrantyStatus.active: [],
    WarrantyStatus.expiringSoon: [],
    WarrantyStatus.expired: [],
    WarrantyStatus.noWarranty: [],
  };

  for (final dev in list) {
    groups[dev.warrantyStatus]!.add(dev);
  }

  return groups;
});

/// System / Light / Dark theme mode notifier.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});
