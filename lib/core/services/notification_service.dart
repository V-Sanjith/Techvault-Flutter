import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../features/devices/domain/models/device.dart';

/// Simple local notification service for warranty expiry reminders.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initializes local notification settings.
  Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notificationsPlugin.initialize(initSettings);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Notification init exception: $e');
    }
  }

  /// Displays an immediate notification when a device warranty is expiring soon.
  Future<void> scheduleWarrantyReminder(Device device) async {
    if (!_isInitialized) await init();

    if (device.warrantyExpiryDate == null) return;

    final daysRemaining = device.remainingWarrantyDays;
    if (daysRemaining != null && daysRemaining <= 30 && daysRemaining >= 0) {
      const androidDetails = AndroidNotificationDetails(
        'techvault_warranty_channel',
        'Warranty Reminders',
        channelDescription:
            'Notifications for devices with expiring warranties.',
        importance: Importance.high,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      try {
        await _notificationsPlugin.show(
          device.id.hashCode,
          'Warranty Expiring Soon: ${device.name}',
          '${device.name} warranty expires in $daysRemaining day(s). Check your TechVault for receipt details.',
          notificationDetails,
        );
      } catch (e) {
        debugPrint('Failed to show notification: $e');
      }
    }
  }
}
