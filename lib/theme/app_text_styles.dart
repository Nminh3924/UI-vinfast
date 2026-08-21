import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system using Be Vietnam Pro font.
/// Chữ lớn hơn bình thường — tài xế cần nhìn nhanh.
class AppTextStyles {
  AppTextStyles._();

  // ─── Display ───
  static TextStyle displayLarge({Color? color}) => GoogleFonts.beVietnamPro(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: color,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle displayMedium({Color? color}) => GoogleFonts.beVietnamPro(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: color,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // ─── Headline ───
  static TextStyle headlineLarge({Color? color}) => GoogleFonts.beVietnamPro(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1.3,
  );

  static TextStyle headlineMedium({Color? color}) => GoogleFonts.beVietnamPro(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1.3,
  );

  // ─── Title ───
  static TextStyle titleLarge({Color? color}) => GoogleFonts.beVietnamPro(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1.4,
  );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.beVietnamPro(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: color,
    height: 1.4,
  );

  // ─── Body (lớn cho tài xế) ───
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.beVietnamPro(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.5,
  );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.beVietnamPro(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.5,
  );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.beVietnamPro(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.5,
  );

  // ─── Label ───
  static TextStyle labelLarge({Color? color}) => GoogleFonts.beVietnamPro(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1.2,
  );

  static TextStyle labelMedium({Color? color}) => GoogleFonts.beVietnamPro(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: color,
    height: 1.2,
  );

  static TextStyle labelSmall({Color? color}) => GoogleFonts.beVietnamPro(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: color,
    letterSpacing: 0.5,
    height: 1.2,
  );
}
