import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/router_paths.dart';
import '../cubits/forgot_password_cubit.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_flow_shell.dart';
import '../widgets/auth_text_field.dart';

/// Forgot-password page.
class ForgotPasswordPage extends StatefulWidget {
  /// Creates an instance of [ForgotPasswordPage].
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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

    context.read<ForgotPasswordCubit>().forgotPassword(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        state.whenOrNull(
          succeed: () => context.push(
            AppRoutePaths.verifyResetCodePath,
            extra: _emailController.text.trim(),
          ),
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
                  'Забыли пароль?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Введите email, который вы использовали при регистрации, мы отправим вам код для сброса пароля',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                AuthTextField(
                  controller: _emailController,
                  enabled: !isInProgress,
                  hintText: 'Введите email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: AuthValidators.email,
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
