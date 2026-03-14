import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../themes/colors/app_color_theme.dart';
import 'svg_picture_widget.dart';

/// Tone variants supported by [AppDecorativeFigure].
enum FigureTone {
  /// Uses the asset's built-in color.
  neutral,

  /// Uses the theme primary color at 40% opacity.
  primary,

  /// Uses the theme secondary color at 50% opacity.
  secondary,
}

/// Shared decorative background figure for auth-style compositions.
class AppDecorativeFigure extends StatelessWidget {
  /// Tone applied to the figure.
  final FigureTone tone;

  /// How to inscribe the figure into its box.
  final BoxFit fit;

  /// Creates an instance of [AppDecorativeFigure].
  const AppDecorativeFigure({
    this.tone = FigureTone.neutral,
    this.fit = BoxFit.contain,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final color = switch (tone) {
      FigureTone.neutral => null,
      FigureTone.primary => colorTheme.primary.withValues(alpha: 0.4),
      FigureTone.secondary => colorTheme.secondary.withValues(alpha: 0.5),
    };
    return IgnorePointer(
      child: ExcludeSemantics(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.2),
          child: SvgPictureWidget.frame(
            AppAssets.imageFigure,
            color: color,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
