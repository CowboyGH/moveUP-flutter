import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../uikit/images/svg_picture_widget.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';

/// Local close button used by the workout execution screen.
class WorkoutCloseButton extends StatelessWidget {
  /// Callback triggered when the button is pressed.
  final VoidCallback? onPressed;

  /// Creates an instance of [WorkoutCloseButton].
  const WorkoutCloseButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: MaterialLocalizations.of(context).closeButtonTooltip,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: SizedBox.square(
          dimension: 24,
          child: Builder(
            builder: (context) {
              final iconColor = IconTheme.of(context).color ?? AppColorTheme.of(context).onSurface;
              return SvgPictureWidget.icon(
                AppAssets.iconClose,
                fit: BoxFit.scaleDown,
                color: iconColor,
              );
            },
          ),
        ),
      ),
    );
  }
}
