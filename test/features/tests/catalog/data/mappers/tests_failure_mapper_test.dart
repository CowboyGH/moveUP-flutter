import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/core/constants/app_strings.dart';
import 'package:moveup_flutter/core/failures/feature/tests/tests_failure.dart';
import 'package:moveup_flutter/core/failures/network/network_failure.dart';
import 'package:moveup_flutter/features/tests/catalog/data/mappers/tests_failure_mapper.dart';

void main() {
  group('TestsFailureMapper.toTestsFailure', () {
    test('maps validation_failed to TestsValidationFailure with validation message', () {
      const failure = ValidationFailure(
        errors: {
          'result_value': ['error_message'],
        },
      );

      final result = failure.toTestsFailure();

      expect(result, isA<TestsValidationFailure>());
      expect(result.message, 'error_message');
    });

    test('falls back to generic tests validation message when field errors are empty', () {
      final result = const ValidationFailure().toTestsFailure();

      expect(result, isA<TestsValidationFailure>());
      expect(result.message, AppStrings.testsValidationFailed);
    });

    test('maps NoNetworkFailure to TestsRequestFailure', () {
      final failure = const NoNetworkFailure().toTestsFailure();

      expect(failure, isA<TestsRequestFailure>());
      expect(failure.message, const NoNetworkFailure().message);
    });

    test('maps ServerErrorFailure to TestsRequestFailure', () {
      final failure = const ServerErrorFailure().toTestsFailure();

      expect(failure, isA<TestsRequestFailure>());
      expect(failure.message, const ServerErrorFailure().message);
    });

    test('maps UnknownNetworkFailure to TestsRequestFailure', () {
      final failure = const UnknownNetworkFailure().toTestsFailure();

      expect(failure, isA<TestsRequestFailure>());
      expect(failure.message, const UnknownNetworkFailure().message);
    });
  });
}
