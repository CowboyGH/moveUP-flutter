import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'sign_in_cubit.freezed.dart';
part 'sign_in_state.dart';

/// Cubit that manages sign-in flow and emits [SignInState].
final class SignInCubit extends Cubit<SignInState> {
  /// Logger for tracking authentication operations and errors.
  final AppLogger _logger;

  /// Authentication repository used for sign-in requests.
  final AuthRepository _repository;

  /// Creates an instance of [SignInCubit].
  SignInCubit(this._logger, this._repository) : super(const SignInState.initial());

  /// Attempts to sign in with [email] and [password].
  Future<void> signIn(String email, String password) async {
    if (state is _InProgress) return;

    _logger.i('signInRequested');
    emit(const SignInState.inProgress());

    final result = await _repository.signIn(email, password);
    switch (result) {
      case Success(data: final user):
        _logger.i('signInCompleted');
        emit(SignInState.succeed(user));
      case Failure(:final error):
        _logger.w('signInFailed');
        emit(SignInState.failed(error));
    }
  }
}
