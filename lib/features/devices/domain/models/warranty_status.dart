import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Warranty coverage state calculated dynamically from the warranty expiry date.
enum WarrantyStatus {
  active,
  expiringSoon,
  expired,
  noWarranty;

  String get displayName {
    switch (this) {
      case WarrantyStatus.active:
        return 'Active';
      case WarrantyStatus.expiringSoon:
        return 'Expiring Soon';
      case WarrantyStatus.expired:
        return 'Expired';
      case WarrantyStatus.noWarranty:
        return 'No Warranty';
    }
  }

  Color get color {
    switch (this) {
      case WarrantyStatus.active:
        return AppColors.statusActive;
      case WarrantyStatus.expiringSoon:
        return AppColors.statusExpiring;
      case WarrantyStatus.expired:
        return AppColors.statusExpired;
      case WarrantyStatus.noWarranty:
        return AppColors.textMutedLight;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case WarrantyStatus.active:
        return AppColors.statusActiveBg;
      case WarrantyStatus.expiringSoon:
        return AppColors.statusExpiringBg;
      case WarrantyStatus.expired:
        return AppColors.statusExpiredBg;
      case WarrantyStatus.noWarranty:
        return const Color(0xFFF1F5F9);
    }
  }

  IconData get icon {
    switch (this) {
      case WarrantyStatus.active:
        return Icons.verified_user_rounded;
      case WarrantyStatus.expiringSoon:
        return Icons.warning_amber_rounded;
      case WarrantyStatus.expired:
        return Icons.gpp_bad_rounded;
      case WarrantyStatus.noWarranty:
        return Icons.shield_outlined;
    }
  }

  /// Calculates the warranty status based on target date and reference date (defaulting to today).
  static WarrantyStatus calculate(
    DateTime? expiryDate, {
    DateTime? referenceDate,
  }) {
    if (expiryDate == null) {
      return WarrantyStatus.noWarranty;
    }

    final ref = referenceDate ?? DateTime.now();
    final today = DateTime(ref.year, ref.month, ref.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);

    if (expiry.isBefore(today)) {
      return WarrantyStatus.expired;
    }

    final daysRemaining = expiry.difference(today).inDays;
    if (daysRemaining <= 30) {
      return WarrantyStatus.expiringSoon;
    }

    return WarrantyStatus.active;
  }
}
