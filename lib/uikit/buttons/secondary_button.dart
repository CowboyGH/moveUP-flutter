import 'package:flutter/material.dart';

import '../themes/colors/app_color_theme.dart';
import '../themes/text/app_text_theme.dart';
import 'button_state.dart';

const _kSecondaryButtonBorderRadius = BorderRadius.all(Radius.circular(8));

/// A customizable secondary button widget.
class SecondaryButton extends StatelessWidget {
  /// The state of the button.
  final ButtonState state;

  /// The callback function to be executed when the button is pressed.
  final VoidCallback onPressed;

  /// Content of the button.
  final Widget child;

  /// Creates an instance of [SecondaryButton].
  const SecondaryButton({
    super.key,
    this.state = ButtonState.enabled,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final isDisabled = state == ButtonState.disabled;
    final isLoading = state == ButtonState.loading;

    return ElevatedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style:
          ElevatedButton.styleFrom(
            textStyle: textTheme.button,
            overlayColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            fixedSize: const Size.fromHeight(38),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const RoundedRectangleBorder(borderRadius: _kSecondaryButtonBorderRadius),
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (isDisabled) return colorTheme.disabled.withValues(alpha: 0.1);
              if (states.contains(WidgetState.pressed)) {
                return colorTheme.primary.withValues(alpha: 0.08);
              }
              return colorTheme.primary.withValues(alpha: 0.1);
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (isDisabled) return colorTheme.disabled.withValues(alpha: 0.4);
              if (states.contains(WidgetState.pressed)) {
                return colorTheme.primary.withValues(alpha: 0.6);
              }
              return colorTheme.primary.withValues(alpha: 0.8);
            }),
            shape: WidgetStateProperty.resolveWith((states) {
              if (isDisabled) {
                return RoundedRectangleBorder(
                  borderRadius: _kSecondaryButtonBorderRadius,
                  side: BorderSide(color: colorTheme.disabled),
                );
              }
              if (states.contains(WidgetState.pressed)) {
                return RoundedRectangleBorder(
                  borderRadius: _kSecondaryButtonBorderRadius,
                  side: BorderSide(color: colorTheme.primary.withValues(alpha: 0.6)),
                );
              }
              return RoundedRectangleBorder(
                borderRadius: _kSecondaryButtonBorderRadius,
                side: BorderSide(color: colorTheme.primary.withValues(alpha: 0.8)),
              );
            }),
          ),
      child: !isLoading
          ? child
          : SizedBox.square(
              dimension: 16,
              child: Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: colorTheme.onPrimary,
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colorTheme.primary),
                ),
              ),
            ),
    );
  }
}
