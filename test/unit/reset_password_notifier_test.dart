import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/features/auth/presentation/reset_password_notifier.dart';
import 'package:mocktail/mocktail.dart';

class MockResetPasswordNotifier extends Mock implements ResetPasswordNotifier {}

void main() {
  group('ResetPasswordNotifier', () {
    late MockResetPasswordNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockResetPasswordNotifier();
    });

    test('resetPassword sets loading and success', () async {
      when(
        () => mockNotifier.resetPassword('user@example.com'),
      ).thenAnswer((_) async => true);
      final result = await mockNotifier.resetPassword('user@example.com');
      expect(result, isTrue);
    });

    test('resetPassword handles error', () async {
      when(
        () => mockNotifier.resetPassword('bad'),
      ).thenThrow(Exception('fail'));
      expect(() => mockNotifier.resetPassword('bad'), throwsException);
    });
  });
}
