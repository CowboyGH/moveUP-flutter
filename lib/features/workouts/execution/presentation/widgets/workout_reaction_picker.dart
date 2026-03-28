import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../uikit/images/svg_picture_widget.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../domain/entities/workout_exercise_reaction.dart';

/// Reaction picker used on the workout execution exercise screen.
class WorkoutReactionPicker extends StatelessWidget {
  /// Callback triggered when user selects a reaction.
  final ValueChanged<WorkoutExerciseReaction> onSelected;

  /// Currently selected reaction, if any.
  final WorkoutExerciseReaction? selectedReaction;

  /// Whether the picker is currently interactive.
  final bool isEnabled;

  /// Creates an instance of [WorkoutReactionPicker].
  const WorkoutReactionPicker({
    required this.onSelected,
    this.selectedReaction,
    this.isEnabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: SizedBox(
        width: 248,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ReactionButton(
              asset: AppAssets.iconBadFace,
              isEnabled: isEnabled,
              isSelected: selectedReaction == WorkoutExerciseReaction.bad,
              onPressed: () => onSelected(WorkoutExerciseReaction.bad),
            ),
            _ReactionButton(
              asset: AppAssets.iconNormalFace,
              isEnabled: isEnabled,
              isSelected: selectedReaction == WorkoutExerciseReaction.normal,
              onPressed: () => onSelected(WorkoutExerciseReaction.normal),
            ),
            _ReactionButton(
              asset: AppAssets.iconGoodFace,
              isEnabled: isEnabled,
              isSelected: selectedReaction == WorkoutExerciseReaction.good,
              onPressed: () => onSelected(WorkoutExerciseReaction.good),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  final String asset;
  final bool isEnabled;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ReactionButton({
    required this.asset,
    required this.isEnabled,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    return IconButton(
      isSelected: isSelected,
      onPressed: isEnabled ? onPressed : null,
      padding: EdgeInsets.zero,
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorTheme.disabled;
          }
          if (states.contains(WidgetState.selected) || states.contains(WidgetState.pressed)) {
            return colorTheme.primary;
          }
          return colorTheme.hint;
        }),
      ),
      icon: Builder(
        builder: (context) {
          final color = IconTheme.of(context).color ?? colorTheme.hint;
          return SvgPictureWidget.icon(asset, color: color);
        },
      ),
    );
  }
}
