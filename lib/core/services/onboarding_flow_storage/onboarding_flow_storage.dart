import '../../../features/fitness_start/domain/entities/fitness_start_stage.dart';

/// Storage for the authenticated onboarding flow state.
abstract interface class OnboardingFlowStorage {
  /// Returns whether the authenticated onboarding flow is pending.
  Future<bool> hasPendingOnboarding();

  /// Returns the saved onboarding stage if available.
  Future<FitnessStartStage?> getPendingOnboardingStage();

  /// Saves onboarding as pending at the provided [stage].
  Future<void> savePendingOnboardingStage(FitnessStartStage stage);

  /// Clears the saved onboarding state.
  Future<void> clearPendingOnboarding();
}
