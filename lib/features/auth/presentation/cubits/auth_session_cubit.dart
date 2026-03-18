import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/services/onboarding_flow_storage/onboarding_flow_storage.dart';
import '../../../../core/services/token_storage/token_storage.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../../fitness_start/domain/entities/fitness_start_stage.dart';
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

  /// Storage for the authenticated onboarding flow state.
  final OnboardingFlowStorage _onboardingFlowStorage;

  /// Logger for non-fatal session cleanup errors.
  final AppLogger _logger;

  /// Creates an instance of [AuthSessionCubit].
  AuthSessionCubit(
    this._repository,
    this._tokenStorage,
    this._onboardingFlowStorage,
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
        await _clearAuthenticatedOnboardingStateSafely();
        if (!isClosed) {
          emit(const AuthSessionState.unauthenticated());
        }
        return;
      }

      final result = await _repository.getCurrentUser();
      if (isClosed) return;

      switch (result) {
        case Success(data: final user):
          final hasPendingOnboarding = await _hasPendingOnboardingSafely();
          if (isClosed) return;
          if (!hasPendingOnboarding) {
            emit(AuthSessionState.authenticated(user));
            return;
          }

          final savedStage = await _getPendingOnboardingStageSafely();
          if (isClosed) return;
          emit(
            AuthSessionState.authenticatedOnboarding(
              user,
              savedStage ?? FitnessStartStage.quiz,
            ),
          );
        case Failure(:final error):
          if (error is UnauthorizedAuthFailure) {
            await _clearTokenSafely();
            await _clearAuthenticatedOnboardingStateSafely();
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

  Future<bool> _hasPendingOnboardingSafely() async {
    try {
      return await _onboardingFlowStorage.hasPendingOnboarding();
    } catch (e, s) {
      _logger.e('Failed to read pending onboarding state.', e, s);
      return false;
    }
  }

  Future<FitnessStartStage?> _getPendingOnboardingStageSafely() async {
    try {
      return await _onboardingFlowStorage.getPendingOnboardingStage();
    } catch (e, s) {
      _logger.e('Failed to read onboarding stage.', e, s);
      return null;
    }
  }

  Future<void> _savePendingOnboardingStageSafely(FitnessStartStage stage) async {
    try {
      await _onboardingFlowStorage.savePendingOnboardingStage(stage);
    } catch (e, s) {
      _logger.e('Failed to persist onboarding stage.', e, s);
    }
  }

  Future<void> _clearAuthenticatedOnboardingStateSafely() async {
    try {
      await _onboardingFlowStorage.clearPendingOnboarding();
    } catch (e, s) {
      _logger.e('Failed to clear authenticated onboarding state.', e, s);
    }
  }

  Future<void> _clearTokenSafely() async {
    try {
      await _tokenStorage.deleteAccessToken();
    } catch (e, s) {
      _logger.e('Failed to clear access token during session restore.', e, s);
    }
  }

  /// Sets session mode to guest and starts onboarding from the quiz stage.
  void continueAsGuest() {
    emit(const AuthSessionState.guest(FitnessStartStage.quiz));
  }

  /// Starts authenticated onboarding after successful email verification.
  Future<void> startAuthenticatedOnboarding(User user) async {
    await _savePendingOnboardingStageSafely(FitnessStartStage.quiz);
    if (!isClosed) {
      emit(AuthSessionState.authenticatedOnboarding(user, FitnessStartStage.quiz));
    }
  }

  /// Updates the current onboarding stage.
  Future<void> updateOnboardingStage(FitnessStartStage stage) async {
    final isGuest = state.maybeWhen(guest: (_) => true, orElse: () => false);
    if (isGuest) {
      if (!isClosed) {
        emit(AuthSessionState.guest(stage));
      }
      return;
    }

    final user = state.whenOrNull(
      authenticatedOnboarding: (user, _) => user,
    );
    if (user == null) return;

    await _savePendingOnboardingStageSafely(stage);
    if (!isClosed) {
      emit(AuthSessionState.authenticatedOnboarding(user, stage));
    }
  }

  /// Cancels the current guest onboarding flow.
  void cancelGuestFlow() {
    state.whenOrNull(
      guest: (_) {
        if (!isClosed) {
          emit(const AuthSessionState.unauthenticated());
        }
      },
    );
  }

  /// Sets session mode to authenticated after a successful sign-in.
  void onSignInSuccess(User user) {
    unawaited(_clearAuthenticatedOnboardingStateSafely());
    emit(AuthSessionState.authenticated(user));
  }

  /// Marks the current session as unauthenticated.
  void clearSession() {
    unawaited(_clearAuthenticatedOnboardingStateSafely());
    if (!isClosed) {
      emit(const AuthSessionState.unauthenticated());
    }
  }
}
