import 'package:flutter/material.dart';

/// Central color definitions for TechVault.
/// Designed for a premium consumer productivity interface with high contrast,
/// clear visual hierarchy, and no excessive gradients.
abstract class AppColors {
  // Brand / Core Colors
  static const Color primary = Color(0xFF0F172A); // Slate 900
  static const Color primaryLight = Color(0xFF1E293B); // Slate 800
  static const Color accent = Color(0xFF2563EB); // Tech Blue 600
  static const Color accentHover = Color(0xFF1D4ED8); // Tech Blue 700

  // Light Palette
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceLight = Color(0xFFFFFFFF); // White
  static const Color cardBorderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate 900
  static const Color textSecondaryLight = Color(0xFF64748B); // Slate 500
  static const Color textMutedLight = Color(0xFF94A3B8); // Slate 400

  // Dark Palette
  static const Color backgroundDark = Color(0xFF0B0F17); // Slate 950 Deep
  static const Color surfaceDark = Color(0xFF1E293B); // Slate 800
  static const Color cardBorderDark = Color(0xFF334155); // Slate 700
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Slate 50
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate 400
  static const Color textMutedDark = Color(0xFF64748B); // Slate 500

  // Status & Utility Colors
  static const Color statusActive = Color(0xFF10B981); // Emerald 500
  static const Color statusActiveBg = Color(0xFFECFDF5); // Emerald 50
  static const Color statusExpiring = Color(0xFFF59E0B); // Amber 500
  static const Color statusExpiringBg = Color(0xFFFFFBEB); // Amber 50
  static const Color statusExpired = Color(0xFFEF4444); // Rose 500
  static const Color statusExpiredBg = Color(0xFFFEF2F2); // Rose 50
}
