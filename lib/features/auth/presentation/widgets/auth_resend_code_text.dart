import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/buttons/app_text_action.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';

/// Inline resend action with optional countdown timer.
class AuthResendCodeText extends StatelessWidget {
  /// Whether resend action is currently available.
  final bool enabled;

  /// Remaining cooldown in seconds.
  final int secondsLeft;

  /// Callback for resend action.
  final VoidCallback? onPressed;

  /// Creates an instance of [AuthResendCodeText].
  const AuthResendCodeText({
    required this.enabled,
    required this.secondsLeft,
    required this.onPressed,
    super.key,
  });

  String _formatTimer() {
    final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final canResend = enabled && onPressed != null && secondsLeft == 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        AppTextAction(
          text: AppStrings.authResendCodeAction,
          onPressed: canResend ? onPressed : null,
          style: textTheme.body.copyWith(
            fontWeight: canResend ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        if (secondsLeft != 0)
          Text(
            ' ${_formatTimer()}',
            style: textTheme.label.copyWith(color: colorTheme.onSurface),
          ),
      ],
    );
  }
}
