import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/core/constants/app_strings.dart';
import 'package:moveup_flutter/core/failures/feature/fitness_start/fitness_start_failure.dart';
import 'package:moveup_flutter/core/failures/network/network_failure.dart';
import 'package:moveup_flutter/features/fitness_start/data/mappers/fitness_start_failure_mapper.dart';

void main() {
  group('FitnessStartFailureMapper.toFitnessStartFailure', () {
    test('maps validation_failed to FitnessStartValidationFailure with multiline message', () {
      const failure = ValidationFailure(
        errors: {
          'age': ['  error_message_1  '],
          'weight': ['error_message_2', ''],
        },
      );

      final result = failure.toFitnessStartFailure();

      expect(result, isA<FitnessStartValidationFailure>());
      expect(result.message, 'error_message_1\nerror_message_2');
    });

    test('falls back to generic fitness-start validation message when field errors are empty', () {
      final result = const ValidationFailure().toFitnessStartFailure();

      expect(result, isA<FitnessStartValidationFailure>());
      expect(result.message, AppStrings.fitnessStartValidationFailed);
    });

    test('maps NoNetworkFailure to FitnessStartRequestFailure', () {
      final result = const NoNetworkFailure().toFitnessStartFailure();

      expect(result, isA<FitnessStartRequestFailure>());
      expect(result.message, const NoNetworkFailure().message);
    });

    test('maps ConnectionTimeoutFailure to FitnessStartRequestFailure', () {
      final result = const ConnectionTimeoutFailure().toFitnessStartFailure();

      expect(result, isA<FitnessStartRequestFailure>());
      expect(result.message, const ConnectionTimeoutFailure().message);
    });

    test('maps ServerErrorFailure to FitnessStartRequestFailure', () {
      final result = const ServerErrorFailure().toFitnessStartFailure();

      expect(result, isA<FitnessStartRequestFailure>());
      expect(result.message, const ServerErrorFailure().message);
    });

    test('maps UnknownNetworkFailure to FitnessStartRequestFailure', () {
      final result = const UnknownNetworkFailure().toFitnessStartFailure();

      expect(result, isA<FitnessStartRequestFailure>());
      expect(result.message, const UnknownNetworkFailure().message);
    });
  });
}
