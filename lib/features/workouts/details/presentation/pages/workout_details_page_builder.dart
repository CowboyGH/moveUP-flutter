import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/di.dart';
import '../../domain/repositories/workout_details_repository.dart';
import '../cubits/workout_details_cubit.dart';
import 'workout_details_page.dart';

/// Builder for the workout details page.
class WorkoutDetailsPageBuilder extends StatelessWidget {
  /// User workout identifier for the requested details screen.
  final int userWorkoutId;

  /// Creates an instance of [WorkoutDetailsPageBuilder].
  const WorkoutDetailsPageBuilder({
    required this.userWorkoutId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutDetailsCubit(
        di<WorkoutDetailsRepository>(),
      )..loadWorkoutDetails(userWorkoutId),
      child: WorkoutDetailsPage(userWorkoutId: userWorkoutId),
    );
  }
}
