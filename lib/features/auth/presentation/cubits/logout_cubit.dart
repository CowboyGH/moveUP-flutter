import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';

part 'logout_cubit.freezed.dart';
part 'logout_state.dart';

/// Cubit that manages logout flow and emits [LogoutState].
final class LogoutCubit extends Cubit<LogoutState> {
  /// Authentication repository used for logout requests.
  final AuthRepository _repository;

  /// Creates an instance of [LogoutCubit].
  LogoutCubit(this._repository) : super(const LogoutState.initial());

  /// Attempts to logout the current user.
  Future<void> logout() async {
    if (state is _InProgress) return;

    emit(const LogoutState.inProgress());

    final result = await _repository.logout();
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const LogoutState.succeed());
      case Failure(:final error):
        if (error is UnauthorizedAuthFailure) {
          emit(const LogoutState.succeed());
          return;
        }
        emit(LogoutState.failed(error));
    }
  }
}
