import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../devices/presentation/providers/device_providers.dart';

/// Settings screen allowing appearance adjustments, viewing app information, and local data actions.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentThemeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Appearance Section
                  Text('Appearance', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.palette_outlined),
                          title: const Text('Theme Mode'),
                          subtitle: Text(_themeModeName(currentThemeMode)),
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.system,
                              label: Text('System'),
                              icon: Icon(Icons.brightness_auto_rounded),
                            ),
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text('Light'),
                              icon: Icon(Icons.light_mode_rounded),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text('Dark'),
                              icon: Icon(Icons.dark_mode_rounded),
                            ),
                          ],
                          selected: {currentThemeMode},
                          onSelectionChanged: (Set<ThemeMode> newSelection) {
                            ref
                                .read(themeModeProvider.notifier)
                                .setThemeMode(newSelection.first);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Data Management
                  Text('Data & Backup', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  AppCard(
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.storage_rounded),
                          title: const Text('Storage Mode'),
                          subtitle: const Text(
                            'Offline Local Persistence (Hive)',
                          ),
                          trailing: const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.statusActive,
                          ),
                        ),
                        const Divider(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.download_rounded),
                          title: const Text('Export Local Data'),
                          subtitle: const Text(
                            'Export device database as JSON file',
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'JSON Export feature will be introduced in the next phase.',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About Application
                  Text('About TechVault', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  AppCard(
                    child: Column(
                      children: [
                        const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.info_outline_rounded),
                          title: Text('Application Version'),
                          trailing: Text(
                            '1.0.0+1',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(height: 16),
                        const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.verified_outlined),
                          title: Text('Architecture'),
                          trailing: Text(
                            'Feature-First Riverpod',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
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

  String _themeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Follow System Settings';
      case ThemeMode.light:
        return 'Light Theme';
      case ThemeMode.dark:
        return 'Dark Theme';
    }
  }
}
