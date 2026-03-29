import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:moveup_flutter/features/profile/presentation/cubits/update_profile_cubit.dart';

import '../../support/profile_dto_fixtures.dart';
import 'update_profile_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
void main() {
  late MockProfileRepository repository;
  late UpdateProfileCubit cubit;

  const currentUser = User(
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
  const failure = ProfileRequestFailure('error_message');

  setUp(() {
    repository = MockProfileRepository();
    cubit = UpdateProfileCubit(repository);
    provideDummy<Result<User, ProfileFailure>>(const Success(updatedUser));
  });

  group('UpdateProfileCubit', () {
    blocTest<UpdateProfileCubit, UpdateProfileState>(
      'emits inProgress and succeed(user) when update succeeds',
      setUp: () => when(
        repository.updateUser(
          currentUser: anyNamed('currentUser'),
          name: anyNamed('name'),
          email: anyNamed('email'),
          avatarPath: anyNamed('avatarPath'),
        ),
      ).thenAnswer((_) async => const Success(updatedUser)),
      build: () => cubit,
      act: (cubit) => cubit.updateProfile(
        currentUser: currentUser,
        name: 'test',
        email: 'test@mail.com',
        avatarPath: '/tmp/avatar.jpg',
      ),
      expect: () => const [
        UpdateProfileState.inProgress(),
        UpdateProfileState.succeed(updatedUser),
      ],
      verify: (_) => verify(
        repository.updateUser(
          currentUser: currentUser,
          name: 'test',
          email: 'test@mail.com',
          avatarPath: '/tmp/avatar.jpg',
        ),
      ).called(1),
    );

    blocTest<UpdateProfileCubit, UpdateProfileState>(
      'emits failed(failure) when update fails',
      setUp: () => when(
        repository.updateUser(
          currentUser: anyNamed('currentUser'),
          name: anyNamed('name'),
          email: anyNamed('email'),
          avatarPath: anyNamed('avatarPath'),
        ),
      ).thenAnswer((_) async => const Failure(failure)),
      build: () => cubit,
      act: (cubit) => cubit.updateProfile(
        currentUser: currentUser,
        name: 'test',
        email: 'test@mail.com',
      ),
      expect: () => const [
        UpdateProfileState.inProgress(),
        UpdateProfileState.failed(failure),
      ],
      verify: (_) => verify(
        repository.updateUser(
          currentUser: currentUser,
          name: 'test',
          email: 'test@mail.com',
        ),
      ).called(1),
    );

    blocTest<UpdateProfileCubit, UpdateProfileState>(
      'emits inProgress only once when updateProfile is called twice',
      setUp: () => when(
        repository.updateUser(
          currentUser: anyNamed('currentUser'),
          name: anyNamed('name'),
          email: anyNamed('email'),
          avatarPath: anyNamed('avatarPath'),
        ),
      ).thenAnswer((_) async => const Success(updatedUser)),
      build: () => cubit,
      act: (cubit) {
        cubit.updateProfile(
          currentUser: currentUser,
          name: 'test',
          email: 'test@mail.com',
        );
        cubit.updateProfile(
          currentUser: currentUser,
          name: 'test',
          email: 'test@mail.com',
        );
      },
      expect: () => const [
        UpdateProfileState.inProgress(),
        UpdateProfileState.succeed(updatedUser),
      ],
      verify: (_) => verify(
        repository.updateUser(
          currentUser: currentUser,
          name: 'test',
          email: 'test@mail.com',
        ),
      ).called(1),
    );
  });
}
