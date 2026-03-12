import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import 'auth_text_field.dart';

/// Reusable password field for auth screens with built-in visibility toggle.
class AuthPasswordField extends StatefulWidget {
  /// Text controller.
  final TextEditingController controller;

  /// Whether the field is enabled.
  final bool enabled;

  /// Field label shown above the input.
  final String labelText;

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
    required this.labelText,
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

  void _toggleVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: widget.controller,
      enabled: widget.enabled,
      labelText: widget.labelText,
      hint: const _PasswordHintDots(),
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      obscureText: !_isPasswordVisible,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Semantics(
          button: true,
          label: _isPasswordVisible ? AppStrings.authHidePassword : AppStrings.authShowPassword,
          child: IconButton(
            onPressed: widget.enabled ? _toggleVisibility : null,
            constraints: const BoxConstraints.tightFor(width: 18, height: 18),
            icon: Builder(
              builder: (context) {
                final iconColor = IconTheme.of(context).color ?? AppColorTheme.of(context).border;
                return SvgPictureWidget.icon(
                  _isPasswordVisible ? AppAssets.iconEyeOpen : AppAssets.iconEyeClose,
                  fit: BoxFit.scaleDown,
                  color: iconColor,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

final class _PasswordHintDots extends StatelessWidget {
  const _PasswordHintDots();

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    const count = 8;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (index) => Container(
          width: 6,
          height: 6,
          margin: EdgeInsets.only(right: index == count - 1 ? 0 : 3),
          decoration: BoxDecoration(
            color: colorTheme.hint,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
