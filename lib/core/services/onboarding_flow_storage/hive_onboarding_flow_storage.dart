import 'package:hive_flutter/hive_flutter.dart';

import '../../../features/fitness_start/domain/entities/fitness_start_stage.dart';
import 'onboarding_flow_storage.dart';

/// Implementation of [OnboardingFlowStorage] using Hive.
final class HiveOnboardingFlowStorage implements OnboardingFlowStorage {
  /// The name of the box that stores onboarding flow state.
  static const boxName = 'onboarding_flow';

  static const _pendingKey = 'pending_fitness_start_onboarding';
  static const _stageKey = 'pending_fitness_start_stage';

  final Box<dynamic> _box;

  /// Creates an instance of [HiveOnboardingFlowStorage].
  HiveOnboardingFlowStorage(this._box);

  @override
  Future<bool> hasPendingOnboarding() async => _box.get(_pendingKey) as bool? ?? false;

  @override
  Future<FitnessStartStage?> getPendingOnboardingStage() async {
    final stageFromBox = _box.get(_stageKey);
    if (stageFromBox is! String) return null;
    return FitnessStartStage.values.asNameMap()[stageFromBox];
  }

  @override
  Future<void> savePendingOnboardingStage(FitnessStartStage stage) async {
    await _box.put(_pendingKey, true);
    await _box.put(_stageKey, stage.name);
  }

  @override
  Future<void> clearPendingOnboarding() async {
    await _box.delete(_pendingKey);
    await _box.delete(_stageKey);
  }
}
