import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/router_paths.dart';
import '../../../../uikit/buttons/app_text_action.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/buttons/secondary_button.dart';
import '../../../../uikit/dialogs/app_action_dialog.dart';
import '../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../cubits/auth_session_cubit.dart';
import '../cubits/sign_in_cubit.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_flow_shell.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_switch_section.dart';
import '../widgets/auth_text_field.dart';

/// Sign-in page.
class SignInPage extends StatefulWidget {
  /// Creates an instance of [SignInPage].
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isResumeDialogVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeShowResumeDialog(context.read<AuthSessionCubit>().state);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    context.read<SignInCubit>().signIn(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  void _startFitnessStart() => unawaited(_startFitnessStartFlow());

  Future<void> _startFitnessStartFlow() async {
    await context.read<AuthSessionCubit>().startGuestFitnessStart();
    if (!mounted) return;
    context.go(AppRoutePaths.fitnessStartQuizPath);
  }

  void _maybeShowResumeDialog(AuthSessionState state) {
    if (_isResumeDialogVisible) return;

    final shouldShowDialog = state.whenOrNull(guestResumeAvailable: () => true);
    if (shouldShowDialog != true) return;

    _isResumeDialogVisible = true;
    _showResumeDialog().whenComplete(() => _isResumeDialogVisible = false);
  }

  Future<void> _showResumeDialog() => showAppActionDialog(
    context,
    title: AppStrings.fitnessStartCompletedTitle,
    description: AppStrings.fitnessStartCompletedMessage,
    primaryAction: MainButton(
      onPressed: () async {
        context.pop();
        await context.read<AuthSessionCubit>().restartGuestProgress();
        if (!mounted) return;
        context.go(AppRoutePaths.fitnessStartQuizPath);
      },
      child: const Text(AppStrings.fitnessStartRestartAction),
    ),
    secondaryAction: SecondaryButton(
      onPressed: () {
        context.pop();
        context.read<AuthSessionCubit>().resumeGuestProgress();
        context.go(AppRoutePaths.signUpPath);
      },
      child: const Text(AppStrings.fitnessStartRegisterAction),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthSessionCubit, AuthSessionState>(
      listenWhen: (previous, current) =>
          previous.maybeWhen(guestResumeAvailable: () => true, orElse: () => false) !=
          current.maybeWhen(guestResumeAvailable: () => true, orElse: () => false),
      listener: (context, state) {
        _maybeShowResumeDialog(state);
      },
      child: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          state.whenOrNull(
            succeed: (user) => context.read<AuthSessionCubit>().onSignInSuccess(user),
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
        builder: (context, state) {
          final textTheme = AppTextTheme.of(context);
          final isInProgress = state.maybeWhen(
            inProgress: () => true,
            orElse: () => false,
          );
          return AuthFlowShell(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.signInTitle,
                    textAlign: TextAlign.center,
                    style: textTheme.title,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.signInSubtitle,
                    textAlign: TextAlign.center,
                    style: textTheme.body,
                  ),
                  const SizedBox(height: 32),
                  AuthTextField(
                    controller: _emailController,
                    enabled: !isInProgress,
                    labelText: AppStrings.emailLabel,
                    hintText: AppStrings.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: AuthValidators.email,
                  ),
                  const SizedBox(height: 12),
                  AuthPasswordField(
                    controller: _passwordController,
                    enabled: !isInProgress,
                    labelText: AppStrings.signInPasswordLabel,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: AuthValidators.password,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppTextAction(
                      text: AppStrings.signInForgotPasswordButton,
                      onPressed: isInProgress
                          ? null
                          : () => context.push(AppRoutePaths.forgotPasswordPath),
                      style: textTheme.label,
                    ),
                  ),
                  const SizedBox(height: 24),
                  MainButton(
                    state: isInProgress ? ButtonState.loading : ButtonState.enabled,
                    onPressed: _submit,
                    child: const Text(AppStrings.signInSubmitButton),
                  ),
                  const SizedBox(height: 20),
                  AuthSwitchSection(
                    title: AppStrings.signInSwitchTitle,
                    actionText: AppStrings.signInSwitchAction,
                    onPressed: isInProgress ? null : _startFitnessStart,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
