import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:moveup_flutter/core/models/fitness_start_guest_progress.dart';
import 'package:moveup_flutter/core/models/fitness_start_stage.dart';
import 'package:moveup_flutter/core/services/fitness_start_progress_storage/hive_fitness_start_progress_storage.dart';

void main() {
  group('HiveFitnessStartProgressStorage', () {
    late Directory tempDirectory;
    late Box<dynamic> box;
    late HiveFitnessStartProgressStorage storage;

    setUp(() async {
      tempDirectory = await Directory.systemTemp.createTemp('moveup_hive_storage_test_');
      Hive.init(tempDirectory.path);
      box = await Hive.openBox<dynamic>(HiveFitnessStartProgressStorage.boxName);
      storage = HiveFitnessStartProgressStorage(box);
    });

    tearDown(() async {
      await Hive.close();
      if (tempDirectory.existsSync()) {
        await tempDirectory.delete(recursive: true);
      }
    });

    test('returns null when guest progress is not saved', () async {
      expect(await storage.getProgress(), isNull);
    });

    test('returns null when saved progress payload is malformed', () async {
      await box.put('guest_fitness_start_progress', 123);

      expect(await storage.getProgress(), isNull);
    });

    test('saves and returns in-progress guest stage', () async {
      await storage.saveInProgress(FitnessStartStage.tests);

      expect(
        await storage.getProgress(),
        const FitnessStartGuestProgress.inProgress(FitnessStartStage.tests),
      );
    });

    test('saves and returns completed guest progress', () async {
      await storage.saveCompleted();

      expect(
        await storage.getProgress(),
        const FitnessStartGuestProgress.completed(),
      );
    });

    test('clears saved guest progress', () async {
      await storage.saveInProgress(FitnessStartStage.quiz);

      await storage.clear();

      expect(await storage.getProgress(), isNull);
    });
  });
}
