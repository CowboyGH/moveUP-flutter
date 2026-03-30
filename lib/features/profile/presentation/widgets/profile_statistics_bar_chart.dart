import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';

/// Single bar item used by [ProfileStatisticsBarChart].
final class ProfileStatisticsBarChartItem {
  /// Axis label rendered under the bar.
  final String label;

  /// Numeric value represented by the bar.
  final double value;

  /// Creates an instance of [ProfileStatisticsBarChartItem].
  const ProfileStatisticsBarChartItem({
    required this.label,
    required this.value,
  });
}

/// Lightweight vertical bar chart for the profile statistics section.
class ProfileStatisticsBarChart extends StatelessWidget {
  /// Bars rendered inside the chart.
  final List<ProfileStatisticsBarChartItem> items;

  /// Creates an instance of [ProfileStatisticsBarChart].
  const ProfileStatisticsBarChart({
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final maxValue = items.fold<double>(0, (current, item) => math.max(current, item.value));
    final normalizedMaxValue = _normalizeMaxValue(maxValue);
    final axisValues = _buildAxisValues(normalizedMaxValue);

    return SizedBox(
      height: 280,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 42,
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 34),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: axisValues
                    .map(
                      (value) => Text(
                        _formatAxisValue(value),
                        style: textTheme.bodySmall.copyWith(
                          fontSize: 10,
                          height: 15 / 10,
                          color: colorTheme.darkHint,
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: colorTheme.outline),
                  bottom: BorderSide(color: colorTheme.outline),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: items
                            .map(
                              (item) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: _Bar(
                                    label: item.label,
                                    value: item.value,
                                    maxValue: normalizedMaxValue,
                                  ),
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items
                          .map(
                            (item) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  item.label,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: textTheme.bodySmall.copyWith(
                                    fontSize: 12,
                                    height: 18 / 12,
                                    color: colorTheme.onSurface,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _Bar extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;

  const _Bar({
    required this.label,
    required this.value,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final heightFactor = maxValue <= 0 ? 0.0 : (value / maxValue).clamp(0.0, 1.0);

    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: heightFactor,
        alignment: Alignment.bottomCenter,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorTheme.secondary.withValues(alpha: 0.28),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
          child: const SizedBox(width: double.infinity),
        ),
      ),
    );
  }
}

List<double> _buildAxisValues(double maxValue) {
  final step = maxValue / 5;
  return List<double>.generate(
    5,
    (index) => maxValue - (step * index),
  );
}

double _normalizeMaxValue(double value) {
  if (value <= 0) return 1;

  var magnitude = 1.0;
  var normalized = value;
  while (normalized >= 10) {
    normalized /= 10;
    magnitude *= 10;
  }

  final rounded = switch (normalized) {
    <= 1 => 1.0,
    <= 2 => 2.0,
    <= 5 => 5.0,
    _ => 10.0,
  };

  return rounded * magnitude;
}

String _formatAxisValue(double value) {
  if (value >= 1000) return value.toStringAsFixed(0);
  if (value % 1 == 0) return value.toInt().toString();
  return value.toStringAsFixed(1);
}
