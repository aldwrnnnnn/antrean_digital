import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary
  static const Color primary = Color(0xFF2563EB); // Royal Blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primarySoft = Color(0xFFEFF6FF); // Blue 50

  // Secondary Accent
  static const Color secondary = Color(0xFF0D9488); // Emerald Teal
  static const Color secondarySoft = Color(0xFFF0FDFA);

  // Background & Surfaces
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F5F9); // Slate 100
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color borderSubtle = Color(0xFFCBD5E1); // Slate 300

  // Text Colors (High Contrast WCAG AA Compliant)
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF64748B); // Slate 500
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Indicators
  static const Color statusActive = Color(0xFF059669); // Emerald 600
  static const Color statusActiveBg = Color(0xFFD1FAE5); // Emerald 100
  static const Color statusActiveBorder = Color(0xFFA7F3D0);

  static const Color statusWaiting = Color(0xFFD97706); // Amber 600
  static const Color statusWaitingBg = Color(0xFFFEF3C7); // Amber 100
  static const Color statusWaitingBorder = Color(0xFFFDE68A);

  static const Color statusDone = Color(0xFF475569); // Slate 600
  static const Color statusDoneBg = Color(0xFFF1F5F9); // Slate 100
  static const Color statusDoneBorder = Color(0xFFE2E8F0);

  static const Color statusSkipped = Color(0xFFE11D48); // Rose 600
  static const Color statusSkippedBg = Color(0xFFFFE4E6); // Rose 100
  static const Color statusSkippedBorder = Color(0xFFFECDD3);

  // Soft shadows
  static List<BoxShadow> get cardShadow => const [
        BoxShadow(
          color: Color(0x080F172A),
          blurRadius: 16,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Color(0x050F172A),
          blurRadius: 6,
          offset: Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get heroCardShadow => const [
        BoxShadow(
          color: Color(0x181D4ED8),
          blurRadius: 24,
          offset: Offset(0, 8),
          spreadRadius: 0,
        ),
      ];
}
