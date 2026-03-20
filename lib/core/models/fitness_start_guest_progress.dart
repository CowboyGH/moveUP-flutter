import 'package:freezed_annotation/freezed_annotation.dart';

import 'fitness_start_stage.dart';

part 'fitness_start_guest_progress.freezed.dart';

/// Persisted guest progress for the mandatory Fitness Start flow.
@freezed
class FitnessStartGuestProgress with _$FitnessStartGuestProgress {
  /// Guest has not completed onboarding and should resume from [stage].
  const factory FitnessStartGuestProgress.inProgress(FitnessStartStage stage) = _InProgress;

  /// Guest has completed onboarding and should continue to registration.
  const factory FitnessStartGuestProgress.completed() = _Completed;
}
