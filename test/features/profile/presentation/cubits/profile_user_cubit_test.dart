import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
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
  });

  group('ProfileUserCubit', () {
    blocTest<ProfileUserCubit, ProfileUserState>(
      'emits loading and refreshed user when refresh succeeds',
      setUp: () => when(repository.getUser()).thenAnswer((_) async => const Success(updatedUser)),
      build: () => cubit,
      act: (cubit) => cubit.refresh(),
      expect: () => const [
        ProfileUserState(
          isLoading: true,
          user: seedUser,
        ),
        ProfileUserState(
          user: updatedUser,
        ),
      ],
      verify: (_) => verify(repository.getUser()).called(1),
    );

    blocTest<ProfileUserCubit, ProfileUserState>(
      'emits loading only once when refresh is called twice in progress',
      setUp: () => when(repository.getUser()).thenAnswer((_) async => const Success(updatedUser)),
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
        ),
      ],
      verify: (_) => verify(repository.getUser()).called(1),
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
