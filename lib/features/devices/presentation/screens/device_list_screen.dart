import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/models/device_category.dart';
import '../providers/device_providers.dart';
import '../widgets/device_card.dart';

/// Screen displaying user's device inventory with search and category filtering.
class DeviceListScreen extends ConsumerWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final devicesAsync = ref.watch(devicesNotifierProvider);
    final filteredDevices = ref.watch(filteredDevicesProvider);
    final selectedCategory = ref.watch(categoryFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final totalCount = devicesAsync.value?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Device',
            onPressed: () => context.push('/devices/add'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Category Bar
            Container(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Search devices by name, brand, model...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                ref.read(searchQueryProvider.notifier).state =
                                    '';
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: isDark
                          ? AppColors.backgroundDark
                          : AppColors.backgroundLight,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Horizontal Category Chips
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: const Text('All Categories'),
                            selected: selectedCategory == null,
                            onSelected: (_) {
                              ref.read(categoryFilterProvider.notifier).state =
                                  null;
                            },
                          ),
                        ),
                        ...DeviceCategory.values.map((cat) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              avatar: Icon(cat.icon, size: 16),
                              label: Text(cat.displayName),
                              selected: selectedCategory == cat,
                              onSelected: (_) {
                                ref
                                        .read(categoryFilterProvider.notifier)
                                        .state =
                                    cat;
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Content Area
            Expanded(
              child: totalCount == 0
                  ? _buildEmptyInventory(context, theme, isDark)
                  : filteredDevices.isEmpty
                  ? _buildNoSearchResults(context, theme)
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredDevices.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final device = filteredDevices[index];
                        return DeviceCard(
                          device: device,
                          onTap: () => context.push('/devices/${device.id}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/devices/add'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Device'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEmptyInventory(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
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
                Icons.devices_other_rounded,
                size: 48,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 20),
            Text('No devices yet', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Add your first device to start building your TechVault.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Add Device',
              icon: Icons.add_rounded,
              onPressed: () => context.push('/devices/add'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResults(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppColors.textMutedLight,
          ),
          const SizedBox(height: 16),
          Text('No matching devices found', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your search query or category filter.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
