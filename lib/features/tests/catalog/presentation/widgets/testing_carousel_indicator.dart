import 'package:flutter/material.dart';

import '../../../../../uikit/themes/colors/app_color_theme.dart';

/// Dots indicator for tests catalog carousel.
class TestingCarouselIndicator extends StatelessWidget {
  /// Total amount of pages.
  final int itemCount;

  /// Currently selected page index.
  final int currentIndex;

  /// Creates an instance of [TestingCarouselIndicator].
  const TestingCarouselIndicator({
    required this.itemCount,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isSelected = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 10,
          height: 10,
          margin: EdgeInsetsDirectional.only(end: index == itemCount - 1 ? 0 : 10),
          decoration: BoxDecoration(
            color: isSelected ? colorTheme.primary : colorTheme.disabled.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
