import '../../domain/entities/profile_stats_history_snapshot.dart';
import '../dto/active_profile_subscription_dto.dart';
import '../dto/profile_test_history_item_dto.dart';
import '../dto/profile_user_data_dto.dart';
import '../dto/profile_workout_history_item_dto.dart';

/// Maps aggregate `/profile` DTO subset to history snapshot entities.
extension ProfileHistorySnapshotMapper on ProfileUserDataDto {
  /// Returns a focused history snapshot for profile statistics UI.
  ProfileStatsHistorySnapshot toStatsHistorySnapshot() {
    final sortedWorkouts = <ProfileWorkoutHistoryItemDto>[
      ...?workouts?.history,
    ]..sort((left, right) => _parseDate(right.completedAt).compareTo(_parseDate(left.completedAt)));

    final sortedTests = <ProfileTestHistoryItemDto>[
      ...?tests?.history,
    ]..sort((left, right) => _parseDate(right.completedAt).compareTo(_parseDate(left.completedAt)));

    return ProfileStatsHistorySnapshot(
      activeSubscription: subscriptions?.active?.toEntity(),
      latestWorkout: sortedWorkouts.isEmpty ? null : sortedWorkouts.first.toEntity(),
      latestTest: sortedTests.isEmpty ? null : sortedTests.first.toEntity(),
    );
  }
}

extension on ActiveProfileSubscriptionDto {
  ProfileActiveSubscriptionSnapshot toEntity() => ProfileActiveSubscriptionSnapshot(
    id: id,
    name: name,
    price: price,
    startDate: startDate,
    endDate: endDate,
  );
}

extension on ProfileWorkoutHistoryItemDto {
  ProfileLatestWorkoutSnapshot toEntity() => ProfileLatestWorkoutSnapshot(
    id: id,
    title: workout.title,
    completedAt: completedAt,
  );
}

extension on ProfileTestHistoryItemDto {
  ProfileLatestTestSnapshot toEntity() => ProfileLatestTestSnapshot(
    attemptId: attemptId,
    title: testing.title,
    completedAt: completedAt,
  );
}

DateTime _parseDate(String rawValue) {
  final normalizedValue = rawValue.contains(' ') ? rawValue.replaceFirst(' ', 'T') : rawValue;
  return DateTime.tryParse(normalizedValue) ?? DateTime.fromMillisecondsSinceEpoch(0);
}
