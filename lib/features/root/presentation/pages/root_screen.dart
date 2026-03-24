import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';

/// Root screen that hosts the main app shell with bottom navigation.
class RootScreen extends StatelessWidget {
  /// Nested navigation shell for the main app tabs.
  final StatefulNavigationShell navigationShell;

  /// Creates an instance of [RootScreen].
  const RootScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(10, 0, 10, 16),
        child: _GlassBottomNavBar(
          selectedIndex: navigationShell.currentIndex,
          onSelected: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          colorTheme: colorTheme,
        ),
      ),
    );
  }
}

const _navItems = <({String label, String iconAsset})>[
  (
    label: AppStrings.testsTab,
    iconAsset: AppAssets.iconTests,
  ),
  (
    label: AppStrings.trainingsTab,
    iconAsset: AppAssets.iconTrainings,
  ),
  (
    label: AppStrings.profileTab,
    iconAsset: AppAssets.iconProfile,
  ),
];

final class _GlassBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final AppColorTheme colorTheme;

  const _GlassBottomNavBar({
    required this.selectedIndex,
    required this.onSelected,
    required this.colorTheme,
  });

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(54));
    return SizedBox(
      height: 52,
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: const SizedBox.expand(),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                color: colorTheme.surface.withValues(alpha: 0.10),
                border: Border.all(
                  color: colorTheme.primary.withValues(alpha: 0.08),
                ),
              ),
            ),
            Row(
              children: [
                for (var i = 0; i < _navItems.length; i++)
                  Expanded(
                    child: _RootNavBarItem(
                      label: _navItems[i].label,
                      iconAsset: _navItems[i].iconAsset,
                      isSelected: i == selectedIndex,
                      selectedColor: colorTheme.primary,
                      unselectedColor: colorTheme.darkHint,
                      onTap: () => onSelected(i),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _RootNavBarItem extends StatelessWidget {
  final String label;
  final String iconAsset;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _RootNavBarItem({
    required this.label,
    required this.iconAsset,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: SvgPictureWidget.icon(
          iconAsset,
          color: color,
        ),
      ),
    );
  }
}
