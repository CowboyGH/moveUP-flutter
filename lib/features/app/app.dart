import 'package:flutter/material.dart';

import '../../core/localization/generated/app_localizations.g.dart';
import '../../core/router/router.dart';

/// The main application widget.
class FlutterStarterTemplate extends StatelessWidget {
  /// Creates a [FlutterStarterTemplate] widget.
  const FlutterStarterTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
