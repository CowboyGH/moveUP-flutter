import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';

part 'verify_reset_code_cubit.freezed.dart';
part 'verify_reset_code_state.dart';

/// Cubit that manages verify-reset-code flow and emits [VerifyResetCodeState].
final class VerifyResetCodeCubit extends Cubit<VerifyResetCodeState> {
  /// Authentication repository used for verify-reset-code requests.
  final AuthRepository _repository;

  /// Creates an instance of [VerifyResetCodeCubit].
  VerifyResetCodeCubit(this._repository) : super(const VerifyResetCodeState.initial());

  /// Attempts to verify reset code [code] for [email].
  Future<void> verifyResetCode(String email, String code) async {
    if (state is _InProgress) return;

    emit(const VerifyResetCodeState.inProgress());

    final result = await _repository.verifyResetCode(email, code);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const VerifyResetCodeState.succeed());
      case Failure(:final error):
        emit(VerifyResetCodeState.failed(error));
    }
  }
}
