import 'package:equatable/equatable.dart';

/// Trend statistics payload used by the profile statistics UI.
final class TrendStatisticsData extends Equatable {
  /// Whether the payload contains chart data.
  final bool hasData;

  /// Selected workout identifier.
  final int? workoutId;

  /// Selected workout title.
  final String title;

  /// Selected workout formatted completion date.
  final String? completedAtFormatted;

  /// Average score percent.
  final int averageScorePercent;

  /// Average score label.
  final String averageScoreLabel;

  /// Trend exercise rows.
  final List<TrendExerciseData> exercises;

  /// Creates an instance of [TrendStatisticsData].
  const TrendStatisticsData({
    required this.hasData,
    required this.workoutId,
    required this.title,
    required this.completedAtFormatted,
    required this.averageScorePercent,
    required this.averageScoreLabel,
    required this.exercises,
  });

  @override
  List<Object?> get props => [
    hasData,
    workoutId,
    title,
    completedAtFormatted,
    averageScorePercent,
    averageScoreLabel,
    exercises,
  ];
}

/// Trend row for a single exercise.
final class TrendExerciseData extends Equatable {
  /// Exercise title.
  final String exerciseName;

  /// Score percent.
  final int scorePercent;

  /// Score label.
  final String? scoreLabel;

  /// Reaction value.
  final String? reaction;

  /// Used weight.
  final String? weightUsed;

  /// Creates an instance of [TrendExerciseData].
  const TrendExerciseData({
    required this.exerciseName,
    required this.scorePercent,
    required this.scoreLabel,
    required this.reaction,
    required this.weightUsed,
  });

  @override
  List<Object?> get props => [
    exerciseName,
    scorePercent,
    scoreLabel,
    reaction,
    weightUsed,
  ];
}
