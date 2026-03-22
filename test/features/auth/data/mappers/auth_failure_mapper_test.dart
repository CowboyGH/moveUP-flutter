import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/core/constants/app_strings.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/failures/network/network_failure.dart';
import 'package:moveup_flutter/features/auth/data/mappers/auth_failure_mapper.dart';

void main() {
  group('AuthFailureMapper.toAuthFailure', () {
    test('maps invalid_credentials to InvalidCredentialsFailure', () {
      final failure = const UnauthorizedFailure(code: 'invalid_credentials').toAuthFailure();
      expect(failure, isA<InvalidCredentialsFailure>());
    });

    test('maps validation_failed to ValidationFailedFailure with validation message', () {
      final failure = const ValidationFailure(
        errors: {
          'email': ['error_message'],
        },
      ).toAuthFailure();

      expect(failure, isA<ValidationFailedFailure>());
      expect(failure.message, 'error_message');
    });

    test('falls back to generic auth validation message when field errors are empty', () {
      final failure = const ValidationFailure().toAuthFailure();

      expect(failure, isA<ValidationFailedFailure>());
      expect(failure.message, AppStrings.authValidationFailed);
    });

    test('maps email_already_verified to EmailAlreadyVerifiedFailure', () {
      final failure = const BadRequestFailure(code: 'email_already_verified').toAuthFailure();
      expect(failure, isA<EmailAlreadyVerifiedFailure>());
    });

    test('maps email_not_verified to EmailNotVerifiedFailure', () {
      final failure = const BadRequestFailure(code: 'email_not_verified').toAuthFailure();
      expect(failure, isA<EmailNotVerifiedFailure>());
    });

    test('maps rate_limited to AuthRateLimitedFailure', () {
      final failure = const RateLimitedFailure().toAuthFailure();
      expect(failure, isA<AuthRateLimitedFailure>());
    });

    test('maps NoNetworkFailure to AuthRequestFailure with network message', () {
      final failure = const NoNetworkFailure().toAuthFailure();

      expect(failure, isA<AuthRequestFailure>());
      expect(failure.message, const NoNetworkFailure().message);
    });

    test('maps ConnectionTimeoutFailure to AuthRequestFailure with network message', () {
      final failure = const ConnectionTimeoutFailure().toAuthFailure();

      expect(failure, isA<AuthRequestFailure>());
      expect(failure.message, const ConnectionTimeoutFailure().message);
    });

    test('maps ServerErrorFailure to AuthRequestFailure with network message', () {
      final failure = const ServerErrorFailure().toAuthFailure();

      expect(failure, isA<AuthRequestFailure>());
      expect(failure.message, const ServerErrorFailure().message);
    });

    test('maps UnknownNetworkFailure to AuthRequestFailure with network message', () {
      final failure = const UnknownNetworkFailure().toAuthFailure();

      expect(failure, isA<AuthRequestFailure>());
      expect(failure.message, const UnknownNetworkFailure().message);
    });

    test('maps auth-session and access codes to UnauthorizedAuthFailure', () {
      const unauthorizedCodes = <String>[
        'token_expired',
        'session_expired_inactivity',
        'session_expired_absolute',
        'unauthorized',
        'forbidden',
      ];

      for (final code in unauthorizedCodes) {
        final failure = UnauthorizedFailure(code: code).toAuthFailure();
        expect(failure, isA<UnauthorizedAuthFailure>());
      }
    });

    test(
      'maps not_found to UnknownAuthFailure (out of range code) to avoid user enumeration',
      () {
        final failure = const NotFoundFailure().toAuthFailure();
        expect(failure, isA<UnknownAuthFailure>());
      },
    );
  });
}
