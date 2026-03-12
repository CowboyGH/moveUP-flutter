import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';

/// Inline resend action with optional countdown timer.
class AuthResendCodeText extends StatefulWidget {
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

  @override
  State<AuthResendCodeText> createState() => _AuthResendCodeTextState();
}

class _AuthResendCodeTextState extends State<AuthResendCodeText> {
  late final TapGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = TapGestureRecognizer();
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  String _formatTimer(int secondsLeft) {
    final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    _recognizer.onTap = widget.enabled ? widget.onPressed : null;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: AppStrings.authResendCodeAction,
            style: textTheme.body.copyWith(
              color: widget.enabled ? colorTheme.onSurface : colorTheme.hint,
              fontWeight: widget.secondsLeft != 0 ? FontWeight.normal : FontWeight.w500,
            ),
            recognizer: _recognizer,
          ),
          if (widget.secondsLeft != 0) ...[
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: SizedBox(width: 8),
            ),
            TextSpan(
              text: _formatTimer(widget.secondsLeft),
              style: textTheme.label.copyWith(color: colorTheme.onSurface),
            ),
          ],
        ],
      ),
    );
  }
}
