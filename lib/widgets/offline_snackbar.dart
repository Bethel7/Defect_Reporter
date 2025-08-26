import 'package:defect_reporter/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

class OfflineSnackbar {
  static final _key = GlobalKey<ScaffoldMessengerState>();
  static GlobalKey<ScaffoldMessengerState> get key => _key;

  static Timer? _offlineTimer;
  static Timer? _onlineTimer;
  static bool _isOfflineSnackbarVisible = false;
  static bool _isOnlineSnackbarVisible = false;

  /// Call this when connection is lost
  static void showWithDebounce() {
    _onlineTimer?.cancel();
    if (_isOfflineSnackbarVisible) return;
    _offlineTimer?.cancel();
    _offlineTimer = Timer(const Duration(seconds: 2), () {
      _showOffline();
    });
  }

  /// Call this when connection is restored
  static void showBackOnlineWithDebounce() {
    _offlineTimer?.cancel();
    if (_isOnlineSnackbarVisible) return;
    if (_isOfflineSnackbarVisible) {
      _onlineTimer?.cancel();
      _onlineTimer = Timer(const Duration(seconds: 1), () {
        _showBackOnline();
      });
    }
  }

  static void _showOffline() {
    _isOfflineSnackbarVisible = true;
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
    // Hide after duration
    Future.delayed(const Duration(seconds: 5), () {
      _isOfflineSnackbarVisible = false;
    });
  }

  static void _showBackOnline() {
    _isOnlineSnackbarVisible = true;
    _key.currentState?.clearSnackBars();
    _key.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        backgroundColor: Colors.black45,
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
    // Hide after duration
    Future.delayed(const Duration(seconds: 3), () {
      _isOnlineSnackbarVisible = false;
    });
  }

  /// Show a custom error (red) snackbar (no debounce)
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
    _offlineTimer?.cancel();
    _onlineTimer?.cancel();
    _isOfflineSnackbarVisible = false;
    _isOnlineSnackbarVisible = false;
    _key.currentState?.clearSnackBars();
  }
}
