import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/core/services/fitness_start_progress_storage/fitness_start_progress_storage.dart';
import 'package:moveup_flutter/core/services/guest_session_storage/guest_session_storage.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:moveup_flutter/features/auth/presentation/cubits/auth_session_cubit.dart';

import 'auth_session_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<TokenStorage>(),
  MockSpec<FitnessStartProgressStorage>(),
  MockSpec<GuestSessionStorage>(),
  MockSpec<AppLogger>(),
])
void main() {
  late MockAuthRepository repository;
  late MockTokenStorage tokenStorage;
  late MockFitnessStartProgressStorage progressStorage;
  late MockGuestSessionStorage guestSessionStorage;
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
    progressStorage = MockFitnessStartProgressStorage();
    guestSessionStorage = MockGuestSessionStorage();
    logger = MockAppLogger();
    authSessionCubit = AuthSessionCubit(
      repository,
      tokenStorage,
      progressStorage,
      guestSessionStorage,
      logger,
    );
    provideDummy<Result<User, AuthFailure>>(const Success(user));
    when(progressStorage.hasCompletedProgress()).thenAnswer((_) async => false);
    when(progressStorage.saveCompleted()).thenAnswer((_) async {});
    when(progressStorage.clear()).thenAnswer((_) async {});
    when(guestSessionStorage.clear()).thenAnswer((_) async {});
  });

  group('AuthSessionCubit', () {
    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits unauthenticated when token is missing and no guest progress exists',
      setUp: () => when(tokenStorage.getAccessToken()).thenAnswer((_) async => null),
      build: () => authSessionCubit,
      act: (cubit) => cubit.restoreSession(),
      expect: () => const [
        AuthSessionState.checking(),
        AuthSessionState.unauthenticated(),
      ],
      verify: (_) {
        verify(tokenStorage.getAccessToken()).called(1);
        verify(progressStorage.hasCompletedProgress()).called(1);
        verify(progressStorage.clear()).called(1);
        verify(guestSessionStorage.clear()).called(1);
        verifyNever(repository.getCurrentUser());
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits guestResumeAvailable when token is missing and completed guest progress exists',
      setUp: () {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => null);
        when(progressStorage.hasCompletedProgress()).thenAnswer((_) async => true);
      },
      build: () => authSessionCubit,
      act: (cubit) => cubit.restoreSession(),
      expect: () => const [
        AuthSessionState.checking(),
        AuthSessionState.guestResumeAvailable(),
      ],
      verify: (_) {
        verify(tokenStorage.getAccessToken()).called(1);
        verify(progressStorage.hasCompletedProgress()).called(1);
        verifyNever(progressStorage.clear());
        verifyNever(guestSessionStorage.clear());
        verifyNever(repository.getCurrentUser());
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits unauthenticated without clearing guest data when completed progress read fails',
      setUp: () {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => null);
        when(progressStorage.hasCompletedProgress()).thenThrow(Exception('storage_error'));
      },
      build: () => authSessionCubit,
      act: (cubit) => cubit.restoreSession(),
      expect: () => const [
        AuthSessionState.checking(),
        AuthSessionState.unauthenticated(),
      ],
      verify: (_) {
        verify(tokenStorage.getAccessToken()).called(1);
        verify(progressStorage.hasCompletedProgress()).called(1);
        verify(logger.e(any, any, any)).called(1);
        verifyNever(progressStorage.clear());
        verifyNever(guestSessionStorage.clear());
        verifyNever(repository.getCurrentUser());
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
        verify(progressStorage.clear()).called(1);
        verify(guestSessionStorage.clear()).called(1);
        verifyNever(progressStorage.hasCompletedProgress());
        verifyNever(tokenStorage.deleteAccessToken());
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits unauthenticated and deletes token on unauthorized failure',
      setUp: () {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'token');
        when(
          repository.getCurrentUser(),
        ).thenAnswer((_) async => const Failure(UnauthorizedAuthFailure()));
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
        verify(progressStorage.clear()).called(1);
        verify(guestSessionStorage.clear()).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits restoreFailed on transient auth failure',
      setUp: () {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'token');
        when(
          repository.getCurrentUser(),
        ).thenAnswer((_) async => const Failure(UnknownAuthFailure()));
      },
      build: () => authSessionCubit,
      act: (cubit) => cubit.restoreSession(),
      expect: () => const [
        AuthSessionState.checking(),
        AuthSessionState.restoreFailed(),
      ],
      verify: (_) {
        verify(tokenStorage.getAccessToken()).called(1);
        verify(repository.getCurrentUser()).called(1);
        verifyNever(tokenStorage.deleteAccessToken());
        verifyNever(progressStorage.hasCompletedProgress());
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits restoreFailed on unexpected exception',
      setUp: () {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'token');
        when(repository.getCurrentUser()).thenThrow(Exception('unexpected_error'));
      },
      build: () => authSessionCubit,
      act: (cubit) => cubit.restoreSession(),
      expect: () => const [
        AuthSessionState.checking(),
        AuthSessionState.restoreFailed(),
      ],
      verify: (_) {
        verify(tokenStorage.getAccessToken()).called(1);
        verify(repository.getCurrentUser()).called(1);
        verify(logger.e(any, any, any)).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'updateAuthenticatedUser emits authenticated(updatedUser) when session is authenticated',
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.authenticated(user),
      act: (cubit) => cubit.updateAuthenticatedUser(
        const User(
          id: 1,
          name: 'updated_name',
          email: 'updated@mail.com',
          avatar: 'avatar.jpg',
        ),
      ),
      expect: () => const [
        AuthSessionState.authenticated(
          User(
            id: 1,
            name: 'updated_name',
            email: 'updated@mail.com',
            avatar: 'avatar.jpg',
          ),
        ),
      ],
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'updateAuthenticatedUser is no-op when session is not authenticated',
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.unauthenticated(),
      act: (cubit) => cubit.updateAuthenticatedUser(user),
      expect: () => const <AuthSessionState>[],
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'startGuestFitnessStart emits guest',
      setUp: () => when(tokenStorage.getAccessToken()).thenAnswer((_) async => null),
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.unauthenticated(),
      act: (cubit) => cubit.startGuestFitnessStart(),
      expect: () => const [AuthSessionState.guest()],
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'startGuestFitnessStart is no-op when session is authenticated',
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.authenticated(user),
      act: (cubit) => cubit.startGuestFitnessStart(),
      expect: () => const <AuthSessionState>[],
      verify: (_) {
        verifyNever(progressStorage.clear());
        verifyNever(progressStorage.saveCompleted());
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'resumeGuestProgress emits guestCompletedOnboarding for completed guest state',
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.guestResumeAvailable(),
      act: (cubit) => cubit.resumeGuestProgress(),
      expect: () => const [AuthSessionState.guestCompletedOnboarding()],
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restartGuestProgress clears progress and guest session before restarting guest flow',
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.guestResumeAvailable(),
      act: (cubit) => cubit.restartGuestProgress(),
      expect: () => const [AuthSessionState.guest()],
      verify: (_) {
        verify(progressStorage.clear()).called(1);
        verify(guestSessionStorage.clear()).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restartGuestProgress does not emit guest when guest progress clear fails',
      setUp: () {
        when(progressStorage.clear()).thenThrow(Exception('storage_error'));
      },
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.guestResumeAvailable(),
      act: (cubit) => cubit.restartGuestProgress(),
      expect: () => const <AuthSessionState>[],
      verify: (_) {
        verify(progressStorage.clear()).called(1);
        verify(guestSessionStorage.clear()).called(1);
        verify(logger.e(any, any, any)).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restartGuestProgress is no-op when session cannot resume guest progress',
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.authenticated(user),
      act: (cubit) => cubit.restartGuestProgress(),
      expect: () => const <AuthSessionState>[],
      verify: (_) {
        verifyNever(progressStorage.clear());
        verifyNever(guestSessionStorage.clear());
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'completeGuestFitnessStart emits guestCompletedOnboarding and saves completed progress',
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.guest(),
      act: (cubit) => cubit.completeGuestFitnessStart(),
      expect: () => const [AuthSessionState.guestCompletedOnboarding()],
      verify: (_) {
        verify(progressStorage.saveCompleted()).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'completeGuestFitnessStart still emits guestCompletedOnboarding when save fails',
      setUp: () {
        when(progressStorage.saveCompleted()).thenThrow(Exception('storage_error'));
      },
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.guest(),
      act: (cubit) => cubit.completeGuestFitnessStart(),
      expect: () => const [AuthSessionState.guestCompletedOnboarding()],
      verify: (_) {
        verify(progressStorage.saveCompleted()).called(1);
        verify(logger.e(any, any, any)).called(1);
        verify(logger.w(any)).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'completeGuestFitnessStart is no-op when session is not in guest flow',
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.checking(),
      act: (cubit) => cubit.completeGuestFitnessStart(),
      expect: () => const <AuthSessionState>[],
      verify: (_) {
        verifyNever(progressStorage.saveCompleted());
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'cancelGuestFlow clears guest data and emits unauthenticated',
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.guest(),
      act: (cubit) => cubit.cancelGuestFlow(),
      expect: () => const [AuthSessionState.unauthenticated()],
      verify: (_) {
        verify(progressStorage.clear()).called(1);
        verify(guestSessionStorage.clear()).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'cancelGuestFlow does not emit unauthenticated when guest session clear fails',
      setUp: () {
        when(guestSessionStorage.clear()).thenThrow(Exception('storage_error'));
      },
      build: () => authSessionCubit,
      seed: () => const AuthSessionState.guest(),
      act: (cubit) => cubit.cancelGuestFlow(),
      expect: () => const <AuthSessionState>[],
      verify: (_) {
        verify(progressStorage.clear()).called(1);
        verify(guestSessionStorage.clear()).called(1);
        verify(logger.e(any, any, any)).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'onSignInSuccess emits authenticated(user) and clears guest data',
      build: () => authSessionCubit,
      act: (cubit) async {
        cubit.onSignInSuccess(user);
        await Future<void>.delayed(Duration.zero);
      },
      expect: () => const [AuthSessionState.authenticated(user)],
      verify: (_) {
        verify(progressStorage.clear()).called(1);
        verify(guestSessionStorage.clear()).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'clearSession emits unauthenticated and clears guest data',
      build: () => authSessionCubit,
      act: (cubit) => cubit.clearSession(),
      expect: () => const [AuthSessionState.unauthenticated()],
      verify: (_) {
        verify(progressStorage.clear()).called(1);
        verify(guestSessionStorage.clear()).called(1);
        verifyNever(repository.getCurrentUser());
        verifyNever(tokenStorage.deleteAccessToken());
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'clearSession emits unauthenticated even when guest data cleanup fails',
      setUp: () {
        when(progressStorage.clear()).thenThrow(Exception('storage_error'));
      },
      build: () => authSessionCubit,
      act: (cubit) => cubit.clearSession(),
      expect: () => const [AuthSessionState.unauthenticated()],
      verify: (_) {
        verify(progressStorage.clear()).called(1);
        verify(guestSessionStorage.clear()).called(1);
        verify(logger.e(any, any, any)).called(1);
        verify(logger.w(any, any, any)).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'signOut deletes access token and clears session',
      setUp: () {
        when(tokenStorage.deleteAccessToken()).thenAnswer((_) async {});
      },
      build: () => authSessionCubit,
      act: (cubit) => cubit.signOut(),
      expect: () => const [AuthSessionState.unauthenticated()],
      verify: (_) {
        verify(tokenStorage.deleteAccessToken()).called(1);
        verify(progressStorage.clear()).called(1);
        verify(guestSessionStorage.clear()).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'signOut emits unauthenticated even when token deletion fails',
      setUp: () {
        when(tokenStorage.deleteAccessToken()).thenThrow(Exception('storage_error'));
      },
      build: () => authSessionCubit,
      act: (cubit) => cubit.signOut(),
      expect: () => const [AuthSessionState.unauthenticated()],
      verify: (_) {
        verify(tokenStorage.deleteAccessToken()).called(1);
        verify(progressStorage.clear()).called(1);
        verify(guestSessionStorage.clear()).called(1);
        verify(logger.e(any, any, any)).called(1);
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
      },
    );
  });
}
