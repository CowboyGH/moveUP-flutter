import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/router_paths.dart';
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
        final isInProgress = state.maybeWhen(
          inProgress: () => true,
          orElse: () => false,
        );
        return AuthFlowShell(
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
                const SizedBox(height: 32),
                AuthPasswordField(
                  controller: _passwordController,
                  enabled: !isInProgress,
                  hintText: 'Введите новый пароль',
                  textInputAction: TextInputAction.next,
                  validator: AuthValidators.password,
                ),
                const SizedBox(height: 12),
                AuthPasswordField(
                  controller: _passwordConfirmationController,
                  enabled: !isInProgress,
                  hintText: 'Подтвердите пароль',
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: _passwordConfirmationValidator,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: isInProgress ? null : _submit,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: isInProgress
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
        );
      },
    );
  }
}
