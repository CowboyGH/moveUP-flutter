import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_starter_template/core/failures/feature/auth/auth_failure.dart';
import 'package:flutter_starter_template/core/result/result.dart';
import 'package:flutter_starter_template/core/utils/analytics/app_analytics.dart';
import 'package:flutter_starter_template/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter_template/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppAnalytics>(), MockSpec<AuthRepository>()])
void main() {
  late AppAnalytics mockAnalytics;
  late AuthRepository mockRepository;
  late AuthBloc authBloc;
  late StreamController<User?> authController;

  const email = 'test@gmail.com';
  const password = 'test_password';
  const user = User(uid: 'test_uid', email: 'test@gmail.com');
  const authFailure = UnknownAuthFailure('test_code');

  setUp(() {
    mockAnalytics = MockAppAnalytics();
    mockRepository = MockAuthRepository();

    authController = StreamController<User?>.broadcast();
    when(mockRepository.authStateChanges).thenAnswer((_) => authController.stream);

    authBloc = AuthBloc(mockAnalytics, mockRepository);

    provideDummy<Result<User, AuthFailure>>(const Success(user));
    provideDummy<Result<void, AuthFailure>>(const Success(null));
  });

  tearDown(() async {
    await authBloc.close();
    await authController.close();
  });

  void verifyRepository() {
    verify(mockRepository.authStateChanges).called(1);
    verifyNoMoreInteractions(mockRepository);
  }

  group('AuthBloc', () {
    group('AuthBloc._onAuthStateChanged', () {
      blocTest(
        'emits authenticated when user is not null',
        build: () => authBloc,
        act: (bloc) async {
          authController.add(user);
          await pumpEventQueue();
        },
        expect: () => [const AuthState.authenticated(user)],
        verify: (_) => verifyRepository(),
      );

      blocTest(
        'emits unauthenticated when user is null',
        build: () => authBloc,
        act: (bloc) async {
          authController.add(null);
          await pumpEventQueue();
        },
        expect: () => [const AuthState.unauthenticated()],
        verify: (_) => verifyRepository(),
      );
    });

    group('AuthBloc._onSignInRequested', () {
      blocTest(
        'emits authenticated when authStateChanges emits user on sign in',
        build: () => authBloc,
        setUp: () => when(
          mockRepository.signInWithEmail(email, password),
        ).thenAnswer((_) async => const Success(user)),
        act: (bloc) async {
          bloc.add(const AuthEvent.signInRequested(email, password));
          await pumpEventQueue();

          authController.add(user);
          await pumpEventQueue();
        },
        expect: () => [
          const AuthState.operationInProgress(),
          const AuthState.authenticated(user),
        ],
        verify: (bloc) {
          verify(mockRepository.signInWithEmail(email, password)).called(1);
          verifyRepository();

          verify(mockAnalytics.logEvent('signInRequested')).called(1);
          verify(mockAnalytics.logEvent('signInCompleted')).called(1);
          verifyNoMoreInteractions(mockAnalytics);
        },
      );

      blocTest(
        'emits authError on sign in failure',
        build: () => authBloc,
        setUp: () => when(
          mockRepository.signInWithEmail(email, password),
        ).thenAnswer((_) async => const Failure(authFailure)),
        act: (bloc) => bloc.add(const AuthEvent.signInRequested(email, password)),
        expect: () => [
          const AuthState.operationInProgress(),
          const AuthState.authError(authFailure),
        ],
        verify: (bloc) {
          verify(mockRepository.signInWithEmail(email, password)).called(1);
          verifyRepository();

          verify(mockAnalytics.logEvent('signInRequested')).called(1);
          verify(
            mockAnalytics.logEvent(
              'authError',
              parameters: {'code': authFailure.code},
            ),
          ).called(1);
          verifyNoMoreInteractions(mockAnalytics);
        },
      );
    });

    group('AuthBloc._onSignUpRequested', () {
      blocTest(
        'emits authenticated when authStateChanges emits user on sign up',
        build: () => authBloc,
        setUp: () => when(
          mockRepository.signUpWithEmail(email, password),
        ).thenAnswer((_) async => const Success(user)),
        act: (bloc) async {
          bloc.add(const AuthEvent.signUpRequested(email, password));
          await pumpEventQueue();

          authController.add(user);
          await pumpEventQueue();
        },
        expect: () => [
          const AuthState.operationInProgress(),
          const AuthState.authenticated(user),
        ],
        verify: (bloc) {
          verify(mockRepository.signUpWithEmail(email, password)).called(1);
          verifyRepository();

          verify(mockAnalytics.logEvent('signUpRequested')).called(1);
          verify(mockAnalytics.logEvent('signUpCompleted')).called(1);
          verifyNoMoreInteractions(mockAnalytics);
        },
      );

      blocTest(
        'emits authError on sign up failure',
        build: () => authBloc,
        setUp: () => when(
          mockRepository.signUpWithEmail(email, password),
        ).thenAnswer((_) async => const Failure(authFailure)),
        act: (bloc) => bloc.add(const AuthEvent.signUpRequested(email, password)),
        expect: () => [
          const AuthState.operationInProgress(),
          const AuthState.authError(authFailure),
        ],
        verify: (bloc) {
          verify(mockRepository.signUpWithEmail(email, password)).called(1);
          verifyRepository();

          verify(mockAnalytics.logEvent('signUpRequested')).called(1);
          verify(
            mockAnalytics.logEvent(
              'authError',
              parameters: {'code': authFailure.code},
            ),
          ).called(1);
          verifyNoMoreInteractions(mockAnalytics);
        },
      );
    });

    group('AuthBloc._onSignOutRequested', () {
      blocTest(
        'emits unauthenticated when authStateChanges emits null on sign out',
        build: () => authBloc,
        setUp: () => when(
          mockRepository.signOut(),
        ).thenAnswer((_) async => const Success(null)),
        act: (bloc) async {
          bloc.add(const AuthEvent.signOutRequested());
          await pumpEventQueue();

          authController.add(null);
          await pumpEventQueue();
        },
        expect: () => [const AuthState.unauthenticated()],
        verify: (bloc) {
          verify(mockRepository.signOut()).called(1);
          verifyRepository();

          verify(mockAnalytics.logEvent('signOutRequested')).called(1);
          verify(mockAnalytics.logEvent('signOutCompleted')).called(1);
          verifyNoMoreInteractions(mockAnalytics);
        },
      );

      blocTest(
        'emits authError on sign out failure',
        build: () => authBloc,
        setUp: () => when(
          mockRepository.signOut(),
        ).thenAnswer((_) async => const Failure(authFailure)),
        act: (bloc) => bloc.add(const AuthEvent.signOutRequested()),
        expect: () => [const AuthState.authError(authFailure)],
        verify: (bloc) {
          verify(mockRepository.signOut()).called(1);
          verifyRepository();

          verify(mockAnalytics.logEvent('signOutRequested')).called(1);
          verify(
            mockAnalytics.logEvent(
              'authError',
              parameters: {'code': authFailure.code},
            ),
          ).called(1);
          verifyNoMoreInteractions(mockAnalytics);
        },
      );
    });

    group('AuthBloc._onSignInWithGoogleRequested', () {
      blocTest(
        'emits authenticated when authStateChanges emits user on sign in with google',
        build: () => authBloc,
        setUp: () => when(mockRepository.signInWithGoogle()).thenAnswer(
          (_) async => const Success(user),
        ),
        act: (bloc) async {
          bloc.add(const AuthEvent.signInWithGoogleRequested());
          await pumpEventQueue();

          authController.add(user);
          await pumpEventQueue();
        },
        expect: () => [
          const AuthState.operationInProgress(),
          const AuthState.authenticated(user),
        ],
        verify: (bloc) {
          verify(mockRepository.signInWithGoogle()).called(1);
          verifyRepository();

          verify(mockAnalytics.logEvent('signInWithGoogleRequested')).called(1);
          verify(mockAnalytics.logEvent('signInWithGoogleCompleted')).called(1);
          verifyNoMoreInteractions(mockAnalytics);
        },
      );

      blocTest(
        'emits authError on sign in with google failure',
        build: () => authBloc,
        setUp: () => when(mockRepository.signInWithGoogle()).thenAnswer(
          (_) async => const Failure(authFailure),
        ),
        act: (bloc) async => bloc.add(const AuthEvent.signInWithGoogleRequested()),
        expect: () => [
          const AuthState.operationInProgress(),
          const AuthState.authError(authFailure),
        ],
        verify: (bloc) {
          verify(mockRepository.signInWithGoogle()).called(1);
          verifyRepository();

          verify(mockAnalytics.logEvent('signInWithGoogleRequested')).called(1);
          verify(
            mockAnalytics.logEvent(
              'authError',
              parameters: {'code': authFailure.code},
            ),
          ).called(1);
          verifyNoMoreInteractions(mockAnalytics);
        },
      );
    });
  });
}
