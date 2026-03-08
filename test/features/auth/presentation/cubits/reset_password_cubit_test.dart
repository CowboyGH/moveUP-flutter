import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:moveup_flutter/features/auth/presentation/cubits/reset_password_cubit.dart';

import 'reset_password_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  late MockAuthRepository repository;
  late ResetPasswordCubit resetPasswordCubit;

  const email = 'email';
  const code = '123456';
  const password = 'password123';
  const passwordConfirmation = 'password123';

  setUp(() {
    repository = MockAuthRepository();
    resetPasswordCubit = ResetPasswordCubit(repository);
    provideDummy<Result<void, AuthFailure>>(const Success<void, AuthFailure>(null));
  });

  group('ResetPasswordCubit', () {
    const authFailure = ValidationFailedFailure();

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits inProgress only once when resetPassword is called twice',
      setUp: () => when(
        repository.resetPassword(email, code, password, passwordConfirmation),
      ).thenAnswer((_) async => const Success<void, AuthFailure>(null)),
      build: () => resetPasswordCubit,
      act: (cubit) {
        cubit.resetPassword(email, code, password, passwordConfirmation);
        cubit.resetPassword(email, code, password, passwordConfirmation);
      },
      expect: () => const [
        ResetPasswordState.inProgress(),
        ResetPasswordState.succeed(),
      ],
      verify: (_) => verify(
        repository.resetPassword(email, code, password, passwordConfirmation),
      ).called(1),
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits succeed when reset-password is succeed',
      setUp: () => when(
        repository.resetPassword(email, code, password, passwordConfirmation),
      ).thenAnswer((_) async => const Success<void, AuthFailure>(null)),
      build: () => resetPasswordCubit,
      act: (cubit) => cubit.resetPassword(email, code, password, passwordConfirmation),
      expect: () => const [
        ResetPasswordState.inProgress(),
        ResetPasswordState.succeed(),
      ],
      verify: (_) => verify(
        repository.resetPassword(email, code, password, passwordConfirmation),
      ).called(1),
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits failed(authFailure) when reset-password is failed',
      setUp: () => when(
        repository.resetPassword(email, code, password, passwordConfirmation),
      ).thenAnswer((_) async => const Failure(authFailure)),
      build: () => resetPasswordCubit,
      act: (cubit) => cubit.resetPassword(email, code, password, passwordConfirmation),
      expect: () => const [
        ResetPasswordState.inProgress(),
        ResetPasswordState.failed(authFailure),
      ],
      verify: (_) => verify(
        repository.resetPassword(email, code, password, passwordConfirmation),
      ).called(1),
    );
  });
}
