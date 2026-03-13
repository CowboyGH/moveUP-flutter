import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:moveup_flutter/features/auth/presentation/cubits/auth_session_cubit.dart';

import 'auth_session_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<TokenStorage>(),
  MockSpec<AppLogger>(),
])
void main() {
  late MockAuthRepository repository;
  late MockTokenStorage tokenStorage;
  late MockAppLogger logger;
  late AuthSessionCubit authSessionCubit;

  const user = User(
    id: 1,
    name: 'name',
    email: 'test@mail.com',
  );

  setUp(() {
    repository = MockAuthRepository();
    tokenStorage = MockTokenStorage();
    logger = MockAppLogger();
    authSessionCubit = AuthSessionCubit(repository, tokenStorage, logger);
    provideDummy<Result<User, AuthFailure>>(const Success(user));
  });

  group('AuthSessionCubit', () {
    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits unauthenticated when token is missing',
      setUp: () => when(tokenStorage.getAccessToken()).thenAnswer((_) async => null),
      build: () => authSessionCubit,
      act: (cubit) => cubit.restoreSession(),
      expect: () => const [
        AuthSessionState.checking(),
        AuthSessionState.unauthenticated(),
      ],
      verify: (_) {
        verify(tokenStorage.getAccessToken()).called(1);
        verifyNever(repository.getCurrentUser());
        verifyNever(tokenStorage.deleteAccessToken());
        verifyNoMoreInteractions(tokenStorage);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits authenticated when token exists and /me succeeds',
      setUp: () {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'token');
        when(repository.getCurrentUser()).thenAnswer((_) async => const Success(user));
      },
      build: () => authSessionCubit,
      act: (cubit) => cubit.restoreSession(),
      expect: () => const [
        AuthSessionState.checking(),
        AuthSessionState.authenticated(user),
      ],
      verify: (_) {
        verify(tokenStorage.getAccessToken()).called(1);
        verify(repository.getCurrentUser()).called(1);
        verifyNever(tokenStorage.deleteAccessToken());
        verifyNoMoreInteractions(tokenStorage);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits unauthenticated and deletes token on auth failure',
      setUp: () {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'token');
        when(
          repository.getCurrentUser(),
        ).thenAnswer((_) async => const Failure(UnknownAuthFailure()));
        when(tokenStorage.deleteAccessToken()).thenAnswer((_) async {});
      },
      build: () => authSessionCubit,
      act: (cubit) => cubit.restoreSession(),
      expect: () => const [
        AuthSessionState.checking(),
        AuthSessionState.unauthenticated(),
      ],
      verify: (_) {
        verify(tokenStorage.getAccessToken()).called(1);
        verify(repository.getCurrentUser()).called(1);
        verify(tokenStorage.deleteAccessToken()).called(1);
        verifyNoMoreInteractions(tokenStorage);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits unauthenticated and deletes token on unexpected exception',
      setUp: () {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'token');
        when(repository.getCurrentUser()).thenThrow(Exception('unexpected_error'));
        when(tokenStorage.deleteAccessToken()).thenAnswer((_) async {});
      },
      build: () => authSessionCubit,
      act: (cubit) => cubit.restoreSession(),
      expect: () => const [
        AuthSessionState.checking(),
        AuthSessionState.unauthenticated(),
      ],
      verify: (_) {
        verify(tokenStorage.getAccessToken()).called(1);
        verify(repository.getCurrentUser()).called(1);
        verify(tokenStorage.deleteAccessToken()).called(1);
        verifyNoMoreInteractions(tokenStorage);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits unauthenticated when token cleanup throws',
      setUp: () {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'token');
        when(
          repository.getCurrentUser(),
        ).thenAnswer((_) async => const Failure(UnknownAuthFailure()));
        when(tokenStorage.deleteAccessToken()).thenThrow(Exception('storage_error'));
      },
      build: () => authSessionCubit,
      act: (cubit) => cubit.restoreSession(),
      expect: () => const [
        AuthSessionState.checking(),
        AuthSessionState.unauthenticated(),
      ],
      verify: (_) {
        verify(tokenStorage.getAccessToken()).called(1);
        verify(repository.getCurrentUser()).called(1);
        verify(tokenStorage.deleteAccessToken()).called(1);
        verify(logger.e(any, any, any)).called(1);
        verifyNoMoreInteractions(tokenStorage);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'continueAsGuest emits guest',
      build: () => authSessionCubit,
      act: (cubit) => cubit.continueAsGuest(),
      expect: () => const [AuthSessionState.guest()],
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'onSignInSuccess emits authenticated(user)',
      build: () => authSessionCubit,
      act: (cubit) => cubit.onSignInSuccess(user),
      expect: () => const [AuthSessionState.authenticated(user)],
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'clearSession emits unauthenticated without touching token storage directly',
      build: () => authSessionCubit,
      act: (cubit) => cubit.clearSession(),
      expect: () => const [AuthSessionState.unauthenticated()],
      verify: (_) {
        verifyNoMoreInteractions(repository);
        verifyNoMoreInteractions(tokenStorage);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession works only once when called twice',
      setUp: () {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'token');
        when(repository.getCurrentUser()).thenAnswer((_) async => const Success(user));
      },
      build: () => authSessionCubit,
      act: (cubit) {
        cubit.restoreSession();
        cubit.restoreSession();
      },
      expect: () => const [
        AuthSessionState.checking(),
        AuthSessionState.authenticated(user),
      ],
      verify: (_) {
        verify(tokenStorage.getAccessToken()).called(1);
        verify(repository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(tokenStorage);
      },
    );
  });
}
