import '../features/auth/data/user_model.dart';

class AuthService {
  Future<UserModel> login(String employeeId, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (employeeId.isNotEmpty && password.isNotEmpty) {
      // Return a dummy user
      return UserModel(
        employeeId: employeeId,
        fullName: 'Test User',
        token: 'dummy_token',
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}