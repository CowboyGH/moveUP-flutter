import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../uikit/images/svg_picture_widget.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';

/// Compact outlined button that toggles the tests categories dropdown.
class TestsCatalogFilterButton extends StatelessWidget {
  /// Callback executed when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the dropdown is currently visible.
  final bool isSelected;

  /// Creates an instance of [TestsCatalogFilterButton].
  const TestsCatalogFilterButton({
    required this.onPressed,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final isDisabled = onPressed == null;
    return OutlinedButton(
      onPressed: onPressed,
      style:
          OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: colorTheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            overlayColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ).copyWith(
            side: WidgetStateProperty.resolveWith((states) {
              if (isDisabled) return BorderSide(color: colorTheme.disabled);
              return BorderSide(color: colorTheme.outline);
            }),
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.testsCatalogFilterLabel,
            style: textTheme.bodyMedium.copyWith(
              color: isDisabled ? colorTheme.disabled : colorTheme.hint,
            ),
          ),
          const SizedBox(width: 8),
          SvgPictureWidget.icon(
            AppAssets.iconFilter,
            color: isDisabled ? colorTheme.disabled : colorTheme.outline,
          ),
        ],
      ),
    );
  }
}
