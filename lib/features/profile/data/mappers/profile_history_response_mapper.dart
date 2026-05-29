import '../../domain/entities/profile_stats_history_snapshot.dart';
import '../dto/focused/profile_history_response_dto.dart';
import '../dto/profile_test_history_item_dto.dart';
import '../dto/profile_workout_history_item_dto.dart';

/// Maps `/profile/history` DTO to the focused stats history snapshot.
extension ProfileHistoryResponseMapper on ProfileHistoryResponseDto {
  /// Returns the latest completed workout and testing snapshots.
  ProfileStatsHistorySnapshot toStatsHistorySnapshot() {
    final sortedWorkouts = <ProfileWorkoutHistoryItemDto>[
      ...data.workouts,
    ]..sort((left, right) => _parseDate(right.completedAt).compareTo(_parseDate(left.completedAt)));
    final sortedTests = <ProfileTestHistoryItemDto>[
      ...data.tests,
    ]..sort((left, right) => _parseDate(right.completedAt).compareTo(_parseDate(left.completedAt)));

    return ProfileStatsHistorySnapshot(
      latestWorkout: sortedWorkouts.isEmpty ? null : sortedWorkouts.first.toEntity(),
      latestTest: sortedTests.isEmpty ? null : sortedTests.first.toEntity(),
    );
  }
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
