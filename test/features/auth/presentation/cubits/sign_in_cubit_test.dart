import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:moveup_flutter/features/auth/presentation/cubits/sign_in_cubit.dart';

import 'sign_in_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<AuthRepository>(),
])
void main() {
  late MockAppLogger logger;
  late MockAuthRepository repository;
  late SignInCubit signInCubit;

  const name = 'name';
  const email = 'email';
  const password = 'password';
  const user = User(id: 1, name: name, email: email);

  setUp(() {
    logger = MockAppLogger();
    repository = MockAuthRepository();
    signInCubit = SignInCubit(logger, repository);
    provideDummy<Result<User, AuthFailure>>(const Success(user));
  });

  group('SignInCubit', () {
    const authFailure = InvalidCredentialsFailure();

    blocTest<SignInCubit, SignInState>(
      'emits inProgress only once when signIn is called twice',
      setUp: () =>
          when(
            repository.signIn(email, password),
          ).thenAnswer(
            (_) async => const Success(user),
          ),
      build: () => signInCubit,
      act: (cubit) {
        cubit.signIn(email, password);
        cubit.signIn(email, password);
      },
      expect: () => [
        const SignInState.inProgress(),
        const SignInState.succeed(user),
      ],
      verify: (_) => verify(repository.signIn(email, password)).called(1),
    );

    blocTest<SignInCubit, SignInState>(
      'emits succeed(user) when sign-in is succeed',
      setUp: () =>
          when(
            repository.signIn(email, password),
          ).thenAnswer(
            (_) async => const Success(user),
          ),
      build: () => signInCubit,
      act: (cubit) => cubit.signIn(email, password),
      expect: () => [
        const SignInState.inProgress(),
        const SignInState.succeed(user),
      ],
      verify: (_) => verify(repository.signIn(email, password)).called(1),
    );

    blocTest<SignInCubit, SignInState>(
      'emits failed(authFailure) when sign-in is failed',
      setUp: () =>
          when(
            repository.signIn(email, password),
          ).thenAnswer(
            (_) async => const Failure(authFailure),
          ),
      build: () => signInCubit,
      act: (cubit) => cubit.signIn(email, password),
      expect: () => [
        const SignInState.inProgress(),
        const SignInState.failed(authFailure),
      ],
      verify: (_) => verify(repository.signIn(email, password)).called(1),
    );
  });
}
