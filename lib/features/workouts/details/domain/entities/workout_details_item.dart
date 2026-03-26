import 'package:equatable/equatable.dart';

/// Supported card types on the workout details screen.
enum WorkoutDetailsItemType {
  /// Warmup card.
  warmup,

  /// Main workout card.
  workout,
}

/// Workout item displayed on the workout details screen.
final class WorkoutDetailsItem extends Equatable {
  /// Content type that determines the CTA label.
  final WorkoutDetailsItemType type;

  /// Item title.
  final String title;

  /// Item description.
  final String description;

  /// Item duration in minutes.
  final int durationMinutes;

  /// Normalized image URL.
  final String imageUrl;

  /// Creates an instance of [WorkoutDetailsItem].
  const WorkoutDetailsItem({
    required this.type,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    type,
    title,
    description,
    durationMinutes,
    imageUrl,
  ];
}
