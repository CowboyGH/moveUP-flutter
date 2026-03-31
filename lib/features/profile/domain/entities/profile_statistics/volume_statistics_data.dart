import 'package:equatable/equatable.dart';

/// Volume statistics payload used by the profile statistics UI.
final class VolumeStatisticsData extends Equatable {
  /// Whether the payload contains chart data.
  final bool hasData;

  /// Selected exercise identifier.
  final int? exerciseId;

  /// Selected exercise title.
  final String title;

  /// Average score percent.
  final int averageScorePercent;

  /// Average score label.
  final String averageScoreLabel;

  /// Current period.
  final VolumePeriodData period;

  /// Chart bars.
  final List<VolumeChartBarData> chart;

  /// Creates an instance of [VolumeStatisticsData].
  const VolumeStatisticsData({
    required this.hasData,
    required this.exerciseId,
    required this.title,
    required this.averageScorePercent,
    required this.averageScoreLabel,
    required this.period,
    required this.chart,
  });

  @override
  List<Object?> get props => [
    hasData,
    exerciseId,
    title,
    averageScorePercent,
    averageScoreLabel,
    period,
    chart,
  ];
}

/// Current volume period metadata.
final class VolumePeriodData extends Equatable {
  /// Period start date.
  final String start;

  /// Period end date.
  final String end;

  /// Human-readable period label.
  final String label;

  /// Current week offset.
  final int weekOffset;

  /// Whether previous period navigation is allowed.
  final bool canGoPrevious;

  /// Whether next period navigation is allowed.
  final bool canGoNext;

  /// Creates an instance of [VolumePeriodData].
  const VolumePeriodData({
    required this.start,
    required this.end,
    required this.label,
    required this.weekOffset,
    required this.canGoPrevious,
    required this.canGoNext,
  });

  @override
  List<Object?> get props => [
    start,
    end,
    label,
    weekOffset,
    canGoPrevious,
    canGoNext,
  ];
}

/// Single bar for the volume chart.
final class VolumeChartBarData extends Equatable {
  /// Axis label.
  final String label;

  /// Bar value.
  final double value;

  /// Optional bar date.
  final String? date;

  /// Creates an instance of [VolumeChartBarData].
  const VolumeChartBarData({
    required this.label,
    required this.value,
    required this.date,
  });

  @override
  List<Object?> get props => [label, value, date];
}
