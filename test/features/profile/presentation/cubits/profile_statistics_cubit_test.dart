import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/frequency_period.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/frequency_statistics_data.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/profile_exercise_option.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/profile_history_tab.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/profile_statistics_mode.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/profile_workout_option.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/trend_statistics_data.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/volume_statistics_data.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_stats_history_snapshot.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_statistics_repository.dart';
import 'package:moveup_flutter/features/profile/presentation/cubits/profile_statistics_cubit.dart';

import 'profile_statistics_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProfileStatisticsRepository>()])
void main() {
  late MockProfileStatisticsRepository repository;
  late ProfileStatisticsCubit cubit;

  const volumeData = VolumeStatisticsData(
    hasData: true,
    exerciseId: 17,
    title: 'Скручивания на пресс',
    averageScorePercent: 66,
    averageScoreLabel: 'Нормально',
    period: VolumePeriodData(
      start: '2026-03-16',
      end: '2026-03-22',
      label: 'Неделя 4',
      weekOffset: 0,
      canGoPrevious: true,
      canGoNext: false,
    ),
    chart: [
      VolumeChartBarData(
        label: 'Пн',
        value: 3500,
        date: '2026-03-16',
      ),
    ],
  );
  const exercises = [
    ProfileExerciseOption(
      id: 17,
      name: 'Скручивания на пресс',
      lastUsedFormatted: '19.03.2026',
    ),
  ];
  const trendData = TrendStatisticsData(
    hasData: true,
    workoutId: 231,
    title: 'Силовая: Грудь + трицепс',
    completedAtFormatted: '18.03.2026 08:32',
    averageScorePercent: 100,
    averageScoreLabel: 'Отлично',
    exercises: [
      TrendExerciseData(
        exerciseName: 'Жим штанги лежа',
        scorePercent: 100,
        scoreLabel: 'Отлично',
        reaction: 'good',
        weightUsed: '60.0',
      ),
    ],
  );
  const workouts = [
    ProfileWorkoutOption(
      id: 231,
      title: 'Силовая: Грудь + трицепс',
      completedAtFormatted: '18.03.2026',
    ),
  ];
  const frequencyData = FrequencyStatisticsData(
    hasData: true,
    period: FrequencyPeriod.month,
    offset: 0,
    label: 'Текущий месяц',
    averagePerWeek: 2.3,
    chart: [
      FrequencyChartBarData(
        label: 'Нед 1',
        shortLabel: '1',
        count: 1,
        goal: 4,
      ),
    ],
  );
  const yearFrequencyData = FrequencyStatisticsData(
    hasData: true,
    period: FrequencyPeriod.year,
    offset: 0,
    label: 'Текущий год',
    averagePerWeek: 2.3,
    chart: [
      FrequencyChartBarData(
        label: 'Янв',
        shortLabel: 'Я',
        count: 1,
        goal: 4,
      ),
    ],
  );
  const historySnapshot = ProfileStatsHistorySnapshot(
    activeSubscription: ProfileActiveSubscriptionSnapshot(
      id: 21,
      name: '3 месяца',
      price: '1400.00',
      startDate: '2026-03-15',
      endDate: '2026-06-13',
    ),
    latestWorkout: ProfileLatestWorkoutSnapshot(
      id: 101,
      title: 'Утренняя зарядка',
      completedAt: '2026-03-15 10:30:00',
    ),
    latestTest: ProfileLatestTestSnapshot(
      attemptId: 3,
      title: 'Базовый тест',
      completedAt: '2026-03-14 15:20:00',
    ),
  );

  setUp(() {
    repository = MockProfileStatisticsRepository();
    cubit = ProfileStatisticsCubit(repository);
    provideDummy<Result<VolumeStatisticsData, ProfileFailure>>(const Success(volumeData));
    provideDummy<Result<TrendStatisticsData, ProfileFailure>>(const Success(trendData));
    provideDummy<Result<FrequencyStatisticsData, ProfileFailure>>(const Success(frequencyData));
    provideDummy<Result<List<ProfileExerciseOption>, ProfileFailure>>(const Success(exercises));
    provideDummy<Result<List<ProfileWorkoutOption>, ProfileFailure>>(const Success(workouts));
  });

  group('ProfileStatisticsCubit', () {
    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'emits initial volume state when loadInitial succeeds',
      setUp: () {
        when(repository.getVolume()).thenAnswer((_) async => const Success(volumeData));
        when(repository.getExercises()).thenAnswer((_) async => const Success(exercises));
      },
      build: () => cubit,
      act: (cubit) => cubit.loadInitial(),
      expect: () => const [
        ProfileStatisticsState(
          isLoading: true,
        ),
        ProfileStatisticsState(
          selectedExerciseId: 17,
          volumeData: volumeData,
          exerciseOptions: exercises,
        ),
      ],
      verify: (_) {
        verify(repository.getVolume()).called(1);
        verify(repository.getExercises()).called(1);
      },
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'loads frequency mode on demand',
      setUp: () => when(
        repository.getFrequency(period: FrequencyPeriod.month, offset: 0),
      ).thenAnswer((_) async => const Success(frequencyData)),
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        selectedExerciseId: 17,
        volumeData: volumeData,
        exerciseOptions: exercises,
      ),
      act: (cubit) => cubit.selectMode(ProfileStatisticsMode.frequency),
      expect: () => const [
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.frequency,
          selectedExerciseId: 17,
          volumeData: volumeData,
          exerciseOptions: exercises,
        ),
        ProfileStatisticsState(
          isLoading: true,
          mode: ProfileStatisticsMode.frequency,
          selectedExerciseId: 17,
          volumeData: volumeData,
          exerciseOptions: exercises,
        ),
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.frequency,
          selectedExerciseId: 17,
          volumeData: volumeData,
          frequencyData: frequencyData,
          exerciseOptions: exercises,
        ),
      ],
      verify: (_) => verify(
        repository.getFrequency(period: FrequencyPeriod.month, offset: 0),
      ).called(1),
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'loads trend mode and workout options on demand',
      setUp: () {
        when(repository.getTrend()).thenAnswer((_) async => const Success(trendData));
        when(repository.getWorkouts()).thenAnswer((_) async => const Success(workouts));
      },
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        selectedExerciseId: 17,
        volumeData: volumeData,
        exerciseOptions: exercises,
      ),
      act: (cubit) => cubit.selectMode(ProfileStatisticsMode.trend),
      expect: () => const [
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.trend,
          selectedExerciseId: 17,
          volumeData: volumeData,
          exerciseOptions: exercises,
        ),
        ProfileStatisticsState(
          isLoading: true,
          mode: ProfileStatisticsMode.trend,
          selectedExerciseId: 17,
          volumeData: volumeData,
          exerciseOptions: exercises,
        ),
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.trend,
          selectedExerciseId: 17,
          selectedWorkoutId: 231,
          volumeData: volumeData,
          trendData: trendData,
          exerciseOptions: exercises,
          workoutOptions: workouts,
        ),
      ],
      verify: (_) {
        verify(repository.getTrend()).called(1);
        verify(repository.getWorkouts()).called(1);
      },
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'refreshes volume when selecting another exercise',
      setUp: () => when(
        repository.getVolume(exerciseId: 17, weekOffset: 0),
      ).thenAnswer((_) async => const Success(volumeData)),
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        selectedExerciseId: 1,
        volumeData: volumeData,
        exerciseOptions: exercises,
      ),
      act: (cubit) => cubit.selectExercise(17),
      expect: () => const [
        ProfileStatisticsState(
          isLoading: true,
          selectedExerciseId: 1,
          volumeData: volumeData,
          exerciseOptions: exercises,
        ),
        ProfileStatisticsState(
          selectedExerciseId: 17,
          volumeData: volumeData,
          exerciseOptions: exercises,
        ),
      ],
      verify: (_) => verify(
        repository.getVolume(exerciseId: 17, weekOffset: 0),
      ).called(1),
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'updates frequency period and resets offset',
      setUp: () => when(
        repository.getFrequency(period: FrequencyPeriod.year, offset: 0),
      ).thenAnswer((_) async => const Success(yearFrequencyData)),
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        mode: ProfileStatisticsMode.frequency,
        selectedFrequencyOffset: 3,
        frequencyData: frequencyData,
      ),
      act: (cubit) => cubit.selectFrequencyPeriod(FrequencyPeriod.year),
      expect: () => const [
        ProfileStatisticsState(
          isLoading: true,
          mode: ProfileStatisticsMode.frequency,
          selectedFrequencyOffset: 3,
          frequencyData: frequencyData,
        ),
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.frequency,
          selectedFrequencyPeriod: FrequencyPeriod.year,
          frequencyData: yearFrequencyData,
        ),
      ],
      verify: (_) => verify(
        repository.getFrequency(period: FrequencyPeriod.year, offset: 0),
      ).called(1),
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'stores history snapshot and switches history tab',
      build: () => cubit,
      act: (cubit) {
        cubit.setHistorySnapshot(historySnapshot);
        cubit.selectHistoryTab(ProfileHistoryTab.tests);
      },
      expect: () => const [
        ProfileStatisticsState(
          historySnapshot: historySnapshot,
        ),
        ProfileStatisticsState(
          selectedHistoryTab: ProfileHistoryTab.tests,
          historySnapshot: historySnapshot,
        ),
      ],
    );
  });
}
