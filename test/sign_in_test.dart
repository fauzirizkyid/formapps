// test/validators_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:form_app/src/validator/validator.dart';

// bool isValidEmail(String email) {
//   final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//   return emailRegex.hasMatch(email);
// }

// bool isValidPassword(String password) {
//   return password.length >= 8;
// }

void main() {
  group('Email validation', () {
    test('Valid email returns null', () {
      expect(
        validateEmail('test@example.com'),
        null,
      );
    });

    test('Invalid email returns error message', () {
      expect(
        validateEmail('invalid-email'),
        'Please enter a valid email address',
      );
    });

    test('Empty email returns Email is required', () {
      expect(
        validateEmail(''),
        'Email is required',
      );
    });

    test('Email without @ symbol returns error message', () {
      expect(
        validateEmail('testexample.com'),
        'Please enter a valid email address',
      );
    });

    test('Email without domain returns error message', () {
      expect(
        validateEmail('test@'),
        'Please enter a valid email address',
      );
    });
  });

  group('Password validation', () {
    test(
        'Password with 8 or more characters with at least one uppercase, lowercase, special character, and number returns null',
        () {
      expect(validatePassword('Password#123'), null);
    });

    test('Password with less than 8 characters returns false', () {
      expect(validatePassword('pass'),
          "Password must be at least 8 characters long");
    });

    test('Empty password returns error message', () {
      expect(validatePassword(''), "Password is required");
    });
  });
}
