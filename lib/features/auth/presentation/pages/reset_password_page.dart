import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/router_paths.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../cubits/reset_password_cubit.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_flow_shell.dart';
import '../widgets/auth_password_field.dart';

/// Reset-password page.
class ResetPasswordPage extends StatefulWidget {
  /// User email for reset-password request.
  final String email;

  /// Verified OTP code for reset-password request.
  final String code;

  /// Creates an instance of [ResetPasswordPage].
  const ResetPasswordPage({
    required this.email,
    required this.code,
    super.key,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
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

    context.read<ResetPasswordCubit>().resetPassword(
      widget.email,
      widget.code,
      _passwordController.text,
      _passwordConfirmationController.text,
    );
  }

  String? _passwordConfirmationValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Подтвердите пароль';
    }

    if (value != _passwordController.text) {
      return 'Пароли не совпадают';
    }

    return null;
  }

  void _handleBack() =>
      Navigator.of(context).canPop() ? context.pop() : context.go(AppRoutePaths.forgotPasswordPath);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        state.whenOrNull(
          succeed: () => context.go(AppRoutePaths.signInPath),
          failed: (failure) {
            if (failure.message.isNotEmpty) {
              _showSnack(failure.message);
            }
          },
        );
      },
      builder: (context, state) {
        final textTheme = AppTextTheme.of(context);
        final colorTheme = AppColorTheme.of(context);
        final isInProgress = state.maybeWhen(
          inProgress: () => true,
          orElse: () => false,
        );
        return AuthFlowShell(
          showBackButton: true,
          onBackPressed: _handleBack,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Восстановление\nпароля',
                  textAlign: TextAlign.center,
                  style: textTheme.title,
                ),
                const SizedBox(height: 12),
                Text(
                  'Введите новый пароль, чтобы завершить восстановление доступа',
                  textAlign: TextAlign.center,
                  style: textTheme.body,
                ),
                const SizedBox(height: 32),
                AuthPasswordField(
                  controller: _passwordController,
                  enabled: !isInProgress,
                  labelText: 'Новый пароль',
                  textInputAction: TextInputAction.next,
                  validator: AuthValidators.password,
                ),
                const SizedBox(height: 12),
                AuthPasswordField(
                  controller: _passwordConfirmationController,
                  enabled: !isInProgress,
                  labelText: 'Повторите пароль',
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: _passwordConfirmationValidator,
                ),
                const SizedBox(height: 24),
                MainButton(
                  state: isInProgress ? ButtonState.loading : ButtonState.enabled,
                  onPressed: _submit,
                  child: const Text('Отправить'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
