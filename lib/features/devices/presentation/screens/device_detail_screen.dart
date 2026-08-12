import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../providers/device_providers.dart';

/// Screen displaying complete details for a single physical technology device.
class DeviceDetailScreen extends ConsumerWidget {
  final String deviceId;

  const DeviceDetailScreen({super.key, required this.deviceId});

  void _confirmDelete(BuildContext context, WidgetRef ref, String deviceName) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Delete Device?'),
          content: Text(
            'Are you sure you want to delete "$deviceName" from your TechVault? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.statusExpired,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.of(ctx).pop();
                await ref
                    .read(devicesNotifierProvider.notifier)
                    .deleteDevice(deviceId);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted "$deviceName"')),
                  );
                  context.go('/devices');
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final devicesAsync = ref.watch(devicesNotifierProvider);
    final list = devicesAsync.value ?? [];
    final deviceIndex = list.indexWhere((d) => d.id == deviceId);

    if (deviceIndex == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Device Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.statusExpired,
              ),
              const SizedBox(height: 16),
              Text('Device not found', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go('/devices'),
                child: const Text('Back to Devices'),
              ),
            ],
          ),
        ),
      );
    }

    final device = list[deviceIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Device',
            onPressed: () => context.push('/devices/${device.id}/edit'),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.statusExpired,
            ),
            tooltip: 'Delete Device',
            onPressed: () => _confirmDelete(context, ref, device.name),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero Header Image / Icon
                  AppCard(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        if (device.imagePath != null &&
                            device.imagePath!.isNotEmpty &&
                            File(device.imagePath!).existsSync())
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(device.imagePath!),
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(
                                alpha: isDark ? 0.2 : 0.08,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                device.category.icon,
                                size: 64,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    device.name,
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${device.brand ?? ''} ${device.model ?? ''}'
                                        .trim(),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(status: device.warrantyStatus),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Specs & Purchase Information
                  Text(
                    'Purchase Information',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  AppCard(
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          icon: Icons.calendar_today_rounded,
                          label: 'Purchase Date',
                          value: Formatters.date(device.purchaseDate),
                        ),
                        const Divider(height: 20),
                        _buildDetailRow(
                          context,
                          icon: Icons.sell_outlined,
                          label: 'Purchase Price',
                          value: Formatters.currency(device.purchasePrice),
                        ),
                        const Divider(height: 20),
                        _buildDetailRow(
                          context,
                          icon: Icons.category_rounded,
                          label: 'Category',
                          value: device.category.displayName,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Warranty Details
                  Text('Warranty Coverage', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  AppCard(
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          icon: Icons.verified_user_rounded,
                          label: 'Warranty Status',
                          value: device.warrantyStatus.displayName,
                          valueColor: device.warrantyStatus.color,
                        ),
                        const Divider(height: 20),
                        _buildDetailRow(
                          context,
                          icon: Icons.event_rounded,
                          label: 'Expiry Date',
                          value: Formatters.date(device.warrantyExpiryDate),
                        ),
                        if (device.remainingWarrantyDays != null) ...[
                          const Divider(height: 20),
                          _buildDetailRow(
                            context,
                            icon: Icons.timer_outlined,
                            label: 'Days Remaining',
                            value: device.remainingWarrantyDays! >= 0
                                ? '${device.remainingWarrantyDays} days'
                                : 'Expired ${device.remainingWarrantyDays!.abs()} days ago',
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Serial Number & Notes
                  Text(
                    'Device Identification & Notes',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          context,
                          icon: Icons.qr_code_rounded,
                          label: 'Serial Number',
                          value:
                              (device.serialNumber != null &&
                                  device.serialNumber!.isNotEmpty)
                              ? device.serialNumber!
                              : 'Not recorded',
                        ),
                        if (device.notes != null &&
                            device.notes!.isNotEmpty) ...[
                          const Divider(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.note_outlined,
                                size: 20,
                                color: AppColors.textMutedLight,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Notes',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      device.notes!,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textMutedLight),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
