import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/router_paths.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../cubits/auth_session_cubit.dart';
import '../cubits/otp_resend_cubit.dart';
import '../cubits/verify_email_cubit.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_flow_shell.dart';
import '../widgets/auth_resend_code_text.dart';
import '../widgets/auth_text_field.dart';

/// Verify-email page.
class VerifyEmailPage extends StatefulWidget {
  /// User email used for OTP verification.
  final String email;

  /// Creates an instance of [VerifyEmailPage].
  const VerifyEmailPage({required this.email, super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
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

    context.read<VerifyEmailCubit>().verifyEmail(
      widget.email,
      _codeController.text.trim(),
    );
  }

  void _onResendPressed() => context.read<OtpResendCubit>().resendOtpCode(widget.email);

  void _handleBack() =>
      Navigator.of(context).canPop() ? context.pop() : context.go(AppRoutePaths.signUpPath);

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final verifyEmailState = context.watch<VerifyEmailCubit>().state;
    final otpResendState = context.watch<OtpResendCubit>().state;
    final isVerifyEmailInProgress = verifyEmailState.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    final isResendInProgress = otpResendState.isInProgress;
    final canResend =
        !isVerifyEmailInProgress && !isResendInProgress && otpResendState.secondsLeft == 0;
    return MultiBlocListener(
      listeners: [
        BlocListener<VerifyEmailCubit, VerifyEmailState>(
          listener: (context, state) {
            state.whenOrNull(
              succeed: (user) => context.read<AuthSessionCubit>().onSignInSuccess(user),
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
              _showSnack(AppStrings.verifyEmailResendSuccess);
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
        showBackButton: true,
        onBackPressed: _handleBack,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.verifyEmailTitle,
                textAlign: TextAlign.center,
                style: textTheme.title,
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.verifyEmailSubtitle,
                textAlign: TextAlign.center,
                style: textTheme.body,
              ),
              const SizedBox(height: 32),
              AuthTextField(
                controller: _codeController,
                enabled: !isVerifyEmailInProgress,
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
                state: isVerifyEmailInProgress ? ButtonState.loading : ButtonState.enabled,
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
