import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/di/di.dart';
import '../../../../../uikit/buttons/app_text_action.dart';
import '../../../../../uikit/buttons/button_state.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/buttons/secondary_button.dart';
import '../../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../../auth/presentation/validators/auth_validators.dart';
import '../../../auth/presentation/widgets/auth_password_field.dart';
import '../../domain/repositories/profile_repository.dart';
import '../cubits/change_password_cubit.dart';
import 'profile_dialog_shell.dart';

/// Result returned by the change-password dialog.
enum ChangePasswordDialogResult {
  /// The password was changed successfully.
  changed,

  /// The user wants to enter the forgot-password flow instead.
  forgotPassword,
}

/// Opens the change-password dialog.
Future<ChangePasswordDialogResult?> showChangePasswordDialog(BuildContext context) {
  return showProfileDialog<ChangePasswordDialogResult>(
    context,
    insetPadding: const EdgeInsets.symmetric(horizontal: 19.5),
    contentPadding: const .symmetric(horizontal: 28, vertical: 40),
    child: BlocProvider(
      create: (_) => ChangePasswordCubit(di<ProfileRepository>()),
      child: const ChangePasswordDialog(),
    ),
  );
}

/// Dialog for changing the authenticated user password.
class ChangePasswordDialog extends StatefulWidget {
  /// Creates an instance of [ChangePasswordDialog].
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmationController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmationController.dispose();
    super.dispose();
  }

  String? _confirmationValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.resetPasswordPasswordConfirmationRequired;
    }
    if (value != _newPasswordController.text) {
      return AppStrings.resetPasswordPasswordMismatch;
    }
    return null;
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    context.read<ChangePasswordCubit>().changePassword(
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
      newPasswordConfirmation: _newPasswordConfirmationController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        state.whenOrNull(
          succeed: () => Navigator.of(context).pop(ChangePasswordDialogResult.changed),
          failed: (failure) {
            if (failure.message.isEmpty) return;
            showAppFeedbackDialog(
              context,
              title: AppStrings.feedbackErrorTitle,
              message: failure.message,
            );
          },
        );
      },
      builder: (context, state) {
        final isInProgress = state.maybeWhen(
          inProgress: () => true,
          orElse: () => false,
        );
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Text(
                AppStrings.profileChangePasswordTitle,
                textAlign: TextAlign.center,
                style: textTheme.title.copyWith(
                  fontSize: 18,
                  height: 27 / 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              AuthPasswordField(
                controller: _oldPasswordController,
                enabled: !isInProgress,
                labelText: AppStrings.profileOldPasswordLabel,
                textInputAction: TextInputAction.next,
                validator: AuthValidators.password,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: AppTextAction(
                  text: AppStrings.signInForgotPasswordButton,
                  onPressed: isInProgress
                      ? null
                      : () => Navigator.of(
                          context,
                        ).pop(ChangePasswordDialogResult.forgotPassword),
                  style: textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 12),
              AuthPasswordField(
                controller: _newPasswordController,
                enabled: !isInProgress,
                labelText: AppStrings.profileNewPasswordLabel,
                textInputAction: TextInputAction.next,
                validator: AuthValidators.password,
              ),
              const SizedBox(height: 12),
              AuthPasswordField(
                controller: _newPasswordConfirmationController,
                enabled: !isInProgress,
                labelText: AppStrings.profilePasswordConfirmationLabel,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: _confirmationValidator,
              ),
              const SizedBox(height: 36),
              MainButton(
                state: isInProgress ? ButtonState.loading : ButtonState.enabled,
                onPressed: _submit,
                child: const Text(AppStrings.profileChangePasswordButton),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                state: isInProgress ? ButtonState.disabled : ButtonState.enabled,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(AppStrings.profileCancelButton),
              ),
            ],
          ),
        );
      },
    );
  }
}
