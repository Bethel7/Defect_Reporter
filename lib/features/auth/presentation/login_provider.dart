import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_state.dart';
import '../../../services/auth_service.dart';


final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final loginProvider =
    StateNotifierProvider<LoginNotifier, LoginState>((ref) {
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

 Future<void> login(BuildContext context) async {
  state = state.copyWith(isLoading: true, error: null);
  try {
    final user = await _authService.login(state.employeeId, state.password);
    // You can store user info or navigate here
    
    if(context.mounted){
      Navigator.pushReplacementNamed(context, '/home');
    }
  
    // For now, just print or log the user
    print('Logged in as: ${user.fullName}');
  } catch (e) {
    state = state.copyWith(error: e.toString());
  } finally {
    state = state.copyWith(isLoading: false);
  }
  
}
}
