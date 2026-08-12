import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techvault/features/devices/presentation/providers/device_providers.dart';
import 'package:techvault/main.dart';
import 'helpers/in_memory_device_repository.dart';

void main() {
  testWidgets('TechVaultApp launches dashboard with navigation bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceRepositoryProvider.overrideWithValue(
            InMemoryDeviceRepository(),
          ),
        ],
        child: const TechVaultApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify main components render
    expect(find.text('TechVault'), findsOneWidget);
    expect(find.text('Welcome to TechVault'), findsOneWidget);
    expect(find.text('Add Your First Device'), findsOneWidget);
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Devices'), findsWidgets);
    expect(find.text('Warranty'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
  });
}
