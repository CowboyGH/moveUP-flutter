import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/core/constants/app_strings.dart';
import 'package:moveup_flutter/core/failures/feature/phases/phases_failure.dart';
import 'package:moveup_flutter/core/failures/network/network_failure.dart';
import 'package:moveup_flutter/features/phases/data/mappers/phases_failure_mapper.dart';

void main() {
  group('PhasesFailureMapper.toPhasesFailure', () {
    test('maps validation_failed to PhasesValidationFailure with validation message', () {
      const failure = ValidationFailure(
        errors: {
          'weekly_goal': ['error_message'],
        },
      );

      final result = failure.toPhasesFailure();

      expect(result, isA<PhasesValidationFailure>());
      expect(result.message, 'error_message');
    });

    test('falls back to generic phases validation message when field errors are empty', () {
      final result = const ValidationFailure().toPhasesFailure();

      expect(result, isA<PhasesValidationFailure>());
      expect(result.message, AppStrings.phasesValidationFailed);
    });

    test('maps NoNetworkFailure to PhasesRequestFailure', () {
      final result = const NoNetworkFailure().toPhasesFailure();

      expect(result, isA<PhasesRequestFailure>());
      expect(result.message, const NoNetworkFailure().message);
    });

    test('maps ServerErrorFailure to PhasesRequestFailure', () {
      final result = const ServerErrorFailure().toPhasesFailure();

      expect(result, isA<PhasesRequestFailure>());
      expect(result.message, const ServerErrorFailure().message);
    });

    test('maps UnknownNetworkFailure to PhasesRequestFailure', () {
      final result = const UnknownNetworkFailure().toPhasesFailure();

      expect(result, isA<PhasesRequestFailure>());
      expect(result.message, const UnknownNetworkFailure().message);
    });
  });
}
