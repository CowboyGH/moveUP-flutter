import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/analytics/app_analytics.dart';
import '../../../../core/utils/logger/logger_mixin.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

/// Bloc for managing authentication state.
class AuthBloc extends Bloc<AuthEvent, AuthState> with AppLoggerMixin {
  /// Creates an instance of [AuthBloc].
  AuthBloc(this._analytics, this._repository) : super(const AuthState.initial()) {
    _authStateChanges = _repository.authStateChanges.listen(
      (user) => add(AuthEvent.authStateChanged(user)),
    );

    on<_SignInRequested>(_onSignInRequested);
    on<_SignUpRequested>(_onSignUpRequested);
    on<_SignOutRequested>(_onSignOutRequested);
    on<_AuthStateChanged>(_onAuthStateChanged);
    on<_SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
  }

  final AppAnalytics _analytics;
  final AuthRepository _repository;

  /// Subscription to authentication state changes.
  StreamSubscription<User?>? _authStateChanges;

  /// Handles authentication state changes.
  void _onAuthStateChanged(
    _AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  /// Handles sign-in requests.
  Future<void> _onSignInRequested(
    _SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is _AuthInProgress) return;

    await _analytics.logEvent('signInRequested');
    emit(const AuthState.operationInProgress());

    final result = await _repository.signInWithEmail(
      event.email,
      event.password,
    );

    switch (result) {
      case Success():
        await _analytics.logEvent('signInCompleted');
      case Failure(:final error):
        await _analytics.logEvent(
          'authError',
          parameters: {'code': error.code},
        );
        emit(AuthState.authError(error));
    }
  }

  /// Handles sign-up requests.
  Future<void> _onSignUpRequested(
    _SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is _AuthInProgress) return;

    await _analytics.logEvent('signUpRequested');
    emit(const AuthState.operationInProgress());

    final result = await _repository.signUpWithEmail(
      event.email,
      event.password,
    );

    switch (result) {
      case Success():
        await _analytics.logEvent('signUpCompleted');
      case Failure(:final error):
        await _analytics.logEvent(
          'authError',
          parameters: {'code': error.code},
        );
        emit(AuthState.authError(error));
    }
  }

  /// Handles sign-out requests.
  ///
  /// No need to emit loading state for sign-out,
  /// as it is quick and handled by auth state changes.
  Future<void> _onSignOutRequested(
    _SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _analytics.logEvent('signOutRequested');
    final result = await _repository.signOut();

    switch (result) {
      case Success():
        await _analytics.logEvent('signOutCompleted');
      case Failure(:final error):
        await _analytics.logEvent(
          'authError',
          parameters: {'code': error.code},
        );
        emit(AuthState.authError(error));
    }
  }

  /// Handles Google sign-in requests.
  Future<void> _onSignInWithGoogleRequested(
    _SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is _AuthInProgress) return;

    await _analytics.logEvent('signInWithGoogleRequested');
    emit(const AuthState.operationInProgress());

    final result = await _repository.signInWithGoogle();

    switch (result) {
      case Success():
        await _analytics.logEvent('signInWithGoogleCompleted');
      case Failure(:final error):
        await _analytics.logEvent(
          'authError',
          parameters: {'code': error.code},
        );
        emit(AuthState.authError(error));
    }
  }

  @override
  Future<void> close() async {
    await _authStateChanges?.cancel();
    return super.close();
  }
}
