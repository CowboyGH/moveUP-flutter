import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/phases/phases_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/phases_repository.dart';

part 'weekly_goal_cubit.freezed.dart';
part 'weekly_goal_state.dart';

/// Cubit that manages weekly-goal submit flow and emits [WeeklyGoalState].
final class WeeklyGoalCubit extends Cubit<WeeklyGoalState> {
  /// Phases repository used for weekly-goal requests.
  final PhasesRepository _repository;

  /// Creates an instance of [WeeklyGoalCubit].
  WeeklyGoalCubit(this._repository) : super(const WeeklyGoalState.initial());

  /// Attempts to update weekly goal with [weeklyGoal].
  Future<void> updateWeeklyGoal(int weeklyGoal) async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const WeeklyGoalState.inProgress());

    final result = await _repository.updateWeeklyGoal(weeklyGoal);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const WeeklyGoalState.succeed());
      case Failure(:final error):
        emit(WeeklyGoalState.failed(error));
    }
  }
}
