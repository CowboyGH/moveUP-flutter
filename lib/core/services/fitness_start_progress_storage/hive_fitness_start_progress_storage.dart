import 'package:hive_ce_flutter/hive_flutter.dart';

import 'fitness_start_progress_storage.dart';

/// Hive-backed implementation of [FitnessStartProgressStorage].
final class HiveFitnessStartProgressStorage implements FitnessStartProgressStorage {
  /// The name of the box that stores guest Fitness Start progress.
  static const boxName = 'fitness_start_progress';

  static const _completedKey = 'guest_fitness_start_completed';

  final Box<dynamic> _box;

  /// Creates an instance of [HiveFitnessStartProgressStorage].
  HiveFitnessStartProgressStorage(this._box);

  @override
  Future<bool> hasCompletedProgress() async {
    final rawValue = _box.get(_completedKey);
    return rawValue is bool ? rawValue : false;
  }

  @override
  Future<void> saveCompleted() async {
    await _box.put(_completedKey, true);
  }

  @override
  Future<void> clear() async {
    await _box.delete(_completedKey);
  }
}
