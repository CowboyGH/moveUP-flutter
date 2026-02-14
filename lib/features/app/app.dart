import 'package:flutter/material.dart';

import '../../core/router/router.dart';

/// The main application widget.
class FlutterStarterTemplate extends StatelessWidget {
  /// Creates a [FlutterStarterTemplate] widget.
  const FlutterStarterTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
