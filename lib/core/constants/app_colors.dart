import 'package:flutter/material.dart';

class AppColors {
  // Green palette from design (oklch)
  static const Color primary = Color(0xFF279F27); // Vibrant green
  static const Color primaryDark = Color(
    0xFF279F27,
  ); // Use same for dark for now
  static const Color accent = Color(0xFF7EE887); // Lighter accent for contrast

  static const Color error = Color(0xFFD4183D); // Design red
  static const Color background = Color(
    0xFFF6F8FA,
  ); // Subtle off-white background
  static const Color text = Color(0xFF252525); // Foreground

  // Outlined inputBorder colors
  static const Color borderGray = Color(0xFFBDBDBD);
  static const Color borderGreen = Color(0xFF279F27);
  static const Color borderRed = Color(0xFFD4183D);
}
