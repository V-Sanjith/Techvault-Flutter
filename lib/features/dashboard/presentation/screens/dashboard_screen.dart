import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/feature_preview_card.dart';
import '../../../../core/widgets/metric_tile.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../devices/presentation/providers/device_providers.dart';
import '../../../devices/presentation/widgets/device_card.dart';

/// Dashboard screen rendering real metrics, warranty distribution, recent items, or onboarding if empty.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final metrics = ref.watch(dashboardMetricsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.devices_rounded,
                color: AppColors.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'TechVault',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Analytics',
            onPressed: () => context.push('/analytics'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: metrics.totalDevices == 0
                  ? _buildOnboardingDashboard(context, theme, isDark)
                  : _buildPopulatedDashboard(
                      context,
                      ref,
                      theme,
                      isDark,
                      metrics,
                    ),
            ),
          ),
        ),
      ),
      floatingActionButton: metrics.totalDevices > 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/devices/add'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Device'),
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Widget _buildOnboardingDashboard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: isDark ? 0.2 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 32,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome to TechVault',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Keep your devices, warranties, documents and service history organized in one place.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Add Your First Device',
                icon: Icons.add_rounded,
                onPressed: () => context.push('/devices/add'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text('What TechVault Does', style: theme.textTheme.titleLarge),
        const SizedBox(height: 14),
        Responsive(
          mobile: const Column(
            children: [
              FeaturePreviewCard(
                icon: Icons.devices_other_rounded,
                title: 'Track Physical Devices & Specs',
                description:
                    'Log model numbers, serials, purchase dates, and estimated values.',
                iconColor: AppColors.accent,
              ),
              SizedBox(height: 12),
              FeaturePreviewCard(
                icon: Icons.verified_user_outlined,
                title: 'Never Miss a Warranty',
                description:
                    'Automatic status calculation keeps coverage deadline visible.',
                iconColor: AppColors.statusExpiring,
              ),
              SizedBox(height: 12),
              FeaturePreviewCard(
                icon: Icons.receipt_long_rounded,
                title: 'Store Invoices & Receipts',
                description:
                    'Keep proof of purchase and service history organized.',
                iconColor: AppColors.statusActive,
              ),
            ],
          ),
          desktop: const Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FeaturePreviewCard(
                      icon: Icons.devices_other_rounded,
                      title: 'Track Physical Devices',
                      description:
                          'Log model numbers, serials, purchase dates, and values.',
                      iconColor: AppColors.accent,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: FeaturePreviewCard(
                      icon: Icons.verified_user_outlined,
                      title: 'Never Miss a Warranty',
                      description:
                          'Automatic status calculation keeps coverage visible.',
                      iconColor: AppColors.statusExpiring,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              FeaturePreviewCard(
                icon: Icons.receipt_long_rounded,
                title: 'Store Invoices & Receipts',
                description:
                    'Keep proof of purchase and repair logs organized.',
                iconColor: AppColors.statusActive,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopulatedDashboard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    bool isDark,
    DashboardMetrics metrics,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Metric Overview Grid
        Responsive(
          mobile: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MetricTile(
                      label: 'Total Devices',
                      value: '${metrics.totalDevices}',
                      icon: Icons.devices_rounded,
                      iconColor: AppColors.accent,
                      onTap: () => context.go('/devices'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MetricTile(
                      label: 'Total Spent',
                      value: Formatters.currency(metrics.totalPurchaseValue),
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: AppColors.statusActive,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: MetricTile(
                      label: 'Active Warranties',
                      value: '${metrics.activeWarranties}',
                      icon: Icons.verified_user_rounded,
                      iconColor: AppColors.statusActive,
                      onTap: () => context.go('/warranty'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MetricTile(
                      label: 'Expiring Soon',
                      value: '${metrics.expiringSoonWarranties}',
                      icon: Icons.warning_amber_rounded,
                      iconColor: AppColors.statusExpiring,
                      onTap: () => context.go('/warranty'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          desktop: Row(
            children: [
              Expanded(
                child: MetricTile(
                  label: 'Total Devices',
                  value: '${metrics.totalDevices}',
                  icon: Icons.devices_rounded,
                  iconColor: AppColors.accent,
                  onTap: () => context.go('/devices'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricTile(
                  label: 'Total Spent',
                  value: Formatters.currency(metrics.totalPurchaseValue),
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: AppColors.statusActive,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricTile(
                  label: 'Active Warranties',
                  value: '${metrics.activeWarranties}',
                  icon: Icons.verified_user_rounded,
                  iconColor: AppColors.statusActive,
                  onTap: () => context.go('/warranty'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricTile(
                  label: 'Expiring Soon',
                  value: '${metrics.expiringSoonWarranties}',
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppColors.statusExpiring,
                  onTap: () => context.go('/warranty'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Recent Devices Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Devices', style: theme.textTheme.titleLarge),
            TextButton(
              onPressed: () => context.go('/devices'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.recentDevices.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final device = metrics.recentDevices[index];
            return DeviceCard(
              device: device,
              onTap: () => context.push('/devices/${device.id}'),
            );
          },
        ),
      ],
    );
  }
}
