import 'package:equatable/equatable.dart';

/// Summary of the testing bound to a test attempt.
final class TestAttemptTesting extends Equatable {
  /// Testing identifier.
  final int id;

  /// Testing title.
  final String title;

  /// Testing description.
  final String description;

  /// Approximate duration in minutes.
  final int durationMinutes;

  /// Normalized testing image URL.
  final String imageUrl;

  /// Total amount of exercises in the testing.
  final int totalExercises;

  /// Creates an instance of [TestAttemptTesting].
  const TestAttemptTesting({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.imageUrl,
    required this.totalExercises,
  });

  @override
  List<Object?> get props => [id, title, description, durationMinutes, imageUrl, totalExercises];
}
