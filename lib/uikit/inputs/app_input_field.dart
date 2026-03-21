import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../themes/colors/app_color_theme.dart';
import '../themes/text/app_text_theme.dart';

/// Shared outlined input field.
class AppInputField extends StatefulWidget {
  /// Text controller.
  final TextEditingController controller;

  /// Field label shown above the input.
  final String labelText;

  /// Placeholder text.
  final String hintText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Keyboard configuration.
  final TextInputType keyboardType;

  /// Optional validation callback.
  final String? Function(String?)? validator;

  /// Keyboard action button.
  final TextInputAction? textInputAction;

  /// Optional input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Text alignment inside the input.
  final TextAlign textAlign;

  /// Creates an instance of [AppInputField].
  const AppInputField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.enabled,
    required this.keyboardType,
    this.validator,
    this.textInputAction,
    this.inputFormatters,
    this.textAlign = TextAlign.center,
    super.key,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final baseBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: colorTheme.disabled.withValues(alpha: 0.6)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Text(
            widget.labelText,
            style: textTheme.label.copyWith(color: colorTheme.hint),
          ),
        ),
        const SizedBox(height: 6),
        Semantics(
          label: widget.labelText,
          textField: true,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            inputFormatters: widget.inputFormatters,
            textInputAction: widget.textInputAction,
            textAlign: widget.textAlign,
            style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
            cursorColor: colorTheme.primary,
            decoration: InputDecoration(
              hintText: _focusNode.hasFocus ? null : widget.hintText,
              hintStyle: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
              isDense: true,
              contentPadding: const EdgeInsets.all(16),
              border: baseBorder,
              enabledBorder: baseBorder,
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: colorTheme.primary.withValues(alpha: 0.8)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: colorTheme.disabled),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
