import 'package:flutter/material.dart';

/// HandsFree Messenger color palette.
/// Xanh dương chủ đạo, Dark mode Đen tuyền (Pure Black), tối giản hiện đại.
class AppColors {
  AppColors._();

  // ─── Brand ───
  static const Color primary = Color(0xFF0A84FF);
  static const Color primaryDark = Color(0xFF0066CC);
  static const Color primaryLight = Color(0xFF3399FF);

  // ─── Dark Mode (Đen tuyền - Pure Black) ───
  static const Color darkBg = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkSurfaceVariant = Color(0xFF1E1E1E);
  static const Color darkBorder = Color(0xFF2C2C2C);
  static const Color darkOnSurface = Color(0xFFF0F0F0);
  static const Color darkOnSurfaceVariant = Color(0xFF9E9E9E);

  // ─── Light Mode ───
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF7F8FA);
  static const Color lightSurfaceVariant = Color(0xFFEEEEEE);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightOnSurface = Color(0xFF1A1A1A);
  static const Color lightOnSurfaceVariant = Color(0xFF666666);

  // ─── Semantic ───
  static const Color error = Color(0xFFFF453A);
  static const Color success = Color(0xFF30D158);
  static const Color warning = Color(0xFFFFD60A);
  static const Color info = Color(0xFF64D2FF);

  // ─── Driver Mode ───
  static const Color driverModeGlow = Color(0xFF0A84FF);

  // ─── Solid / Minimal Gradients ───
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
    colors: [Color(0xFF0A84FF), Color(0xFF0066CC)],
  );

  static const LinearGradient sosGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF453A), Color(0xFFD32F2F)],
  );
}
