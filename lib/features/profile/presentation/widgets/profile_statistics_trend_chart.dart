import 'package:flutter/material.dart';

import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/profile_statistics/trend_statistics_data.dart';

/// Lightweight list-based trend view for profile statistics.
class ProfileStatisticsTrendChart extends StatelessWidget {
  /// Trend rows to render.
  final List<TrendExerciseData> exercises;

  /// Creates an instance of [ProfileStatisticsTrendChart].
  const ProfileStatisticsTrendChart({
    required this.exercises,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: exercises
          .map(
            (exercise) => Padding(
              padding: EdgeInsets.only(
                bottom: exercise == exercises.last ? 0 : 16,
              ),
              child: _TrendExerciseRow(exercise: exercise),
            ),
          )
          .toList(growable: false),
    );
  }
}

final class _TrendExerciseRow extends StatelessWidget {
  final TrendExerciseData exercise;

  const _TrendExerciseRow({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final details = <String>[
      if (exercise.scoreLabel != null && exercise.scoreLabel!.isNotEmpty) exercise.scoreLabel!,
      if (exercise.weightUsed != null && exercise.weightUsed!.isNotEmpty)
        '${exercise.weightUsed} кг',
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorTheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorTheme.outline.withValues(alpha: 0.7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exercise.exerciseName,
                    maxLines: 2,
                    style: textTheme.bodyMedium.copyWith(
                      fontSize: 13,
                      height: 19 / 13,
                      fontWeight: FontWeight.w500,
                      color: colorTheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${exercise.scorePercent}%',
                  style: textTheme.bodyMedium.copyWith(
                    fontSize: 13,
                    height: 19 / 13,
                    fontWeight: FontWeight.w600,
                    color: colorTheme.onSurface,
                  ),
                ),
              ],
            ),
            if (details.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                details.join(' • '),
                style: textTheme.bodySmall.copyWith(
                  fontSize: 11,
                  height: 16 / 11,
                  color: colorTheme.darkHint,
                ),
              ),
            ],
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: (exercise.scorePercent / 100).clamp(0, 1),
                minHeight: 8,
                backgroundColor: colorTheme.disabled.withValues(alpha: 0.25),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _resolveProgressColor(colorTheme, exercise),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _resolveProgressColor(AppColorTheme colorTheme, TrendExerciseData exercise) {
  final normalized = (exercise.reaction ?? exercise.scoreLabel ?? '').trim().toLowerCase();
  if (normalized.contains('bad') || normalized.contains('плох')) {
    return colorTheme.error.withValues(alpha: 0.75);
  }
  if (normalized.contains('good') || normalized.contains('отлич') || normalized.contains('хорош')) {
    return colorTheme.primary;
  }
  return colorTheme.secondary;
}
