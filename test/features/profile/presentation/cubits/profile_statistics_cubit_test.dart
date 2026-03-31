import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/frequency_period.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/frequency_statistics_data.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/profile_current_phase_summary.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/profile_exercise_option.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/profile_history_tab.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/profile_statistics_mode.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/profile_workout_option.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/trend_statistics_data.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/volume_statistics_data.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_statistics_repository.dart';
import 'package:moveup_flutter/features/profile/presentation/cubits/profile_statistics_cubit.dart';

import '../../support/profile_statistics_dto_fixtures.dart';
import 'profile_statistics_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProfileStatisticsRepository>()])
void main() {
  late MockProfileStatisticsRepository repository;
  late ProfileStatisticsCubit cubit;
  const failure = ProfileRequestFailure('error_message');

  setUp(() {
    repository = MockProfileStatisticsRepository();
    cubit = ProfileStatisticsCubit(repository);
    provideDummy<Result<VolumeStatisticsData, ProfileFailure>>(
      const Success(testProfileStatisticsVolumeData),
    );
    provideDummy<Result<TrendStatisticsData, ProfileFailure>>(
      const Success(testProfileStatisticsTrendData),
    );
    provideDummy<Result<FrequencyStatisticsData, ProfileFailure>>(
      const Success(testProfileStatisticsFrequencyData),
    );
    provideDummy<Result<ProfileCurrentPhaseSummary, ProfileFailure>>(
      const Success(testProfileCurrentPhaseSummary),
    );
    provideDummy<Result<List<ProfileExerciseOption>, ProfileFailure>>(
      const Success(testProfileStatisticsExercises),
    );
    provideDummy<Result<List<ProfileWorkoutOption>, ProfileFailure>>(
      const Success(testProfileStatisticsWorkouts),
    );
  });

  group('ProfileStatisticsCubit', () {
    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'emits initial volume state when loadInitial succeeds',
      setUp: () {
        when(repository.getVolume()).thenAnswer(
          (_) async => const Success(testProfileStatisticsVolumeData),
        );
        when(repository.getCurrentPhaseSummary()).thenAnswer(
          (_) async => const Success(testProfileCurrentPhaseSummary),
        );
        when(repository.getExercises()).thenAnswer(
          (_) async => const Success(testProfileStatisticsExercises),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.loadInitial(),
      expect: () => const [
        ProfileStatisticsState(
          isLoading: true,
          isLoadingCurrentPhaseSummary: true,
        ),
        ProfileStatisticsState(
          selectedExerciseId: 17,
          currentPhaseSummary: testProfileCurrentPhaseSummary,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
      ],
      verify: (_) {
        verify(repository.getVolume()).called(1);
        verify(repository.getCurrentPhaseSummary()).called(1);
        verify(repository.getExercises()).called(1);
      },
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'stores failure when initial volume load fails',
      setUp: () {
        when(repository.getVolume()).thenAnswer((_) async => const Failure(failure));
        when(repository.getCurrentPhaseSummary()).thenAnswer(
          (_) async => const Success(testProfileCurrentPhaseSummary),
        );
        when(repository.getExercises()).thenAnswer(
          (_) async => const Success(testProfileStatisticsExercises),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.loadInitial(),
      expect: () => const [
        ProfileStatisticsState(
          isLoading: true,
          isLoadingCurrentPhaseSummary: true,
        ),
        ProfileStatisticsState(
          currentPhaseSummary: testProfileCurrentPhaseSummary,
          failure: failure,
        ),
      ],
      verify: (_) {
        verify(repository.getVolume()).called(1);
        verify(repository.getCurrentPhaseSummary()).called(1);
        verify(repository.getExercises()).called(1);
      },
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'reloads current phase summary without affecting statistics mode payload',
      setUp: () => when(
        repository.getCurrentPhaseSummary(),
      ).thenAnswer((_) async => const Success(testProfileCurrentPhaseSummary)),
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        selectedExerciseId: 17,
        volumeData: testProfileStatisticsVolumeData,
        exerciseOptions: testProfileStatisticsExercises,
      ),
      act: (cubit) => cubit.reloadCurrentPhaseSummary(),
      expect: () => const [
        ProfileStatisticsState(
          isLoadingCurrentPhaseSummary: true,
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
        ProfileStatisticsState(
          selectedExerciseId: 17,
          currentPhaseSummary: testProfileCurrentPhaseSummary,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
      ],
      verify: (_) => verify(repository.getCurrentPhaseSummary()).called(1),
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'stores failure when reloading current phase summary fails',
      setUp: () => when(
        repository.getCurrentPhaseSummary(),
      ).thenAnswer((_) async => const Failure(failure)),
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        currentPhaseSummary: testProfileCurrentPhaseSummary,
      ),
      act: (cubit) => cubit.reloadCurrentPhaseSummary(),
      expect: () => const [
        ProfileStatisticsState(
          isLoadingCurrentPhaseSummary: true,
          currentPhaseSummary: testProfileCurrentPhaseSummary,
        ),
        ProfileStatisticsState(
          currentPhaseSummary: testProfileCurrentPhaseSummary,
          currentPhaseSummaryFailure: failure,
        ),
      ],
      verify: (_) => verify(repository.getCurrentPhaseSummary()).called(1),
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'reloadCurrentPhaseSummary ignores repeated calls while request is in progress',
      setUp: () => when(
        repository.getCurrentPhaseSummary(),
      ).thenAnswer((_) async => const Success(testProfileCurrentPhaseSummary)),
      build: () => cubit,
      act: (cubit) {
        cubit.reloadCurrentPhaseSummary();
        cubit.reloadCurrentPhaseSummary();
      },
      expect: () => const [
        ProfileStatisticsState(
          isLoadingCurrentPhaseSummary: true,
        ),
        ProfileStatisticsState(
          currentPhaseSummary: testProfileCurrentPhaseSummary,
        ),
      ],
      verify: (_) => verify(repository.getCurrentPhaseSummary()).called(1),
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'loads frequency mode on demand',
      setUp: () => when(
        repository.getFrequency(period: FrequencyPeriod.month, offset: 0),
      ).thenAnswer((_) async => const Success(testProfileStatisticsFrequencyData)),
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        selectedExerciseId: 17,
        volumeData: testProfileStatisticsVolumeData,
        exerciseOptions: testProfileStatisticsExercises,
      ),
      act: (cubit) => cubit.selectMode(ProfileStatisticsMode.frequency),
      expect: () => const [
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.frequency,
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
        ProfileStatisticsState(
          isLoading: true,
          mode: ProfileStatisticsMode.frequency,
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.frequency,
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          frequencyData: testProfileStatisticsFrequencyData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
      ],
      verify: (_) => verify(
        repository.getFrequency(period: FrequencyPeriod.month, offset: 0),
      ).called(1),
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'stores failure when loading frequency mode fails',
      setUp: () => when(
        repository.getFrequency(period: FrequencyPeriod.month, offset: 0),
      ).thenAnswer((_) async => const Failure(failure)),
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        selectedExerciseId: 17,
        volumeData: testProfileStatisticsVolumeData,
        exerciseOptions: testProfileStatisticsExercises,
      ),
      act: (cubit) => cubit.selectMode(ProfileStatisticsMode.frequency),
      expect: () => const [
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.frequency,
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
        ProfileStatisticsState(
          isLoading: true,
          mode: ProfileStatisticsMode.frequency,
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.frequency,
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
          failure: failure,
        ),
      ],
      verify: (_) => verify(
        repository.getFrequency(period: FrequencyPeriod.month, offset: 0),
      ).called(1),
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'loads trend mode and workout options on demand',
      setUp: () {
        when(repository.getTrend()).thenAnswer(
          (_) async => const Success(testProfileStatisticsTrendData),
        );
        when(repository.getWorkouts()).thenAnswer(
          (_) async => const Success(testProfileStatisticsWorkouts),
        );
      },
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        selectedExerciseId: 17,
        volumeData: testProfileStatisticsVolumeData,
        exerciseOptions: testProfileStatisticsExercises,
      ),
      act: (cubit) => cubit.selectMode(ProfileStatisticsMode.trend),
      expect: () => const [
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.trend,
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
        ProfileStatisticsState(
          isLoading: true,
          mode: ProfileStatisticsMode.trend,
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.trend,
          selectedExerciseId: 17,
          selectedWorkoutId: 231,
          volumeData: testProfileStatisticsVolumeData,
          trendData: testProfileStatisticsTrendData,
          exerciseOptions: testProfileStatisticsExercises,
          workoutOptions: testProfileStatisticsWorkouts,
        ),
      ],
      verify: (_) {
        verify(repository.getTrend()).called(1);
        verify(repository.getWorkouts()).called(1);
      },
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'reuses cached trend mode payload without reloading',
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        selectedExerciseId: 17,
        volumeData: testProfileStatisticsVolumeData,
        exerciseOptions: testProfileStatisticsExercises,
        selectedWorkoutId: 231,
        trendData: testProfileStatisticsTrendData,
        workoutOptions: testProfileStatisticsWorkouts,
      ),
      act: (cubit) => cubit.selectMode(ProfileStatisticsMode.trend),
      expect: () => const [
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.trend,
          selectedExerciseId: 17,
          selectedWorkoutId: 231,
          volumeData: testProfileStatisticsVolumeData,
          trendData: testProfileStatisticsTrendData,
          exerciseOptions: testProfileStatisticsExercises,
          workoutOptions: testProfileStatisticsWorkouts,
        ),
      ],
      verify: (_) {
        verifyNever(repository.getTrend());
        verifyNever(repository.getWorkouts());
      },
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'stores failure when loading trend mode fails',
      setUp: () {
        when(repository.getTrend()).thenAnswer((_) async => const Failure(failure));
        when(repository.getWorkouts()).thenAnswer(
          (_) async => const Success(testProfileStatisticsWorkouts),
        );
      },
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        selectedExerciseId: 17,
        volumeData: testProfileStatisticsVolumeData,
        exerciseOptions: testProfileStatisticsExercises,
      ),
      act: (cubit) => cubit.selectMode(ProfileStatisticsMode.trend),
      expect: () => const [
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.trend,
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
        ProfileStatisticsState(
          isLoading: true,
          mode: ProfileStatisticsMode.trend,
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.trend,
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
          failure: failure,
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
      ).thenAnswer((_) async => const Success(testProfileStatisticsVolumeData)),
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        selectedExerciseId: 1,
        volumeData: testProfileStatisticsVolumeData,
        exerciseOptions: testProfileStatisticsExercises,
      ),
      act: (cubit) => cubit.selectExercise(17),
      expect: () => const [
        ProfileStatisticsState(
          isLoading: true,
          selectedExerciseId: 1,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
        ProfileStatisticsState(
          selectedExerciseId: 17,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
      ],
      verify: (_) => verify(
        repository.getVolume(exerciseId: 17, weekOffset: 0),
      ).called(1),
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'stores failure when refreshing volume for another exercise fails',
      setUp: () => when(
        repository.getVolume(exerciseId: 17, weekOffset: 0),
      ).thenAnswer((_) async => const Failure(failure)),
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        selectedExerciseId: 1,
        volumeData: testProfileStatisticsVolumeData,
        exerciseOptions: testProfileStatisticsExercises,
      ),
      act: (cubit) => cubit.selectExercise(17),
      expect: () => const [
        ProfileStatisticsState(
          isLoading: true,
          selectedExerciseId: 1,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
        ),
        ProfileStatisticsState(
          selectedExerciseId: 1,
          volumeData: testProfileStatisticsVolumeData,
          exerciseOptions: testProfileStatisticsExercises,
          failure: failure,
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
      ).thenAnswer((_) async => const Success(testProfileStatisticsYearFrequencyData)),
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        mode: ProfileStatisticsMode.frequency,
        selectedFrequencyOffset: 3,
        frequencyData: testProfileStatisticsFrequencyData,
      ),
      act: (cubit) => cubit.selectFrequencyPeriod(FrequencyPeriod.year),
      expect: () => const [
        ProfileStatisticsState(
          isLoading: true,
          mode: ProfileStatisticsMode.frequency,
          selectedFrequencyOffset: 3,
          frequencyData: testProfileStatisticsFrequencyData,
        ),
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.frequency,
          selectedFrequencyPeriod: FrequencyPeriod.year,
          frequencyData: testProfileStatisticsYearFrequencyData,
        ),
      ],
      verify: (_) => verify(
        repository.getFrequency(period: FrequencyPeriod.year, offset: 0),
      ).called(1),
    );

    blocTest<ProfileStatisticsCubit, ProfileStatisticsState>(
      'stores failure when updating frequency period fails',
      setUp: () => when(
        repository.getFrequency(period: FrequencyPeriod.year, offset: 0),
      ).thenAnswer((_) async => const Failure(failure)),
      build: () => cubit,
      seed: () => const ProfileStatisticsState(
        mode: ProfileStatisticsMode.frequency,
        selectedFrequencyOffset: 3,
        frequencyData: testProfileStatisticsFrequencyData,
      ),
      act: (cubit) => cubit.selectFrequencyPeriod(FrequencyPeriod.year),
      expect: () => const [
        ProfileStatisticsState(
          isLoading: true,
          mode: ProfileStatisticsMode.frequency,
          selectedFrequencyOffset: 3,
          frequencyData: testProfileStatisticsFrequencyData,
        ),
        ProfileStatisticsState(
          mode: ProfileStatisticsMode.frequency,
          selectedFrequencyOffset: 3,
          frequencyData: testProfileStatisticsFrequencyData,
          failure: failure,
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
        cubit.setHistorySnapshot(testProfileStatisticsHistorySnapshot);
        cubit.selectHistoryTab(ProfileHistoryTab.tests);
      },
      expect: () => const [
        ProfileStatisticsState(
          historySnapshot: testProfileStatisticsHistorySnapshot,
        ),
        ProfileStatisticsState(
          selectedHistoryTab: ProfileHistoryTab.tests,
          historySnapshot: testProfileStatisticsHistorySnapshot,
        ),
      ],
    );
  });
}
