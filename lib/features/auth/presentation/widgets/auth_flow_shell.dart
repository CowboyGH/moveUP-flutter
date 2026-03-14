import 'package:flutter/material.dart';

import '../../../../uikit/buttons/app_back_button.dart';
import '../../../../uikit/images/app_decorative_figure.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/colors/app_gradients.dart';

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
              right: -65,
              bottom: 10,
              child: AppDecorativeFigure(tone: FigureTone.secondary),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (showBackButton)
                        AppBackButton(onPressed: onBackPressed)
                      else
                        const SizedBox.square(dimension: 24),

                      const Spacer(),
                      ?topRightAction,
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppGradients.secondaryLinear,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: colorTheme.surface,
                                borderRadius: BorderRadius.circular(23),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 36,
                                ),
                                child: child,
                              ),
                            ),
                          ),
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
