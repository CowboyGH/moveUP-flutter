import 'package:flutter/material.dart';

/// Reusable auth text field with shared decoration style.
class AuthTextField extends StatelessWidget {
  /// Text controller.
  final TextEditingController controller;

  /// Whether the field is enabled.
  final bool enabled;

  /// Placeholder text.
  final String hintText;

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
    required this.hintText,
    required this.keyboardType,
    required this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.obscureText = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
