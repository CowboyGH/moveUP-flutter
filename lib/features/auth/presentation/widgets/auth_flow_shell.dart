import 'package:flutter/material.dart';

/// Shared layout shell for auth screens.
class AuthFlowShell extends StatelessWidget {
  /// Main card content.
  final Widget child;

  /// Optional top-right action (for example: `Пропустить`).
  final Widget? topRightAction;

  /// Creates an instance of [AuthFlowShell].
  const AuthFlowShell({
    required this.child,
    this.topRightAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              if (topRightAction != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: topRightAction,
                ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 36),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
