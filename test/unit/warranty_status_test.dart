import 'package:flutter_test/flutter_test.dart';
import 'package:techvault/features/devices/domain/models/warranty_status.dart';

void main() {
  group('WarrantyStatus Calculation Tests', () {
    final now = DateTime(2026, 8, 9);

    test('Returns noWarranty when expiry date is null', () {
      final status = WarrantyStatus.calculate(null, referenceDate: now);
      expect(status, WarrantyStatus.noWarranty);
    });

    test('Returns expired when expiry date is before reference date', () {
      final pastDate = DateTime(2026, 8, 1);
      final status = WarrantyStatus.calculate(pastDate, referenceDate: now);
      expect(status, WarrantyStatus.expired);
    });

    test('Returns expiringSoon when expiry date is within 30 days', () {
      final in20Days = DateTime(2026, 8, 29);
      final status = WarrantyStatus.calculate(in20Days, referenceDate: now);
      expect(status, WarrantyStatus.expiringSoon);

      final in30Days = DateTime(2026, 9, 8);
      final status30 = WarrantyStatus.calculate(in30Days, referenceDate: now);
      expect(status30, WarrantyStatus.expiringSoon);
    });

    test('Returns active when expiry date is more than 30 days away', () {
      final in60Days = DateTime(2026, 10, 8);
      final status = WarrantyStatus.calculate(in60Days, referenceDate: now);
      expect(status, WarrantyStatus.active);
    });
  });
}
