import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/phases/phases_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/phases/data/remote/phases_api_client.dart';
import 'package:moveup_flutter/features/phases/data/repositories/phases_repository_impl.dart';
import 'package:moveup_flutter/features/phases/domain/repositories/phases_repository.dart';

import '../../support/phases_fixtures.dart';
import 'phases_repository_impl_update_weekly_goal_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<PhasesApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockPhasesApiClient apiClient;
  late PhasesRepository repository;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockPhasesApiClient();
    repository = PhasesRepositoryImpl(logger, apiClient);
  });

  group('PhasesRepositoryImpl.updateWeeklyGoal', () {
    test('returns success and sends weekly_goal when api succeeds', () async {
      when(apiClient.updateWeeklyGoal(any)).thenAnswer((_) async {});

      final result = await repository.updateWeeklyGoal(5);

      expect(result.isSuccess, isTrue);

      final captured = verify(apiClient.updateWeeklyGoal(captureAny)).captured.single;
      expect(captured, {'weekly_goal': 5});
      verifyNoMoreInteractions(apiClient);
    });

    test('returns PhasesValidationFailure when api returns validation error', () async {
      final exception = createPhasesDioBadResponseException(
        path: '/user/weekly-goal',
        statusCode: 422,
        code: 'validation_failed',
        errors: const {
          'weekly_goal': ['error_message'],
        },
      );
      when(apiClient.updateWeeklyGoal(any)).thenThrow(exception);

      final result = await repository.updateWeeklyGoal(5);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<PhasesValidationFailure>());
      expect(result.failure!.message, 'error_message');
      expect(result.failure!.parentException, exception);

      verify(apiClient.updateWeeklyGoal(any)).called(1);
      verifyNoMoreInteractions(apiClient);
    });

    test('returns UnknownPhasesFailure when unexpected exception occurs', () async {
      final exception = Exception('unexpected_error');
      when(apiClient.updateWeeklyGoal(any)).thenThrow(exception);

      final result = await repository.updateWeeklyGoal(5);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<UnknownPhasesFailure>());
      expect(result.failure!.parentException, exception);

      verify(apiClient.updateWeeklyGoal(any)).called(1);
      verifyNoMoreInteractions(apiClient);
    });
  });
}
