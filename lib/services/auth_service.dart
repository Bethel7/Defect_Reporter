import 'package:dio/dio.dart';
import '../features/auth/data/user_model.dart';

class AuthService {
  static const String defaultBaseUrl = 'http://svdcbas02:8212/';
  final Dio _dio;

  AuthService({String? baseUrl})
    : _dio = Dio(BaseOptions(baseUrl: baseUrl ?? defaultBaseUrl));

  Future<UserModel> login(String employeeId, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {'employeeId': employeeId, 'password': password},
      );
      print('API login response: \\${response.data}');
      final data = response.data;
      final user = UserModel.fromJson(data);
      print('Parsed user fullName: \\${user.fullName}');
      return user;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Login failed: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    }
  }

  Future<void> logout() async {
    await _dio.post('/api/auth/logout');
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post('/api/auth/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Forgot password failed: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Forgot password failed: ${e.message}');
      }
    }
  }

  Future<void> resetPassword(String code, String newPassword) async {
    try {
      await _dio.post(
        '/api/auth/reset-password',
        data: {'code': code, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Reset password failed: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Reset password failed: ${e.message}');
      }
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _dio.post(
        '/api/auth/change-password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Change password failed: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Change password failed: ${e.message}');
      }
    }
  }
}
