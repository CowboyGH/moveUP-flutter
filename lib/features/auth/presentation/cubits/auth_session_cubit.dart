import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/services/token_storage/token_storage.dart';
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

  /// Creates an instance of [AuthSessionCubit].
  AuthSessionCubit(this._repository, this._tokenStorage) : super(const AuthSessionState.initial());

  /// Restores current session from storage and backend.
  Future<void> restoreSession() async {
    // if (state is _Checking) return;

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
            // Defensive cleanup for terminal 401 after interceptor refresh/retry
            // (e.g. race condition or backend/client state mismatch).
            await _tokenStorage.deleteAccessToken();
            if (isClosed) return;
          }
          emit(const AuthSessionState.unauthenticated());
      }
    } catch (_) {
      if (!isClosed) {
        emit(const AuthSessionState.unauthenticated());
      }
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

  /// Clears session and emits unauthenticated state.
  Future<void> logout() async {
    // TODO(feature/auth-logout): call backend /logout before local token cleanup.
    try {
      await _tokenStorage.deleteAccessToken();
    } finally {
      if (!isClosed) {
        emit(const AuthSessionState.unauthenticated());
      }
    }
  }
}
