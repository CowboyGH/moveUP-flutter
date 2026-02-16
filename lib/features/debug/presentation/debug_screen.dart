import 'package:flutter/material.dart';

/// A screen for debugging purposes.
class DebugScreen extends StatelessWidget {
  /// Creates a [DebugScreen].
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Debug Screen'),
      ),
    );
  }
}
