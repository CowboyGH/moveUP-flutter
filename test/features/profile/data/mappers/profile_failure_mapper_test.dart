import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/core/constants/app_strings.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/failures/network/network_failure.dart';
import 'package:moveup_flutter/features/profile/data/mappers/profile_failure_mapper.dart';

void main() {
  group('ProfileFailureMapper.toProfileFailure', () {
    test('maps validation_failed to ProfileValidationFailure with validation message', () {
      const failure = ValidationFailure(
        errors: {
          'email': ['error_message'],
        },
      );

      final result = failure.toProfileFailure();

      expect(result, isA<ProfileValidationFailure>());
      expect(result.message, 'error_message');
    });

    test('falls back to generic profile validation message when field errors are empty', () {
      final result = const ValidationFailure().toProfileFailure();

      expect(result, isA<ProfileValidationFailure>());
      expect(result.message, AppStrings.profileValidationFailed);
    });

    test('maps NoNetworkFailure to ProfileRequestFailure', () {
      final result = const NoNetworkFailure().toProfileFailure();

      expect(result, isA<ProfileRequestFailure>());
      expect(result.message, const NoNetworkFailure().message);
    });

    test('maps ConnectionTimeoutFailure to ProfileRequestFailure', () {
      final result = const ConnectionTimeoutFailure().toProfileFailure();

      expect(result, isA<ProfileRequestFailure>());
      expect(result.message, const ConnectionTimeoutFailure().message);
    });

    test('maps ServerErrorFailure to ProfileRequestFailure', () {
      final result = const ServerErrorFailure().toProfileFailure();

      expect(result, isA<ProfileRequestFailure>());
      expect(result.message, const ServerErrorFailure().message);
    });

    test('maps UnknownNetworkFailure to ProfileRequestFailure', () {
      final result = const UnknownNetworkFailure().toProfileFailure();

      expect(result, isA<ProfileRequestFailure>());
      expect(result.message, const UnknownNetworkFailure().message);
    });

    test('maps auth-session and access failures to ProfileRequestFailure', () {
      const failures = <NetworkFailure>[
        UnauthorizedFailure(code: 'token_expired'),
        UnauthorizedFailure(code: 'session_expired_inactivity'),
        UnauthorizedFailure(code: 'session_expired_absolute'),
        UnauthorizedFailure(),
        ForbiddenFailure(),
      ];

      for (final failure in failures) {
        final result = failure.toProfileFailure();

        expect(result, isA<ProfileRequestFailure>());
        expect(result.message, failure.message);
      }
    });
  });
}
