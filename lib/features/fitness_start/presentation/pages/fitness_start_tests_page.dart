import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../widgets/fitness_start_flow_app_bar.dart';

/// Temporary completion screen for the next Fitness Start slice.
class FitnessStartTestsPage extends StatelessWidget {
  /// Creates an instance of [FitnessStartTestsPage].
  const FitnessStartTestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authSessionCubit = context.read<AuthSessionCubit>();
    return Scaffold(
      appBar: FitnessStartFlowAppBar(
        progress: 1,
        showBackButton: true,
        onBackPressed: () => authSessionCubit.cancelGuestFlow(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: MainButton(
            onPressed: () => unawaited(authSessionCubit.completeGuestFitnessStart()),
            child: const Text(AppStrings.fitnessStartRegisterAction),
          ),
        ),
      ),
    );
  }
}
