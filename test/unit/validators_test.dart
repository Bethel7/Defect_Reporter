import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('validateTitle returns error for empty title', () {
      expect(Validators.validateTitle(''), isNotNull);
    });

    test('validateTitle returns null for valid title', () {
      expect(Validators.validateTitle('A valid title'), isNull);
    });

    test('validateDescription returns error for empty description', () {
      expect(Validators.validateDescription(''), isNotNull);
    });

    test('validateDescription returns null for valid description', () {
      expect(Validators.validateDescription('A valid description'), isNull);
    });

    test('validateImagePath returns error for null or empty path', () {
      expect(Validators.validateImagePath(null), isNotNull);
      expect(Validators.validateImagePath(''), isNotNull);
    });

    test('validateImagePath returns null for valid path', () {
      expect(Validators.validateImagePath('some/path/image.png'), isNull);
    });
  });
}
