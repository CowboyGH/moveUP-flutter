import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/workouts/workouts_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/workouts/execution/domain/entities/workout_execution_entry_mode.dart';
import 'package:moveup_flutter/features/workouts/execution/domain/entities/workout_execution_result.dart';
import 'package:moveup_flutter/features/workouts/execution/domain/entities/workout_execution_start.dart';
import 'package:moveup_flutter/features/workouts/execution/domain/entities/workout_execution_step.dart';
import 'package:moveup_flutter/features/workouts/execution/domain/entities/workout_exercise_reaction.dart';
import 'package:moveup_flutter/features/workouts/execution/domain/repositories/workout_execution_repository.dart';
import 'package:moveup_flutter/features/workouts/execution/presentation/cubits/workout_execution_cubit.dart';

import '../../../support/workouts_dto_fixtures.dart';
import 'workout_execution_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WorkoutExecutionRepository>()])
void main() {
  late MockWorkoutExecutionRepository repository;
  late WorkoutExecutionCubit cubit;
  late WorkoutExecutionStart executionStart;
  late WorkoutExecutionStep warmupStep;
  late WorkoutExerciseStep exerciseStep;
  late WorkoutExecutionResult nextExerciseResult;
  late WorkoutExecutionResult awaitingCompletionResult;

  const userWorkoutId = 1;
  const exerciseId = 21;
  const double weightUsed = 1;

  setUp(() {
    repository = MockWorkoutExecutionRepository();
    cubit = WorkoutExecutionCubit(repository);
    warmupStep = createWorkoutWarmupStep();
    exerciseStep = createWorkoutExerciseStep();
    executionStart = createWorkoutExecutionStart(currentStep: warmupStep);
    nextExerciseResult = createWorkoutExecutionNextExerciseResult();
    awaitingCompletionResult = createWorkoutExecutionAwaitingCompletionResult();

    provideDummy<Result<WorkoutExecutionStart, WorkoutsFailure>>(Success(executionStart));
    provideDummy<Result<WorkoutExecutionStep, WorkoutsFailure>>(Success(warmupStep));
    provideDummy<Result<WorkoutExerciseStep, WorkoutsFailure>>(Success(exerciseStep));
    provideDummy<Result<WorkoutExecutionResult, WorkoutsFailure>>(Success(nextExerciseResult));
    provideDummy<Result<void, WorkoutsFailure>>(const Success(null));
  });

  group('WorkoutExecutionCubit', () {
    const workoutsFailure = WorkoutsRequestFailure('error_message');

    blocTest<WorkoutExecutionCubit, WorkoutExecutionState>(
      'startExecution emits inProgress only once when called twice',
      setUp: () => when(
        repository.startExecution(
          userWorkoutId: userWorkoutId,
          entryMode: WorkoutExecutionEntryMode.warmup,
        ),
      ).thenAnswer((_) async => Success(executionStart)),
      build: () => cubit,
      act: (cubit) {
        cubit.startExecution(1, WorkoutExecutionEntryMode.warmup);
        cubit.startExecution(1, WorkoutExecutionEntryMode.warmup);
      },
      expect: () => [
        const WorkoutExecutionState(isStarting: true, userWorkoutId: userWorkoutId),
        WorkoutExecutionState(userWorkoutId: userWorkoutId, currentStep: warmupStep),
      ],
      verify: (_) => verify(
        repository.startExecution(
          userWorkoutId: userWorkoutId,
          entryMode: WorkoutExecutionEntryMode.warmup,
        ),
      ).called(1),
    );

    blocTest<WorkoutExecutionCubit, WorkoutExecutionState>(
      'startExecution emits failure when repository fails',
      setUp: () => when(
        repository.startExecution(
          userWorkoutId: userWorkoutId,
          entryMode: WorkoutExecutionEntryMode.workout,
        ),
      ).thenAnswer((_) async => const Failure(workoutsFailure)),
      build: () => cubit,
      act: (cubit) => cubit.startExecution(1, WorkoutExecutionEntryMode.workout),
      expect: () => const [
        WorkoutExecutionState(isStarting: true, userWorkoutId: userWorkoutId),
        WorkoutExecutionState(userWorkoutId: userWorkoutId, failure: workoutsFailure),
      ],
      verify: (_) => verify(
        repository.startExecution(
          userWorkoutId: userWorkoutId,
          entryMode: WorkoutExecutionEntryMode.workout,
        ),
      ).called(1),
    );

    blocTest<WorkoutExecutionCubit, WorkoutExecutionState>(
      'nextWarmup switches current step to exercise on success',
      setUp: () => when(
        repository.nextWarmup(
          userWorkoutId: userWorkoutId,
          currentWarmupId: 1,
        ),
      ).thenAnswer((_) async => Success(exerciseStep)),
      build: () => cubit,
      seed: () => WorkoutExecutionState(
        userWorkoutId: userWorkoutId,
        currentStep: createWorkoutWarmupStep(),
      ),
      act: (cubit) => cubit.nextWarmup(),
      expect: () => [
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: createWorkoutWarmupStep(),
          isAdvancingWarmup: true,
        ),
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: exerciseStep,
        ),
      ],
      verify: (_) => verify(
        repository.nextWarmup(
          userWorkoutId: userWorkoutId,
          currentWarmupId: 1,
        ),
      ).called(1),
    );

    blocTest<WorkoutExecutionCubit, WorkoutExecutionState>(
      'skipWarmup updates current step to exercise on success',
      setUp: () => when(
        repository.skipWarmup(1),
      ).thenAnswer((_) async => Success(exerciseStep)),
      build: () => cubit,
      seed: () => WorkoutExecutionState(
        userWorkoutId: userWorkoutId,
        currentStep: warmupStep,
      ),
      act: (cubit) => cubit.skipWarmup(),
      expect: () => [
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: warmupStep,
          isAdvancingWarmup: true,
        ),
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: exerciseStep,
        ),
      ],
      verify: (_) => verify(repository.skipWarmup(1)).called(1),
    );

    blocTest<WorkoutExecutionCubit, WorkoutExecutionState>(
      'abandonWorkout sets shouldPopToDetails to true on success',
      setUp: () => when(
        repository.abandonWorkout(1),
      ).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      seed: () => WorkoutExecutionState(
        userWorkoutId: userWorkoutId,
        currentStep: warmupStep,
      ),
      act: (cubit) => cubit.abandonWorkout(),
      expect: () => [
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: warmupStep,
          isAbandoning: true,
        ),
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: warmupStep,
          shouldPopToDetails: true,
        ),
      ],
      verify: (_) => verify(repository.abandonWorkout(1)).called(1),
    );

    blocTest<WorkoutExecutionCubit, WorkoutExecutionState>(
      'abandonWorkout emits failure and preserves current step context when repository fails',
      setUp: () => when(
        repository.abandonWorkout(1),
      ).thenAnswer((_) async => const Failure(workoutsFailure)),
      build: () => cubit,
      seed: () => WorkoutExecutionState(
        userWorkoutId: userWorkoutId,
        currentStep: warmupStep,
      ),
      act: (cubit) => cubit.abandonWorkout(),
      expect: () => [
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: warmupStep,
          isAbandoning: true,
        ),
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: warmupStep,
          failure: workoutsFailure,
        ),
      ],
      verify: (_) => verify(repository.abandonWorkout(1)).called(1),
    );

    blocTest<WorkoutExecutionCubit, WorkoutExecutionState>(
      'abandonWorkout emits inProgress only once when called twice',
      setUp: () => when(
        repository.abandonWorkout(1),
      ).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      seed: () => WorkoutExecutionState(
        userWorkoutId: userWorkoutId,
        currentStep: warmupStep,
      ),
      act: (cubit) {
        cubit.abandonWorkout();
        cubit.abandonWorkout();
      },
      expect: () => [
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: warmupStep,
          isAbandoning: true,
        ),
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: warmupStep,
          shouldPopToDetails: true,
        ),
      ],
      verify: (_) => verify(repository.abandonWorkout(1)).called(1),
    );

    blocTest<WorkoutExecutionCubit, WorkoutExecutionState>(
      'submitReaction advances to next exercise on success',
      setUp: () => when(
        repository.saveExerciseResult(
          userWorkoutId: userWorkoutId,
          exerciseId: exerciseId,
          reaction: WorkoutExerciseReaction.good,
          weightUsed: weightUsed,
        ),
      ).thenAnswer((_) async => Success(nextExerciseResult)),
      build: () => cubit,
      seed: () => WorkoutExecutionState(
        userWorkoutId: userWorkoutId,
        currentStep: createWorkoutExerciseStep(),
      ),
      act: (cubit) => cubit.submitReaction(
        WorkoutExerciseReaction.good,
        weightUsed: weightUsed,
      ),
      expect: () => [
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: createWorkoutExerciseStep(),
          isSubmittingResult: true,
        ),
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: nextExerciseResult.nextExercise,
        ),
      ],
      verify: (_) => verify(
        repository.saveExerciseResult(
          userWorkoutId: userWorkoutId,
          exerciseId: exerciseId,
          reaction: WorkoutExerciseReaction.good,
          weightUsed: weightUsed,
        ),
      ).called(1),
    );

    test('consumePendingAdjustment returns latest adjustment only once', () async {
      // Arrange
      final adjustment = createWorkoutLoadAdjustment();
      when(
        repository.saveExerciseResult(
          userWorkoutId: userWorkoutId,
          exerciseId: exerciseId,
          reaction: WorkoutExerciseReaction.good,
          weightUsed: weightUsed,
        ),
      ).thenAnswer(
        (_) async => Success(
          createWorkoutExecutionNextExerciseResult(adjustment: adjustment),
        ),
      );
      cubit.emit(
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: createWorkoutExerciseStep(),
        ),
      );

      // Act
      await cubit.submitReaction(
        WorkoutExerciseReaction.good,
        weightUsed: weightUsed,
      );

      // Assert
      expect(cubit.consumePendingAdjustment(), adjustment);
      expect(cubit.consumePendingAdjustment(), isNull);
    });

    blocTest<WorkoutExecutionCubit, WorkoutExecutionState>(
      'submitReaction on last exercise triggers workout completion flow',
      setUp: () {
        when(
          repository.saveExerciseResult(
            userWorkoutId: userWorkoutId,
            exerciseId: exerciseId,
            reaction: WorkoutExerciseReaction.normal,
            weightUsed: weightUsed,
          ),
        ).thenAnswer((_) async => Success(awaitingCompletionResult));
        when(
          repository.completeWorkout(1),
        ).thenAnswer((_) async => const Success(null));
      },
      build: () => cubit,
      seed: () => WorkoutExecutionState(
        userWorkoutId: userWorkoutId,
        currentStep: createWorkoutExerciseStep(),
      ),
      act: (cubit) => cubit.submitReaction(
        WorkoutExerciseReaction.normal,
        weightUsed: weightUsed,
      ),
      expect: () => [
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: createWorkoutExerciseStep(),
          isSubmittingResult: true,
        ),
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: createWorkoutExerciseStep(),
        ),
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: createWorkoutExerciseStep(),
          isCompleting: true,
        ),
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: createWorkoutExerciseStep(),
          isCompleted: true,
        ),
      ],
      verify: (_) {
        verify(
          repository.saveExerciseResult(
            userWorkoutId: userWorkoutId,
            exerciseId: exerciseId,
            reaction: WorkoutExerciseReaction.normal,
            weightUsed: weightUsed,
          ),
        ).called(1);
        verify(repository.completeWorkout(1)).called(1);
      },
    );

    blocTest<WorkoutExecutionCubit, WorkoutExecutionState>(
      'completeWorkout emits completed state on success',
      setUp: () => when(
        repository.completeWorkout(1),
      ).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      seed: () => WorkoutExecutionState(
        userWorkoutId: userWorkoutId,
        currentStep: exerciseStep,
      ),
      act: (cubit) => cubit.completeWorkout(),
      expect: () => [
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: exerciseStep,
          isCompleting: true,
        ),
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: exerciseStep,
          isCompleted: true,
        ),
      ],
      verify: (_) => verify(repository.completeWorkout(1)).called(1),
    );

    blocTest<WorkoutExecutionCubit, WorkoutExecutionState>(
      'submitReaction emits failure and preserves current step context when repository fails',
      setUp: () => when(
        repository.saveExerciseResult(
          userWorkoutId: userWorkoutId,
          exerciseId: exerciseId,
          reaction: WorkoutExerciseReaction.bad,
          weightUsed: weightUsed,
        ),
      ).thenAnswer((_) async => const Failure(workoutsFailure)),
      build: () => cubit,
      seed: () => WorkoutExecutionState(
        userWorkoutId: userWorkoutId,
        currentStep: createWorkoutExerciseStep(),
      ),
      act: (cubit) => cubit.submitReaction(
        WorkoutExerciseReaction.bad,
        weightUsed: weightUsed,
      ),
      expect: () => [
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: createWorkoutExerciseStep(),
          isSubmittingResult: true,
        ),
        WorkoutExecutionState(
          userWorkoutId: userWorkoutId,
          currentStep: createWorkoutExerciseStep(),
          failure: workoutsFailure,
        ),
      ],
      verify: (_) => verify(
        repository.saveExerciseResult(
          userWorkoutId: userWorkoutId,
          exerciseId: exerciseId,
          reaction: WorkoutExerciseReaction.bad,
          weightUsed: weightUsed,
        ),
      ).called(1),
    );
  });
}
