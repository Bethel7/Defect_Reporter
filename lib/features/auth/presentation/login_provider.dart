// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_state.dart';
import '../../../services/auth_service.dart';
import '../data/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final currentUserProvider = StateProvider<UserModel?>((ref) => null);

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref.read(authServiceProvider));
});

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthService _authService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  LoginNotifier(this._authService) : super(LoginState.initial());

  void setEmployeeId(String id) {
    state = state.copyWith(employeeId: id);
  }

  void setPassword(String pwd) {
    state = state.copyWith(password: pwd);
  }

  /// Login and persist user info in secure storage. 
  Future<bool> login(WidgetRef ref) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.login(state.employeeId, state.password);
      // Store user globally
      ref.read(currentUserProvider.notifier).state = user;
      // Persist user info in secure storage
      await _storage.write(key: 'fullName', value: user.fullName);
      await _storage.write(key: 'role', value: user.role);
      
      state = state.copyWith(isLoading: false, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  /// Restore user session from secure storage (call on app start)
  Future<void> restoreUserSession(WidgetRef ref) async {
    final fullName = await _storage.read(key: 'fullName');
    final role = await _storage.read(key: 'role');
    if (fullName != null && role != null) {
      final user = UserModel(fullName: fullName, role: role);
      ref.read(currentUserProvider.notifier).state = user;
    }
  }
}
