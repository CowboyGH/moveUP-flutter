import 'package:flutter/material.dart';

import '../themes/colors/app_color_theme.dart';

/// Shared text-only action link.
class AppTextAction extends StatelessWidget {
  /// Visible action label.
  final String text;

  /// Callback for the action.
  final VoidCallback? onPressed;

  /// Optional text style for the label.
  final TextStyle? style;

  /// Text alignment.
  final TextAlign textAlign;

  /// Creates an instance of [AppTextAction].
  const AppTextAction({
    required this.text,
    required this.onPressed,
    this.style,
    this.textAlign = TextAlign.start,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final themeStyle = Theme.of(context).textButtonTheme.style;
    return TextButton(
      onPressed: onPressed,
      style: themeStyle?.copyWith(
        textStyle: WidgetStatePropertyAll(style ?? DefaultTextStyle.of(context).style),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return colorTheme.disabled;
          if (states.contains(WidgetState.pressed)) return colorTheme.primary;
          return colorTheme.onSurface;
        }),
      ),
      child: Text(text, textAlign: textAlign),
    );
  }
}
