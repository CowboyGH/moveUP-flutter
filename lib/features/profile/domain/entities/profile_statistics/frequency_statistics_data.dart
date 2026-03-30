import 'package:equatable/equatable.dart';

import 'frequency_period.dart';

/// Frequency statistics payload used by the profile statistics UI.
final class FrequencyStatisticsData extends Equatable {
  /// Whether the payload contains chart data.
  final bool hasData;

  /// Selected frequency period.
  final FrequencyPeriod period;

  /// Selected offset.
  final int offset;

  /// Human-readable period label.
  final String label;

  /// Average workouts per week.
  final double averagePerWeek;

  /// Chart bars.
  final List<FrequencyChartBarData> chart;

  /// Creates an instance of [FrequencyStatisticsData].
  const FrequencyStatisticsData({
    required this.hasData,
    required this.period,
    required this.offset,
    required this.label,
    required this.averagePerWeek,
    required this.chart,
  });

  @override
  List<Object?> get props => [
    hasData,
    period,
    offset,
    label,
    averagePerWeek,
    chart,
  ];
}

/// Single bar for the frequency chart.
final class FrequencyChartBarData extends Equatable {
  /// Axis label.
  final String label;

  /// Short axis label.
  final String shortLabel;

  /// Bar count.
  final int count;

  /// Goal reference line.
  final int goal;

  /// Creates an instance of [FrequencyChartBarData].
  const FrequencyChartBarData({
    required this.label,
    required this.shortLabel,
    required this.count,
    required this.goal,
  });

  @override
  List<Object?> get props => [
    label,
    shortLabel,
    count,
    goal,
  ];
}
