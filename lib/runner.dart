import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/di/di.dart';
import 'core/utils/logger/app_logger.dart';
import 'features/app/app.dart';
import 'firebase_options.dart';

/// The main entry point of the application.
Future<void> run() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);

      // Setup dependency injection
      await setupDI();
      final logger = di<AppLogger>();

      // Catch errors from Flutter framework
      FlutterError.onError = (details) {
        logger.e('FlutterError', details.exception, details.stack);
        FirebaseCrashlytics.instance.recordFlutterError(details);
      };

      // Catch errors from outside Flutter framework
      PlatformDispatcher.instance.onError = (error, stack) {
        logger.f('PlatformDispatcherError', error, stack);
        FirebaseCrashlytics.instance.recordError(error, stack);
        return true;
      };

      runApp(const MoveUpApp());
    },
    (error, stackTrace) {
      // Fallback handler (without DI)
      debugPrint('UncaughtZoneError: $error');
      debugPrintStack(stackTrace: stackTrace);

      try {
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
      } catch (e, s) {
        // In case Firebase/Crashlytics aren't ready yet
        debugPrint('Error while reporting to Crashlytics: $e');
        debugPrintStack(stackTrace: s);
      }
    },
  );
}
