import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/services/auth_service.dart';
import 'package:defect_reporter/features/auth/data/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('AuthService', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    test('login returns UserModel on success', () async {
      final user = UserModel(fullName: 'Test User', role: UserRole.user);
      when(
        () => mockAuthService.login('emp123', 'password'),
      ).thenAnswer((_) async => user);

      final result = await mockAuthService.login('emp123', 'password');
      expect(result.fullName, 'Test User');
      expect(result.role, UserRole.user);
    });

    test('login throws on error', () async {
      when(
        () => mockAuthService.login('bad', 'bad'),
      ).thenThrow(Exception('fail'));
      expect(() => mockAuthService.login('bad', 'bad'), throwsException);
    });
  });
}
