import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth_session_cubit.dart';
import '../cubits/sign_in_cubit.dart';

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

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

    if (value.length > 128) {
      return 'Пароль слишком длинный';
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
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (!kDebugMode || isInProgress)
                          ? null
                          : () => context.read<AuthSessionCubit>().continueAsGuest(),
                      child: const Text('Пропустить'),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
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
                                TextFormField(
                                  controller: _emailController,
                                  enabled: !isInProgress,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    hintText: 'Введите email',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  validator: _emailValidator,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _passwordController,
                                  enabled: !isInProgress,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: !_isPasswordVisible,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _submit(),
                                  decoration: InputDecoration(
                                    hintText: 'Введите пароль',
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: isInProgress
                                          ? null
                                          : () => setState(() {
                                              _isPasswordVisible = !_isPasswordVisible;
                                            }),
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                      ),
                                    ),
                                  ),
                                  validator: _passwordValidator,
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
                                Text(
                                  'Еще нет аккаунта?',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 4),
                                const TextButton(
                                  onPressed: null,
                                  child: Text('Зарегистрироваться'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
