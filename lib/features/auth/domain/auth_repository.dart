import '../data/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:defect_reporter/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login(String employeeId, String password);
  Future<Either<Failure, void>> logout();
}
