import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/images/app_decorative_figure.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';

/// Offline fallback screen shown when network access is unavailable.
class OfflinePage extends StatelessWidget {
  /// Creates an instance of [OfflinePage].
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: -97,
            top: 35,
            child: Transform.scale(
              scaleX: -1,
              scaleY: -1,
              child: const AppDecorativeFigure(tone: FigureTone.primary),
            ),
          ),
          const Positioned(
            right: -97,
            bottom: -65,
            child: AppDecorativeFigure(tone: FigureTone.secondary),
          ),
          Padding(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 24),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: .center,
                      mainAxisSize: .min,
                      children: [
                        const SvgPictureWidget.icon(AppAssets.iconNoConnection),
                        const SizedBox(height: 44),
                        Text(
                          AppStrings.noConnectionTitle,
                          textAlign: TextAlign.center,
                          style: textTheme.title,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppStrings.noConnectionSubtitle,
                          textAlign: TextAlign.center,
                          style: textTheme.body.copyWith(
                            fontSize: 16,
                            height: 24 / 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
