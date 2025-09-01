import 'package:flutter/material.dart';

class AppColors {
  // Brand colors (green palette)
  static const Color primary = Color(0xFF279F27); // Vibrant green
  static const Color primaryDark = Color(0xFF1E7F1E); // Slightly darker shade
  static const Color accent = Color(0xFF7EE887); // Lighter accent green

  // Feedback colors
  static const Color error = Color(0xFFD4183D); // Design red
  static const Color success = Color(0xFF2E7D32); // Muted green for success states
  static const Color warning = Color(0xFFFFA000); // Amber/yellow for warnings
  static const Color neutralDark = Color(0xFF323232); // For snackbars, toasts, overlays
  static const Color neutralLight = Color(0xFFF1F1F1); // Light gray background

  // Background & text
  static const Color background = Color(0xFFF6F8FA); // Subtle off-white background
  static const Color text = Color(0xFF252525); // Dark text

  // On-colors (for text/icons on top of backgrounds)
  static const Color onPrimary = Colors.white;
  static const Color onError = Colors.white;
  static const Color onNeutral = Colors.white;

  // Borders
  static const Color borderGray = Color(0xFFBDBDBD);
  static const Color borderGreen = primary;
  static const Color borderRed = error;
}
