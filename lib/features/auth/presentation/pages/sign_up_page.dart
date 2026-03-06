import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/router_paths.dart';
import '../cubits/auth_session_cubit.dart';
import '../cubits/sign_up_cubit.dart';
import '../widgets/auth_flow_shell.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_text_field.dart';

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

  bool _isAgree = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите имя';
    }
    if (value.length > 20) {
      return 'Длина имени должна быть не более 20 символов';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите email';
    }

    final emailPattern = RegExp(
      r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~%-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$",
    );

    if (!emailPattern.hasMatch(value.trim())) {
      return 'Неверный формат email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }

    if (value.length < 8) {
      return 'Пароль должен содержать минимум 8 символов';
    }
    if (value.length > 64) {
      return 'Пароль должен быть не длиннее 64 символов';
    }

    final allowedCharsPattern = RegExp(r'^[A-Za-z0-9]+$');
    if (!allowedCharsPattern.hasMatch(value)) {
      return 'Пароль должен содержать только латинские буквы и цифры';
    }

    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    if (!hasLetter || !hasDigit) {
      return 'Пароль должен содержать буквы и цифры';
    }

    return null;
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

    if (!_isAgree) {
      // TODO: сделать норм текст
      _showSnack('Подтвердите согласие');
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
            _showSnack('Регистрация прошла успешно. Проверьте почту для получения кода.');
            context.go(AppRoutePaths.signInPath);
          },
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
          topRightAction: TextButton(
            onPressed: (!kDebugMode || isInProgress)
                ? null
                : () => context.read<AuthSessionCubit>().continueAsGuest(),
            child: const Text('Пропустить'),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Регистрация',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                AuthTextField(
                  controller: _nameController,
                  enabled: !isInProgress,
                  hintText: 'Введите имя',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: _nameValidator,
                ),
                const SizedBox(height: 12),
                AuthTextField(
                  controller: _emailController,
                  enabled: !isInProgress,
                  hintText: 'Введите email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _emailValidator,
                ),
                const SizedBox(height: 12),
                AuthPasswordField(
                  controller: _passwordController,
                  enabled: !isInProgress,
                  hintText: 'Введите пароль',
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: _passwordValidator,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: isInProgress ? null : () => setState(() => _isAgree = !_isAgree),
                      child: Container(
                        height: 16,
                        width: 16,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _isAgree
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: _isAgree
                                ? Colors.transparent
                                : Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: _isAgree
                            ? Icon(
                                Icons.check,
                                size: 12,
                                color: Theme.of(context).colorScheme.onPrimary,
                              )
                            : null,
                      ),
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Я согласен с ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              text: 'Политикой конфиденциальности ',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: 'и даю ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              text: 'Согласие на обработку персональных данных',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                      : const Text('Зарегистрироваться'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Уже есть аккаунт?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: isInProgress ? null : () => context.go(AppRoutePaths.signInPath),
                  child: const Text('Войти'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
