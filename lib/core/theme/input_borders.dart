import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'dart:io' show Platform;

class InputBorders {
  static OutlineInputBorder custom(Color color, {double radius = 16}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: color),
      );

  /// Returns a border appropriate for the current platform (Material or Cupertino style)
  static InputBorder adaptive({
    Color color = AppColors.borderGray,
    double radius = 16,
    bool isError = false,
  }) {
    if (Platform.isIOS) {
      // Cupertino style: thinner border, more rounded
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius + 8),
        borderSide: BorderSide(
          color: isError ? AppColors.borderRed : color,
          width: 1.0,
        ),
      );
    } else {
      // Material style
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: isError ? AppColors.borderRed : color,
          width: 2.0,
        ),
      );
    }
  }
}
