import 'package:flutter/material.dart';

import 'auth_text_field.dart';

/// Reusable password field for auth screens with built-in visibility toggle.
class AuthPasswordField extends StatefulWidget {
  /// Text controller.
  final TextEditingController controller;

  /// Whether the field is enabled.
  final bool enabled;

  /// Placeholder text.
  final String hintText;

  /// Keyboard action button.
  final TextInputAction textInputAction;

  /// Optional validator.
  final String? Function(String?)? validator;

  /// Optional submit callback.
  final ValueChanged<String>? onFieldSubmitted;

  /// Creates an instance of [AuthPasswordField].
  const AuthPasswordField({
    required this.controller,
    required this.enabled,
    required this.hintText,
    required this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    super.key,
  });

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: widget.controller,
      enabled: widget.enabled,
      hintText: widget.hintText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      obscureText: !_isPasswordVisible,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      suffixIcon: IconButton(
        onPressed: widget.enabled
            ? () => setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              })
            : null,
        icon: Icon(
          _isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
        ),
      ),
    );
  }
}
