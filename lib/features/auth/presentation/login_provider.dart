import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_state.dart';
import '../../../services/auth_service.dart';
import '../data/user_model.dart';

final currentUserProvider = StateProvider<UserModel?>((ref) => null);

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref.read(authServiceProvider));
});

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthService _authService;

  LoginNotifier(this._authService) : super(LoginState.initial());

  void setEmployeeId(String id) {
    state = state.copyWith(employeeId: id);
  }

  void setPassword(String pwd) {
    state = state.copyWith(password: pwd);
  }

  Future<void> login(BuildContext context, WidgetRef ref) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.login(state.employeeId, state.password);
      // Store user globally
      ref.read(currentUserProvider.notifier).state = user;

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }

      print('Logged in as: ${user.fullName}');
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
