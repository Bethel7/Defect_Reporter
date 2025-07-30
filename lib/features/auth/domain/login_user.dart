import 'auth_repository.dart';
import '../data/user_model.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<UserModel> call(String employeeId, String password) {
    return repository.login(employeeId, password);
  }
}