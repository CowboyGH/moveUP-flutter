import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../images/svg_picture_widget.dart';
import '../themes/colors/app_color_theme.dart';

/// Shared back button with the current app iconography.
class AppBackButton extends StatelessWidget {
  /// Callback triggered when the button is pressed.
  final VoidCallback? onPressed;

  /// Creates an instance of [AppBackButton].
  const AppBackButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    return Semantics(
      button: true,
      label: MaterialLocalizations.of(context).backButtonTooltip,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: SizedBox.square(
          dimension: 24,
          child: SvgPictureWidget.icon(
            AppAssets.iconArrowBack,
            fit: BoxFit.scaleDown,
            color: colorTheme.onBackground,
          ),
        ),
      ),
    );
  }
}
