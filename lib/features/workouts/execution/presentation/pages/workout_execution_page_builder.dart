import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/di.dart';
import '../../domain/entities/workout_execution_entry_mode.dart';
import '../../domain/repositories/workout_execution_repository.dart';
import '../cubits/workout_execution_cubit.dart';
import 'workout_execution_page.dart';

/// Builder for the workout execution page.
class WorkoutExecutionPageBuilder extends StatelessWidget {
  /// User workout identifier for execution requests.
  final int userWorkoutId;

  /// Entry mode used to start the execution flow.
  final WorkoutExecutionEntryMode entryMode;

  /// Creates an instance of [WorkoutExecutionPageBuilder].
  const WorkoutExecutionPageBuilder({
    required this.userWorkoutId,
    required this.entryMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutExecutionCubit(
        di<WorkoutExecutionRepository>(),
      )..startExecution(userWorkoutId, entryMode),
      child: WorkoutExecutionPage(
        userWorkoutId: userWorkoutId,
        entryMode: entryMode,
      ),
    );
  }
}
