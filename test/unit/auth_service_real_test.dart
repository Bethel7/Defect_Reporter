import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/services/auth_service.dart';
import 'package:defect_reporter/features/auth/data/user_model.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:defect_reporter/core/utils/service_error.dart';

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

void main() {
  group('AuthService', () {
    late MockDio mockDio;
    late AuthService service;

    setUp(() {
      mockDio = MockDio();
      service = AuthService();
      // Patch the _dio field for testing
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      service.testDio = mockDio;
    });

    test('login returns UserModel on success', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.data).thenReturn({
        'fullName': 'Test User',
        'role': 'user',
        'employeeID': 'EMP1',
        'email': 'test@example.com',
      });
      when(
        () => mockDio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => mockResponse);
      final result = await service.login('emp123', 'password');
      expect(result, isA<UserModel>());
      expect(result.fullName, 'Test User');
      expect(result.role, UserRole.user.name);
    });

    test('login throws user-friendly error on Dio error', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/api/auth/login')),
      );
      expect(
        () => service.login('emp123', 'bad'),
        throwsA(isA<ServiceError>()),
      );
    });

    test('logout completes without error', () async {
      when(() => mockDio.post(any())).thenAnswer((_) async => MockResponse());
      await service.logout();
      verify(() => mockDio.post(any())).called(1);
    });

    test('logout throws user-friendly error on Dio error', () async {
      when(() => mockDio.post(any())).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/api/auth/logout')),
      );
      expect(() => service.logout(), throwsA(isA<ServiceError>()));
    });

    test('forgotPassword returns backend message if present', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.data).thenReturn({'message': 'Reset sent!'});
      when(
        () => mockDio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => mockResponse);
      final result = await service.forgotPassword('user@example.com');
      expect(result, 'Reset sent!');
    });

    test('forgotPassword returns default message on 200/201/204', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.data).thenReturn({});
      when(() => mockResponse.statusCode).thenReturn(200);
      when(
        () => mockDio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => mockResponse);
      final result = await service.forgotPassword('user@example.com');
      expect(result, 'Password reset link sent!');
    });

    test('forgotPassword throws user-friendly error on Dio error', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/auth/forgot-password'),
        ),
      );
      expect(
        () => service.forgotPassword('user@example.com'),
        throwsA(isA<ServiceError>()),
      );
    });

    test('resetPassword completes without error', () async {
      when(
        () => mockDio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => MockResponse());
      await service.resetPassword('code', 'newPassword');
      verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);
    });

    test('resetPassword throws user-friendly error on Dio error', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/auth/reset-password'),
        ),
      );
      expect(
        () => service.resetPassword('code', 'bad'),
        throwsA(isA<ServiceError>()),
      );
    });

    test('changePassword completes without error', () async {
      when(
        () => mockDio.put(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => MockResponse());
      await service.changePassword('old', 'new');
      verify(() => mockDio.put(any(), data: any(named: 'data'))).called(1);
    });

    test('changePassword throws user-friendly error on Dio error', () async {
      when(() => mockDio.put(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/auth/update-password'),
        ),
      );
      expect(
        () => service.changePassword('old', 'bad'),
        throwsA(isA<ServiceError>()),
      );
    });
  });
}
