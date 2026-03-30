import 'package:equatable/equatable.dart';

/// Focused snapshot used by the profile statistics history dialog.
final class ProfileStatsHistorySnapshot extends Equatable {
  /// Currently active subscription.
  final ProfileActiveSubscriptionSnapshot? activeSubscription;

  /// Latest completed workout.
  final ProfileLatestWorkoutSnapshot? latestWorkout;

  /// Latest completed testing.
  final ProfileLatestTestSnapshot? latestTest;

  /// Creates an instance of [ProfileStatsHistorySnapshot].
  const ProfileStatsHistorySnapshot({
    required this.activeSubscription,
    required this.latestWorkout,
    required this.latestTest,
  });

  @override
  List<Object?> get props => [
    activeSubscription,
    latestWorkout,
    latestTest,
  ];
}

/// Active subscription content used in the history dialog.
final class ProfileActiveSubscriptionSnapshot extends Equatable {
  /// Subscription identifier.
  final int id;

  /// Subscription title.
  final String name;

  /// Subscription price value.
  final String price;

  /// Start date.
  final String startDate;

  /// End date.
  final String endDate;

  /// Creates an instance of [ProfileActiveSubscriptionSnapshot].
  const ProfileActiveSubscriptionSnapshot({
    required this.id,
    required this.name,
    required this.price,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    startDate,
    endDate,
  ];
}

/// Latest workout content used in the history dialog.
final class ProfileLatestWorkoutSnapshot extends Equatable {
  /// Workout identifier.
  final int id;

  /// Workout title.
  final String title;

  /// Completion timestamp.
  final String completedAt;

  /// Creates an instance of [ProfileLatestWorkoutSnapshot].
  const ProfileLatestWorkoutSnapshot({
    required this.id,
    required this.title,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    completedAt,
  ];
}

/// Latest test content used in the history dialog.
final class ProfileLatestTestSnapshot extends Equatable {
  /// Test attempt identifier.
  final int attemptId;

  /// Testing title.
  final String title;

  /// Completion timestamp.
  final String completedAt;

  /// Creates an instance of [ProfileLatestTestSnapshot].
  const ProfileLatestTestSnapshot({
    required this.attemptId,
    required this.title,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [
    attemptId,
    title,
    completedAt,
  ];
}
