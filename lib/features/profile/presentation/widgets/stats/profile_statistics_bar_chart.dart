import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../../uikit/themes/text/app_text_theme.dart';

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
    final visibleLabelIndexes = _buildVisibleLabelIndexes(items.length);

    return SizedBox(
      height: 280,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final plotWidth = math.max(0.0, constraints.maxWidth - 74);
          final slotPadding = _resolveSlotPadding(items.length);
          final barWidth = _resolveBarWidth(
            itemCount: items.length,
            availableWidth: plotWidth,
            slotPadding: slotPadding,
          );

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 42,
                height: 235,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: axisValues
                        .map(
                          (value) => Text(
                            _formatAxisValue(value),
                            style: textTheme.body,
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ),
              const SizedBox(width: 11),
              SizedBox(
                height: 238,
                child: VerticalDivider(
                  color: colorTheme.outline,
                  width: 1,
                  thickness: 1,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 235,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: _buildBarChildren(
                          items,
                          barWidth: barWidth,
                          slotPadding: slotPadding,
                          maxValue: normalizedMaxValue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      color: colorTheme.outline,
                      height: 1,
                      thickness: 1,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildLabelChildren(
                        items,
                        slotPadding: slotPadding,
                        textStyle: textTheme.body,
                        visibleLabelIndexes: visibleLabelIndexes,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

final class _Bar extends StatelessWidget {
  final double width;
  final double value;
  final double maxValue;

  const _Bar({
    required this.width,
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
            color: colorTheme.secondary.withValues(alpha: 0.2),
          ),
          child: SizedBox(width: width),
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

List<Widget> _buildBarChildren(
  List<ProfileStatisticsBarChartItem> items, {
  required double barWidth,
  required double slotPadding,
  required double maxValue,
}) {
  return items
      .map(
        (item) => Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: slotPadding),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _Bar(
                width: barWidth,
                value: item.value,
                maxValue: maxValue,
              ),
            ),
          ),
        ),
      )
      .toList(growable: false);
}

List<Widget> _buildLabelChildren(
  List<ProfileStatisticsBarChartItem> items, {
  required double slotPadding,
  required TextStyle textStyle,
  required Set<int> visibleLabelIndexes,
}) {
  return items.indexed
      .map((entry) {
        final index = entry.$1;
        final item = entry.$2;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: slotPadding),
            child: visibleLabelIndexes.contains(index)
                ? Align(
                    alignment: Alignment.topCenter,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item.label,
                        maxLines: 1,
                        style: textStyle,
                      ),
                    ),
                  )
                : const SizedBox.expand(),
          ),
        );
      })
      .toList(growable: false);
}

Set<int> _buildVisibleLabelIndexes(int itemCount) {
  if (itemCount <= 0) return const {};
  if (itemCount <= 12) {
    return Set<int>.from(List<int>.generate(itemCount, (index) => index));
  }

  const targetLabelCount = 6;
  final step = ((itemCount - 1) / (targetLabelCount - 1)).ceil();
  final indexes = <int>{0, itemCount - 1};

  for (var index = step; index < itemCount - 1; index += step) {
    indexes.add(index);
  }

  return indexes;
}

double _resolveSlotPadding(int itemCount) {
  if (itemCount <= 7) return 6;
  if (itemCount <= 12) return 2;
  return 1;
}

double _resolveBarWidth({
  required int itemCount,
  required double availableWidth,
  required double slotPadding,
}) {
  if (itemCount <= 0) return 0;

  final slotWidth = availableWidth / itemCount;
  final resolvedWidth = slotWidth - (slotPadding * 2);
  return resolvedWidth.clamp(4.0, 20.0);
}
