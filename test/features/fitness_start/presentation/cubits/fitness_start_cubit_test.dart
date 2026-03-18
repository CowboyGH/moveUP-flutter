import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/fitness_start/fitness_start_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/fitness_start/domain/entities/fitness_start_gender.dart';
import 'package:moveup_flutter/features/fitness_start/domain/entities/fitness_start_references.dart';
import 'package:moveup_flutter/features/fitness_start/domain/repositories/fitness_start_repository.dart';
import 'package:moveup_flutter/features/fitness_start/presentation/cubits/fitness_start_cubit.dart';

import '../../support/fitness_start_dto_fixtures.dart';
import 'fitness_start_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FitnessStartRepository>()])
void main() {
  late MockFitnessStartRepository repository;
  late FitnessStartCubit cubit;
  late FitnessStartReferences references;

  setUp(() {
    repository = MockFitnessStartRepository();
    cubit = FitnessStartCubit(repository);
    references = createFitnessStartReferences();
    provideDummy<Result<FitnessStartReferences, FitnessStartFailure>>(Success(references));
    provideDummy<Result<void, FitnessStartFailure>>(const Success(null));
  });

  group('FitnessStartCubit', () {
    const requestFailure = FitnessStartRequestFailure('request_failed');

    blocTest<FitnessStartCubit, FitnessStartState>(
      'loadReferences emits loading and loaded state when repository succeeds',
      setUp: () => when(repository.getReferences()).thenAnswer((_) async => Success(references)),
      build: () => cubit,
      act: (cubit) => cubit.loadReferences(),
      expect: () => [
        const FitnessStartState(isLoadingReferences: true),
        FitnessStartState(references: references),
      ],
      verify: (_) => verify(repository.getReferences()).called(1),
    );

    blocTest<FitnessStartCubit, FitnessStartState>(
      'loadReferences emits failure when repository fails',
      setUp: () =>
          when(repository.getReferences()).thenAnswer((_) async => const Failure(requestFailure)),
      build: () => cubit,
      act: (cubit) => cubit.loadReferences(),
      expect: () => [
        const FitnessStartState(isLoadingReferences: true),
        const FitnessStartState(failure: requestFailure),
      ],
      verify: (_) => verify(repository.getReferences()).called(1),
    );

    blocTest<FitnessStartCubit, FitnessStartState>(
      'submitGoal emits inProgress only once when called twice',
      setUp: () => when(repository.saveGoal(1)).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      seed: () => const FitnessStartState(selectedGoalId: 1),
      act: (cubit) {
        cubit.submitGoal();
        cubit.submitGoal();
      },
      expect: () => const [
        FitnessStartState(isSubmitting: true, selectedGoalId: 1),
        FitnessStartState(currentStep: 1, selectedGoalId: 1),
      ],
      verify: (_) => verify(repository.saveGoal(1)).called(1),
    );

    blocTest<FitnessStartCubit, FitnessStartState>(
      'submitAnthropometry advances quiz to the third step on success',
      setUp: () => when(
        repository.saveAnthropometry(
          gender: FitnessStartGender.male,
          age: 27,
          weight: 73.5,
          height: 180,
          equipmentId: 5,
        ),
      ).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      seed: () => const FitnessStartState(
        currentStep: 1,
        selectedGender: FitnessStartGender.male,
        selectedEquipmentId: 5,
      ),
      act: (cubit) => cubit.submitAnthropometry(
        age: 27,
        weight: 73.5,
        height: 180,
      ),
      expect: () => const [
        FitnessStartState(
          currentStep: 1,
          isSubmitting: true,
          selectedGender: FitnessStartGender.male,
          selectedEquipmentId: 5,
        ),
        FitnessStartState(
          currentStep: 2,
          selectedGender: FitnessStartGender.male,
          selectedEquipmentId: 5,
        ),
      ],
      verify: (_) => verify(
        repository.saveAnthropometry(
          gender: FitnessStartGender.male,
          age: 27,
          weight: 73.5,
          height: 180,
          equipmentId: 5,
        ),
      ).called(1),
    );

    blocTest<FitnessStartCubit, FitnessStartState>(
      'submitLevel marks quiz as completed on success',
      setUp: () => when(repository.saveLevel(3)).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      seed: () => const FitnessStartState(
        currentStep: 2,
        selectedLevelId: 3,
      ),
      act: (cubit) => cubit.submitLevel(),
      expect: () => const [
        FitnessStartState(
          currentStep: 2,
          isSubmitting: true,
          selectedLevelId: 3,
        ),
        FitnessStartState(
          currentStep: 2,
          selectedLevelId: 3,
          isCompleted: true,
        ),
      ],
      verify: (_) => verify(repository.saveLevel(3)).called(1),
    );
  });
}
