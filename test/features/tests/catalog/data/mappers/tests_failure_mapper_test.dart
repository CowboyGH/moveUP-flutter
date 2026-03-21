import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/core/failures/feature/tests/tests_failure.dart';
import 'package:moveup_flutter/core/failures/network/network_failure.dart';
import 'package:moveup_flutter/features/tests/catalog/data/mappers/tests_failure_mapper.dart';

void main() {
  group('TestsFailureMapper.toTestsFailure', () {
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

    test('maps ValidationFailure to TestsValidationFailure', () {
      final failure = const ValidationFailure().toTestsFailure();

      expect(failure, isA<TestsValidationFailure>());
      expect(failure.message, const TestsValidationFailure().message);
    });
  });
}
