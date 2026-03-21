import 'package:flutter/material.dart';

import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';

/// Compact chip that displays a testing category.
class TestingCategoryChip extends StatelessWidget {
  /// Category display name.
  final String label;

  /// Creates an instance of [TestingCategoryChip].
  const TestingCategoryChip({
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorTheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colorTheme.hint),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
        ),
      ),
    );
  }
}
