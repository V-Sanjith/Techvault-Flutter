import 'package:flutter/material.dart';

/// Categories supported for personal technology devices.
enum DeviceCategory {
  laptop,
  smartphone,
  tablet,
  desktop,
  monitor,
  keyboard,
  mouse,
  headphones,
  camera,
  smartwatch,
  gaming,
  other;

  String get displayName {
    switch (this) {
      case DeviceCategory.laptop:
        return 'Laptop';
      case DeviceCategory.smartphone:
        return 'Smartphone';
      case DeviceCategory.tablet:
        return 'Tablet';
      case DeviceCategory.desktop:
        return 'Desktop';
      case DeviceCategory.monitor:
        return 'Monitor';
      case DeviceCategory.keyboard:
        return 'Keyboard';
      case DeviceCategory.mouse:
        return 'Mouse';
      case DeviceCategory.headphones:
        return 'Audio & Headphones';
      case DeviceCategory.camera:
        return 'Camera';
      case DeviceCategory.smartwatch:
        return 'Smartwatch & Wearable';
      case DeviceCategory.gaming:
        return 'Gaming Console';
      case DeviceCategory.other:
        return 'Other Tech';
    }
  }

  IconData get icon {
    switch (this) {
      case DeviceCategory.laptop:
        return Icons.laptop_mac_rounded;
      case DeviceCategory.smartphone:
        return Icons.phone_iphone_rounded;
      case DeviceCategory.tablet:
        return Icons.tablet_mac_rounded;
      case DeviceCategory.desktop:
        return Icons.desktop_windows_rounded;
      case DeviceCategory.monitor:
        return Icons.monitor_rounded;
      case DeviceCategory.keyboard:
        return Icons.keyboard_rounded;
      case DeviceCategory.mouse:
        return Icons.mouse_rounded;
      case DeviceCategory.headphones:
        return Icons.headphones_rounded;
      case DeviceCategory.camera:
        return Icons.photo_camera_rounded;
      case DeviceCategory.smartwatch:
        return Icons.watch_rounded;
      case DeviceCategory.gaming:
        return Icons.sports_esports_rounded;
      case DeviceCategory.other:
        return Icons.devices_other_rounded;
    }
  }

  static DeviceCategory fromName(String name) {
    return DeviceCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => DeviceCategory.other,
    );
  }
}
