import 'package:equatable/equatable.dart';

/// Summary of the testing bound to a test attempt.
final class TestAttemptTesting extends Equatable {
  /// Testing title.
  final String title;

  /// Total amount of exercises in the testing.
  final int totalExercises;

  /// Creates an instance of [TestAttemptTesting].
  const TestAttemptTesting({
    required this.title,
    required this.totalExercises,
  });

  @override
  List<Object?> get props => [title, totalExercises];
}
