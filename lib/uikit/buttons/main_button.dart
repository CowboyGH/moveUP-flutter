import 'package:flutter/material.dart';

import '../themes/colors/app_color_theme.dart';
import '../themes/text/app_text_theme.dart';
import 'button_state.dart';

/// A customizable main button widget.
class MainButton extends StatelessWidget {
  /// The state of the button.
  final ButtonState state;

  /// The callback function to be executed when the button is pressed.
  final VoidCallback onPressed;

  /// Content of the button.
  final Widget child;

  /// Creates an instance of [MainButton].
  const MainButton({
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (isLoading) return colorTheme.primary;
              if (isDisabled) return colorTheme.disabled;
              if (states.contains(WidgetState.pressed)) {
                return colorTheme.primary.withValues(alpha: 0.4);
              }
              return colorTheme.primary;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (isLoading) return colorTheme.onPrimary;
              if (isDisabled) return colorTheme.onDisabled;
              if (states.contains(WidgetState.pressed)) return colorTheme.primary;
              return colorTheme.onPrimary;
            }),
            shape: WidgetStateProperty.resolveWith((states) {
              final side = !isDisabled && !isLoading && states.contains(WidgetState.pressed)
                  ? BorderSide(color: colorTheme.primary.withValues(alpha: 0.8))
                  : BorderSide.none;
              return RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                side: side,
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
