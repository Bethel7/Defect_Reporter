import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';
import 'user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:defect_reporter/core/error/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserModel>> login(
    String employeeId,
    String password,
  ) async {
    final result = await remoteDataSource.login(employeeId, password);
    return result.fold((failure) => Left(failure), (user) => Right(user));
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final result = await remoteDataSource.logout();
    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }
}
