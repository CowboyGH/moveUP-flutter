import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/workouts/workouts_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/workouts/data/remote/workouts_api_client.dart';
import 'package:moveup_flutter/features/workouts/details/data/repositories/workout_details_repository_impl.dart';
import 'package:moveup_flutter/features/workouts/details/domain/entities/workout_details_item.dart';
import 'package:moveup_flutter/features/workouts/details/domain/repositories/workout_details_repository.dart';

import '../../../support/workouts_dto_fixtures.dart';
import 'workout_details_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<WorkoutsApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockWorkoutsApiClient apiClient;
  late WorkoutDetailsRepository repository;

  const userWorkoutId = 1;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockWorkoutsApiClient();
    repository = WorkoutDetailsRepositoryImpl(logger, apiClient);
  });

  group('WorkoutDetailsRepositoryImpl', () {
    group('WorkoutDetailsRepositoryImpl.getWorkoutDetails', () {
      test('returns success(items) when api succeeds', () async {
        final responseDto = createWorkoutDetailsResponseDto();
        final expectedItems = createWorkoutDetailsItems();
        when(apiClient.getWorkoutDetails(userWorkoutId)).thenAnswer((_) async => responseDto);

        final result = await repository.getWorkoutDetails(userWorkoutId);

        expect(result.isSuccess, isTrue);
        expect(result.success, expectedItems);
        expect(result.success!.first.type, WorkoutDetailsItemType.warmup);
        expect(result.success!.last.type, WorkoutDetailsItemType.workout);

        verify(apiClient.getWorkoutDetails(userWorkoutId)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns WorkoutsRequestFailure when api returns server error', () async {
        final exception = createWorkoutsDioBadResponseException(
          path: '/workout-execution/$userWorkoutId',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.getWorkoutDetails(userWorkoutId)).thenThrow(exception);

        final result = await repository.getWorkoutDetails(userWorkoutId);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<WorkoutsRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getWorkoutDetails(userWorkoutId)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownWorkoutsFailure when unexpected exception occurs', () async {
        final exception = Exception('unexpected_error');
        when(apiClient.getWorkoutDetails(userWorkoutId)).thenThrow(exception);

        final result = await repository.getWorkoutDetails(userWorkoutId);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownWorkoutsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getWorkoutDetails(userWorkoutId)).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });
  });
}
