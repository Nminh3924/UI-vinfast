import 'package:flutter/material.dart';

/// Quản lý trạng thái chuyển đổi Light/Dark mode trong toàn bộ ứng dụng
class ThemeController {
  ThemeController._();

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static bool get isDark => themeMode.value == ThemeMode.dark;

  static void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
  }
}
