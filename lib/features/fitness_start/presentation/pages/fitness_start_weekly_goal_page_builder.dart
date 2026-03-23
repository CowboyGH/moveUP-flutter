import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../phases/domain/repositories/phases_repository.dart';
import '../../../phases/presentation/cubits/weekly_goal_cubit.dart';
import 'fitness_start_weekly_goal_page.dart';

/// Builder for the final Fitness Start weekly-goal page.
class FitnessStartWeeklyGoalPageBuilder extends StatelessWidget {
  /// Creates an instance of [FitnessStartWeeklyGoalPageBuilder].
  const FitnessStartWeeklyGoalPageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeeklyGoalCubit(di<PhasesRepository>()),
      child: const FitnessStartWeeklyGoalPage(),
    );
  }
}
