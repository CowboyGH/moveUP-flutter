import 'package:flutter/material.dart';

import '../../../../uikit/buttons/app_back_button.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';

/// Shared app bar for the Fitness Start flow.
class FitnessStartFlowAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Current progress in the flow, from `0` to `1`.
  final double progress;

  /// Title displayed in the app bar.
  final String? title;

  /// Whether the back button should be shown.
  final bool showBackButton;

  /// Callback triggered when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// Creates an instance of [FitnessStartFlowAppBar].
  const FitnessStartFlowAppBar({
    required this.progress,
    this.title,
    this.showBackButton = false,
    this.onBackPressed,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(82);

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: colorTheme.surface,
      surfaceTintColor: Colors.transparent,
      title: Text(
        title ?? '',
        style: textTheme.title.copyWith(
          fontSize: 20,
          height: 24 / 20,
        ),
      ),
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 24),
              child: AppBackButton(onPressed: onBackPressed),
            )
          : null,
      leadingWidth: showBackButton ? 40 : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 3, 24, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 8,
              backgroundColor: colorTheme.disabled.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(colorTheme.onSurface),
            ),
          ),
        ),
      ),
    );
  }
}
