import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/core/failures/feature/subscriptions/subscriptions_failure.dart';
import 'package:moveup_flutter/core/failures/network/network_failure.dart';
import 'package:moveup_flutter/features/subscriptions/data/mappers/subscriptions_failure_mapper.dart';

void main() {
  group('SubscriptionsFailureMapper.toSubscriptionsFailure', () {
    test('maps validation failure to SubscriptionsValidationFailure', () {
      final failure = const ValidationFailure(
        errors: {
          'cvv': ['invalid_cvv'],
        },
      ).toSubscriptionsFailure();

      expect(failure, isA<SubscriptionsValidationFailure>());
      expect(failure.message, 'invalid_cvv');
    });

    test('maps not found to generic SubscriptionsRequestFailure', () {
      final failure = const NotFoundFailure().toSubscriptionsFailure();

      expect(failure, isA<SubscriptionsRequestFailure>());
      expect(failure.message, const NotFoundFailure().message);
    });
  });

  group('SubscriptionsFailureMapper.toSanitizedPaymentFailure', () {
    test('maps validation failure without parentException', () {
      final failure = const ValidationFailure(
        errors: {
          'cvv': ['invalid_cvv'],
        },
      ).toSanitizedPaymentFailure();

      expect(failure, isA<SubscriptionsValidationFailure>());
      expect(failure.message, 'invalid_cvv');
      expect(failure.parentException, isNull);
    });

    test('maps request failure without parentException', () {
      final failure = const ServerErrorFailure().toSanitizedPaymentFailure();

      expect(failure, isA<SubscriptionsRequestFailure>());
      expect(failure.message, const ServerErrorFailure().message);
      expect(failure.parentException, isNull);
    });
  });
}
