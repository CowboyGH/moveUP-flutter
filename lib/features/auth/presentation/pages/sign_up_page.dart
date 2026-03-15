import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/router_paths.dart';
import '../../../../uikit/buttons/app_text_action.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../cubits/auth_session_cubit.dart';
import '../cubits/sign_up_cubit.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_flow_shell.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_switch_section.dart';
import '../widgets/auth_text_field.dart';
import 'legal_document_type.dart';

/// Sign-up page.
class SignUpPage extends StatefulWidget {
  /// Creates an instance of [SignUpPage].
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final TapGestureRecognizer _privacyPolicyTapRecognizer;
  late final TapGestureRecognizer _dataProcessingConsentTapRecognizer;

  bool _isAgree = false;

  @override
  void initState() {
    super.initState();
    _privacyPolicyTapRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push(
        AppRoutePaths.legalDocumentPath,
        extra: LegalDocumentType.privacyPolicy,
      );
    _dataProcessingConsentTapRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push(
        AppRoutePaths.legalDocumentPath,
        extra: LegalDocumentType.dataProcessingConsent,
      );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _privacyPolicyTapRecognizer.dispose();
    _dataProcessingConsentTapRecognizer.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    if (!_isAgree) {
      showAppFeedbackDialog(
        context,
        title: AppStrings.feedbackConsentRequiredTitle,
        message: AppStrings.signUpConsentSnack,
      );
      return;
    }

    context.read<SignUpCubit>().signUp(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        state.whenOrNull(
          succeed: (_) {
            context.go(
              AppRoutePaths.verifyEmailPath,
              extra: _emailController.text.trim(),
            );
          },
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
          topRightAction: AppTextAction(
            text: AppStrings.skipButton,
            onPressed: isInProgress
                ? null
                : () => context.read<AuthSessionCubit>().continueAsGuest(),
            style: textTheme.label.copyWith(
              fontSize: 14,
              height: 21 / 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.signUpTitle,
                  textAlign: TextAlign.center,
                  style: textTheme.title,
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.signUpSubtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.body,
                ),
                const SizedBox(height: 32),
                AuthTextField(
                  controller: _nameController,
                  enabled: !isInProgress,
                  labelText: AppStrings.signUpNameLabel,
                  hintText: AppStrings.signUpNameHint,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: AuthValidators.name,
                ),
                const SizedBox(height: 12),
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
                  labelText: AppStrings.signUpPasswordLabel,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: AuthValidators.password,
                ),
                const SizedBox(height: 8),
                _ConsentRow(
                  isAgree: _isAgree,
                  enabled: !isInProgress,
                  onTap: () => setState(() => _isAgree = !_isAgree),
                  privacyPolicyTapRecognizer: isInProgress ? null : _privacyPolicyTapRecognizer,
                  dataProcessingConsentTapRecognizer: isInProgress
                      ? null
                      : _dataProcessingConsentTapRecognizer,
                ),
                const SizedBox(height: 24),
                MainButton(
                  state: isInProgress ? ButtonState.loading : ButtonState.enabled,
                  onPressed: _submit,
                  child: const Text(AppStrings.signUpSubmitButton),
                ),
                const SizedBox(height: 20),
                AuthSwitchSection(
                  title: AppStrings.signUpSwitchTitle,
                  actionText: AppStrings.signUpSwitchAction,
                  onPressed: isInProgress ? null : () => context.go(AppRoutePaths.signInPath),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Local sign-up widget for consent checkbox and legal text.
final class _ConsentRow extends StatelessWidget {
  final bool isAgree;
  final bool enabled;
  final VoidCallback onTap;
  final TapGestureRecognizer? privacyPolicyTapRecognizer;
  final TapGestureRecognizer? dataProcessingConsentTapRecognizer;

  const _ConsentRow({
    required this.isAgree,
    required this.enabled,
    required this.onTap,
    required this.privacyPolicyTapRecognizer,
    required this.dataProcessingConsentTapRecognizer,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Row(
      children: [
        Semantics(
          label: AppStrings.signUpConsentCheckboxLabel,
          checked: isAgree,
          enabled: enabled,
          onTap: enabled ? onTap : null,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 16,
              width: 16,
              margin: const EdgeInsets.only(left: 4, right: 6),
              decoration: BoxDecoration(
                color: isAgree ? colorTheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: isAgree ? colorTheme.primary : const Color(0xFF727272),
                ),
              ),
              child: isAgree
                  ? Icon(
                      Icons.check_rounded,
                      size: 12,
                      color: colorTheme.onPrimary,
                    )
                  : null,
            ),
          ),
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: AppStrings.signUpConsentPrefix,
                  style: textTheme.bodySmall.copyWith(color: colorTheme.onSurface),
                ),
                TextSpan(
                  text: AppStrings.signUpConsentPrivacyPolicy,
                  style: textTheme.bodySmall.copyWith(
                    color: colorTheme.onSurface,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: privacyPolicyTapRecognizer,
                ),
                TextSpan(
                  text: AppStrings.signUpConsentMiddle,
                  style: textTheme.bodySmall.copyWith(color: colorTheme.onSurface),
                ),
                TextSpan(
                  text: AppStrings.signUpConsentDataProcessing,
                  style: textTheme.bodySmall.copyWith(
                    color: colorTheme.onSurface,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: dataProcessingConsentTapRecognizer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
