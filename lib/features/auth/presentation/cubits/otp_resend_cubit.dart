import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/otp_resend_flow.dart';
import '../../domain/repositories/auth_repository.dart';

part 'otp_resend_cubit.freezed.dart';
part 'otp_resend_state.dart';

/// Cubit that manages OTP resend requests and resend cooldown.
final class OtpResendCubit extends Cubit<OtpResendState> {
  static const int _cooldownSeconds = 60;

  /// Authentication repository used for resend requests.
  final AuthRepository _repository;

  Timer? _cooldownTimer;

  /// Creates an instance of [OtpResendCubit].
  OtpResendCubit(this._repository) : super(const OtpResendState());

  /// Attempts to resend OTP code for [email] and [flow].
  Future<void> resendOtpCode(String email, OtpResendFlow flow) async {
    if (state.isInProgress || state.secondsLeft > 0) return;

    emit(
      state.copyWith(
        isInProgress: true,
        isSucceeded: false,
        failure: null,
      ),
    );

    final result = await _repository.resendOtpCode(email, flow);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            isInProgress: false,
            secondsLeft: _cooldownSeconds,
            isSucceeded: true,
            failure: null,
          ),
        );
        _startCooldownTimer();
      case Failure(:final error):
        emit(
          state.copyWith(
            isInProgress: false,
            isSucceeded: false,
            failure: error,
          ),
        );
    }
  }

  /// Initializes verify-email resend state according to the entry scenario.
  Future<void> initializeEmailVerification({
    required String email,
    required bool resendOnOpen,
  }) async {
    if (resendOnOpen) {
      await resendOtpCode(email, OtpResendFlow.emailVerification);
      return;
    }
    startCooldown();
  }

  /// Starts or restarts the cooldown timer.
  void startCooldown() {
    emit(state.copyWith(secondsLeft: _cooldownSeconds));
    _startCooldownTimer();
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }

      if (state.secondsLeft <= 1) {
        timer.cancel();
        emit(state.copyWith(secondsLeft: 0));
        return;
      }

      emit(state.copyWith(secondsLeft: state.secondsLeft - 1));
    });
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
  }
}
