import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:moveup_flutter/core/models/fitness_start_stage.dart';
import 'package:moveup_flutter/core/services/onboarding_flow_storage/hive_onboarding_flow_storage.dart';

void main() {
  group('HiveOnboardingFlowStorage', () {
    late Directory tempDirectory;
    late Box<dynamic> box;
    late HiveOnboardingFlowStorage storage;

    setUp(() async {
      tempDirectory = await Directory.systemTemp.createTemp('moveup_hive_storage_test_');
      Hive.init(tempDirectory.path);
      box = await Hive.openBox<dynamic>(HiveOnboardingFlowStorage.boxName);
      storage = HiveOnboardingFlowStorage(box);
    });

    tearDown(() async {
      await Hive.close();
      if (tempDirectory.existsSync()) {
        await tempDirectory.delete(recursive: true);
      }
    });

    test('returns false and null when onboarding state is not saved', () async {
      expect(await storage.hasPendingOnboarding(), isFalse);
      expect(await storage.getPendingOnboardingStage(), isNull);
    });

    test('returns false and null when saved stage is malformed', () async {
      await box.put('pending_fitness_start_stage', 123);

      expect(await storage.hasPendingOnboarding(), isFalse);
      expect(await storage.getPendingOnboardingStage(), isNull);
    });

    test('saves and returns pending onboarding stage', () async {
      await storage.savePendingOnboardingStage(FitnessStartStage.tests);

      expect(await storage.hasPendingOnboarding(), isTrue);
      expect(await storage.getPendingOnboardingStage(), FitnessStartStage.tests);
    });

    test('clears saved onboarding state', () async {
      await storage.savePendingOnboardingStage(FitnessStartStage.quiz);

      await storage.clearPendingOnboarding();

      expect(await storage.hasPendingOnboarding(), isFalse);
      expect(await storage.getPendingOnboardingStage(), isNull);
    });
  });
}
