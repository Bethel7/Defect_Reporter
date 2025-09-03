import '../core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final String label;
  final String? initialValue;
  final TextEditingController? controller;
  final bool obscureText;
  final int maxLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final TextStyle? errorStyle;
  final Widget? prefixIcon;
  final TextStyle? style;
  final bool? enabled;
  final List<String>? autofillHints;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.maxLines = 1,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.errorStyle,
    this.prefixIcon,
    this.style,
    this.enabled,
    this.autofillHints,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);
    const thinBorderWidth = 0.7;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      textCapitalization: TextCapitalization.sentences,
      style: style ?? TextStyle(color: theme.colorScheme.onSurface),
      enabled: enabled,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark
              ? theme.colorScheme.onSurface.withOpacity(0.7)
              : const Color(0xFF717182), // subtle gray for light mode
        ),
        border:
            border ??
            OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: AppColors.borderGray,
                width: thinBorderWidth,
              ),
            ),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: AppColors.borderGray,
                width: thinBorderWidth,
              ),
            ),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: AppColors.primary,
                width: thinBorderWidth,
              ),
            ),
        errorBorder:
            errorBorder ??
            OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: AppColors.borderRed,
                width: thinBorderWidth,
              ),
            ),
        focusedErrorBorder:
            focusedErrorBorder ??
            OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: AppColors.borderRed,
                width: thinBorderWidth,
              ),
            ),
        errorStyle: errorStyle,
        prefixIcon: prefixIcon,
        fillColor: isDark ? theme.colorScheme.surface : Colors.white,
        filled: true,
      ),
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
