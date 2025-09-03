import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../features/auth/data/user_model.dart';
import '../api_client.dart';
import '../core/utils/service_error.dart';

class AuthService {
  Dio _dio;
    // a mock Dio instance for testing purpose
  @visibleForTesting
  set testDio(Dio dio) => _dio = dio;

  AuthService() : _dio = ApiClient().dio;

  Future<UserModel> login(String employeeId, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {'employeeId': employeeId, 'password': password},
      );
      final data = response.data;

      return UserModel.fromJson(data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/api/auth/logout');
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<String> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        '/api/auth/forgot-password',
        data: {'email': email},
      );
      // Try to extract a message from the backend response
      if (response.data != null &&
          response.data is Map &&
          response.data['message'] != null) {
        return response.data['message'] as String;
      }
      // Fallback: if status code is 200/201/204, assume success
      if ([200, 201, 204].contains(response.statusCode)) {
        return 'Password reset link sent!';
      }
      // Otherwise, treat as error
      throw Exception('Failed to send reset link.');
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> resetPassword(String code, String newPassword) async {
    try {
      await _dio.post(
        '/api/auth/reset-password',
        data: {'code': code, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _dio.put(
        '/api/auth/update-password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
