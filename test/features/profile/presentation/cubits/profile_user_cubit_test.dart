import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_gender.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_snapshot.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_phase_snapshot.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_stats_history_snapshot.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:moveup_flutter/features/profile/presentation/cubits/profile_user_cubit.dart';

import '../../support/profile_dto_fixtures.dart';
import 'profile_user_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
void main() {
  late MockProfileRepository repository;
  late ProfileUserCubit cubit;

  const seedUser = User(
    id: testProfileUserId,
    name: testProfileUserName,
    email: testProfileUserEmail,
    avatar: testProfileUserAvatar,
  );
  const updatedUser = User(
    id: testProfileUserId,
    name: 'test',
    email: 'test@mail.com',
    avatar: 'new-avatar.jpg',
  );

  setUp(() {
    repository = MockProfileRepository();
    cubit = ProfileUserCubit(repository, seedUser: seedUser);
    provideDummy<Result<User, ProfileFailure>>(const Success(seedUser));
    provideDummy<Result<ProfileStatsHistorySnapshot, ProfileFailure>>(
      Success(createProfileStatsHistorySnapshot()),
    );
    provideDummy<Result<ProfilePhaseSnapshot, ProfileFailure>>(
      Success(createProfilePhaseSnapshot()),
    );
    provideDummy<Result<ProfileParametersSnapshot?, ProfileFailure>>(
      Success(createProfileParametersSnapshot()),
    );
  });

  group('ProfileUserCubit', () {
    blocTest<ProfileUserCubit, ProfileUserState>(
      'emits loading and refreshed user when refresh succeeds',
      setUp: () {
        when(repository.getUser()).thenAnswer((_) async => const Success(updatedUser));
        when(repository.getStatsHistorySnapshot()).thenAnswer(
          (_) async => Success(createProfileStatsHistorySnapshot()),
        );
        when(repository.getPhaseSnapshot()).thenAnswer(
          (_) async => Success(createProfilePhaseSnapshot()),
        );
        when(repository.getParametersSnapshot()).thenAnswer(
          (_) async => Success(createProfileParametersSnapshot()),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.refresh(),
      expect: () => const [
        ProfileUserState(
          isLoading: true,
          user: seedUser,
        ),
        ProfileUserState(
          user: updatedUser,
          historySnapshot: ProfileStatsHistorySnapshot(
            activeSubscription: ProfileActiveSubscriptionSnapshot(
              id: testProfileSubscriptionId,
              name: testProfileSubscriptionName,
              price: testProfileSubscriptionPrice,
              startDate: testProfileSubscriptionStartDate,
              endDate: testProfileSubscriptionEndDate,
            ),
            latestWorkout: ProfileLatestWorkoutSnapshot(
              id: testProfileWorkoutHistoryId,
              title: testProfileWorkoutTitle,
              completedAt: testProfileWorkoutCompletedAt,
            ),
            latestTest: ProfileLatestTestSnapshot(
              attemptId: testProfileTestAttemptId,
              title: testProfileTestTitle,
              completedAt: testProfileTestCompletedAt,
            ),
          ),
          phaseSnapshot: ProfilePhaseSnapshot(
            hasProgress: testProfileHasProgress,
            currentPhaseName: testProfilePhaseName,
          ),
          parametersSnapshot: ProfileParametersSnapshot(
            goal: testProfileParametersGoal,
            gender: ProfileParametersGender.female,
            age: testProfileParametersAge,
            weight: testProfileParametersWeight,
            height: testProfileParametersHeight,
            equipment: testProfileParametersEquipment,
            level: testProfileParametersLevel,
          ),
        ),
      ],
      verify: (_) {
        verify(repository.getUser()).called(1);
        verify(repository.getStatsHistorySnapshot()).called(1);
        verify(repository.getPhaseSnapshot()).called(1);
        verify(repository.getParametersSnapshot()).called(1);
      },
    );

    blocTest<ProfileUserCubit, ProfileUserState>(
      'emits loading only once when refresh is called twice in progress',
      setUp: () {
        when(repository.getUser()).thenAnswer((_) async => const Success(updatedUser));
        when(repository.getStatsHistorySnapshot()).thenAnswer(
          (_) async => Success(createProfileStatsHistorySnapshot()),
        );
        when(repository.getPhaseSnapshot()).thenAnswer(
          (_) async => Success(createProfilePhaseSnapshot()),
        );
        when(repository.getParametersSnapshot()).thenAnswer(
          (_) async => Success(createProfileParametersSnapshot()),
        );
      },
      build: () => cubit,
      act: (cubit) {
        cubit.refresh();
        cubit.refresh();
      },
      expect: () => const [
        ProfileUserState(
          isLoading: true,
          user: seedUser,
        ),
        ProfileUserState(
          user: updatedUser,
          historySnapshot: ProfileStatsHistorySnapshot(
            activeSubscription: ProfileActiveSubscriptionSnapshot(
              id: testProfileSubscriptionId,
              name: testProfileSubscriptionName,
              price: testProfileSubscriptionPrice,
              startDate: testProfileSubscriptionStartDate,
              endDate: testProfileSubscriptionEndDate,
            ),
            latestWorkout: ProfileLatestWorkoutSnapshot(
              id: testProfileWorkoutHistoryId,
              title: testProfileWorkoutTitle,
              completedAt: testProfileWorkoutCompletedAt,
            ),
            latestTest: ProfileLatestTestSnapshot(
              attemptId: testProfileTestAttemptId,
              title: testProfileTestTitle,
              completedAt: testProfileTestCompletedAt,
            ),
          ),
          phaseSnapshot: ProfilePhaseSnapshot(
            hasProgress: testProfileHasProgress,
            currentPhaseName: testProfilePhaseName,
          ),
          parametersSnapshot: ProfileParametersSnapshot(
            goal: testProfileParametersGoal,
            gender: ProfileParametersGender.female,
            age: testProfileParametersAge,
            weight: testProfileParametersWeight,
            height: testProfileParametersHeight,
            equipment: testProfileParametersEquipment,
            level: testProfileParametersLevel,
          ),
        ),
      ],
      verify: (_) {
        verify(repository.getUser()).called(1);
        verify(repository.getStatsHistorySnapshot()).called(1);
        verify(repository.getPhaseSnapshot()).called(1);
        verify(repository.getParametersSnapshot()).called(1);
      },
    );

    blocTest<ProfileUserCubit, ProfileUserState>(
      'keeps seed user and stores failure when refresh fails',
      setUp: () => when(
        repository.getUser(),
      ).thenAnswer((_) async => const Failure(ProfileRequestFailure('error_message'))),
      build: () => cubit,
      act: (cubit) => cubit.refresh(),
      expect: () => const [
        ProfileUserState(
          isLoading: true,
          user: seedUser,
        ),
        ProfileUserState(
          user: seedUser,
          failure: ProfileRequestFailure('error_message'),
        ),
      ],
      verify: (_) => verify(repository.getUser()).called(1),
    );

    blocTest<ProfileUserCubit, ProfileUserState>(
      'replaceUser updates current user and clears failure',
      build: () => cubit,
      seed: () => const ProfileUserState(
        user: seedUser,
        failure: ProfileRequestFailure('error_message'),
      ),
      act: (cubit) => cubit.replaceUser(updatedUser),
      expect: () => const [
        ProfileUserState(
          user: updatedUser,
        ),
      ],
    );
  });
}
