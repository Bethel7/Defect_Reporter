import 'user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String employeeId, String password);
  Future<void> logout();
}