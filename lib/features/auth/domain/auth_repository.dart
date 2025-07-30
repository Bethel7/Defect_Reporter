import '../data/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String employeeId, String password);
  Future<void> logout();
}