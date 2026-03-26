import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/core/failures/feature/workouts/workouts_failure.dart';
import 'package:moveup_flutter/core/failures/network/network_failure.dart';
import 'package:moveup_flutter/features/workouts/data/mappers/workouts_failure_mapper.dart';

void main() {
  group('WorkoutsFailureMapper.toWorkoutsFailure', () {
    test('maps NoNetworkFailure to WorkoutsRequestFailure', () {
      final result = const NoNetworkFailure().toWorkoutsFailure();

      expect(result, isA<WorkoutsRequestFailure>());
      expect(result.message, const NoNetworkFailure().message);
    });

    test('maps UnknownNetworkFailure to WorkoutsRequestFailure', () {
      final result = const UnknownNetworkFailure().toWorkoutsFailure();

      expect(result, isA<WorkoutsRequestFailure>());
      expect(result.message, const UnknownNetworkFailure().message);
    });
  });
}
