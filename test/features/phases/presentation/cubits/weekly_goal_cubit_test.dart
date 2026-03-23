import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/phases/phases_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/phases/domain/repositories/phases_repository.dart';
import 'package:moveup_flutter/features/phases/presentation/cubits/weekly_goal_cubit.dart';

import 'weekly_goal_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PhasesRepository>()])
void main() {
  late MockPhasesRepository repository;
  late WeeklyGoalCubit cubit;

  setUp(() {
    repository = MockPhasesRepository();
    cubit = WeeklyGoalCubit(repository);
    provideDummy<Result<void, PhasesFailure>>(const Success<void, PhasesFailure>(null));
  });

  group('WeeklyGoalCubit', () {
    const requestFailure = PhasesRequestFailure('request_failed');

    blocTest<WeeklyGoalCubit, WeeklyGoalState>(
      'emits inProgress only once when updateWeeklyGoal is called twice',
      setUp: () => when(repository.updateWeeklyGoal(4)).thenAnswer(
        (_) async => const Success<void, PhasesFailure>(null),
      ),
      build: () => cubit,
      act: (cubit) {
        cubit.updateWeeklyGoal(4);
        cubit.updateWeeklyGoal(4);
      },
      expect: () => const [
        WeeklyGoalState.inProgress(),
        WeeklyGoalState.succeed(),
      ],
      verify: (_) => verify(repository.updateWeeklyGoal(4)).called(1),
    );

    blocTest<WeeklyGoalCubit, WeeklyGoalState>(
      'emits succeed when updateWeeklyGoal succeeds',
      setUp: () => when(repository.updateWeeklyGoal(4)).thenAnswer(
        (_) async => const Success<void, PhasesFailure>(null),
      ),
      build: () => cubit,
      act: (cubit) => cubit.updateWeeklyGoal(4),
      expect: () => const [
        WeeklyGoalState.inProgress(),
        WeeklyGoalState.succeed(),
      ],
      verify: (_) => verify(repository.updateWeeklyGoal(4)).called(1),
    );

    blocTest<WeeklyGoalCubit, WeeklyGoalState>(
      'emits failed(requestFailure) when updateWeeklyGoal fails',
      setUp: () => when(repository.updateWeeklyGoal(4)).thenAnswer(
        (_) async => const Failure(requestFailure),
      ),
      build: () => cubit,
      act: (cubit) => cubit.updateWeeklyGoal(4),
      expect: () => const [
        WeeklyGoalState.inProgress(),
        WeeklyGoalState.failed(requestFailure),
      ],
      verify: (_) => verify(repository.updateWeeklyGoal(4)).called(1),
    );
  });
}
