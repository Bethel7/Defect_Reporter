import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_state.dart';
import '../../../services/auth_service.dart';
import '../data/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/utils/service_error.dart';

final currentUserProvider = StateProvider<UserModel?>((ref) => null);

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref.read(authServiceProvider));
});

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthService _authService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isRestoringSession = false;

  LoginNotifier(this._authService) : super(LoginState.initial());

  /// Check if a valid session exists
  Future<bool> hasValidSession() async {
    try {
      final userId = await _storage.read(key: 'userId');
      return userId != null && userId.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking session: $e');
      return false;
    }
  }

  /// Autofill credentials from secure storage (called from UI init)
  Future<void> autofillCredentials({
    required TextEditingController employeeIdController,
    required TextEditingController passwordController,
  }) async {
    try {
      final savedEmployeeId = await _storage.read(key: 'employeeId');
      final savedPassword = await _storage.read(key: 'password');

      // Only use for autofill, not for userId fetching
      if (savedEmployeeId != null &&
          savedPassword != null &&
          employeeIdController.text.isEmpty &&
          passwordController.text.isEmpty) {
        employeeIdController.text = savedEmployeeId;
        passwordController.text = savedPassword;
      }
    } catch (e) {
      debugPrint('Error autofilling credentials: $e');
    }
  }

  void setEmployeeId(String id) {
    state = state.copyWith(employeeId: id);
  }

  void setPassword(String pwd) {
    state = state.copyWith(password: pwd);
  }

  /// Login and persist user info in secure storage, including userId.
  Future<bool> login(WidgetRef ref) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.login(state.employeeId, state.password);

      debugPrint('[LoginNotifier.login] user: ${user.id}');

      // Store user globally
      ref.read(currentUserProvider.notifier).state = user;

      // Persist user info in secure storage (write all required fields)
      await _persistUserData(user);

      state = state.copyWith(isLoading: false, error: null);
      return true;
    } on ServiceError catch (e) {
      final errorMsg = e.userMessage;
      debugPrint('[LoginNotifier.login] ServiceError: ${e.toDebugString()}');
      state = state.copyWith(error: errorMsg, isLoading: false);
      return false;
    } on FormatException catch (e) {
      // Handle JSON parsing errors from UserModel.fromJson
      final errorMsg = 'Invalid response from server. Please try again.';
      debugPrint('[LoginNotifier.login] FormatException: $e');
      state = state.copyWith(error: errorMsg, isLoading: false);
      return false;
    } catch (e) {
      // Handle unexpected errors
      final errorMsg = 'An unexpected error occurred. Please try again.';
      debugPrint('[LoginNotifier.login] Unexpected error: $e');
      state = state.copyWith(error: errorMsg, isLoading: false);
      return false;
    }
  }

  /// Atomic operation to persist all user data
  Future<void> _persistUserData(UserModel user) async {
    try {
      // Write all user data in sequence
      await _storage.write(key: 'userId', value: user.id.toString());
      await _storage.write(key: 'fullName', value: user.fullName);
      await _storage.write(key: 'role', value: user.role.name);
      await _storage.write(key: 'employeeId', value: user.employeeId);
      await _storage.write(key: 'email', value: user.email);
      await _storage.write(key: 'password', value: state.password);
    } catch (e) {
      debugPrint('Error persisting user data: $e');
      // If any write fails, clear all to avoid inconsistent state
      await _clearStoredUserData();
      rethrow;
    }
  }

  /// Clear all user data from storage
  Future<void> _clearStoredUserData() async {
    try {
      await _storage.delete(key: 'userId');
      await _storage.delete(key: 'fullName');
      await _storage.delete(key: 'role');
      await _storage.delete(key: 'employeeId');
      await _storage.delete(key: 'email');
      await _storage.delete(key: 'password');
    } catch (e) {
      debugPrint('Error clearing stored data: $e');
    }
  }

  /// Restore user session from secure storage (call on app start)
  Future<void> restoreUserSession(WidgetRef ref) async {
    if (_isRestoringSession) return; // Prevent concurrent restoration
    _isRestoringSession = true;

    try {
      final userIdStr = await _storage.read(key: 'userId');
      final fullName = await _storage.read(key: 'fullName');
      final role = await _storage.read(key: 'role');
      final employeeId = await _storage.read(key: 'employeeId');
      final email = await _storage.read(key: 'email');

      if (userIdStr != null &&
          fullName != null &&
          role != null &&
          employeeId != null &&
          email != null) {
        final user = UserModel(
          id: int.tryParse(userIdStr) ?? 0,
          fullName: fullName,
          employeeId: employeeId,
          email: email,
          role: UserRole.values.firstWhere(
            (e) => e.name == role,
            orElse: () => UserRole.unknown,
          ),
        );

        ref.read(currentUserProvider.notifier).state = user;
        debugPrint('[restoreUserSession] Restored userId: ${user.id}');
      } else {
        // Incomplete session data, clear everything
        await _clearStoredUserData();
        debugPrint('[restoreUserSession] No valid session found in storage');
      }
    } catch (e) {
      debugPrint('[restoreUserSession] Error restoring session: $e');
      await _clearStoredUserData(); // Clean up on error
    } finally {
      _isRestoringSession = false;
    }
  }

  /// Logout with proper cleanup
  Future<void> logout(WidgetRef ref) async {
    try {
      await _authService.logout();
    } on ServiceError catch (e) {
      debugPrint('[LoginNotifier.logout] ServiceError: ${e.toDebugString()}');
      // Continue with local cleanup even if API call fails
    } catch (e) {
      debugPrint('[LoginNotifier.logout] Unexpected error: $e');
    } finally {
      // Always clear local data
      await _clearStoredUserData();
      ref.read(currentUserProvider.notifier).state = null;
      state = state.copyWith(employeeId: '', password: '');
    }
  }
}
