import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:moveup_flutter/features/auth/presentation/cubits/logout_cubit.dart';

import 'logout_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  late MockAuthRepository repository;
  late LogoutCubit logoutCubit;

  setUp(() {
    repository = MockAuthRepository();
    logoutCubit = LogoutCubit(repository);
    provideDummy<Result<void, AuthFailure>>(const Success<void, AuthFailure>(null));
  });

  group('LogoutCubit', () {
    const authFailure = UnknownAuthFailure();

    blocTest<LogoutCubit, LogoutState>(
      'emits inProgress only once when logout is called twice',
      setUp: () => when(repository.logout()).thenAnswer(
        (_) async => const Success<void, AuthFailure>(null),
      ),
      build: () => logoutCubit,
      act: (cubit) {
        cubit.logout();
        cubit.logout();
      },
      expect: () => const [
        LogoutState.inProgress(),
        LogoutState.succeed(),
      ],
      verify: (_) => verify(repository.logout()).called(1),
    );

    blocTest<LogoutCubit, LogoutState>(
      'emits succeed when logout succeeds',
      setUp: () => when(repository.logout()).thenAnswer(
        (_) async => const Success<void, AuthFailure>(null),
      ),
      build: () => logoutCubit,
      act: (cubit) => cubit.logout(),
      expect: () => const [
        LogoutState.inProgress(),
        LogoutState.succeed(),
      ],
      verify: (_) => verify(repository.logout()).called(1),
    );

    blocTest<LogoutCubit, LogoutState>(
      'emits succeed when logout fails with UnauthorizedAuthFailure',
      setUp: () => when(repository.logout()).thenAnswer(
        (_) async => const Failure(UnauthorizedAuthFailure()),
      ),
      build: () => logoutCubit,
      act: (cubit) => cubit.logout(),
      expect: () => const [
        LogoutState.inProgress(),
        LogoutState.succeed(),
      ],
      verify: (_) => verify(repository.logout()).called(1),
    );

    blocTest<LogoutCubit, LogoutState>(
      'emits failed(authFailure) when logout fails with non-unauthorized failure',
      setUp: () => when(repository.logout()).thenAnswer(
        (_) async => const Failure(authFailure),
      ),
      build: () => logoutCubit,
      act: (cubit) => cubit.logout(),
      expect: () => const [
        LogoutState.inProgress(),
        LogoutState.failed(authFailure),
      ],
      verify: (_) => verify(repository.logout()).called(1),
    );
  });
}
