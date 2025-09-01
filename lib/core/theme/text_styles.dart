import 'package:flutter/material.dart';

class TextStyles {
  // Base styles without color for theme adaptation
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.1,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  // Helpers for context-based, theme-adaptive styles
  static TextStyle headlineLargeOf(BuildContext context) => Theme.of(context)
      .textTheme
      .headlineLarge!
      .copyWith(fontSize: 32 * MediaQuery.textScaleFactorOf(context));

  static TextStyle headlineMediumOf(BuildContext context) => Theme.of(context)
      .textTheme
      .headlineMedium!
      .copyWith(fontSize: 24 * MediaQuery.textScaleFactorOf(context));

  static TextStyle bodyLargeOf(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyLarge!
      .copyWith(fontSize: 18 * MediaQuery.textScaleFactorOf(context));

  static TextStyle bodyMediumOf(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: 16 * MediaQuery.textScaleFactorOf(context));

  static TextStyle labelLargeOf(BuildContext context) => Theme.of(context)
      .textTheme
      .labelLarge!
      .copyWith(fontSize: 16 * MediaQuery.textScaleFactorOf(context));
}
