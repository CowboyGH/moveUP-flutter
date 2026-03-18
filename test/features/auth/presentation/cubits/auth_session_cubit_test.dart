import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/models/fitness_start_stage.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/core/services/onboarding_flow_storage/onboarding_flow_storage.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:moveup_flutter/features/auth/presentation/cubits/auth_session_cubit.dart';

import 'auth_session_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<TokenStorage>(),
  MockSpec<OnboardingFlowStorage>(),
  MockSpec<AppLogger>(),
])
void main() {
  late MockAuthRepository repository;
  late MockTokenStorage tokenStorage;
  late MockOnboardingFlowStorage onboardingFlowStorage;
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
    onboardingFlowStorage = MockOnboardingFlowStorage();
    logger = MockAppLogger();
    authSessionCubit = AuthSessionCubit(
      repository,
      tokenStorage,
      onboardingFlowStorage,
      logger,
    );
    provideDummy<Result<User, AuthFailure>>(const Success(user));
    when(onboardingFlowStorage.hasPendingOnboarding()).thenAnswer((_) async => false);
    when(onboardingFlowStorage.getPendingOnboardingStage()).thenAnswer((_) async => null);
    when(onboardingFlowStorage.savePendingOnboardingStage(any)).thenAnswer((_) async {});
    when(onboardingFlowStorage.clearPendingOnboarding()).thenAnswer((_) async {});
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
        verify(onboardingFlowStorage.clearPendingOnboarding()).called(1);
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
        verify(onboardingFlowStorage.hasPendingOnboarding()).called(1);
        verifyNever(onboardingFlowStorage.getPendingOnboardingStage());
        verifyNever(tokenStorage.deleteAccessToken());
        verifyNoMoreInteractions(tokenStorage);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits authenticatedOnboarding when pending onboarding exists',
      setUp: () {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'token');
        when(repository.getCurrentUser()).thenAnswer((_) async => const Success(user));
        when(onboardingFlowStorage.hasPendingOnboarding()).thenAnswer((_) async => true);
        when(
          onboardingFlowStorage.getPendingOnboardingStage(),
        ).thenAnswer((_) async => FitnessStartStage.tests);
      },
      build: () => authSessionCubit,
      act: (cubit) => cubit.restoreSession(),
      expect: () => const [
        AuthSessionState.checking(),
        AuthSessionState.authenticatedOnboarding(user, FitnessStartStage.tests),
      ],
      verify: (_) {
        verify(tokenStorage.getAccessToken()).called(1);
        verify(repository.getCurrentUser()).called(1);
        verify(onboardingFlowStorage.hasPendingOnboarding()).called(1);
        verify(onboardingFlowStorage.getPendingOnboardingStage()).called(1);
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
        verify(onboardingFlowStorage.clearPendingOnboarding()).called(1);
        verifyNoMoreInteractions(tokenStorage);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits restoreFailed without deleting token on transient auth failure',
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
        verifyNoMoreInteractions(tokenStorage);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits restoreFailed without deleting token on unexpected exception',
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
        verifyNever(tokenStorage.deleteAccessToken());
        verifyNoMoreInteractions(tokenStorage);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'restoreSession emits unauthenticated when token cleanup throws for unauthorized failure',
      setUp: () {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'token');
        when(
          repository.getCurrentUser(),
        ).thenAnswer((_) async => const Failure(UnauthorizedAuthFailure()));
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
      'continueAsGuest emits guest(quiz)',
      build: () => authSessionCubit,
      act: (cubit) => cubit.continueAsGuest(),
      expect: () => const [AuthSessionState.guest(FitnessStartStage.quiz)],
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'startAuthenticatedOnboarding emits authenticatedOnboarding(user, quiz)',
      build: () => authSessionCubit,
      act: (cubit) => cubit.startAuthenticatedOnboarding(user),
      expect: () => const [
        AuthSessionState.authenticatedOnboarding(user, FitnessStartStage.quiz),
      ],
      verify: (_) {
        verify(
          onboardingFlowStorage.savePendingOnboardingStage(FitnessStartStage.quiz),
        ).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'updateOnboardingStage transitions guest quiz to guest tests',
      build: () => authSessionCubit,
      act: (cubit) {
        cubit.continueAsGuest();
        cubit.updateOnboardingStage(FitnessStartStage.tests);
      },
      expect: () => const [
        AuthSessionState.guest(FitnessStartStage.quiz),
        AuthSessionState.guest(FitnessStartStage.tests),
      ],
      verify: (_) {
        verifyNever(onboardingFlowStorage.savePendingOnboardingStage(any));
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'updateOnboardingStage transitions authenticated onboarding and persists stage',
      build: () => authSessionCubit,
      act: (cubit) async {
        await cubit.startAuthenticatedOnboarding(user);
        await cubit.updateOnboardingStage(FitnessStartStage.tests);
      },
      expect: () => const [
        AuthSessionState.authenticatedOnboarding(user, FitnessStartStage.quiz),
        AuthSessionState.authenticatedOnboarding(user, FitnessStartStage.tests),
      ],
      verify: (_) {
        verify(
          onboardingFlowStorage.savePendingOnboardingStage(FitnessStartStage.quiz),
        ).called(1);
        verify(
          onboardingFlowStorage.savePendingOnboardingStage(FitnessStartStage.tests),
        ).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'cancelGuestFlow emits unauthenticated',
      build: () => authSessionCubit,
      act: (cubit) {
        cubit.continueAsGuest();
        cubit.cancelGuestFlow();
      },
      expect: () => const [
        AuthSessionState.guest(FitnessStartStage.quiz),
        AuthSessionState.unauthenticated(),
      ],
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'onSignInSuccess emits authenticated(user)',
      build: () => authSessionCubit,
      act: (cubit) async {
        cubit.onSignInSuccess(user);
        await Future<void>.delayed(Duration.zero);
      },
      expect: () => const [AuthSessionState.authenticated(user)],
      verify: (_) {
        verify(onboardingFlowStorage.clearPendingOnboarding()).called(1);
      },
    );

    blocTest<AuthSessionCubit, AuthSessionState>(
      'clearSession emits unauthenticated without touching token storage directly',
      build: () => authSessionCubit,
      act: (cubit) async {
        cubit.clearSession();
        await Future<void>.delayed(Duration.zero);
      },
      expect: () => const [AuthSessionState.unauthenticated()],
      verify: (_) {
        verifyNoMoreInteractions(repository);
        verifyNoMoreInteractions(tokenStorage);
        verify(onboardingFlowStorage.clearPendingOnboarding()).called(1);
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
