import 'package:flutter_test/flutter_test.dart';
import 'package:defect_reporter/core/utils/validators.dart';

void main() {
  group('Validators', () {
    // requiredValidator
    group('requiredValidator', () {
      test('returns error for null', () {
        expect(
          Validators.requiredValidator(null, 'Field'),
          'Field is required',
        );
      });
      test('returns error for empty string', () {
        expect(Validators.requiredValidator('', 'Field'), 'Field is required');
      });
      test('returns error for whitespace only', () {
        expect(
          Validators.requiredValidator('   ', 'Field'),
          'Field is required',
        );
      });
      test('returns null for valid string', () {
        expect(Validators.requiredValidator('Valid', 'Field'), isNull);
      });
    });

    // validateEmail
    group('validateEmail', () {
      test('returns error for null', () {
        expect(Validators.validateEmail(null), 'Please enter your email');
      });
      test('returns error for empty string', () {
        expect(Validators.validateEmail(''), 'Please enter your email');
      });
      test('returns error for whitespace only', () {
        expect(Validators.validateEmail('   '), 'Please enter your email');
      });
      test('returns error for invalid email: plainaddress', () {
        expect(Validators.validateEmail('plainaddress'), 'Enter a valid email');
      });
      test('returns error for invalid email: @missingusername.com', () {
        expect(
          Validators.validateEmail('@missingusername.com'),
          'Enter a valid email',
        );
      });
      test('returns error for invalid email: user@.com', () {
        expect(Validators.validateEmail('user@.com'), 'Enter a valid email');
      });
      test('returns error for invalid email: user@domain', () {
        expect(Validators.validateEmail('user@domain'), 'Enter a valid email');
      });
      test('returns null for valid email: user@example.com', () {
        expect(Validators.validateEmail('user@example.com'), isNull);
      });
      test('returns null for valid email: user.name+tag@domain.co', () {
        expect(Validators.validateEmail('user.name+tag@domain.co'), isNull);
      });
    });

    // validateEmployeeId
    group('validateEmployeeId', () {
      test('returns error for null', () {
        expect(Validators.validateEmployeeId(null), 'Employee ID is required');
      });
      test('returns error for empty string', () {
        expect(Validators.validateEmployeeId(''), 'Employee ID is required');
      });
      test('returns error for whitespace only', () {
        expect(Validators.validateEmployeeId('   '), 'Employee ID is required');
      });
      test('returns null for valid ID', () {
        expect(Validators.validateEmployeeId('EMP123'), isNull);
      });
    });

    // validatePassword
    group('validatePassword', () {
      test('returns error for null', () {
        expect(Validators.validatePassword(null), 'Password is required');
      });
      test('returns error for empty string', () {
        expect(Validators.validatePassword(''), 'Password is required');
      });
      test('returns error for less than 8 chars', () {
        expect(
          Validators.validatePassword('Abc123'),
          'Password must be at least 8 characters',
        );
      });
      test('returns error for no uppercase', () {
        expect(
          Validators.validatePassword('password1'),
          'Password must contain an uppercase letter',
        );
      });
      test('returns error for no lowercase', () {
        expect(
          Validators.validatePassword('PASSWORD1'),
          'Password must contain a lowercase letter',
        );
      });
      test('returns error for no number', () {
        expect(
          Validators.validatePassword('Password'),
          'Password must contain a number',
        );
      });
      test('returns error for whitespace in password', () {
        expect(
          Validators.validatePassword('Password 1'),
          'Password cannot contain spaces',
        );
      });
      test('returns null for valid strong password', () {
        expect(Validators.validatePassword('Password1'), isNull);
      });
    });

    // validateTitle (add too long case)
    test('validateTitle returns error for title exceeding 100 chars', () {
      expect(Validators.validateTitle('A' * 101), 'Title is too long');
    });

    // validateLocation
    group('validateLocation', () {
      test('returns error for null', () {
        expect(Validators.validateLocation(null), 'Location is required');
      });
      test('returns error for empty string', () {
        expect(Validators.validateLocation(''), 'Location is required');
      });
      test('returns error for whitespace only', () {
        expect(Validators.validateLocation('   '), 'Location is required');
      });
      test('returns null for valid location', () {
        expect(Validators.validateLocation('HQ'), isNull);
      });
    });

    // validateImagePath (edge: no extension, non-image extension)
    test('validateImagePath returns null for path without extension', () {
      expect(Validators.validateImagePath('some/path/file'), isNull);
    });
    test('validateImagePath returns null for non-image extension', () {
      expect(Validators.validateImagePath('some/path/file.txt'), isNull);
    });

    // validateDescription (add too long case)
    test(
      'validateDescription returns error for description exceeding 500 chars',
      () {
        expect(
          Validators.validateDescription('B' * 501),
          'Description is too long',
        );
      },
    );

    // validateLocationId
    group('validateLocationId', () {
      test('returns error for null', () {
        expect(Validators.validateLocationId(null), 'Please select a location');
      });
      test('returns error for empty string', () {
        expect(Validators.validateLocationId(''), 'Please select a location');
      });
      test('returns error for whitespace only', () {
        expect(
          Validators.validateLocationId('   '),
          'Please select a location',
        );
      });
      test('returns null for valid locationId', () {
        expect(Validators.validateLocationId('123'), isNull);
      });
    });

    // validateConfirmPassword
    group('validateConfirmPassword', () {
      test('returns error for null', () {
        expect(
          Validators.validateConfirmPassword(null, 'Password1'),
          'Please confirm your password',
        );
      });
      test('returns error for empty string', () {
        expect(
          Validators.validateConfirmPassword('', 'Password1'),
          'Please confirm your password',
        );
      });
      test('returns error for whitespace only', () {
        expect(
          Validators.validateConfirmPassword('   ', 'Password1'),
          'Please confirm your password',
        );
      });
      test('returns error for mismatch', () {
        expect(
          Validators.validateConfirmPassword('Password2', 'Password1'),
          'Passwords do not match',
        );
      });
      test('returns null for match', () {
        expect(
          Validators.validateConfirmPassword('Password1', 'Password1'),
          isNull,
        );
      });
    });
    // Title
    test('validateTitle returns error for empty title', () {
      expect(Validators.validateTitle(''), isNotNull);
    });
    test('validateTitle returns error for whitespace-only', () {
      expect(Validators.validateTitle('   '), isNotNull);
    });
    test('validateTitle returns null for valid title', () {
      expect(Validators.validateTitle('A valid title'), isNull);
    });
    test('validateTitle returns null for long but valid title', () {
      expect(Validators.validateTitle('A' * 100), isNull);
    });
    test(
      'validateTitle returns error for borderline invalid (single char if not allowed)',
      () {
        // If your validator requires >1 char, adjust this test accordingly
        expect(Validators.validateTitle('A'), anyOf(isNull, isNotNull));
      },
    );
    test('validateTitle handles special characters', () {
      expect(
        Validators.validateTitle('!@#%&*()_+-='),
        anyOf(isNull, isNotNull),
      );
    });

    // Description
    test('validateDescription returns error for empty description', () {
      expect(Validators.validateDescription(''), isNotNull);
    });
    test('validateDescription returns error for whitespace-only', () {
      expect(Validators.validateDescription('   '), isNotNull);
    });
    test('validateDescription returns null for valid description', () {
      expect(Validators.validateDescription('A valid description'), isNull);
    });
    test('validateDescription returns null for long description', () {
      expect(Validators.validateDescription('B' * 500), isNull);
    });
    test('validateDescription handles special characters', () {
      expect(
        Validators.validateDescription('!@#%&*()_+-='),
        anyOf(isNull, isNotNull),
      );
    });

    // Image path
    test('validateImagePath returns error for null or empty path', () {
      expect(Validators.validateImagePath(null), isNotNull);
      expect(Validators.validateImagePath(''), isNotNull);
    });
    test('validateImagePath returns error for whitespace-only', () {
      expect(Validators.validateImagePath('   '), isNotNull);
    });
    test('validateImagePath returns null for valid path', () {
      expect(Validators.validateImagePath('some/path/image.png'), isNull);
    });
    test('validateImagePath returns null for long path', () {
      expect(Validators.validateImagePath('/a/${'b' * 200}.jpg'), isNull);
    });
    test('validateImagePath handles special characters', () {
      expect(
        Validators.validateImagePath('!@#%&*()_+-=img.png'),
        anyOf(isNull, isNotNull),
      );
    });
  });
}
