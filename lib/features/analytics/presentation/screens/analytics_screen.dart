import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

/// Placeholder screen explaining future analytics capabilities.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Asset Analytics')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
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
                            color: AppColors.accent.withValues(
                              alpha: isDark ? 0.2 : 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.pie_chart_outline_rounded,
                            size: 36,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Analytics & Reports Coming Soon',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'TechVault is actively collecting real device and warranty data locally on your device.',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Planned Analytics Features:',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          context,
                          icon: Icons.category_outlined,
                          title: 'Category Breakdown',
                          description:
                              'Visualize investment distribution across smartphones, laptops, audio gear, and peripherals.',
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          context,
                          icon: Icons.show_chart_rounded,
                          title: 'Purchase Timeline',
                          description:
                              'Track asset accumulation over years and forecast upgrade cycles.',
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          context,
                          icon: Icons.build_circle_outlined,
                          title: 'Maintenance Cost Tracking',
                          description:
                              'Monitor repair bills and service history against total current asset value.',
                        ),
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

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.accent),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(description, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
