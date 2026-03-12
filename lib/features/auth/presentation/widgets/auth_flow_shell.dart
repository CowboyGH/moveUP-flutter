import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';

/// Shared layout shell for auth screens.
class AuthFlowShell extends StatelessWidget {
  /// Main card content.
  final Widget child;

  /// Optional top-right action (for example: `Пропустить`).
  final Widget? topRightAction;

  /// Whether the shell should show a back button in the top-left corner.
  final bool showBackButton;

  /// Optional back-button callback.
  final VoidCallback? onBackPressed;

  /// Creates an instance of [AuthFlowShell].
  const AuthFlowShell({
    required this.child,
    this.topRightAction,
    this.showBackButton = false,
    this.onBackPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              right: -99,
              bottom: 10,
              child: IgnorePointer(
                child: SizedBox(
                  width: 262,
                  height: 288,
                  child: ExcludeSemantics(
                    child: SvgPictureWidget.frame(AppAssets.imageFigure),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (showBackButton)
                        IconButton(
                          onPressed: onBackPressed,
                          padding: EdgeInsets.zero,
                          icon: SizedBox.square(
                            dimension: 24,
                            child: SvgPictureWidget.icon(
                              AppAssets.iconArrowBack,
                              fit: BoxFit.scaleDown,
                              color: colorTheme.onBackground,
                            ),
                          ),
                        )
                      else
                        const SizedBox.square(dimension: 24),

                      const Spacer(),
                      ?topRightAction,
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
                          decoration: BoxDecoration(
                            color: colorTheme.surface,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
