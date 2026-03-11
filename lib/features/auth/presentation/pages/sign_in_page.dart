import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/router_paths.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
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

  void _continueAsGuest() => context.read<AuthSessionCubit>().continueAsGuest();

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
        final textTheme = AppTextTheme.of(context);
        final colorTheme = AppColorTheme.of(context);
        final isInProgress = state.maybeWhen(
          inProgress: () => true,
          orElse: () => false,
        );
        return AuthFlowShell(
          topRightAction: TextButton(
            onPressed: isInProgress ? null : _continueAsGuest,
            style: TextButton.styleFrom(
              textStyle: textTheme.label.copyWith(fontSize: 14),
              foregroundColor: colorTheme.onSurface,
              overlayColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: const Text('Пропустить'),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Авторизация',
                  textAlign: TextAlign.center,
                  style: textTheme.title,
                ),
                const SizedBox(height: 12),
                Text(
                  'Введите email и пароль, чтобы войти в аккаунт',
                  textAlign: TextAlign.center,
                  style: textTheme.body,
                ),
                const SizedBox(height: 32),
                AuthTextField(
                  controller: _emailController,
                  enabled: !isInProgress,
                  labelText: 'Email',
                  hintText: 'email@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: AuthValidators.email,
                ),
                const SizedBox(height: 12),
                AuthPasswordField(
                  controller: _passwordController,
                  enabled: !isInProgress,
                  labelText: 'Пароль',
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: AuthValidators.password,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: isInProgress
                        ? null
                        : () => context.push(AppRoutePaths.forgotPasswordPath),
                    style: TextButton.styleFrom(
                      textStyle: textTheme.label,
                      foregroundColor: colorTheme.onSurface,
                      overlayColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text('Забыли пароль?'),
                  ),
                ),
                const SizedBox(height: 24),
                MainButton(
                  state: isInProgress ? ButtonState.loading : ButtonState.enabled,
                  onPressed: _submit,
                  child: const Text('Войти'),
                ),
                const SizedBox(height: 20),
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
