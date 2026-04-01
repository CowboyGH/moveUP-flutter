import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_data.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_gender.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_references.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_snapshot.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_parameters_repository.dart';
import 'package:moveup_flutter/features/profile/presentation/cubits/profile_parameters_cubit.dart';

import '../../support/profile_dto_fixtures.dart';
import '../../support/profile_parameters_dto_fixtures.dart';
import 'profile_parameters_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProfileParametersRepository>()])
void main() {
  late MockProfileParametersRepository repository;
  late ProfileParametersCubit cubit;

  setUp(() {
    repository = MockProfileParametersRepository();
    cubit = ProfileParametersCubit(repository);

    provideDummy<Result<ProfileParametersReferences, ProfileFailure>>(
      const Success(testProfileParametersReferences),
    );
    provideDummy<Result<ProfileParametersData, ProfileFailure>>(
      const Success(testProfileParametersData),
    );
  });

  group('ProfileParametersCubit', () {
    const requestFailure = ProfileRequestFailure('request_failed');

    blocTest<ProfileParametersCubit, ProfileParametersState>(
      'loadInitial emits loading and loaded state when repository succeeds',
      setUp: () {
        when(repository.getReferences()).thenAnswer(
          (_) async => const Success(testProfileParametersReferences),
        );
        when(repository.getCurrentParameters()).thenAnswer(
          (_) async => const Success(testProfileParametersData),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.loadInitial(),
      expect: () => const [
        ProfileParametersState(isLoading: true),
        ProfileParametersState(
          references: testProfileParametersReferences,
          currentParameters: testProfileParametersData,
          bootstrapSnapshot: ProfileParametersSnapshot(
            goal: testProfileParametersGoalName,
            gender: ProfileParametersGender.female,
            age: testProfileParametersAgeValue,
            weight: testProfileParametersWeightValue,
            height: testProfileParametersHeightValue,
            equipment: testProfileParametersEquipmentName,
            level: testProfileParametersLevelName,
          ),
          selectedGoalId: testProfileParametersGoalId,
          selectedGender: ProfileParametersGender.female,
          selectedEquipmentId: testProfileParametersEquipmentId,
          selectedLevelId: testProfileParametersLevelId,
        ),
      ],
      verify: (_) {
        verify(repository.getReferences()).called(1);
        verify(repository.getCurrentParameters()).called(1);
      },
    );

    blocTest<ProfileParametersCubit, ProfileParametersState>(
      'loadInitial stores failure when repository fails',
      setUp: () {
        when(repository.getReferences()).thenAnswer(
          (_) async => const Failure(requestFailure),
        );
        when(repository.getCurrentParameters()).thenAnswer(
          (_) async => const Failure(requestFailure),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.loadInitial(),
      expect: () => const [
        ProfileParametersState(isLoading: true),
        ProfileParametersState(failure: requestFailure),
      ],
      verify: (_) {
        verify(repository.getReferences()).called(1);
        verify(repository.getCurrentParameters()).called(1);
      },
    );

    blocTest<ProfileParametersCubit, ProfileParametersState>(
      'setBootstrapSnapshot stores profile bootstrap seed',
      build: () => cubit,
      act: (cubit) => cubit.setBootstrapSnapshot(createProfileParametersSnapshot()),
      expect: () => [
        ProfileParametersState(
          bootstrapSnapshot: createProfileParametersSnapshot(),
          selectedGender: ProfileParametersGender.female,
        ),
      ],
    );

    blocTest<ProfileParametersCubit, ProfileParametersState>(
      'selection methods update selected values',
      build: () => cubit,
      seed: () => const ProfileParametersState(
        currentParameters: testProfileParametersData,
      ),
      act: (cubit) {
        cubit.selectGoal(testProfileParametersUpdatedGoalId);
        cubit.selectGender(ProfileParametersGender.male);
        cubit.selectEquipment(testProfileParametersUpdatedEquipmentId);
        cubit.selectLevel(testProfileParametersUpdatedLevelId);
      },
      expect: () => const [
        ProfileParametersState(
          currentParameters: testProfileParametersData,
          selectedGoalId: testProfileParametersUpdatedGoalId,
        ),
        ProfileParametersState(
          currentParameters: testProfileParametersData,
          selectedGoalId: testProfileParametersUpdatedGoalId,
          selectedGender: ProfileParametersGender.male,
        ),
        ProfileParametersState(
          currentParameters: testProfileParametersData,
          selectedGoalId: testProfileParametersUpdatedGoalId,
          selectedGender: ProfileParametersGender.male,
          selectedEquipmentId: testProfileParametersUpdatedEquipmentId,
        ),
        ProfileParametersState(
          currentParameters: testProfileParametersData,
          selectedGoalId: testProfileParametersUpdatedGoalId,
          selectedGender: ProfileParametersGender.male,
          selectedEquipmentId: testProfileParametersUpdatedEquipmentId,
          selectedLevelId: testProfileParametersUpdatedLevelId,
        ),
      ],
    );

    blocTest<ProfileParametersCubit, ProfileParametersState>(
      'submit marks workouts for reload when goal changes',
      setUp: () =>
          when(
            repository.saveParameters(
              currentParameters: testProfileParametersData,
              currentWeeklyGoal: testProfileParametersWeeklyGoal,
              payload: createProfileParametersSubmitPayload(
                goalId: testProfileParametersUpdatedGoalId,
              ),
            ),
          ).thenAnswer(
            (_) async => const Success(
              ProfileParametersData(
                goalId: testProfileParametersUpdatedGoalId,
                equipmentId: testProfileParametersEquipmentId,
                levelId: testProfileParametersLevelId,
                gender: ProfileParametersGender.female,
                age: testProfileParametersAgeValue,
                weight: testProfileParametersWeightValue,
                height: testProfileParametersHeightValue,
                goalName: testProfileParametersUpdatedGoalName,
                equipmentName: testProfileParametersEquipmentName,
                levelName: testProfileParametersLevelName,
              ),
            ),
          ),
      build: () => cubit,
      seed: () => const ProfileParametersState(
        currentParameters: testProfileParametersData,
        selectedGoalId: testProfileParametersGoalId,
        selectedGender: ProfileParametersGender.female,
        selectedEquipmentId: testProfileParametersEquipmentId,
        selectedLevelId: testProfileParametersLevelId,
      ),
      act: (cubit) => cubit.submit(
        payload: createProfileParametersSubmitPayload(
          goalId: testProfileParametersUpdatedGoalId,
        ),
        currentWeeklyGoal: testProfileParametersWeeklyGoal,
      ),
      expect: () => const [
        ProfileParametersState(
          isSubmitting: true,
          currentParameters: testProfileParametersData,
          selectedGoalId: testProfileParametersGoalId,
          selectedGender: ProfileParametersGender.female,
          selectedEquipmentId: testProfileParametersEquipmentId,
          selectedLevelId: testProfileParametersLevelId,
        ),
        ProfileParametersState(
          shouldReloadWorkouts: true,
          currentParameters: ProfileParametersData(
            goalId: testProfileParametersUpdatedGoalId,
            equipmentId: testProfileParametersEquipmentId,
            levelId: testProfileParametersLevelId,
            gender: ProfileParametersGender.female,
            age: testProfileParametersAgeValue,
            weight: testProfileParametersWeightValue,
            height: testProfileParametersHeightValue,
            goalName: testProfileParametersUpdatedGoalName,
            equipmentName: testProfileParametersEquipmentName,
            levelName: testProfileParametersLevelName,
          ),
          bootstrapSnapshot: ProfileParametersSnapshot(
            goal: testProfileParametersUpdatedGoalName,
            gender: ProfileParametersGender.female,
            age: testProfileParametersAgeValue,
            weight: testProfileParametersWeightValue,
            height: testProfileParametersHeightValue,
            equipment: testProfileParametersEquipmentName,
            level: testProfileParametersLevelName,
          ),
          selectedGoalId: testProfileParametersUpdatedGoalId,
          selectedGender: ProfileParametersGender.female,
          selectedEquipmentId: testProfileParametersEquipmentId,
          selectedLevelId: testProfileParametersLevelId,
        ),
      ],
      verify: (_) => verify(
        repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: createProfileParametersSubmitPayload(
            goalId: testProfileParametersUpdatedGoalId,
          ),
        ),
      ).called(1),
    );

    blocTest<ProfileParametersCubit, ProfileParametersState>(
      'submit keeps workouts reload disabled for anthropometry-only changes',
      setUp: () =>
          when(
            repository.saveParameters(
              currentParameters: testProfileParametersData,
              currentWeeklyGoal: testProfileParametersWeeklyGoal,
              payload: createProfileParametersSubmitPayload(
                age: testProfileParametersAgeValue + 1,
              ),
            ),
          ).thenAnswer(
            (_) async => const Success(
              ProfileParametersData(
                goalId: testProfileParametersGoalId,
                equipmentId: testProfileParametersEquipmentId,
                levelId: testProfileParametersLevelId,
                gender: ProfileParametersGender.female,
                age: testProfileParametersAgeValue + 1,
                weight: testProfileParametersWeightValue,
                height: testProfileParametersHeightValue,
                goalName: testProfileParametersGoalName,
                equipmentName: testProfileParametersEquipmentName,
                levelName: testProfileParametersLevelName,
              ),
            ),
          ),
      build: () => cubit,
      seed: () => const ProfileParametersState(
        currentParameters: testProfileParametersData,
      ),
      act: (cubit) => cubit.submit(
        payload: createProfileParametersSubmitPayload(
          age: testProfileParametersAgeValue + 1,
        ),
        currentWeeklyGoal: testProfileParametersWeeklyGoal,
      ),
      expect: () => const [
        ProfileParametersState(
          isSubmitting: true,
          currentParameters: testProfileParametersData,
        ),
        ProfileParametersState(
          currentParameters: ProfileParametersData(
            goalId: testProfileParametersGoalId,
            equipmentId: testProfileParametersEquipmentId,
            levelId: testProfileParametersLevelId,
            gender: ProfileParametersGender.female,
            age: testProfileParametersAgeValue + 1,
            weight: testProfileParametersWeightValue,
            height: testProfileParametersHeightValue,
            goalName: testProfileParametersGoalName,
            equipmentName: testProfileParametersEquipmentName,
            levelName: testProfileParametersLevelName,
          ),
          bootstrapSnapshot: ProfileParametersSnapshot(
            goal: testProfileParametersGoalName,
            gender: ProfileParametersGender.female,
            age: testProfileParametersAgeValue + 1,
            weight: testProfileParametersWeightValue,
            height: testProfileParametersHeightValue,
            equipment: testProfileParametersEquipmentName,
            level: testProfileParametersLevelName,
          ),
          selectedGoalId: testProfileParametersGoalId,
          selectedGender: ProfileParametersGender.female,
          selectedEquipmentId: testProfileParametersEquipmentId,
          selectedLevelId: testProfileParametersLevelId,
        ),
      ],
      verify: (_) => verify(
        repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: createProfileParametersSubmitPayload(
            age: testProfileParametersAgeValue + 1,
          ),
        ),
      ).called(1),
    );

    blocTest<ProfileParametersCubit, ProfileParametersState>(
      'submit stores failure when repository fails',
      setUp: () => when(
        repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: createProfileParametersSubmitPayload(
            goalId: testProfileParametersUpdatedGoalId,
          ),
        ),
      ).thenAnswer((_) async => const Failure(requestFailure)),
      build: () => cubit,
      seed: () => const ProfileParametersState(
        currentParameters: testProfileParametersData,
        selectedGoalId: testProfileParametersGoalId,
      ),
      act: (cubit) => cubit.submit(
        payload: createProfileParametersSubmitPayload(
          goalId: testProfileParametersUpdatedGoalId,
        ),
        currentWeeklyGoal: testProfileParametersWeeklyGoal,
      ),
      expect: () => const [
        ProfileParametersState(
          isSubmitting: true,
          currentParameters: testProfileParametersData,
          selectedGoalId: testProfileParametersGoalId,
        ),
        ProfileParametersState(
          currentParameters: testProfileParametersData,
          selectedGoalId: testProfileParametersGoalId,
          failure: requestFailure,
        ),
      ],
      verify: (_) => verify(
        repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: createProfileParametersSubmitPayload(
            goalId: testProfileParametersUpdatedGoalId,
          ),
        ),
      ).called(1),
    );

    blocTest<ProfileParametersCubit, ProfileParametersState>(
      'submit ignores repeated calls while request is in progress',
      setUp: () => when(
        repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: createProfileParametersSubmitPayload(
            goalId: testProfileParametersUpdatedGoalId,
          ),
        ),
      ).thenAnswer((_) async => const Success(testProfileParametersData)),
      build: () => cubit,
      seed: () => const ProfileParametersState(
        currentParameters: testProfileParametersData,
      ),
      act: (cubit) {
        cubit.submit(
          payload: createProfileParametersSubmitPayload(
            goalId: testProfileParametersUpdatedGoalId,
          ),
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
        );
        cubit.submit(
          payload: createProfileParametersSubmitPayload(
            goalId: testProfileParametersUpdatedGoalId,
          ),
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
        );
      },
      expect: () => const [
        ProfileParametersState(
          isSubmitting: true,
          currentParameters: testProfileParametersData,
        ),
        ProfileParametersState(
          shouldReloadWorkouts: true,
          currentParameters: testProfileParametersData,
          bootstrapSnapshot: ProfileParametersSnapshot(
            goal: testProfileParametersGoalName,
            gender: ProfileParametersGender.female,
            age: testProfileParametersAgeValue,
            weight: testProfileParametersWeightValue,
            height: testProfileParametersHeightValue,
            equipment: testProfileParametersEquipmentName,
            level: testProfileParametersLevelName,
          ),
          selectedGoalId: testProfileParametersGoalId,
          selectedGender: ProfileParametersGender.female,
          selectedEquipmentId: testProfileParametersEquipmentId,
          selectedLevelId: testProfileParametersLevelId,
        ),
      ],
      verify: (_) => verify(
        repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: createProfileParametersSubmitPayload(
            goalId: testProfileParametersUpdatedGoalId,
          ),
        ),
      ).called(1),
    );

    blocTest<ProfileParametersCubit, ProfileParametersState>(
      'submit does nothing when values are unchanged',
      build: () => cubit,
      seed: () => const ProfileParametersState(
        currentParameters: testProfileParametersData,
      ),
      act: (cubit) => cubit.submit(
        payload: testProfileParametersSubmitPayload,
        currentWeeklyGoal: testProfileParametersWeeklyGoal,
      ),
      expect: () => const <ProfileParametersState>[],
      verify: (_) => verifyNever(
        repository.saveParameters(
          currentParameters: anyNamed('currentParameters'),
          currentWeeklyGoal: anyNamed('currentWeeklyGoal'),
          payload: anyNamed('payload'),
        ),
      ),
    );

    blocTest<ProfileParametersCubit, ProfileParametersState>(
      'consumeWorkoutsReloadRequest clears pending reload flag',
      build: () => cubit,
      seed: () => const ProfileParametersState(shouldReloadWorkouts: true),
      act: (cubit) => cubit.consumeWorkoutsReloadRequest(),
      expect: () => const [
        ProfileParametersState(),
      ],
    );
  });
}
