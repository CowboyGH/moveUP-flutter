import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:moveup_flutter/features/profile/presentation/cubits/delete_profile_cubit.dart';

import 'delete_profile_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
void main() {
  late MockProfileRepository repository;
  late DeleteProfileCubit cubit;

  const failure = ProfileRequestFailure('test');

  setUp(() {
    repository = MockProfileRepository();
    cubit = DeleteProfileCubit(repository);
    provideDummy<Result<void, ProfileFailure>>(const Success(null));
  });

  group('DeleteProfileCubit', () {
    blocTest<DeleteProfileCubit, DeleteProfileState>(
      'emits inProgress and succeed when profile deletion succeeds',
      setUp: () => when(repository.deleteProfile()).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      act: (cubit) => cubit.deleteProfile(),
      expect: () => const [
        DeleteProfileState.inProgress(),
        DeleteProfileState.succeed(),
      ],
      verify: (_) => verify(repository.deleteProfile()).called(1),
    );

    blocTest<DeleteProfileCubit, DeleteProfileState>(
      'emits failed(failure) when profile deletion fails',
      setUp: () => when(repository.deleteProfile()).thenAnswer((_) async => const Failure(failure)),
      build: () => cubit,
      act: (cubit) => cubit.deleteProfile(),
      expect: () => const [
        DeleteProfileState.inProgress(),
        DeleteProfileState.failed(failure),
      ],
      verify: (_) => verify(repository.deleteProfile()).called(1),
    );

    blocTest<DeleteProfileCubit, DeleteProfileState>(
      'emits inProgress only once when deleteProfile is called twice',
      setUp: () => when(repository.deleteProfile()).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      act: (cubit) {
        cubit.deleteProfile();
        cubit.deleteProfile();
      },
      expect: () => const [
        DeleteProfileState.inProgress(),
        DeleteProfileState.succeed(),
      ],
      verify: (_) => verify(repository.deleteProfile()).called(1),
    );
  });
}
