import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:moveup_flutter/features/auth/presentation/cubits/sign_up_cubit.dart';

import 'sign_up_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  late MockAuthRepository repository;
  late SignUpCubit signUpCubit;

  const name = 'name';
  const email = 'email';
  const password = 'password';
  const user = User(id: 1, name: name, email: email);

  setUp(() {
    repository = MockAuthRepository();
    signUpCubit = SignUpCubit(repository);
    provideDummy<Result<User, AuthFailure>>(const Success(user));
  });

  group('SignUpCubit', () {
    const authFailure = ValidationFailedFailure();

    blocTest<SignUpCubit, SignUpState>(
      'emits inProgress only once when signUp is called twice',
      setUp: () =>
          when(
            repository.signUp(name, email, password),
          ).thenAnswer(
            (_) async => const Success(user),
          ),
      build: () => signUpCubit,
      act: (cubit) {
        cubit.signUp(name, email, password);
        cubit.signUp(name, email, password);
      },
      expect: () => [
        const SignUpState.inProgress(),
        const SignUpState.succeed(user),
      ],
      verify: (_) => verify(repository.signUp(name, email, password)).called(1),
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits succeed(user) when sign-up is succeed',
      setUp: () =>
          when(
            repository.signUp(name, email, password),
          ).thenAnswer(
            (_) async => const Success(user),
          ),
      build: () => signUpCubit,
      act: (cubit) => cubit.signUp(name, email, password),
      expect: () => [
        const SignUpState.inProgress(),
        const SignUpState.succeed(user),
      ],
      verify: (_) => verify(repository.signUp(name, email, password)).called(1),
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits failed(authFailure) when sign-up is failed',
      setUp: () =>
          when(
            repository.signUp(name, email, password),
          ).thenAnswer(
            (_) async => const Failure(authFailure),
          ),
      build: () => signUpCubit,
      act: (cubit) => cubit.signUp(name, email, password),
      expect: () => [
        const SignUpState.inProgress(),
        const SignUpState.failed(authFailure),
      ],
      verify: (_) => verify(repository.signUp(name, email, password)).called(1),
    );
  });
}
