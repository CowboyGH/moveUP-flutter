import 'package:flutter/material.dart';

/// Shared section with auth mode switch text and action button.
class AuthSwitchSection extends StatelessWidget {
  /// Top helper text.
  final String title;

  /// Action button text.
  final String actionText;

  /// Action callback.
  final VoidCallback? onPressed;

  /// Creates an instance of [AuthSwitchSection].
  const AuthSwitchSection({
    required this.title,
    required this.actionText,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: onPressed,
          child: Text(actionText),
        ),
      ],
    );
  }
}
