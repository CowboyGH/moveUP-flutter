import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/workouts/workouts_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/workouts/data/remote/workouts_api_client.dart';
import 'package:moveup_flutter/features/workouts/execution/data/repositories/workout_execution_repository_impl.dart';
import 'package:moveup_flutter/features/workouts/execution/domain/entities/workout_execution_entry_mode.dart';
import 'package:moveup_flutter/features/workouts/execution/domain/entities/workout_exercise_reaction.dart';
import 'package:moveup_flutter/features/workouts/execution/domain/repositories/workout_execution_repository.dart';

import '../../../support/workouts_dto_fixtures.dart';
import 'workout_execution_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<WorkoutsApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockWorkoutsApiClient apiClient;
  late WorkoutExecutionRepository repository;

  const userWorkoutId = 1;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockWorkoutsApiClient();
    repository = WorkoutExecutionRepositoryImpl(logger, apiClient);
  });

  group('WorkoutExecutionRepositoryImpl', () {
    group('startExecution', () {
      test('returns warmup step when assigned workout starts with warmup', () async {
        // Arrange
        final detailsResponse = createWorkoutDetailsResponseDto(status: 'assigned');
        final startResponse = createWorkoutExecutionWarmupResponseDto();
        when(apiClient.getWorkoutDetails(userWorkoutId)).thenAnswer((_) async => detailsResponse);
        when(
          apiClient.startWorkout({
            'workout_id': detailsResponse.data.workout.id,
            'with_warmup': true,
          }),
        ).thenAnswer((_) async => startResponse);

        // Act
        final result = await repository.startExecution(
          userWorkoutId: userWorkoutId,
          entryMode: WorkoutExecutionEntryMode.warmup,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.success,
          createWorkoutExecutionStart(currentStep: createWorkoutWarmupStep()),
        );

        verifyInOrder([
          apiClient.getWorkoutDetails(userWorkoutId),
          apiClient.startWorkout({
            'workout_id': detailsResponse.data.workout.id,
            'with_warmup': true,
          }),
        ]);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns exercise step when assigned workout starts without warmup', () async {
        // Arrange
        final detailsResponse = createWorkoutDetailsResponseDto(status: 'assigned');
        final startResponse = createWorkoutExecutionExerciseResponseDto();
        when(apiClient.getWorkoutDetails(userWorkoutId)).thenAnswer((_) async => detailsResponse);
        when(
          apiClient.startWorkout({
            'workout_id': detailsResponse.data.workout.id,
            'with_warmup': false,
          }),
        ).thenAnswer((_) async => startResponse);

        // Act
        final result = await repository.startExecution(
          userWorkoutId: userWorkoutId,
          entryMode: WorkoutExecutionEntryMode.workout,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.success,
          createWorkoutExecutionStart(currentStep: createWorkoutExerciseStep()),
        );

        verifyInOrder([
          apiClient.getWorkoutDetails(userWorkoutId),
          apiClient.startWorkout({
            'workout_id': detailsResponse.data.workout.id,
            'with_warmup': false,
          }),
        ]);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns warmup step when started workout enters through warmup', () async {
        // Arrange
        final detailsResponse = createWorkoutDetailsResponseDto();
        final startResponse = createWorkoutExecutionWarmupResponseDto();
        when(apiClient.getWorkoutDetails(userWorkoutId)).thenAnswer((_) async => detailsResponse);
        when(apiClient.startWarmup(userWorkoutId)).thenAnswer((_) async => startResponse);

        // Act
        final result = await repository.startExecution(
          userWorkoutId: userWorkoutId,
          entryMode: WorkoutExecutionEntryMode.warmup,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.success,
          createWorkoutExecutionStart(currentStep: createWorkoutWarmupStep()),
        );

        verifyInOrder([
          apiClient.getWorkoutDetails(userWorkoutId),
          apiClient.startWarmup(userWorkoutId),
        ]);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns exercise step when started workout enters through workout', () async {
        // Arrange
        final detailsResponse = createWorkoutDetailsResponseDto();
        final startResponse = createWorkoutExecutionExerciseResponseDto();
        when(apiClient.getWorkoutDetails(userWorkoutId)).thenAnswer((_) async => detailsResponse);
        when(apiClient.completeWarmup(userWorkoutId)).thenAnswer((_) async => startResponse);

        // Act
        final result = await repository.startExecution(
          userWorkoutId: userWorkoutId,
          entryMode: WorkoutExecutionEntryMode.workout,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.success,
          createWorkoutExecutionStart(currentStep: createWorkoutExerciseStep()),
        );

        verifyInOrder([
          apiClient.getWorkoutDetails(userWorkoutId),
          apiClient.completeWarmup(userWorkoutId),
        ]);
        verifyNoMoreInteractions(apiClient);
      });

      test(
        'falls back to requested userWorkoutId when execution payload does not provide it',
        () async {
          // Arrange
          final detailsResponse = createWorkoutDetailsResponseDto(status: 'assigned');
          final startResponse = createWorkoutExecutionWarmupResponseDto(userWorkoutId: null);
          when(apiClient.getWorkoutDetails(userWorkoutId)).thenAnswer((_) async => detailsResponse);
          when(
            apiClient.startWorkout({
              'workout_id': detailsResponse.data.workout.id,
              'with_warmup': true,
            }),
          ).thenAnswer((_) async => startResponse);

          // Act
          final result = await repository.startExecution(
            userWorkoutId: userWorkoutId,
            entryMode: WorkoutExecutionEntryMode.warmup,
          );

          // Assert
          expect(result.isSuccess, isTrue);
          expect(
            result.success,
            createWorkoutExecutionStart(
              currentStep: createWorkoutWarmupStep(),
            ),
          );

          verifyInOrder([
            apiClient.getWorkoutDetails(userWorkoutId),
            apiClient.startWorkout({
              'workout_id': detailsResponse.data.workout.id,
              'with_warmup': true,
            }),
          ]);
          verifyNoMoreInteractions(apiClient);
        },
      );

      test('returns WorkoutsRequestFailure when api request fails', () async {
        // Arrange
        final exception = createWorkoutsDioBadResponseException(
          path: '/workout-execution/$userWorkoutId',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.getWorkoutDetails(userWorkoutId)).thenThrow(exception);

        // Act
        final result = await repository.startExecution(
          userWorkoutId: userWorkoutId,
          entryMode: WorkoutExecutionEntryMode.warmup,
        );

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<WorkoutsRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getWorkoutDetails(userWorkoutId)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns ActiveWorkoutExistsFailure when assigned workout start conflicts', () async {
        // Arrange
        final detailsResponse = createWorkoutDetailsResponseDto(status: 'assigned');
        final exception = createWorkoutsDioBadResponseException(
          path: '/workouts/start',
          statusCode: 409,
          code: 'conflict',
        );
        when(apiClient.getWorkoutDetails(userWorkoutId)).thenAnswer((_) async => detailsResponse);
        when(
          apiClient.startWorkout({
            'workout_id': detailsResponse.data.workout.id,
            'with_warmup': true,
          }),
        ).thenThrow(exception);

        // Act
        final result = await repository.startExecution(
          userWorkoutId: userWorkoutId,
          entryMode: WorkoutExecutionEntryMode.warmup,
        );

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<ActiveWorkoutExistsFailure>());

        verifyInOrder([
          apiClient.getWorkoutDetails(userWorkoutId),
          apiClient.startWorkout({
            'workout_id': detailsResponse.data.workout.id,
            'with_warmup': true,
          }),
        ]);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('nextWarmup', () {
      test('returns next warmup step when backend provides a warmup', () async {
        // Arrange
        when(
          apiClient.nextWarmup(userWorkoutId, {'current_warmup_id': 1}),
        ).thenAnswer((_) async => createWorkoutExecutionWarmupResponseDto(warmupId: 2));

        // Act
        final result = await repository.nextWarmup(
          userWorkoutId: userWorkoutId,
          currentWarmupId: 1,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, createWorkoutWarmupStep(id: 2));

        verify(
          apiClient.nextWarmup(userWorkoutId, {'current_warmup_id': 1}),
        ).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns exercise step when warmups are exhausted', () async {
        // Arrange
        when(
          apiClient.nextWarmup(userWorkoutId, {'current_warmup_id': 2}),
        ).thenAnswer((_) async => createWorkoutExecutionExerciseResponseDto());

        // Act
        final result = await repository.nextWarmup(
          userWorkoutId: userWorkoutId,
          currentWarmupId: 2,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, createWorkoutExerciseStep());

        verify(
          apiClient.nextWarmup(userWorkoutId, {'current_warmup_id': 2}),
        ).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns WorkoutsRequestFailure when api request fails', () async {
        // Arrange
        final exception = createWorkoutsDioBadResponseException(
          path: '/workout-execution/$userWorkoutId/next-warmup',
          statusCode: 500,
          code: 'server_error',
        );
        when(
          apiClient.nextWarmup(userWorkoutId, {'current_warmup_id': 1}),
        ).thenThrow(exception);

        // Act
        final result = await repository.nextWarmup(
          userWorkoutId: userWorkoutId,
          currentWarmupId: 1,
        );

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<WorkoutsRequestFailure>());

        verify(
          apiClient.nextWarmup(userWorkoutId, {'current_warmup_id': 1}),
        ).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('skipWarmup', () {
      test('returns first exercise after completing warmup', () async {
        // Arrange
        when(apiClient.completeWarmup(userWorkoutId)).thenAnswer(
          (_) async => createWorkoutExecutionExerciseResponseDto(),
        );

        // Act
        final result = await repository.skipWarmup(userWorkoutId);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, createWorkoutExerciseStep());

        verify(apiClient.completeWarmup(userWorkoutId)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns WorkoutsRequestFailure when api request fails', () async {
        // Arrange
        final exception = createWorkoutsDioBadResponseException(
          path: '/workout-execution/$userWorkoutId/complete-warmup',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.completeWarmup(userWorkoutId)).thenThrow(exception);

        // Act
        final result = await repository.skipWarmup(userWorkoutId);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<WorkoutsRequestFailure>());

        verify(apiClient.completeWarmup(userWorkoutId)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('saveExerciseResult', () {
      test('returns next exercise when backend provides next_exercise', () async {
        // Arrange
        when(
          apiClient.saveExerciseResult(userWorkoutId, argThat(isA<Object>())),
        ).thenAnswer(
          (_) async => createSaveExerciseResultNextExerciseResponseDto(
            adjustment: createSaveExerciseResultAdjustmentDto(),
          ),
        );

        // Act
        final result = await repository.saveExerciseResult(
          userWorkoutId: userWorkoutId,
          exerciseId: 21,
          reaction: WorkoutExerciseReaction.good,
          weightUsed: 50,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.success,
          createWorkoutExecutionNextExerciseResult(
            adjustment: createWorkoutLoadAdjustment(),
          ),
        );

        verify(apiClient.saveExerciseResult(userWorkoutId, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns awaiting completion when all exercises are completed', () async {
        // Arrange
        when(apiClient.saveExerciseResult(userWorkoutId, any)).thenAnswer(
          (_) async => createSaveExerciseResultCompletedResponseDto(
            adjustment: createSaveExerciseResultAdjustmentDto(),
          ),
        );

        // Act
        final result = await repository.saveExerciseResult(
          userWorkoutId: userWorkoutId,
          exerciseId: 21,
          reaction: WorkoutExerciseReaction.normal,
          weightUsed: 50,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.success,
          createWorkoutExecutionAwaitingCompletionResult(
            adjustment: createWorkoutLoadAdjustment(),
          ),
        );

        verify(apiClient.saveExerciseResult(userWorkoutId, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns WorkoutsRequestFailure when api request fails', () async {
        // Arrange
        final exception = createWorkoutsDioBadResponseException(
          path: '/workout-execution/$userWorkoutId/save-exercise-result',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.saveExerciseResult(userWorkoutId, any)).thenThrow(exception);

        // Act
        final result = await repository.saveExerciseResult(
          userWorkoutId: userWorkoutId,
          exerciseId: 21,
          reaction: WorkoutExerciseReaction.good,
          weightUsed: 50,
        );

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<WorkoutsRequestFailure>());

        verify(apiClient.saveExerciseResult(userWorkoutId, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('completeWorkout', () {
      test('returns success(null) when api succeeds', () async {
        // Arrange
        when(apiClient.completeWorkout(userWorkoutId)).thenAnswer((_) async {});

        // Act
        final result = await repository.completeWorkout(userWorkoutId);

        // Assert
        expect(result.isSuccess, isTrue);
        verify(apiClient.completeWorkout(userWorkoutId)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns WorkoutsRequestFailure when api request fails', () async {
        // Arrange
        final exception = createWorkoutsDioBadResponseException(
          path: '/workout-execution/$userWorkoutId/complete',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.completeWorkout(userWorkoutId)).thenThrow(exception);

        // Act
        final result = await repository.completeWorkout(userWorkoutId);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<WorkoutsRequestFailure>());

        verify(apiClient.completeWorkout(userWorkoutId)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownWorkoutsFailure when unexpected exception occurs', () async {
        // Arrange
        final exception = Exception('unexpected_error');
        when(apiClient.completeWorkout(userWorkoutId)).thenThrow(exception);

        // Act
        final result = await repository.completeWorkout(userWorkoutId);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownWorkoutsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.completeWorkout(userWorkoutId)).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('abandonWorkout', () {
      test('returns success(null) when api succeeds', () async {
        // Arrange
        when(apiClient.abandonWorkout(userWorkoutId)).thenAnswer((_) async {});

        // Act
        final result = await repository.abandonWorkout(userWorkoutId);

        // Assert
        expect(result.isSuccess, isTrue);
        verify(apiClient.abandonWorkout(userWorkoutId)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns WorkoutsRequestFailure when api request fails', () async {
        // Arrange
        final exception = createWorkoutsDioBadResponseException(
          path: '/workouts/$userWorkoutId/abandon',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.abandonWorkout(userWorkoutId)).thenThrow(exception);

        // Act
        final result = await repository.abandonWorkout(userWorkoutId);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<WorkoutsRequestFailure>());

        verify(apiClient.abandonWorkout(userWorkoutId)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownWorkoutsFailure when unexpected exception occurs', () async {
        // Arrange
        final exception = Exception('unexpected_error');
        when(apiClient.abandonWorkout(userWorkoutId)).thenThrow(exception);

        // Act
        final result = await repository.abandonWorkout(userWorkoutId);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownWorkoutsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.abandonWorkout(userWorkoutId)).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });
  });
}
