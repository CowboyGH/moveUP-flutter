import 'package:flutter/material.dart';

import '../../core/router/router.dart';

/// The main application widget.
class MoveUpApp extends StatelessWidget {
  /// Creates a [MoveUpApp] widget.
  const MoveUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
