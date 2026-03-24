import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'core/di/di.dart';
import 'core/utils/logger/app_logger.dart';
import 'features/app/app.dart';

/// The main entry point of the application.
Future<void> run() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      await Hive.initFlutter();

      // Setup dependency injection
      await setupDI();

      final logger = di<AppLogger>();

      // Catch errors from Flutter framework
      FlutterError.onError = (details) {
        logger.e('FlutterError', details.exception, details.stack);
      };

      // Catch errors from outside Flutter framework
      PlatformDispatcher.instance.onError = (error, stack) {
        logger.f('PlatformDispatcherError', error, stack);
        return true;
      };

      runApp(const MoveUpApp());
    },
    (error, stackTrace) {
      // Fallback handler (without DI)
      debugPrint('UncaughtZoneError: $error');
      debugPrintStack(stackTrace: stackTrace);
    },
  );
}
