import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';

/// Shared section with auth mode switch text and action button.
class AuthSwitchSection extends StatefulWidget {
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
  State<AuthSwitchSection> createState() => _AuthSwitchSectionState();
}

class _AuthSwitchSectionState extends State<AuthSwitchSection> {
  late final TapGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = TapGestureRecognizer()..onTap = widget.onPressed;
  }

  @override
  void didUpdateWidget(covariant AuthSwitchSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _recognizer.onTap = widget.onPressed;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '${widget.title} ',
              style: textTheme.body.copyWith(color: colorTheme.onSurface),
            ),
            TextSpan(
              text: widget.actionText,
              style: textTheme.label.copyWith(color: colorTheme.onSurface),
              recognizer: _recognizer,
            ),
          ],
        ),
      ),
    );
  }
}
