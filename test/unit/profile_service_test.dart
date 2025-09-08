import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/services/profile_service.dart';
import 'package:defect_reporter/features/profile/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

void main() {
  group('ProfileService', () {
    late MockDio mockDio;
    late ProfileService service;

    setUp(() {
      mockDio = MockDio();
      service = ProfileService();
      // Inject mockDio if ProfileService is refactored to accept it
      // For now, we patch the _dio field directly for testing
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      service._dio = mockDio;
    });

    test(
      'fetchProfile returns ProfileModel on success (direct data)',
      () async {
        final mockResponse = MockResponse();
        when(() => mockResponse.data).thenReturn({
          'fullName': 'Test User',
          'employeeID': 'EMP1',
          'email': 'test@example.com',
          'role': 'employee',
          'isActive': true,
          'createdAt': DateTime.now().toIso8601String(),
        });
        when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);
        final result = await service.fetchProfile();
        expect(result, isA<ProfileModel>());
        expect(result.fullName, 'Test User');
      },
    );

    test(
      'fetchProfile returns ProfileModel on success (nested data)',
      () async {
        final mockResponse = MockResponse();
        when(() => mockResponse.data).thenReturn({
          'data': {
            'fullName': 'Test User',
            'employeeID': 'EMP1',
            'email': 'test@example.com',
            'role': 'user',
            'isActive': true,
            'createdAt': DateTime.now().toIso8601String(),
          },
        });
        when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);
        final result = await service.fetchProfile();
        expect(result, isA<ProfileModel>());
        expect(result.fullName, 'Test User');
      },
    );

    test('fetchProfile throws on Dio error', () async {
      when(() => mockDio.get(any())).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/api/auth/my-profile')),
      );
      expect(() => service.fetchProfile(), throwsA(isA<DioException>()));
    });

    test('fetchProfile handles malformed/missing fields', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.data).thenReturn({'fullName': 'Test User'});
      when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);
      final result = await service.fetchProfile();
      expect(result.fullName, 'Test User');
      expect(result.employeeId, '');
      expect(result.email, '');
      expect(result.role, '');
      expect(result.isActive, false);
      expect(result.createdAt, isNull);
    });
  });
}
