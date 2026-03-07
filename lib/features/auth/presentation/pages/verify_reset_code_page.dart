import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/otp_resend_cubit.dart';
import '../cubits/verify_reset_code_cubit.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_flow_shell.dart';
import '../widgets/auth_text_field.dart';

/// Verify-reset-code page.
class VerifyResetCodePage extends StatefulWidget {
  /// User email used for reset code verification.
  final String email;

  /// Creates an instance of [VerifyResetCodePage].
  const VerifyResetCodePage({required this.email, super.key});

  @override
  State<VerifyResetCodePage> createState() => _VerifyResetCodePageState();
}

class _VerifyResetCodePageState extends State<VerifyResetCodePage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OtpResendCubit>().startCooldown();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    context.read<VerifyResetCodeCubit>().verifyResetCode(
      widget.email,
      _codeController.text.trim(),
    );
  }

  String _formatTimer(int secondsLeft) {
    final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onResendPressed() => context.read<OtpResendCubit>().resendOtpCode(widget.email);

  @override
  Widget build(BuildContext context) {
    final verifyResetCodeState = context.watch<VerifyResetCodeCubit>().state;
    final otpResendState = context.watch<OtpResendCubit>().state;
    final isVerifyResetCodeInProgress = verifyResetCodeState.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    final isResendInProgress = otpResendState.isInProgress;
    final canResend =
        !isVerifyResetCodeInProgress && !isResendInProgress && otpResendState.secondsLeft == 0;
    return MultiBlocListener(
      listeners: [
        BlocListener<VerifyResetCodeCubit, VerifyResetCodeState>(
          listener: (context, state) {
            state.whenOrNull(
              succeed: () => _showSnack('Код сброса пароля успешно подтвержден.'),
              failed: (failure) {
                if (failure.message.isNotEmpty) {
                  _showSnack(failure.message);
                }
              },
            );
          },
        ),
        BlocListener<OtpResendCubit, OtpResendState>(
          listenWhen: (previous, current) =>
              previous.isSucceeded != current.isSucceeded || previous.failure != current.failure,
          listener: (context, state) {
            if (state.isSucceeded) {
              _showSnack('Код для сброса пароля повторно отправлен на вашу почту.');
              return;
            }
            final failure = state.failure;
            if (failure != null && failure.message.isNotEmpty) {
              _showSnack(failure.message);
            }
          },
        ),
      ],
      child: AuthFlowShell(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Восстановление\nпароля',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Введите код, отправленный на почту',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              AuthTextField(
                controller: _codeController,
                enabled: !isVerifyResetCodeInProgress,
                hintText: 'Введите код',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: AuthValidators.otpCode,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: canResend ? _onResendPressed : null,
                    child: const Text('Отправить повторно'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTimer(otpResendState.secondsLeft),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: isVerifyResetCodeInProgress ? null : _submit,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: isVerifyResetCodeInProgress
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : const Text('Отправить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
