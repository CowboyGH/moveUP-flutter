import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/workouts/workouts_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/workouts/details/domain/entities/workout_details_item.dart';
import 'package:moveup_flutter/features/workouts/details/domain/repositories/workout_details_repository.dart';
import 'package:moveup_flutter/features/workouts/details/presentation/cubits/workout_details_cubit.dart';

import 'workout_details_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WorkoutDetailsRepository>()])
void main() {
  late MockWorkoutDetailsRepository repository;
  late WorkoutDetailsCubit workoutDetailsCubit;

  const userWorkoutId = 1;
  const items = [
    WorkoutDetailsItem(
      type: WorkoutDetailsItemType.warmup,
      title: 'title',
      description: 'description',
      durationMinutes: 5,
      imageUrl: 'test.png',
    ),
  ];

  setUp(() {
    repository = MockWorkoutDetailsRepository();
    workoutDetailsCubit = WorkoutDetailsCubit(repository);
    provideDummy<Result<List<WorkoutDetailsItem>, WorkoutsFailure>>(
      const Success<List<WorkoutDetailsItem>, WorkoutsFailure>(items),
    );
  });

  group('WorkoutDetailsCubit', () {
    const workoutsFailure = WorkoutsRequestFailure('error_message');

    blocTest<WorkoutDetailsCubit, WorkoutDetailsState>(
      'emits inProgress only once when loadWorkoutDetails is called twice',
      setUp: () => when(repository.getWorkoutDetails(userWorkoutId)).thenAnswer(
        (_) async => const Success<List<WorkoutDetailsItem>, WorkoutsFailure>(items),
      ),
      build: () => workoutDetailsCubit,
      act: (cubit) {
        cubit.loadWorkoutDetails(userWorkoutId);
        cubit.loadWorkoutDetails(userWorkoutId);
      },
      expect: () => const [
        WorkoutDetailsState.inProgress(),
        WorkoutDetailsState.loaded(items),
      ],
      verify: (_) => verify(repository.getWorkoutDetails(userWorkoutId)).called(1),
    );

    blocTest<WorkoutDetailsCubit, WorkoutDetailsState>(
      'emits loaded(items) when load-workout-details is succeed',
      setUp: () => when(repository.getWorkoutDetails(userWorkoutId)).thenAnswer(
        (_) async => const Success<List<WorkoutDetailsItem>, WorkoutsFailure>(items),
      ),
      build: () => workoutDetailsCubit,
      act: (cubit) => cubit.loadWorkoutDetails(userWorkoutId),
      expect: () => const [
        WorkoutDetailsState.inProgress(),
        WorkoutDetailsState.loaded(items),
      ],
      verify: (_) => verify(repository.getWorkoutDetails(userWorkoutId)).called(1),
    );

    blocTest<WorkoutDetailsCubit, WorkoutDetailsState>(
      'emits failed(workoutsFailure) when load-workout-details is failed',
      setUp: () => when(repository.getWorkoutDetails(userWorkoutId)).thenAnswer(
        (_) async => const Failure<List<WorkoutDetailsItem>, WorkoutsFailure>(workoutsFailure),
      ),
      build: () => workoutDetailsCubit,
      act: (cubit) => cubit.loadWorkoutDetails(userWorkoutId),
      expect: () => const [
        WorkoutDetailsState.inProgress(),
        WorkoutDetailsState.failed(workoutsFailure),
      ],
      verify: (_) => verify(repository.getWorkoutDetails(userWorkoutId)).called(1),
    );
  });
}
