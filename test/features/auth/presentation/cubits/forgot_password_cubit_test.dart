import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:moveup_flutter/features/auth/presentation/cubits/forgot_password_cubit.dart';

import 'forgot_password_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  late MockAuthRepository repository;
  late ForgotPasswordCubit forgotPasswordCubit;

  const email = 'email';

  setUp(() {
    repository = MockAuthRepository();
    forgotPasswordCubit = ForgotPasswordCubit(repository);
    provideDummy<Result<void, AuthFailure>>(const Success<void, AuthFailure>(null));
  });

  group('ForgotPasswordCubit', () {
    const authFailure = ValidationFailedFailure();

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits inProgress only once when forgotPassword is called twice',
      setUp: () => when(repository.forgotPassword(email)).thenAnswer(
        (_) async => const Success<void, AuthFailure>(null),
      ),
      build: () => forgotPasswordCubit,
      act: (cubit) {
        cubit.forgotPassword(email);
        cubit.forgotPassword(email);
      },
      expect: () => const [
        ForgotPasswordState.inProgress(),
        ForgotPasswordState.succeed(),
      ],
      verify: (_) => verify(repository.forgotPassword(email)).called(1),
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits succeed when forgot-password is succeed',
      setUp: () => when(repository.forgotPassword(email)).thenAnswer(
        (_) async => const Success<void, AuthFailure>(null),
      ),
      build: () => forgotPasswordCubit,
      act: (cubit) => cubit.forgotPassword(email),
      expect: () => const [
        ForgotPasswordState.inProgress(),
        ForgotPasswordState.succeed(),
      ],
      verify: (_) => verify(repository.forgotPassword(email)).called(1),
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits failed(authFailure) when forgot-password is failed',
      setUp: () => when(repository.forgotPassword(email)).thenAnswer(
        (_) async => const Failure(authFailure),
      ),
      build: () => forgotPasswordCubit,
      act: (cubit) => cubit.forgotPassword(email),
      expect: () => const [
        ForgotPasswordState.inProgress(),
        ForgotPasswordState.failed(authFailure),
      ],
      verify: (_) => verify(repository.forgotPassword(email)).called(1),
    );
  });
}
