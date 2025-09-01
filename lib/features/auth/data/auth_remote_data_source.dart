import 'package:dartz/dartz.dart';
import 'package:defect_reporter/core/error/failures.dart';
import 'user_model.dart';

abstract class AuthRemoteDataSource {
  /// Returns Either<Failure, UserModel> for error handling
  Future<Either<Failure, UserModel>> login(String employeeId, String password);

  /// Returns Either<Failure, void> for error handling
  Future<Either<Failure, void>> logout();

  // /// Optional: Refreshes the auth token if supported
  // Future<Either<Failure, String>> refreshToken();

  ///  Checks if the session is still valid
  Future<Either<Failure, bool>> checkSession();
}
