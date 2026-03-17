import 'package:flutter/material.dart';

import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';

/// Reusable auth text field with shared decoration style.
class AuthTextField extends StatelessWidget {
  /// Text controller.
  final TextEditingController controller;

  /// Whether the field is enabled.
  final bool enabled;

  /// Field label shown above the input.
  final String labelText;

  /// Placeholder text.
  final String? hintText;

  /// Optional custom hint widget.
  final Widget? hint;

  /// Keyboard configuration.
  final TextInputType keyboardType;

  /// Keyboard action button.
  final TextInputAction textInputAction;

  /// Optional validator.
  final String? Function(String?)? validator;

  /// Optional submit callback.
  final ValueChanged<String>? onFieldSubmitted;

  /// Optional suffix icon widget.
  final Widget? suffixIcon;

  /// Whether to hide text.
  final bool obscureText;

  /// Creates an instance of [AuthTextField].
  const AuthTextField({
    required this.controller,
    required this.enabled,
    required this.labelText,
    required this.keyboardType,
    required this.textInputAction,
    this.hintText,
    this.hint,
    this.validator,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.obscureText = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Text(
            labelText,
            style: textTheme.label.copyWith(color: colorTheme.onSurface),
          ),
        ),
        const SizedBox(height: 4),
        Semantics(
          label: labelText,
          textField: true,
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            style: textTheme.body.copyWith(color: colorTheme.onSurface),
            cursorColor: colorTheme.primary,
            decoration: InputDecoration(
              hint: hint,
              hintText: hint == null ? hintText : null,
              suffixIcon: suffixIcon,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
