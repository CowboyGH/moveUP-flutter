import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/workouts/workouts_failure.dart';
import '../../../../../core/result/result.dart';
import '../../domain/entities/workout_details_item.dart';
import '../../domain/repositories/workout_details_repository.dart';

part 'workout_details_cubit.freezed.dart';
part 'workout_details_state.dart';

/// Cubit that manages workout details loading flow and emits [WorkoutDetailsState].
final class WorkoutDetailsCubit extends Cubit<WorkoutDetailsState> {
  /// Repository used for workout details requests.
  final WorkoutDetailsRepository _repository;

  /// Creates an instance of [WorkoutDetailsCubit].
  WorkoutDetailsCubit(this._repository) : super(const WorkoutDetailsState.initial());

  /// Loads workout details items for the provided [userWorkoutId].
  Future<void> loadWorkoutDetails(int userWorkoutId) async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const WorkoutDetailsState.inProgress());

    final result = await _repository.getWorkoutDetails(userWorkoutId);
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(WorkoutDetailsState.loaded(data));
      case Failure(:final error):
        emit(WorkoutDetailsState.failed(error));
    }
  }
}
