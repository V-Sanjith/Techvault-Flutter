import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/scaffold_with_navbar.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/devices/presentation/screens/add_edit_device_screen.dart';
import '../../features/devices/presentation/screens/device_detail_screen.dart';
import '../../features/devices/presentation/screens/device_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/warranty/presentation/screens/warranty_center_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// GoRouter configuration establishing all Phase 2 navigation paths.
abstract class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: <RouteBase>[
      // Stateful shell for main tab navigation bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // Branch 1: Devices
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/devices',
                name: 'devices',
                builder: (context, state) => const DeviceListScreen(),
              ),
            ],
          ),

          // Branch 2: Warranty
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/warranty',
                name: 'warranty',
                builder: (context, state) => const WarrantyCenterScreen(),
              ),
            ],
          ),

          // Branch 3: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Standalone modal / detail routes (outside bottom bar)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/devices/add',
        name: 'addDevice',
        builder: (context, state) => const AddEditDeviceScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/devices/:id',
        name: 'deviceDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DeviceDetailScreen(deviceId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/devices/:id/edit',
        name: 'editDevice',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AddEditDeviceScreen(deviceId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/analytics',
        name: 'analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
    ],
  );
}
