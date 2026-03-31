import 'package:equatable/equatable.dart';

/// Focused frequency summary used by the profile current phase section.
final class ProfileCurrentPhaseSummary extends Equatable {
  /// Average weekly training frequency.
  final double averagePerWeek;

  /// Recommended weekly training goal.
  final int weeklyGoal;

  /// Creates an instance of [ProfileCurrentPhaseSummary].
  const ProfileCurrentPhaseSummary({
    required this.averagePerWeek,
    required this.weeklyGoal,
  });

  @override
  List<Object?> get props => [averagePerWeek, weeklyGoal];
}
