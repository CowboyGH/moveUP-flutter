import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/di.dart';
import '../../domain/repositories/workouts_overview_repository.dart';
import '../cubits/workouts_overview_cubit.dart';
import 'workouts_overview_page.dart';

/// Builder for the workouts overview page.
class WorkoutsOverviewPageBuilder extends StatelessWidget {
  /// Creates an instance of [WorkoutsOverviewPageBuilder].
  const WorkoutsOverviewPageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutsOverviewCubit(di<WorkoutsOverviewRepository>())..loadWorkouts(),
      child: const WorkoutsOverviewPage(),
    );
  }
}
