import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:moveup_flutter/features/profile/presentation/cubits/change_password_cubit.dart';

import 'change_password_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
void main() {
  late MockProfileRepository repository;
  late ChangePasswordCubit cubit;

  const failure = ProfileValidationFailure(message: 'test');

  setUp(() {
    repository = MockProfileRepository();
    cubit = ChangePasswordCubit(repository);
    provideDummy<Result<void, ProfileFailure>>(const Success(null));
  });

  group('ChangePasswordCubit', () {
    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits inProgress and succeed when password change succeeds',
      setUp: () => when(
        repository.changePassword(
          oldPassword: anyNamed('oldPassword'),
          newPassword: anyNamed('newPassword'),
          newPasswordConfirmation: anyNamed('newPasswordConfirmation'),
        ),
      ).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      act: (cubit) => cubit.changePassword(
        oldPassword: 'oldPass123',
        newPassword: 'newPass123',
        newPasswordConfirmation: 'newPass123',
      ),
      expect: () => const [
        ChangePasswordState.inProgress(),
        ChangePasswordState.succeed(),
      ],
      verify: (_) => verify(
        repository.changePassword(
          oldPassword: 'oldPass123',
          newPassword: 'newPass123',
          newPasswordConfirmation: 'newPass123',
        ),
      ).called(1),
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits failed(failure) when password change fails',
      setUp: () => when(
        repository.changePassword(
          oldPassword: anyNamed('oldPassword'),
          newPassword: anyNamed('newPassword'),
          newPasswordConfirmation: anyNamed('newPasswordConfirmation'),
        ),
      ).thenAnswer((_) async => const Failure(failure)),
      build: () => cubit,
      act: (cubit) => cubit.changePassword(
        oldPassword: 'oldPass123',
        newPassword: 'newPass123',
        newPasswordConfirmation: 'newPass123',
      ),
      expect: () => const [
        ChangePasswordState.inProgress(),
        ChangePasswordState.failed(failure),
      ],
      verify: (_) => verify(
        repository.changePassword(
          oldPassword: 'oldPass123',
          newPassword: 'newPass123',
          newPasswordConfirmation: 'newPass123',
        ),
      ).called(1),
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits inProgress only once when changePassword is called twice',
      setUp: () => when(
        repository.changePassword(
          oldPassword: anyNamed('oldPassword'),
          newPassword: anyNamed('newPassword'),
          newPasswordConfirmation: anyNamed('newPasswordConfirmation'),
        ),
      ).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      act: (cubit) {
        cubit.changePassword(
          oldPassword: 'oldPass123',
          newPassword: 'newPass123',
          newPasswordConfirmation: 'newPass123',
        );
        cubit.changePassword(
          oldPassword: 'oldPass123',
          newPassword: 'newPass123',
          newPasswordConfirmation: 'newPass123',
        );
      },
      expect: () => const [
        ChangePasswordState.inProgress(),
        ChangePasswordState.succeed(),
      ],
      verify: (_) => verify(
        repository.changePassword(
          oldPassword: 'oldPass123',
          newPassword: 'newPass123',
          newPasswordConfirmation: 'newPass123',
        ),
      ).called(1),
    );
  });
}
