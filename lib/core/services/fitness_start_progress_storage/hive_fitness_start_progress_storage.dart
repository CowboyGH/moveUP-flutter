import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../models/fitness_start_guest_progress.dart';
import '../../models/fitness_start_stage.dart';
import 'fitness_start_progress_storage.dart';

/// Hive-backed implementation of [FitnessStartProgressStorage].
final class HiveFitnessStartProgressStorage implements FitnessStartProgressStorage {
  /// The name of the box that stores guest Fitness Start progress.
  static const boxName = 'fitness_start_progress';

  static const _progressKey = 'guest_fitness_start_progress';
  static const _typeKey = 'type';
  static const _stageKey = 'stage';
  static const _inProgressType = 'in_progress';
  static const _completedType = 'completed';

  final Box<dynamic> _box;

  /// Creates an instance of [HiveFitnessStartProgressStorage].
  HiveFitnessStartProgressStorage(this._box);

  @override
  Future<FitnessStartGuestProgress?> getProgress() async {
    final rawProgress = _box.get(_progressKey);
    if (rawProgress is! Map) return null;

    final type = rawProgress[_typeKey];
    if (type == _completedType) {
      return const FitnessStartGuestProgress.completed();
    }

    if (type != _inProgressType) return null;

    final stageName = rawProgress[_stageKey];
    if (stageName is! String) return null;

    final stage = FitnessStartStage.values.asNameMap()[stageName];
    if (stage == null) return null;

    return FitnessStartGuestProgress.inProgress(stage);
  }

  @override
  Future<void> saveInProgress(FitnessStartStage stage) async {
    await _box.put(_progressKey, <String, dynamic>{
      _typeKey: _inProgressType,
      _stageKey: stage.name,
    });
  }

  @override
  Future<void> saveCompleted() async {
    await _box.put(_progressKey, <String, dynamic>{
      _typeKey: _completedType,
    });
  }

  @override
  Future<void> clear() async {
    await _box.delete(_progressKey);
  }
}
