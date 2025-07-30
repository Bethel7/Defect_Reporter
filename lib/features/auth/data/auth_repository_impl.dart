import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';
import 'user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserModel> login(String employeeId, String password) async {
    final userModel = await remoteDataSource.login(employeeId, password);
    return userModel;
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }
}