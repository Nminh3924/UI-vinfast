import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Quản lý trạng thái và lưu phiên đăng nhập của người dùng
class AuthService {
  AuthService._();

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserEmail = 'user_email';

  static final ValueNotifier<bool> isLoggedInNotifier = ValueNotifier<bool>(false);

  /// Khởi tạo và đọc phiên đăng nhập từ SharedPreferences
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    isLoggedInNotifier.value = loggedIn;
  }

  static bool get isLoggedIn => isLoggedInNotifier.value;

  /// Đăng nhập và lưu phiên
  static Future<void> login({String email = 'minh@email.com'}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserEmail, email);
    isLoggedInNotifier.value = true;
  }

  /// Đăng xuất và xoá phiên
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyUserEmail);
    isLoggedInNotifier.value = false;
  }

  /// Lấy email người dùng đã lưu
  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail) ?? 'minh@email.com';
  }
}
