import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
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

  /// Logger for non-fatal session cleanup errors.
  final AppLogger _logger;

  /// Creates an instance of [AuthSessionCubit].
  AuthSessionCubit(this._repository, this._tokenStorage, this._logger)
    : super(const AuthSessionState.initial());

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
        if (!isClosed) {
          emit(const AuthSessionState.unauthenticated());
        }
        return;
      }

      final result = await _repository.getCurrentUser();
      if (isClosed) return;

      switch (result) {
        case Success(data: final user):
          emit(AuthSessionState.authenticated(user));
        case Failure(:final error):
          if (error is UnauthorizedAuthFailure) {
            await _clearTokenSafely();
            if (isClosed) return;
            emit(const AuthSessionState.unauthenticated());
            return;
          }

          if (isClosed) return;
          emit(const AuthSessionState.restoreFailed());
      }
    } catch (_) {
      if (isClosed) return;
      emit(const AuthSessionState.restoreFailed());
    }
  }

  Future<void> _clearTokenSafely() async {
    try {
      await _tokenStorage.deleteAccessToken();
    } catch (error, stackTrace) {
      _logger.e(
        'Failed to clear access token during session restore.',
        error,
        stackTrace,
      );
    }
  }

  /// Sets session mode to guest.
  void continueAsGuest() {
    emit(const AuthSessionState.guest());
  }

  /// Sets session mode to authenticated after a successful sign-in.
  void onSignInSuccess(User user) {
    emit(AuthSessionState.authenticated(user));
  }

  /// Marks the current session as unauthenticated.
  void clearSession() {
    if (!isClosed) {
      emit(const AuthSessionState.unauthenticated());
    }
  }
}
