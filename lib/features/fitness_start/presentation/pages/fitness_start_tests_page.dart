import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../widgets/fitness_start_flow_app_bar.dart';

/// Placeholder screen for the next onboarding slice that will show test list.
class FitnessStartTestsPage extends StatelessWidget {
  /// Creates an instance of [FitnessStartTestsPage].
  const FitnessStartTestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FitnessStartFlowAppBar(progress: 1),
      body: Center(
        child: Text(AppStrings.fitnessStartTitle),
      ),
    );
  }
}
