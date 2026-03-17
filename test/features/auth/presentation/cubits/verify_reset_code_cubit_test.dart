import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:moveup_flutter/features/auth/presentation/cubits/verify_reset_code_cubit.dart';

import 'verify_reset_code_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  late MockAuthRepository repository;
  late VerifyResetCodeCubit verifyResetCodeCubit;

  const email = 'email';
  const code = '123456';

  setUp(() {
    repository = MockAuthRepository();
    verifyResetCodeCubit = VerifyResetCodeCubit(repository);
    provideDummy<Result<void, AuthFailure>>(const Success<void, AuthFailure>(null));
  });

  group('VerifyResetCodeCubit', () {
    const authFailure = ValidationFailedFailure();

    blocTest<VerifyResetCodeCubit, VerifyResetCodeState>(
      'emits inProgress only once when verifyResetCode is called twice',
      setUp: () => when(repository.verifyResetCode(email, code)).thenAnswer(
        (_) async => const Success<void, AuthFailure>(null),
      ),
      build: () => verifyResetCodeCubit,
      act: (cubit) {
        cubit.verifyResetCode(email, code);
        cubit.verifyResetCode(email, code);
      },
      expect: () => const [
        VerifyResetCodeState.inProgress(),
        VerifyResetCodeState.succeed(),
      ],
      verify: (_) => verify(repository.verifyResetCode(email, code)).called(1),
    );

    blocTest<VerifyResetCodeCubit, VerifyResetCodeState>(
      'emits succeed when verify-reset-code is succeed',
      setUp: () => when(repository.verifyResetCode(email, code)).thenAnswer(
        (_) async => const Success<void, AuthFailure>(null),
      ),
      build: () => verifyResetCodeCubit,
      act: (cubit) => cubit.verifyResetCode(email, code),
      expect: () => const [
        VerifyResetCodeState.inProgress(),
        VerifyResetCodeState.succeed(),
      ],
      verify: (_) => verify(repository.verifyResetCode(email, code)).called(1),
    );

    blocTest<VerifyResetCodeCubit, VerifyResetCodeState>(
      'emits failed(authFailure) when verify-reset-code is failed',
      setUp: () => when(repository.verifyResetCode(email, code)).thenAnswer(
        (_) async => const Failure(authFailure),
      ),
      build: () => verifyResetCodeCubit,
      act: (cubit) => cubit.verifyResetCode(email, code),
      expect: () => const [
        VerifyResetCodeState.inProgress(),
        VerifyResetCodeState.failed(authFailure),
      ],
      verify: (_) => verify(repository.verifyResetCode(email, code)).called(1),
    );
  });
}
