import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/router_paths.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../cubits/otp_resend_cubit.dart';
import '../cubits/verify_reset_code_cubit.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_flow_shell.dart';
import '../widgets/auth_resend_code_text.dart';
import '../widgets/auth_text_field.dart';
import 'reset_password_route_args.dart';

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

  void _onResendPressed() => context.read<OtpResendCubit>().resendOtpCode(widget.email);

  void _handleBack() =>
      Navigator.of(context).canPop() ? context.pop() : context.go(AppRoutePaths.forgotPasswordPath);

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
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
              succeed: () => context.push(
                AppRoutePaths.resetPasswordPath,
                extra: ResetPasswordRouteArgs(
                  email: widget.email,
                  code: _codeController.text.trim(),
                ),
              ),
              failed: (failure) {
                if (failure.message.isNotEmpty) {
                  showAppFeedbackDialog(
                    context,
                    title: AppStrings.feedbackErrorTitle,
                    message: failure.message,
                  );
                }
              },
            );
          },
        ),
        BlocListener<OtpResendCubit, OtpResendState>(
          listenWhen: (previous, current) =>
              previous.isSucceeded != current.isSucceeded || previous.failure != current.failure,
          listener: (context, state) {
            final failure = state.failure;
            if (failure != null && failure.message.isNotEmpty) {
              showAppFeedbackDialog(
                context,
                title: AppStrings.feedbackErrorTitle,
                message: failure.message,
              );
            }
          },
        ),
      ],
      child: AuthFlowShell(
        showBackButton: true,
        onBackPressed: _handleBack,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.verifyResetCodeTitle,
                textAlign: TextAlign.center,
                style: textTheme.title,
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.verifyResetCodeSubtitle,
                textAlign: TextAlign.center,
                style: textTheme.body,
              ),
              const SizedBox(height: 32),
              AuthTextField(
                controller: _codeController,
                enabled: !isVerifyResetCodeInProgress,
                labelText: AppStrings.codeLabel,
                hintText: AppStrings.codeHint,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: AuthValidators.otpCode,
              ),
              const SizedBox(height: 8),
              AuthResendCodeText(
                enabled: canResend,
                secondsLeft: otpResendState.secondsLeft,
                onPressed: _onResendPressed,
              ),
              const SizedBox(height: 24),
              MainButton(
                state: isVerifyResetCodeInProgress ? ButtonState.loading : ButtonState.enabled,
                onPressed: _submit,
                child: const Text(AppStrings.sendButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
