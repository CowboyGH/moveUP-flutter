import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'verify_email_cubit.freezed.dart';
part 'verify_email_state.dart';

/// Cubit that manages verify-email flow and emits [VerifyEmailState].
final class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  /// Authentication repository used for verify-email requests.
  final AuthRepository _repository;

  /// Creates an instance of [VerifyEmailCubit].
  VerifyEmailCubit(this._repository) : super(const VerifyEmailState.initial());

  /// Attempts to verify email with [email] and otp [code].
  Future<void> verifyEmail(String email, String code) async {
    if (state is _InProgress) return;

    emit(const VerifyEmailState.inProgress());

    final result = await _repository.verifyEmail(email, code);
    if (isClosed) return;

    switch (result) {
      case Success(data: final user):
        emit(VerifyEmailState.succeed(user));
      case Failure(:final error):
        emit(VerifyEmailState.failed(error));
    }
  }
}
