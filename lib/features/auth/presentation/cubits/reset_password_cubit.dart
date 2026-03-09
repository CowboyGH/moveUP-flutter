import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';

part 'reset_password_cubit.freezed.dart';
part 'reset_password_state.dart';

/// Cubit that manages reset-password flow and emits [ResetPasswordState].
final class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  /// Authentication repository used for reset-password requests.
  final AuthRepository _repository;

  /// Creates an instance of [ResetPasswordCubit].
  ResetPasswordCubit(this._repository) : super(const ResetPasswordState.initial());

  /// Attempts to reset password for [email] and verified [code].
  Future<void> resetPassword(
    String email,
    String code,
    String password,
    String passwordConfirmation,
  ) async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const ResetPasswordState.inProgress());

    final result = await _repository.resetPassword(
      email,
      code,
      password,
      passwordConfirmation,
    );
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const ResetPasswordState.succeed());
      case Failure(:final error):
        emit(ResetPasswordState.failed(error));
    }
  }
}
