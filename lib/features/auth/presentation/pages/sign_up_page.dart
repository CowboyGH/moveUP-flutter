import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/router_paths.dart';
import '../cubits/auth_session_cubit.dart';
import '../cubits/sign_up_cubit.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_flow_shell.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_switch_section.dart';
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
      _showSnack('Подтвердите согласие с условиями обработки персональных данных');
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
            onPressed: isInProgress
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
                  validator: AuthValidators.name,
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
                _ConsentRow(
                  isAgree: _isAgree,
                  enabled: !isInProgress,
                  onTap: () => setState(() => _isAgree = !_isAgree),
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
                AuthSwitchSection(
                  title: 'Уже есть аккаунт?',
                  actionText: 'Войти',
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

  const _ConsentRow({
    required this.isAgree,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            height: 16,
            width: 16,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isAgree ? Theme.of(context).colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: isAgree ? Colors.transparent : Theme.of(context).colorScheme.outline,
              ),
            ),
            child: isAgree
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
    );
  }
}
