import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/workouts/workouts_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/workouts/overview/domain/entities/workout_overview_item.dart';
import 'package:moveup_flutter/features/workouts/overview/domain/repositories/workouts_overview_repository.dart';
import 'package:moveup_flutter/features/workouts/overview/presentation/cubits/workouts_overview_cubit.dart';

import 'workouts_overview_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WorkoutsOverviewRepository>()])
void main() {
  late MockWorkoutsOverviewRepository repository;
  late WorkoutsOverviewCubit workoutsOverviewCubit;

  const items = [
    WorkoutOverviewItem(
      userWorkoutId: 1,
      isStarted: true,
      isBlockedByActiveWorkout: false,
      title: 'title',
      description: 'description',
      durationMinutes: 1,
      imageUrl: 'test.png',
    ),
  ];

  setUp(() {
    repository = MockWorkoutsOverviewRepository();
    workoutsOverviewCubit = WorkoutsOverviewCubit(repository);
    provideDummy<Result<List<WorkoutOverviewItem>, WorkoutsFailure>>(
      const Success<List<WorkoutOverviewItem>, WorkoutsFailure>(items),
    );
  });

  group('WorkoutsOverviewCubit', () {
    const workoutsFailure = WorkoutsRequestFailure('error_message');

    blocTest<WorkoutsOverviewCubit, WorkoutsOverviewState>(
      'emits inProgress only once when loadWorkouts is called twice',
      setUp: () => when(repository.getWorkouts()).thenAnswer(
        (_) async => const Success<List<WorkoutOverviewItem>, WorkoutsFailure>(items),
      ),
      build: () => workoutsOverviewCubit,
      act: (cubit) {
        cubit.loadWorkouts();
        cubit.loadWorkouts();
      },
      expect: () => const [
        WorkoutsOverviewState.inProgress(),
        WorkoutsOverviewState.loaded(items),
      ],
      verify: (_) => verify(repository.getWorkouts()).called(1),
    );

    blocTest<WorkoutsOverviewCubit, WorkoutsOverviewState>(
      'emits loaded(items) when load-workouts is succeed',
      setUp: () => when(repository.getWorkouts()).thenAnswer(
        (_) async => const Success<List<WorkoutOverviewItem>, WorkoutsFailure>(items),
      ),
      build: () => workoutsOverviewCubit,
      act: (cubit) => cubit.loadWorkouts(),
      expect: () => const [
        WorkoutsOverviewState.inProgress(),
        WorkoutsOverviewState.loaded(items),
      ],
      verify: (_) => verify(repository.getWorkouts()).called(1),
    );

    blocTest<WorkoutsOverviewCubit, WorkoutsOverviewState>(
      'emits failed(workoutsFailure) when load-workouts is failed',
      setUp: () => when(repository.getWorkouts()).thenAnswer(
        (_) async => const Failure<List<WorkoutOverviewItem>, WorkoutsFailure>(workoutsFailure),
      ),
      build: () => workoutsOverviewCubit,
      act: (cubit) => cubit.loadWorkouts(),
      expect: () => const [
        WorkoutsOverviewState.inProgress(),
        WorkoutsOverviewState.failed(workoutsFailure),
      ],
      verify: (_) => verify(repository.getWorkouts()).called(1),
    );
  });
}
