import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_phase_snapshot.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/profile_current_phase_summary.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_statistics_repository.dart';
import 'package:moveup_flutter/features/profile/presentation/cubits/profile_phase_cubit.dart';

import '../../support/profile_statistics_dto_fixtures.dart';
import 'profile_phase_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ProfileRepository>(),
  MockSpec<ProfileStatisticsRepository>(),
])
void main() {
  late MockProfileRepository profileRepository;
  late MockProfileStatisticsRepository statisticsRepository;
  late ProfilePhaseCubit cubit;
  const failure = ProfileRequestFailure('error_message');
  const phaseSnapshot = ProfilePhaseSnapshot(
    hasProgress: true,
    currentPhaseName: 'Накопление',
  );

  setUp(() {
    profileRepository = MockProfileRepository();
    statisticsRepository = MockProfileStatisticsRepository();
    cubit = ProfilePhaseCubit(profileRepository, statisticsRepository);
    provideDummy<Result<ProfilePhaseSnapshot, ProfileFailure>>(
      const Success(phaseSnapshot),
    );
    provideDummy<Result<ProfileCurrentPhaseSummary, ProfileFailure>>(
      const Success(testProfileCurrentPhaseSummary),
    );
  });

  group('ProfilePhaseCubit', () {
    blocTest<ProfilePhaseCubit, ProfilePhaseState>(
      'load emits loading then loaded state when both requests succeed',
      setUp: () {
        when(profileRepository.getPhaseSnapshot()).thenAnswer(
          (_) async => const Success(phaseSnapshot),
        );
        when(statisticsRepository.getCurrentPhaseSummary()).thenAnswer(
          (_) async => const Success(testProfileCurrentPhaseSummary),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.load(),
      expect: () => const [
        ProfilePhaseState(isLoading: true, isLoadingSummary: true),
        ProfilePhaseState(
          phaseSnapshot: phaseSnapshot,
          currentPhaseSummary: testProfileCurrentPhaseSummary,
        ),
      ],
      verify: (_) {
        verify(profileRepository.getPhaseSnapshot()).called(1);
        verify(statisticsRepository.getCurrentPhaseSummary()).called(1);
      },
    );

    blocTest<ProfilePhaseCubit, ProfilePhaseState>(
      'load stores phase failure when phase request fails',
      setUp: () {
        when(profileRepository.getPhaseSnapshot()).thenAnswer(
          (_) async => const Failure(failure),
        );
        when(statisticsRepository.getCurrentPhaseSummary()).thenAnswer(
          (_) async => const Success(testProfileCurrentPhaseSummary),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.load(),
      expect: () => const [
        ProfilePhaseState(isLoading: true, isLoadingSummary: true),
        ProfilePhaseState(
          currentPhaseSummary: testProfileCurrentPhaseSummary,
          phaseFailure: failure,
        ),
      ],
    );

    blocTest<ProfilePhaseCubit, ProfilePhaseState>(
      'load stores summary failure when summary request fails',
      setUp: () {
        when(profileRepository.getPhaseSnapshot()).thenAnswer(
          (_) async => const Success(phaseSnapshot),
        );
        when(statisticsRepository.getCurrentPhaseSummary()).thenAnswer(
          (_) async => const Failure(failure),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.load(),
      expect: () => const [
        ProfilePhaseState(isLoading: true, isLoadingSummary: true),
        ProfilePhaseState(
          phaseSnapshot: phaseSnapshot,
          summaryFailure: failure,
        ),
      ],
    );

    blocTest<ProfilePhaseCubit, ProfilePhaseState>(
      'load ignores repeated calls while request is in progress',
      setUp: () {
        when(profileRepository.getPhaseSnapshot()).thenAnswer(
          (_) async => const Success(phaseSnapshot),
        );
        when(statisticsRepository.getCurrentPhaseSummary()).thenAnswer(
          (_) async => const Success(testProfileCurrentPhaseSummary),
        );
      },
      build: () => cubit,
      act: (cubit) {
        cubit.load();
        cubit.load();
      },
      expect: () => const [
        ProfilePhaseState(isLoading: true, isLoadingSummary: true),
        ProfilePhaseState(
          phaseSnapshot: phaseSnapshot,
          currentPhaseSummary: testProfileCurrentPhaseSummary,
        ),
      ],
      verify: (_) {
        verify(profileRepository.getPhaseSnapshot()).called(1);
        verify(statisticsRepository.getCurrentPhaseSummary()).called(1);
      },
    );

    blocTest<ProfilePhaseCubit, ProfilePhaseState>(
      'reloadSummary refreshes summary without touching phase snapshot',
      setUp: () => when(statisticsRepository.getCurrentPhaseSummary()).thenAnswer(
        (_) async => const Success(testProfileCurrentPhaseSummary),
      ),
      build: () => cubit,
      seed: () => const ProfilePhaseState(phaseSnapshot: phaseSnapshot),
      act: (cubit) => cubit.reloadSummary(),
      expect: () => const [
        ProfilePhaseState(
          isLoadingSummary: true,
          phaseSnapshot: phaseSnapshot,
        ),
        ProfilePhaseState(
          phaseSnapshot: phaseSnapshot,
          currentPhaseSummary: testProfileCurrentPhaseSummary,
        ),
      ],
      verify: (_) {
        verify(statisticsRepository.getCurrentPhaseSummary()).called(1);
        verifyNever(profileRepository.getPhaseSnapshot());
      },
    );

    blocTest<ProfilePhaseCubit, ProfilePhaseState>(
      'reloadSummary stores failure when summary request fails',
      setUp: () => when(statisticsRepository.getCurrentPhaseSummary()).thenAnswer(
        (_) async => const Failure(failure),
      ),
      build: () => cubit,
      seed: () => const ProfilePhaseState(phaseSnapshot: phaseSnapshot),
      act: (cubit) => cubit.reloadSummary(),
      expect: () => const [
        ProfilePhaseState(
          isLoadingSummary: true,
          phaseSnapshot: phaseSnapshot,
        ),
        ProfilePhaseState(
          phaseSnapshot: phaseSnapshot,
          summaryFailure: failure,
        ),
      ],
    );
  });
}
