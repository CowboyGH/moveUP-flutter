import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/services/fitness_start_progress_storage/fitness_start_progress_storage.dart';
import '../../../../core/services/guest_session_storage/guest_session_storage.dart';
import '../../../../core/services/token_storage/token_storage.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_session_cubit.freezed.dart';
part 'auth_session_state.dart';

/// Global cubit that manages authentication session state.
final class AuthSessionCubit extends Cubit<AuthSessionState> {
  /// Repository for auth-related backend operations.
  final AuthRepository _repository;

  /// Secure storage for access token management.
  final TokenStorage _tokenStorage;

  /// Storage for persisted guest Fitness Start progress.
  final FitnessStartProgressStorage _fitnessStartProgressStorage;

  /// Storage for persisted guest backend session cookies.
  final GuestSessionStorage _guestSessionStorage;

  /// Logger for non-fatal session cleanup errors.
  final AppLogger _logger;

  /// Creates an instance of [AuthSessionCubit].
  AuthSessionCubit(
    this._repository,
    this._tokenStorage,
    this._fitnessStartProgressStorage,
    this._guestSessionStorage,
    this._logger,
  ) : super(const AuthSessionState.initial());

  /// Restores current session from storage and backend.
  Future<void> restoreSession() async {
    final isChecking = state.maybeWhen(
      checking: () => true,
      orElse: () => false,
    );
    if (isChecking) return;

    emit(const AuthSessionState.checking());

    try {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        final hasCompletedProgress = await _hasCompletedGuestProgressSafely();
        if (!hasCompletedProgress) {
          await _clearGuestProgressSafely();
          await _clearGuestSessionSafely();
        }
        if (!isClosed) {
          emit(
            hasCompletedProgress
                ? const AuthSessionState.guestResumeAvailable()
                : const AuthSessionState.unauthenticated(),
          );
        }
        return;
      }

      final result = await _repository.getCurrentUser();
      if (isClosed) return;

      switch (result) {
        case Success(data: final user):
          await _clearGuestProgressSafely();
          await _clearGuestSessionSafely();
          if (isClosed) return;
          emit(AuthSessionState.authenticated(user));
        case Failure(:final error):
          if (error is UnauthorizedAuthFailure) {
            await _clearTokenSafely();
            await _clearGuestProgressSafely();
            await _clearGuestSessionSafely();
            if (isClosed) return;
            emit(const AuthSessionState.unauthenticated());
            return;
          }

          if (isClosed) return;
          emit(const AuthSessionState.restoreFailed());
      }
    } catch (e, s) {
      _logger.e('RestoreSession failed with unexpected error.', e, s);
      if (isClosed) return;
      emit(const AuthSessionState.restoreFailed());
    }
  }

  Future<bool> _hasCompletedGuestProgressSafely() async {
    try {
      return await _fitnessStartProgressStorage.hasCompletedProgress();
    } catch (e, s) {
      _logger.e('Failed to read completed guest Fitness Start progress.', e, s);
      return false;
    }
  }

  Future<void> _saveGuestCompletedSafely() async {
    try {
      await _fitnessStartProgressStorage.saveCompleted();
    } catch (e, s) {
      _logger.e('Failed to persist completed guest Fitness Start progress.', e, s);
    }
  }

  Future<void> _clearGuestProgressSafely() async {
    try {
      await _fitnessStartProgressStorage.clear();
    } catch (e, s) {
      _logger.e('Failed to clear guest Fitness Start progress.', e, s);
    }
  }

  Future<void> _clearGuestSessionSafely() async {
    try {
      await _guestSessionStorage.clear();
    } catch (e, s) {
      _logger.e('Failed to clear guest session cookies.', e, s);
    }
  }

  Future<void> _clearTokenSafely() async {
    try {
      await _tokenStorage.deleteAccessToken();
    } catch (e, s) {
      _logger.e('Failed to clear access token during session restore.', e, s);
    }
  }

  /// Starts guest Fitness Start from the first quiz step.
  Future<void> startGuestFitnessStart() async {
    if (!isClosed) {
      emit(const AuthSessionState.guest());
    }
  }

  /// Continues with saved completed guest data after user confirmation on sign-in.
  void resumeGuestProgress() {
    final canResume = state.maybeWhen(
      guestResumeAvailable: () => true,
      orElse: () => false,
    );
    if (!canResume || isClosed) return;

    emit(const AuthSessionState.guestCompletedOnboarding());
  }

  /// Clears saved guest progress and restarts Fitness Start from the quiz stage.
  Future<void> restartGuestProgress() async {
    await _clearGuestProgressSafely();
    await _clearGuestSessionSafely();
    await startGuestFitnessStart();
  }

  /// Marks guest Fitness Start as completed and redirects user to registration.
  Future<void> completeGuestFitnessStart() async {
    await _saveGuestCompletedSafely();
    if (!isClosed) {
      emit(const AuthSessionState.guestCompletedOnboarding());
    }
  }

  /// Cancels the current guest onboarding flow.
  Future<void> cancelGuestFlow() async {
    final canCancel = state.maybeWhen(
      guest: () => true,
      guestCompletedOnboarding: () => true,
      orElse: () => false,
    );
    if (!canCancel) return;

    await _clearGuestProgressSafely();
    await _clearGuestSessionSafely();
    if (!isClosed) {
      emit(const AuthSessionState.unauthenticated());
    }
  }

  /// Sets session mode to authenticated after a successful sign-in.
  void onSignInSuccess(User user) {
    unawaited(_clearGuestProgressSafely());
    unawaited(_clearGuestSessionSafely());
    emit(AuthSessionState.authenticated(user));
  }

  /// Marks the current session as unauthenticated.
  void clearSession() {
    unawaited(_clearGuestProgressSafely());
    unawaited(_clearGuestSessionSafely());
    if (!isClosed) {
      emit(const AuthSessionState.unauthenticated());
    }
  }
}
