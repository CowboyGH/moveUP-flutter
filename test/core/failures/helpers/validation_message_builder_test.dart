import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/core/failures/helpers/validation_message_builder.dart';

void main() {
  group('buildValidationMessage', () {
    test('normalizes, deduplicates, and joins field error messages', () {
      const result = 'error_message_1\nerror_message_2';
      final message = buildValidationMessage(
        const {
          'email': ['  error_message_1  ', '', 'error_message_1'],
          'password': ['error_message_2'],
        },
        fallbackMessage: 'fallback',
      );

      expect(message, result);
    });

    test('returns fallback message when normalized field errors are empty', () {
      final message = buildValidationMessage(
        const {
          'email': ['  ', ''],
        },
        fallbackMessage: 'fallback',
      );

      expect(message, 'fallback');
    });
  });
}
