import 'package:flutter/material.dart';

import '../../../../uikit/images/svg_picture_widget.dart';

/// The first Flutter frame shown while session restore is in progress.
class SplashPage extends StatelessWidget {
  /// Creates a [SplashPage].
  const SplashPage({super.key});
  static const _overlayColor = Color(0x42000000);
  static const _backgroundImagePath = 'assets/images/splash_bg.jpg';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_backgroundImagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  _overlayColor,
                  BlendMode.srcOver,
                ),
              ),
            ),
          ),
          Center(
            child: SvgPictureWidget.frame(
              'logo',
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
      ),
    );
  }
}
