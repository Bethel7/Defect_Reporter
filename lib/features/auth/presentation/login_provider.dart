import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
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
  /// Autofill credentials from secure storage (called from UI init)
  Future<void> autofillCredentials({
    required TextEditingController employeeIdController,
    required TextEditingController passwordController,
  }) async {
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
  }

  final AuthService _authService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  LoginNotifier(this._authService) : super(LoginState.initial());

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
      // Store user globally
      ref.read(currentUserProvider.notifier).state = user;
      // Persist user info in secure storage
      await _storage.write(key: 'userId', value: user.userId.toString());
      await _storage.write(key: 'fullName', value: user.fullName);
      await _storage.write(key: 'role', value: user.role.name);

      state = state.copyWith(isLoading: false, error: null);
      return true;
    } catch (e) {
      String errorMsg = 'An error occurred. Please try again.';
      // Handle ServiceError for 401 Unauthorized
      if (e is ServiceError && e.statusCode == 401) {
        errorMsg = 'Incorrect Employee ID or password. Please try again.';
      } else if (e is ServiceError && e.message.isNotEmpty) {
        // For other service errors, show a generic message
        errorMsg = e.message;
      }
      state = state.copyWith(error: errorMsg, isLoading: false);
      return false;
    }
  }

  /// Restore user session from secure storage (call on app start)
  Future<void> restoreUserSession(WidgetRef ref) async {
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
        userId: int.tryParse(userIdStr) ?? 0,
        fullName: fullName,
        employeeId: employeeId,
        email: email,
        role: UserRole.values.firstWhere(
          (e) => e.name == role,
          orElse: () => UserRole.unknown,
        ),
      );
      ref.read(currentUserProvider.notifier).state = user;
    }
  }
}
