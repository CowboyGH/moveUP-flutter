import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/workouts/workouts_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/workouts/data/remote/workouts_api_client.dart';
import 'package:moveup_flutter/features/workouts/overview/data/repositories/workouts_overview_repository_impl.dart';
import 'package:moveup_flutter/features/workouts/overview/domain/repositories/workouts_overview_repository.dart';

import '../../../support/workouts_dto_fixtures.dart';
import 'workouts_overview_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<WorkoutsApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockWorkoutsApiClient apiClient;
  late WorkoutsOverviewRepository repository;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockWorkoutsApiClient();
    repository = WorkoutsOverviewRepositoryImpl(logger, apiClient);
  });

  group('WorkoutsOverviewRepositoryImpl', () {
    group('WorkoutsOverviewRepositoryImpl.getWorkouts', () {
      test('returns success(items) when api succeeds', () async {
        final responseDto = createWorkoutsResponseDto();
        final expectedItems = createWorkoutOverviewItems();
        when(apiClient.getWorkouts()).thenAnswer((_) async => responseDto);

        final result = await repository.getWorkouts();

        expect(result.isSuccess, isTrue);
        expect(result.success, expectedItems);
        expect(result.success!.first.status, 'started');
        expect(result.success!.last.status, 'assigned');

        verify(apiClient.getWorkouts()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns WorkoutsRequestFailure when api returns server error', () async {
        final exception = createWorkoutsDioBadResponseException(
          path: '/workouts',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.getWorkouts()).thenThrow(exception);

        final result = await repository.getWorkouts();

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<WorkoutsRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getWorkouts()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownWorkoutsFailure when unexpected exception occurs', () async {
        final exception = Exception('unexpected_error');
        when(apiClient.getWorkouts()).thenThrow(exception);

        final result = await repository.getWorkouts();

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownWorkoutsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getWorkouts()).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });
  });
}
