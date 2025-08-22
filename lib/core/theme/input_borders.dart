import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class InputBorders {
  static final BorderRadius _radius = BorderRadius.circular(16);

  static final OutlineInputBorder gray = OutlineInputBorder(
    borderSide: const BorderSide(color: AppColors.borderGray),
    borderRadius: _radius,
  );
  static final OutlineInputBorder green = OutlineInputBorder(
    borderSide: const BorderSide(color: AppColors.borderGreen),
    borderRadius: _radius,
  );
  static final OutlineInputBorder red = OutlineInputBorder(
    borderSide: const BorderSide(color: AppColors.borderRed),
    borderRadius: _radius,
  );
}
