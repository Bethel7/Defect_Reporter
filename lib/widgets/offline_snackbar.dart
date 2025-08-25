import 'package:defect_reporter/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OfflineSnackbar {
  static final _key = GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get key => _key;

  /// Show the offline (red) snackbar
  static void show() {
    _key.currentState?.clearSnackBars();
    _key.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 5),
        content: Row(
          children: const [
            FaIcon(FontAwesomeIcons.wifi, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'No internet connection',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show the back online (green) snackbar
  static void showBackOnline() {
    _key.currentState?.clearSnackBars();
    _key.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        backgroundColor: const Color(0xFF388E3C),
        duration: const Duration(seconds: 3),
        content: Row(
          children: const [
            FaIcon(FontAwesomeIcons.checkCircle, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Back online',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show a custom error (red) snackbar
  static void showError(String message) {
    _key.currentState?.clearSnackBars();
    _key.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void hide() {
    _key.currentState?.clearSnackBars();
  }
}
