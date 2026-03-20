/// Storage for persisted guest Fitness Start progress.
abstract interface class FitnessStartProgressStorage {
  /// Returns whether completed guest progress is saved.
  Future<bool> hasCompletedProgress();

  /// Persists completed guest onboarding.
  Future<void> saveCompleted();

  /// Clears persisted guest progress.
  Future<void> clear();
}
