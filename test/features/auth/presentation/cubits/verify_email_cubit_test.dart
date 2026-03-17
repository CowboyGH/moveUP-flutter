import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:moveup_flutter/features/auth/presentation/cubits/verify_email_cubit.dart';

import 'verify_email_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  late MockAuthRepository repository;
  late VerifyEmailCubit verifyEmailCubit;

  const email = 'email';
  const code = '123456';
  const user = User(id: 1, name: 'name', email: email);

  setUp(() {
    repository = MockAuthRepository();
    verifyEmailCubit = VerifyEmailCubit(repository);
    provideDummy<Result<User, AuthFailure>>(const Success(user));
  });

  group('VerifyEmailCubit', () {
    const authFailure = ValidationFailedFailure();

    blocTest<VerifyEmailCubit, VerifyEmailState>(
      'emits inProgress only once when verifyEmail is called twice',
      setUp: () =>
          when(
            repository.verifyEmail(email, code),
          ).thenAnswer(
            (_) async => const Success(user),
          ),
      build: () => verifyEmailCubit,
      act: (cubit) {
        cubit.verifyEmail(email, code);
        cubit.verifyEmail(email, code);
      },
      expect: () => const [
        VerifyEmailState.inProgress(),
        VerifyEmailState.succeed(user),
      ],
      verify: (_) => verify(repository.verifyEmail(email, code)).called(1),
    );

    blocTest<VerifyEmailCubit, VerifyEmailState>(
      'emits succeed(user) when verify-email is succeed',
      setUp: () =>
          when(
            repository.verifyEmail(email, code),
          ).thenAnswer(
            (_) async => const Success(user),
          ),
      build: () => verifyEmailCubit,
      act: (cubit) => cubit.verifyEmail(email, code),
      expect: () => const [
        VerifyEmailState.inProgress(),
        VerifyEmailState.succeed(user),
      ],
      verify: (_) => verify(repository.verifyEmail(email, code)).called(1),
    );

    blocTest<VerifyEmailCubit, VerifyEmailState>(
      'emits failed(authFailure) when verify-email is failed',
      setUp: () =>
          when(
            repository.verifyEmail(email, code),
          ).thenAnswer(
            (_) async => const Failure(authFailure),
          ),
      build: () => verifyEmailCubit,
      act: (cubit) => cubit.verifyEmail(email, code),
      expect: () => const [
        VerifyEmailState.inProgress(),
        VerifyEmailState.failed(authFailure),
      ],
      verify: (_) => verify(repository.verifyEmail(email, code)).called(1),
    );
  });
}
