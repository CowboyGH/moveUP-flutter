import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/workouts/workouts_failure.dart';
import '../../../../../core/result/result.dart';
import '../../domain/entities/workout_overview_item.dart';
import '../../domain/repositories/workouts_overview_repository.dart';

part 'workouts_overview_cubit.freezed.dart';
part 'workouts_overview_state.dart';

/// Cubit that manages workouts overview loading flow and emits [WorkoutsOverviewState].
final class WorkoutsOverviewCubit extends Cubit<WorkoutsOverviewState> {
  /// Repository used for workouts overview requests.
  final WorkoutsOverviewRepository _repository;

  /// Creates an instance of [WorkoutsOverviewCubit].
  WorkoutsOverviewCubit(this._repository) : super(const WorkoutsOverviewState.initial());

  /// Loads all workouts available for the overview screen.
  Future<void> loadWorkouts() async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const WorkoutsOverviewState.inProgress());

    final result = await _repository.getWorkouts();
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(WorkoutsOverviewState.loaded(data));
      case Failure(:final error):
        emit(WorkoutsOverviewState.failed(error));
    }
  }
}
