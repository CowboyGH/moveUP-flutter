import '../../models/fitness_start_guest_progress.dart';
import '../../models/fitness_start_stage.dart';

/// Storage for persisted guest Fitness Start progress.
abstract interface class FitnessStartProgressStorage {
  /// Returns saved guest progress if available.
  Future<FitnessStartGuestProgress?> getProgress();

  /// Persists in-progress guest onboarding at [stage].
  Future<void> saveInProgress(FitnessStartStage stage);

  /// Persists completed guest onboarding.
  Future<void> saveCompleted();

  /// Clears persisted guest progress.
  Future<void> clear();
}
