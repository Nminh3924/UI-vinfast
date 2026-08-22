import 'package:flutter/material.dart';

/// HandsFree Messenger color palette.
/// Phong cách tối giản đen tuyền — Pure Black OLED, accents xanh dương tinh tế.
class AppColors {
  AppColors._();

  // ─── Brand ───
  static const Color primary = Color(0xFF0A84FF);
  static const Color primaryDark = Color(0xFF0066CC);
  static const Color primaryLight = Color(0xFF3399FF);
  static const Color cyanAccent = Color(0xFF00E5FF);
  static const Color xenonWhite = Color(0xFFF5FAFF);

  // ─── Dark Mode (Đen tuyền — Pure Black OLED) ───
  static const Color darkBg = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF111111);
  static const Color darkSurfaceVariant = Color(0xFF1A1A1A);
  static const Color darkBorder = Color(0xFF2A2A2A);
  static const Color darkOnSurface = Color(0xFFF1F5F9);
  static const Color darkOnSurfaceVariant = Color(0xFF8E8E93);

  // ─── Light Mode ───
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightOnSurface = Color(0xFF0F172A);
  static const Color lightOnSurfaceVariant = Color(0xFF64748B);

  // ─── Semantic ───
  static const Color error = Color(0xFFFF453A);
  static const Color success = Color(0xFF30D158);
  static const Color warning = Color(0xFFFFD60A);
  static const Color info = Color(0xFF64D2FF);

  // ─── LLM Categories & Priority Colors ───
  static const Color urgentRed = Color(0xFFFF3B30);
  static const Color importantAmber = Color(0xFFFF9F0A);
  static const Color familyPurple = Color(0xFFBF5AF2);
  static const Color workCyan = Color(0xFF00E5FF);
  static const Color friendsGreen = Color(0xFF30D158);
  static const Color financeGold = Color(0xFFFFD60A);

  // ─── Driver Mode ───
  static const Color driverModeGlow = Color(0xFF00E5FF);

  // ─── Gradients ───
  static const LinearGradient ledDrlGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF0066CC), Color(0xFF00E5FF), Colors.white],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A84FF), Color(0xFF0066CC)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF000000), Color(0xFF000000)],
  );

  static const LinearGradient driverModeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A84FF), Color(0xFF00E5FF)],
  );

  static const LinearGradient sosGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF453A), Color(0xFFD32F2F)],
  );
}
