import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../../core/result/result.dart';
import '../../domain/repositories/profile_repository.dart';

part 'change_password_cubit.freezed.dart';
part 'change_password_state.dart';

/// Cubit that manages the change-password flow.
final class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ProfileRepository _repository;

  /// Creates an instance of [ChangePasswordCubit].
  ChangePasswordCubit(this._repository) : super(const ChangePasswordState.initial());

  /// Attempts to change the current authenticated user password.
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const ChangePasswordState.inProgress());

    final result = await _repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const ChangePasswordState.succeed());
      case Failure(:final error):
        emit(ChangePasswordState.failed(error));
    }
  }
}
