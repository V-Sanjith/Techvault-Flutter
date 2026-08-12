import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/metric_tile.dart';
import '../../../devices/domain/models/warranty_status.dart';
import '../../../devices/presentation/providers/device_providers.dart';
import '../../../devices/presentation/widgets/device_card.dart';

/// Screen categorizing stored devices by their active warranty expiration status.
class WarrantyCenterScreen extends ConsumerWidget {
  const WarrantyCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final metrics = ref.watch(dashboardMetricsProvider);
    final grouping = ref.watch(warrantyGroupingProvider);

    final activeList = grouping[WarrantyStatus.active] ?? [];
    final expiringSoonList = grouping[WarrantyStatus.expiringSoon] ?? [];
    final expiredList = grouping[WarrantyStatus.expired] ?? [];
    final noWarrantyList = grouping[WarrantyStatus.noWarranty] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Warranty Center')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: metrics.totalDevices == 0
                  ? _buildEmptyState(context, theme, isDark)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Overview Metric Summary Bar
                        Row(
                          children: [
                            Expanded(
                              child: MetricTile(
                                label: 'Active',
                                value: '${metrics.activeWarranties}',
                                icon: Icons.verified_user_rounded,
                                iconColor: AppColors.statusActive,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: MetricTile(
                                label: 'Expiring',
                                value: '${metrics.expiringSoonWarranties}',
                                icon: Icons.warning_amber_rounded,
                                iconColor: AppColors.statusExpiring,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: MetricTile(
                                label: 'Expired',
                                value: '${metrics.expiredWarranties}',
                                icon: Icons.gpp_bad_rounded,
                                iconColor: AppColors.statusExpired,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Section 1: Expiring Soon (High priority)
                        if (expiringSoonList.isNotEmpty) ...[
                          _buildSectionHeader(
                            context,
                            title: 'Expiring Soon (Within 30 Days)',
                            count: expiringSoonList.length,
                            status: WarrantyStatus.expiringSoon,
                          ),
                          const SizedBox(height: 10),
                          ...expiringSoonList.map(
                            (d) => Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: DeviceCard(
                                device: d,
                                onTap: () => context.push('/devices/${d.id}'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Section 2: Active
                        if (activeList.isNotEmpty) ...[
                          _buildSectionHeader(
                            context,
                            title: 'Active Coverage',
                            count: activeList.length,
                            status: WarrantyStatus.active,
                          ),
                          const SizedBox(height: 10),
                          ...activeList.map(
                            (d) => Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: DeviceCard(
                                device: d,
                                onTap: () => context.push('/devices/${d.id}'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Section 3: Expired
                        if (expiredList.isNotEmpty) ...[
                          _buildSectionHeader(
                            context,
                            title: 'Expired Warranties',
                            count: expiredList.length,
                            status: WarrantyStatus.expired,
                          ),
                          const SizedBox(height: 10),
                          ...expiredList.map(
                            (d) => Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: DeviceCard(
                                device: d,
                                onTap: () => context.push('/devices/${d.id}'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Section 4: No Warranty Listed
                        if (noWarrantyList.isNotEmpty) ...[
                          _buildSectionHeader(
                            context,
                            title: 'No Warranty Expiry Date',
                            count: noWarrantyList.length,
                            status: WarrantyStatus.noWarranty,
                          ),
                          const SizedBox(height: 10),
                          ...noWarrantyList.map(
                            (d) => Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: DeviceCard(
                                device: d,
                                onTap: () => context.push('/devices/${d.id}'),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required int count,
    required WarrantyStatus status,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(status.icon, size: 20, color: status.color),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: status.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: status.color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: isDark ? 0.2 : 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              size: 48,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 20),
          Text('No Warranty Records', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Add devices with warranty expiry dates to monitor active, expiring, and expired coverage.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/devices/add'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Device'),
          ),
        ],
      ),
    );
  }
}
