import 'package:flutter/material.dart';

import '../../../../uikit/buttons/app_text_action.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';

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
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$title ',
          textAlign: TextAlign.center,
          style: textTheme.body.copyWith(color: colorTheme.onSurface),
        ),
        AppTextAction(
          text: actionText,
          onPressed: onPressed,
          style: textTheme.label,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
