import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../images/svg_picture_widget.dart';
import '../themes/colors/app_color_theme.dart';
import '../themes/text/app_text_theme.dart';

/// Shared compact search field.
class AppSearchField extends StatelessWidget {
  /// Text controller.
  final TextEditingController controller;

  /// Placeholder text.
  final String hintText;

  /// Creates an instance of [AppSearchField].
  const AppSearchField({
    required this.controller,
    required this.hintText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return TextField(
      controller: controller,
      cursorColor: colorTheme.primary,
      style: textTheme.bodyMedium,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: colorTheme.surface,
        hintText: hintText,
        hintStyle: textTheme.body.copyWith(color: colorTheme.outline),
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: SvgPictureWidget.icon(
            AppAssets.iconSearch,
            fit: BoxFit.scaleDown,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minHeight: 20,
          minWidth: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorTheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorTheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorTheme.primary.withValues(alpha: 0.8)),
        ),
      ),
    );
  }
}
