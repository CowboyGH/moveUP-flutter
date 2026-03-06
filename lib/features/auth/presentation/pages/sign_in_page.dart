import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/router_paths.dart';
import '../cubits/auth_session_cubit.dart';
import '../cubits/sign_in_cubit.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_switch_section.dart';
import '../widgets/auth_flow_shell.dart';
import '../widgets/auth_password_field.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

    context.read<SignInCubit>().signIn(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
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
                  'Авторизация',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                AuthTextField(
                  controller: _emailController,
                  enabled: !isInProgress,
                  hintText: 'Введите email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: AuthValidators.email,
                ),
                const SizedBox(height: 12),
                AuthPasswordField(
                  controller: _passwordController,
                  enabled: !isInProgress,
                  hintText: 'Введите пароль',
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: AuthValidators.password,
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: null,
                    child: Text('Забыли пароль?'),
                  ),
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
                      : const Text('Войти'),
                ),
                const SizedBox(height: 16),
                AuthSwitchSection(
                  title: 'Еще нет аккаунта?',
                  actionText: 'Зарегистрироваться',
                  onPressed: isInProgress ? null : () => context.go(AppRoutePaths.signUpPath),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
