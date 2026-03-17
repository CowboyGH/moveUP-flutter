part of 'otp_resend_cubit.dart';

/// State for [OtpResendCubit].
@freezed
abstract class OtpResendState with _$OtpResendState {
  /// Creates an instance of [OtpResendState].
  const factory OtpResendState({
    @Default(false) bool isInProgress,
    @Default(0) int secondsLeft,
    @Default(false) bool isSucceeded,
    AuthFailure? failure,
  }) = _OtpResendState;
}
