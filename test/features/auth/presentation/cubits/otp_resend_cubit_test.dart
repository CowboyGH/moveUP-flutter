import 'package:bloc_test/bloc_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/auth/domain/entities/otp_resend_flow.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:moveup_flutter/features/auth/presentation/cubits/otp_resend_cubit.dart';

import 'otp_resend_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  late MockAuthRepository repository;
  late OtpResendCubit otpResendCubit;

  const email = 'email';
  const emailVerificationFlow = OtpResendFlow.emailVerification;
  const resetPasswordFlow = OtpResendFlow.resetPassword;

  setUp(() {
    repository = MockAuthRepository();
    otpResendCubit = OtpResendCubit(repository);
    provideDummy<Result<void, AuthFailure>>(const Success<void, AuthFailure>(null));
  });

  group('OtpResendCubit', () {
    const authFailure = AuthRateLimitedFailure();

    test('initial state is clear (no progress, no feedback, zero cooldown)', () {
      expect(otpResendCubit.state, const OtpResendState());
    });

    blocTest<OtpResendCubit, OtpResendState>(
      'resendOtpCode is executed only once when called twice during inProgress',
      setUp: () => when(repository.resendOtpCode(email, emailVerificationFlow)).thenAnswer(
        (_) async => const Success<void, AuthFailure>(null),
      ),
      build: () => otpResendCubit,
      act: (cubit) {
        cubit.resendOtpCode(email, emailVerificationFlow);
        cubit.resendOtpCode(email, emailVerificationFlow);
      },
      expect: () => const [
        OtpResendState(isInProgress: true),
        OtpResendState(secondsLeft: 60, isSucceeded: true),
      ],
      verify: (_) => verify(repository.resendOtpCode(email, emailVerificationFlow)).called(1),
    );

    test('startCooldown sets countdown to 60', () {
      fakeAsync((async) {
        otpResendCubit.startCooldown();
        expect(otpResendCubit.state.secondsLeft, 60);
      });
    });

    test('startCooldown decrements to zero', () {
      fakeAsync((async) {
        otpResendCubit.startCooldown();
        expect(otpResendCubit.state.secondsLeft, 60);

        async.elapse(const Duration(seconds: 60));
        expect(otpResendCubit.state.secondsLeft, 0);
      });
    });

    test('resendOtpCode does nothing when cooldown is active', () {
      fakeAsync((_) {
        otpResendCubit.startCooldown();

        otpResendCubit.resendOtpCode(email, emailVerificationFlow);

        verifyNever(repository.resendOtpCode(any, any));
      });
    });

    test(
      'initializeEmailVerification starts cooldown without resend when code is already sent',
      () {
        fakeAsync((_) {
          otpResendCubit.initializeEmailVerification(
            email: email,
            resendOnOpen: false,
          );

          expect(otpResendCubit.state.secondsLeft, 60);
          verifyNever(repository.resendOtpCode(any, any));
        });
      },
    );

    blocTest<OtpResendCubit, OtpResendState>(
      'emits inProgress and success state, then restarts cooldown on success',
      setUp: () => when(repository.resendOtpCode(email, resetPasswordFlow)).thenAnswer(
        (_) async => const Success<void, AuthFailure>(null),
      ),
      build: () => otpResendCubit,
      act: (cubit) => cubit.resendOtpCode(email, resetPasswordFlow),
      expect: () => const [
        OtpResendState(isInProgress: true),
        OtpResendState(secondsLeft: 60, isSucceeded: true),
      ],
      verify: (_) => verify(repository.resendOtpCode(email, resetPasswordFlow)).called(1),
    );

    blocTest<OtpResendCubit, OtpResendState>(
      'emits inProgress and failure on repository failure',
      setUp: () => when(repository.resendOtpCode(email, resetPasswordFlow)).thenAnswer(
        (_) async => const Failure(authFailure),
      ),
      build: () => otpResendCubit,
      act: (cubit) => cubit.resendOtpCode(email, resetPasswordFlow),
      expect: () => const [
        OtpResendState(isInProgress: true),
        OtpResendState(failure: authFailure),
      ],
      verify: (_) => verify(repository.resendOtpCode(email, resetPasswordFlow)).called(1),
    );

    blocTest<OtpResendCubit, OtpResendState>(
      'initializeEmailVerification resends code on open when requested',
      setUp: () => when(repository.resendOtpCode(email, emailVerificationFlow)).thenAnswer(
        (_) async => const Success<void, AuthFailure>(null),
      ),
      build: () => otpResendCubit,
      act: (cubit) => cubit.initializeEmailVerification(
        email: email,
        resendOnOpen: true,
      ),
      expect: () => const [
        OtpResendState(isInProgress: true),
        OtpResendState(secondsLeft: 60, isSucceeded: true),
      ],
      verify: (_) => verify(repository.resendOtpCode(email, emailVerificationFlow)).called(1),
    );
  });
}
