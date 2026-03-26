import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/tests/tests_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/tests/attempt/domain/entities/test_attempt_result.dart';
import 'package:moveup_flutter/features/tests/attempt/domain/entities/test_attempt_start.dart';
import 'package:moveup_flutter/features/tests/attempt/domain/repositories/test_attempt_repository.dart';
import 'package:moveup_flutter/features/tests/attempt/presentation/cubits/test_attempt_cubit.dart';

import '../../support/test_attempt_dto_fixtures.dart';
import 'test_attempt_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TestAttemptRepository>()])
void main() {
  late MockTestAttemptRepository repository;
  late TestAttemptCubit cubit;
  late TestAttemptStart startedAttempt;
  late TestAttemptResult nextExerciseResult;
  late TestAttemptResult awaitingPulseResult;

  setUp(() {
    repository = MockTestAttemptRepository();
    cubit = TestAttemptCubit(repository);
    startedAttempt = createTestAttemptStart();
    nextExerciseResult = createTestAttemptNextExerciseResult();
    awaitingPulseResult = createTestAttemptAwaitingPulseResult();

    provideDummy<Result<TestAttemptStart, TestsFailure>>(Success(startedAttempt));
    provideDummy<Result<TestAttemptResult, TestsFailure>>(Success(nextExerciseResult));
    provideDummy<Result<void, TestsFailure>>(const Success(null));
  });

  group('TestAttemptCubit', () {
    const requestFailure = TestsRequestFailure('request_failed');

    blocTest<TestAttemptCubit, TestAttemptState>(
      'startTest emits inProgress only once when called twice',
      setUp: () => when(repository.startTest(8)).thenAnswer((_) async => Success(startedAttempt)),
      build: () => cubit,
      act: (cubit) {
        cubit.startTest(8);
        cubit.startTest(8);
      },
      expect: () => [
        const TestAttemptState(isStarting: true),
        TestAttemptState(
          attemptId: startedAttempt.attemptId,
          testing: startedAttempt.testing,
          currentExercise: startedAttempt.currentExercise,
        ),
      ],
      verify: (_) => verify(repository.startTest(8)).called(1),
    );

    blocTest<TestAttemptCubit, TestAttemptState>(
      'startTest emits failure when repository fails',
      setUp: () =>
          when(repository.startTest(8)).thenAnswer((_) async => const Failure(requestFailure)),
      build: () => cubit,
      act: (cubit) => cubit.startTest(8),
      expect: () => const [
        TestAttemptState(isStarting: true),
        TestAttemptState(failure: requestFailure),
      ],
      verify: (_) => verify(repository.startTest(8)).called(1),
    );

    blocTest<TestAttemptCubit, TestAttemptState>(
      'submitResult advances to the next exercise on success',
      setUp: () => when(
        repository.saveResult(
          attemptId: startedAttempt.attemptId,
          testingExerciseId: startedAttempt.currentExercise.id,
          resultValue: 2,
        ),
      ).thenAnswer((_) async => Success(nextExerciseResult)),
      build: () => cubit,
      seed: () => TestAttemptState(
        attemptId: startedAttempt.attemptId,
        testing: startedAttempt.testing,
        currentExercise: startedAttempt.currentExercise,
      ),
      act: (cubit) => cubit.submitResult(2),
      expect: () => [
        TestAttemptState(
          attemptId: startedAttempt.attemptId,
          testing: startedAttempt.testing,
          currentExercise: startedAttempt.currentExercise,
          isSubmittingResult: true,
        ),
        TestAttemptState(
          attemptId: startedAttempt.attemptId,
          testing: startedAttempt.testing,
          currentExercise: nextExerciseResult.nextExercise,
        ),
      ],
      verify: (_) => verify(
        repository.saveResult(
          attemptId: startedAttempt.attemptId,
          testingExerciseId: startedAttempt.currentExercise.id,
          resultValue: 2,
        ),
      ).called(1),
    );

    blocTest<TestAttemptCubit, TestAttemptState>(
      'submitResult switches to pulse step on last exercise',
      setUp: () => when(
        repository.saveResult(
          attemptId: startedAttempt.attemptId,
          testingExerciseId: startedAttempt.currentExercise.id,
          resultValue: 4,
        ),
      ).thenAnswer((_) async => Success(awaitingPulseResult)),
      build: () => cubit,
      seed: () => TestAttemptState(
        attemptId: startedAttempt.attemptId,
        testing: startedAttempt.testing,
        currentExercise: startedAttempt.currentExercise,
      ),
      act: (cubit) => cubit.submitResult(4),
      expect: () => [
        TestAttemptState(
          attemptId: startedAttempt.attemptId,
          testing: startedAttempt.testing,
          currentExercise: startedAttempt.currentExercise,
          isSubmittingResult: true,
        ),
        TestAttemptState(
          attemptId: startedAttempt.attemptId,
          testing: startedAttempt.testing,
          currentExercise: startedAttempt.currentExercise,
          isAwaitingPulse: true,
        ),
      ],
      verify: (_) => verify(
        repository.saveResult(
          attemptId: startedAttempt.attemptId,
          testingExerciseId: startedAttempt.currentExercise.id,
          resultValue: 4,
        ),
      ).called(1),
    );

    blocTest<TestAttemptCubit, TestAttemptState>(
      'submitResult emits failure and preserves attempt context when repository fails',
      setUp: () => when(
        repository.saveResult(
          attemptId: startedAttempt.attemptId,
          testingExerciseId: startedAttempt.currentExercise.id,
          resultValue: 3,
        ),
      ).thenAnswer((_) async => const Failure(requestFailure)),
      build: () => cubit,
      seed: () => TestAttemptState(
        attemptId: startedAttempt.attemptId,
        testing: startedAttempt.testing,
        currentExercise: startedAttempt.currentExercise,
      ),
      act: (cubit) => cubit.submitResult(3),
      expect: () => [
        TestAttemptState(
          attemptId: startedAttempt.attemptId,
          testing: startedAttempt.testing,
          currentExercise: startedAttempt.currentExercise,
          isSubmittingResult: true,
        ),
        TestAttemptState(
          attemptId: startedAttempt.attemptId,
          testing: startedAttempt.testing,
          currentExercise: startedAttempt.currentExercise,
          failure: requestFailure,
        ),
      ],
      verify: (_) => verify(
        repository.saveResult(
          attemptId: startedAttempt.attemptId,
          testingExerciseId: startedAttempt.currentExercise.id,
          resultValue: 3,
        ),
      ).called(1),
    );

    blocTest<TestAttemptCubit, TestAttemptState>(
      'submitPulse emits completed state on success',
      setUp: () => when(
        repository.completeTest(
          attemptId: startedAttempt.attemptId,
          pulse: 151,
        ),
      ).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      seed: () => TestAttemptState(
        attemptId: startedAttempt.attemptId,
        testing: startedAttempt.testing,
        isAwaitingPulse: true,
      ),
      act: (cubit) => cubit.submitPulse(151),
      expect: () => [
        TestAttemptState(
          attemptId: startedAttempt.attemptId,
          testing: startedAttempt.testing,
          isAwaitingPulse: true,
          isCompleting: true,
        ),
        TestAttemptState(
          attemptId: startedAttempt.attemptId,
          testing: startedAttempt.testing,
          isCompleted: true,
        ),
      ],
      verify: (_) => verify(
        repository.completeTest(
          attemptId: startedAttempt.attemptId,
          pulse: 151,
        ),
      ).called(1),
    );

    blocTest<TestAttemptCubit, TestAttemptState>(
      'submitPulse emits failure when repository fails',
      setUp: () => when(
        repository.completeTest(
          attemptId: startedAttempt.attemptId,
          pulse: 151,
        ),
      ).thenAnswer((_) async => const Failure(requestFailure)),
      build: () => cubit,
      seed: () => TestAttemptState(
        attemptId: startedAttempt.attemptId,
        testing: startedAttempt.testing,
        isAwaitingPulse: true,
      ),
      act: (cubit) => cubit.submitPulse(151),
      expect: () => [
        TestAttemptState(
          attemptId: startedAttempt.attemptId,
          testing: startedAttempt.testing,
          isAwaitingPulse: true,
          isCompleting: true,
        ),
        TestAttemptState(
          attemptId: startedAttempt.attemptId,
          testing: startedAttempt.testing,
          isAwaitingPulse: true,
          failure: requestFailure,
        ),
      ],
      verify: (_) => verify(
        repository.completeTest(
          attemptId: startedAttempt.attemptId,
          pulse: 151,
        ),
      ).called(1),
    );

    blocTest<TestAttemptCubit, TestAttemptState>(
      'submitResult is no-op when attempt is already completed',
      build: () => cubit,
      seed: () => TestAttemptState(
        attemptId: startedAttempt.attemptId,
        testing: startedAttempt.testing,
        currentExercise: startedAttempt.currentExercise,
        isCompleted: true,
      ),
      act: (cubit) => cubit.submitResult(2),
      expect: () => const <TestAttemptState>[],
      verify: (_) => verifyNever(
        repository.saveResult(
          attemptId: anyNamed('attemptId'),
          testingExerciseId: anyNamed('testingExerciseId'),
          resultValue: anyNamed('resultValue'),
        ),
      ),
    );
  });
}
