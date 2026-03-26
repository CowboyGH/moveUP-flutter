import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/cards/app_card.dart';
import '../../../../../uikit/images/network_image_widget.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/workout_details_item.dart';

/// Card widget for a workout details item.
class WorkoutDetailsCard extends StatelessWidget {
  /// Workout item displayed inside the card.
  final WorkoutDetailsItem item;

  /// Callback fired when the action button is pressed.
  final VoidCallback onPressed;

  /// Creates an instance of [WorkoutDetailsCard].
  const WorkoutDetailsCard({
    required this.item,
    required this.onPressed,
    super.key,
  });

  static String _workoutsMinutes(int count) {
    final mod10 = count % 10;
    final mod100 = count % 100;

    if (mod10 == 1 && mod100 != 11) return 'минута';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return 'минуты';
    }
    return 'минут';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final buttonLabel = switch (item.type) {
      WorkoutDetailsItemType.warmup => AppStrings.workoutDetailsStartWarmupButton,
      WorkoutDetailsItemType.workout => AppStrings.workoutDetailsStartWorkoutButton,
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: NetworkImageWidget(
                  imageUrl: item.imageUrl,
                  height: constraints.maxWidth,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            item.title,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium.copyWith(
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w500,
              color: colorTheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '(${item.durationMinutes} ${_workoutsMinutes(item.durationMinutes)})',
            textAlign: TextAlign.end,
            style: textTheme.bodyMedium.copyWith(
              height: 21 / 14,
              color: colorTheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            textAlign: TextAlign.end,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: textTheme.body.copyWith(
              height: 18 / 12,
              color: colorTheme.hint,
            ),
          ),
          const SizedBox(height: 24),
          MainButton(
            onPressed: onPressed,
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}
