import 'package:flutter/material.dart';

import '../themes/colors/app_color_theme.dart';
import '../themes/text/app_text_theme.dart';
import 'button_state.dart';

/// Shared outlined option button.
class OptionButton extends StatelessWidget {
  /// The state of the button.
  final ButtonState state;

  /// The callback function to be executed when the button is pressed.
  final VoidCallback onPressed;

  /// Content of the button.
  final Widget child;

  /// Whether the button is currently selected.
  final bool isSelected;

  /// Creates an instance of [OptionButton].
  const OptionButton({
    this.state = ButtonState.enabled,
    required this.onPressed,
    required this.child,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final isDisabled = state == ButtonState.disabled;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style:
            OutlinedButton.styleFrom(
              fixedSize: const Size.fromHeight(53),
              padding: const EdgeInsets.all(16),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: textTheme.bodyMedium,
              foregroundColor: colorTheme.onSurface,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              backgroundColor: colorTheme.surface,
              shadowColor: Colors.transparent,
              overlayColor: Colors.transparent,
            ).copyWith(
              side: WidgetStateProperty.resolveWith((states) {
                if (isDisabled) return BorderSide(color: colorTheme.disabled);

                if (isSelected || states.contains(WidgetState.pressed)) {
                  return BorderSide(color: colorTheme.primary.withValues(alpha: 0.8));
                }
                return BorderSide(color: colorTheme.disabled.withValues(alpha: 0.6));
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (isDisabled) return colorTheme.disabled;
                return colorTheme.onSurface;
              }),
            ),
        child: child,
      ),
    );
  }
}
