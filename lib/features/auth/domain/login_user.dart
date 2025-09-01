import 'package:dartz/dartz.dart';
import 'package:defect_reporter/core/error/failures.dart';
import 'package:defect_reporter/core/utils/validators.dart';
import 'package:defect_reporter/features/auth/domain/auth_repository.dart';
import 'package:defect_reporter/features/auth/data/user_model.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, UserModel>> call(
    String employeeId,
    String password,
  ) async {
    final idError = Validators.validateEmployeeId(employeeId);
    if (idError != null) return Left(AuthFailure(idError));
    final pwError = Validators.validatePassword(password);
    if (pwError != null) return Left(AuthFailure(pwError));
    // Call repository and return result
    return await repository.login(employeeId, password);
  }
}
