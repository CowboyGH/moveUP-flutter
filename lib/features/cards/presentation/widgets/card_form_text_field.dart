import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';

/// Cards-specific text field used only inside the save-card flow.
class CardFormTextField extends StatelessWidget {
  /// Text controller.
  final TextEditingController controller;

  /// Whether the field is enabled.
  final bool enabled;

  /// Field label shown above the input.
  final String labelText;

  /// Optional label color override.
  final Color? labelColor;

  /// Placeholder text.
  final String? hintText;

  /// Optional semantics label when the visible label is hidden.
  final String? semanticsLabel;

  /// Keyboard configuration.
  final TextInputType keyboardType;

  /// Keyboard action button.
  final TextInputAction textInputAction;

  /// Optional validator.
  final String? Function(String?)? validator;

  /// Optional submit callback.
  final ValueChanged<String>? onFieldSubmitted;

  /// Optional input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Whether to hide text.
  final bool obscureText;

  /// Whether the visible label should be rendered.
  final bool showLabel;

  /// Whether validation error text should be shown.
  final bool showErrorText;

  /// Creates an instance of [CardFormTextField].
  const CardFormTextField({
    required this.controller,
    required this.enabled,
    required this.labelText,
    required this.keyboardType,
    required this.textInputAction,
    this.labelColor,
    this.hintText,
    this.semanticsLabel,
    this.validator,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.obscureText = false,
    this.showLabel = true,
    this.showErrorText = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          ExcludeSemantics(
            child: Text(
              labelText,
              style: textTheme.label.copyWith(color: labelColor ?? colorTheme.onSurface),
            ),
          ),
          const SizedBox(height: 4),
        ],
        Semantics(
          label: semanticsLabel ?? labelText,
          textField: true,
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            inputFormatters: inputFormatters,
            style: textTheme.body.copyWith(color: colorTheme.onSurface),
            cursorColor: colorTheme.primary,
            decoration: InputDecoration(
              hintText: hintText,
              errorStyle: showErrorText
                  ? null
                  : const TextStyle(
                      fontSize: 0,
                      height: 0,
                      color: Colors.transparent,
                    ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
