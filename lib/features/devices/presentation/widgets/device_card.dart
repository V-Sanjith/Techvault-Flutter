import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/models/device.dart';

/// Reusable device list item card.
class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;

  const DeviceCard({super.key, required this.device, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget imageWidget;
    if (device.imagePath != null &&
        device.imagePath!.isNotEmpty &&
        File(device.imagePath!).existsSync()) {
      imageWidget = Image.file(
        File(device.imagePath!),
        width: 64,
        height: 64,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: isDark ? 0.2 : 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(device.category.icon, size: 32, color: AppColors.accent),
      );
    }

    final String brandModelText = [
      if (device.brand != null && device.brand!.isNotEmpty) device.brand,
      if (device.model != null && device.model!.isNotEmpty) device.model,
    ].join(' ');

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageWidget,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        device.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(status: device.warrantyStatus),
                  ],
                ),
                const SizedBox(height: 4),
                if (brandModelText.isNotEmpty) ...[
                  Text(
                    brandModelText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.sell_outlined,
                          size: 13,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Formatters.currency(device.purchasePrice),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (device.warrantyExpiryDate != null)
                      Text(
                        'Exp: ${Formatters.date(device.warrantyExpiryDate)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
