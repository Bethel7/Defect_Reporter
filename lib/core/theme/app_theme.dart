import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'text_styles.dart';

// ThemeExtension for custom app colors
class MyColors extends ThemeExtension<MyColors> {
  final Color? primary;
  final Color? primaryDark;
  final Color? accent;
  final Color? error;
  final Color? background;
  final Color? text;

  const MyColors({
    this.primary,
    this.primaryDark,
    this.accent,
    this.error,
    this.background,
    this.text,
  });

  @override
  MyColors copyWith({
    Color? primary,
    Color? primaryDark,
    Color? accent,
    Color? error,
    Color? background,
    Color? text,
  }) {
    return MyColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      accent: accent ?? this.accent,
      error: error ?? this.error,
      background: background ?? this.background,
      text: text ?? this.text,
    );
  }

  @override
  MyColors lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) return this;
    return MyColors(
      primary: Color.lerp(primary, other.primary, t),
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t),
      accent: Color.lerp(accent, other.accent, t),
      error: Color.lerp(error, other.error, t),
      background: Color.lerp(background, other.background, t),
      text: Color.lerp(text, other.text, t),
    );
  }
}

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        error: AppColors.error,
        background: AppColors.background,
        surface: Colors.white,
      ),
      extensions: const [
        MyColors(
          primary: AppColors.primary,
          primaryDark: AppColors.primaryDark,
          accent: AppColors.accent,
          error: AppColors.error,
          background: AppColors.background,
          text: AppColors.text,
        ),
      ],
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: TextStyles.button,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardColor: Colors.white,
      textTheme: TextTheme(
        headlineLarge: TextStyles.headlineLarge,
        headlineMedium: TextStyles.headlineMedium,
        bodyLarge: TextStyles.bodyLarge,
        bodyMedium: TextStyles.bodyMedium,
        labelLarge: TextStyles.labelLarge,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
        labelStyle: TextStyle(color: AppColors.primaryDark),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        error: AppColors.error,
        background: Colors.black,
        surface: Colors.grey[900]!,
      ),
      extensions: const [
        MyColors(
          primary: AppColors.primary,
          primaryDark: AppColors.primaryDark,
          accent: AppColors.accent,
          error: AppColors.error,
          background: Colors.black,
          text: Colors.white,
        ),
      ],
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          textStyle: TextStyles.button,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardColor: Colors.grey[900],
      textTheme: TextTheme(
        headlineLarge: TextStyles.headlineLarge.copyWith(color: Colors.white),
        headlineMedium: TextStyles.headlineMedium.copyWith(color: Colors.white),
        bodyLarge: TextStyles.bodyLarge.copyWith(color: Colors.white),
        bodyMedium: TextStyles.bodyMedium.copyWith(color: Colors.white70),
        labelLarge: TextStyles.labelLarge.copyWith(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryDark),
        ),
        labelStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
