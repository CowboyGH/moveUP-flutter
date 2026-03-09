import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';

part 'forgot_password_cubit.freezed.dart';
part 'forgot_password_state.dart';

/// Cubit that manages forgot-password flow and emits [ForgotPasswordState].
final class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  /// Authentication repository used for forgot-password requests.
  final AuthRepository _repository;

  /// Creates an instance of [ForgotPasswordCubit].
  ForgotPasswordCubit(this._repository) : super(const ForgotPasswordState.initial());

  /// Attempts to request password reset OTP for [email].
  Future<void> forgotPassword(String email) async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const ForgotPasswordState.inProgress());

    final result = await _repository.forgotPassword(email);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const ForgotPasswordState.succeed());
      case Failure(:final error):
        emit(ForgotPasswordState.failed(error));
    }
  }
}
