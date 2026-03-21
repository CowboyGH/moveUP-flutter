import 'package:equatable/equatable.dart';

/// Payload returned after completing a test attempt.
final class CompletedTestAttempt extends Equatable {
  /// Attempt identifier.
  final String attemptId;

  /// Completion timestamp string.
  final String completedAt;

  /// Saved pulse value.
  final int pulse;

  /// Creates an instance of [CompletedTestAttempt].
  const CompletedTestAttempt({
    required this.attemptId,
    required this.completedAt,
    required this.pulse,
  });

  @override
  List<Object?> get props => [attemptId, completedAt, pulse];
}
