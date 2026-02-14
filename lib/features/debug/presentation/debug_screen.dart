import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/presentation/bloc/auth_bloc.dart';

/// A screen for debugging purposes.
class DebugScreen extends StatelessWidget {
  /// Creates a [DebugScreen].
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(
              const AuthEvent.signOutRequested(),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
