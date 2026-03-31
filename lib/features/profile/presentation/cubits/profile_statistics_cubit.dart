import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../../core/result/result.dart';
import '../../domain/entities/profile_statistics/frequency_period.dart';
import '../../domain/entities/profile_statistics/frequency_statistics_data.dart';
import '../../domain/entities/profile_statistics/profile_exercise_option.dart';
import '../../domain/entities/profile_statistics/profile_history_tab.dart';
import '../../domain/entities/profile_statistics/profile_statistics_mode.dart';
import '../../domain/entities/profile_statistics/profile_workout_option.dart';
import '../../domain/entities/profile_statistics/trend_statistics_data.dart';
import '../../domain/entities/profile_statistics/volume_statistics_data.dart';
import '../../domain/entities/profile_stats_history_snapshot.dart';
import '../../domain/repositories/profile_statistics_repository.dart';

part 'profile_statistics_cubit.freezed.dart';
part 'profile_statistics_state.dart';

/// Cubit that manages the profile statistics state flow.
final class ProfileStatisticsCubit extends Cubit<ProfileStatisticsState> {
  final ProfileStatisticsRepository _repository;

  /// Creates an instance of [ProfileStatisticsCubit].
  ProfileStatisticsCubit(this._repository) : super(const ProfileStatisticsState());

  /// Loads the initial statistics payload.
  Future<void> loadInitial() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, failure: null));

    final volumeResult = await _repository.getVolume();
    final exercisesResult = await _repository.getExercises();

    if (isClosed) return;

    switch (volumeResult) {
      case Success(data: final volumeData):
        final exerciseOptions = switch (exercisesResult) {
          Success(data: final options) => options,
          Failure() => const <ProfileExerciseOption>[],
        };
        emit(
          state.copyWith(
            isLoading: false,
            mode: ProfileStatisticsMode.volume,
            selectedExerciseId: volumeData.exerciseId,
            volumeData: volumeData,
            exerciseOptions: exerciseOptions,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isLoading: false,
            failure: error,
          ),
        );
    }
  }

  /// Stores the latest history snapshot provided by the profile bootstrap flow.
  void setHistorySnapshot(ProfileStatsHistorySnapshot historySnapshot) {
    if (isClosed || state.historySnapshot == historySnapshot) return;

    emit(state.copyWith(historySnapshot: historySnapshot));
  }

  /// Updates the selected history tab.
  void selectHistoryTab(ProfileHistoryTab tab) {
    if (isClosed || state.selectedHistoryTab == tab) return;

    emit(state.copyWith(selectedHistoryTab: tab));
  }

  /// Switches the visible statistics mode.
  Future<void> selectMode(ProfileStatisticsMode mode) async {
    if (state.isLoading || state.mode == mode) return;

    emit(state.copyWith(mode: mode, failure: null));

    switch (mode) {
      case ProfileStatisticsMode.volume:
        if (state.volumeData != null && state.exerciseOptions.isNotEmpty) return;
        await _loadVolume(
          exerciseId: state.selectedExerciseId,
          weekOffset: state.volumeData?.period.weekOffset ?? 0,
          loadExercises: state.exerciseOptions.isEmpty,
        );
      case ProfileStatisticsMode.frequency:
        if (state.frequencyData != null) return;
        await _loadFrequency(
          period: state.selectedFrequencyPeriod,
          offset: state.selectedFrequencyOffset,
        );
      case ProfileStatisticsMode.trend:
        await _loadTrend(
          workoutId: state.selectedWorkoutId,
          loadWorkouts: state.workoutOptions.isEmpty,
        );
    }
  }

  /// Selects a new volume exercise and refreshes the chart.
  Future<void> selectExercise(int exerciseId) async {
    if (state.isLoading || state.selectedExerciseId == exerciseId) return;

    await _loadVolume(
      exerciseId: exerciseId,
      weekOffset: state.volumeData?.period.weekOffset ?? 0,
      loadExercises: false,
    );
  }

  /// Selects a new trend workout and refreshes the trend payload.
  Future<void> selectWorkout(int workoutId) async {
    if (state.isLoading || state.selectedWorkoutId == workoutId) return;

    await _loadTrend(
      workoutId: workoutId,
      loadWorkouts: false,
    );
  }

  /// Selects a new frequency period and resets offset to zero.
  Future<void> selectFrequencyPeriod(FrequencyPeriod period) async {
    if (state.isLoading || state.selectedFrequencyPeriod == period) return;

    await _loadFrequency(period: period, offset: 0);
  }

  /// Loads the previous available period for the currently selected mode.
  Future<void> loadPreviousPeriod() async {
    if (state.isLoading) return;

    switch (state.mode) {
      case ProfileStatisticsMode.volume:
        final volumeData = state.volumeData;
        if (volumeData == null || !volumeData.period.canGoPrevious) return;
        await _loadVolume(
          exerciseId: state.selectedExerciseId,
          weekOffset: volumeData.period.weekOffset + 1,
          loadExercises: false,
        );
      case ProfileStatisticsMode.frequency:
        await _loadFrequency(
          period: state.selectedFrequencyPeriod,
          offset: state.selectedFrequencyOffset + 1,
        );
      case ProfileStatisticsMode.trend:
        return;
    }
  }

  /// Loads the next available period for the currently selected mode.
  Future<void> loadNextPeriod() async {
    if (state.isLoading) return;

    switch (state.mode) {
      case ProfileStatisticsMode.volume:
        final volumeData = state.volumeData;
        if (volumeData == null || !volumeData.period.canGoNext) return;
        await _loadVolume(
          exerciseId: state.selectedExerciseId,
          weekOffset: volumeData.period.weekOffset - 1,
          loadExercises: false,
        );
      case ProfileStatisticsMode.frequency:
        if (state.selectedFrequencyOffset <= 0) return;
        await _loadFrequency(
          period: state.selectedFrequencyPeriod,
          offset: state.selectedFrequencyOffset - 1,
        );
      case ProfileStatisticsMode.trend:
        return;
    }
  }

  /// Reloads the current statistics mode without changing local selections.
  Future<void> reload() async {
    if (state.isLoading) return;

    switch (state.mode) {
      case ProfileStatisticsMode.volume:
        await _loadVolume(
          exerciseId: state.selectedExerciseId,
          weekOffset: state.volumeData?.period.weekOffset ?? 0,
          loadExercises: state.exerciseOptions.isEmpty,
        );
      case ProfileStatisticsMode.frequency:
        await _loadFrequency(
          period: state.selectedFrequencyPeriod,
          offset: state.selectedFrequencyOffset,
        );
      case ProfileStatisticsMode.trend:
        await _loadTrend(
          workoutId: state.selectedWorkoutId,
          loadWorkouts: state.workoutOptions.isEmpty,
        );
    }
  }

  Future<void> _loadVolume({
    required int? exerciseId,
    required int weekOffset,
    required bool loadExercises,
  }) async {
    emit(state.copyWith(isLoading: true, failure: null));

    final volumeFuture = _repository.getVolume(
      exerciseId: exerciseId,
      weekOffset: weekOffset,
    );
    final exercisesFuture = loadExercises ? _repository.getExercises() : null;

    final volumeResult = await volumeFuture;
    final exercisesResult = await exercisesFuture;
    if (isClosed) return;

    switch (volumeResult) {
      case Success(data: final volumeData):
        final nextExerciseOptions = switch (exercisesResult) {
          Success(data: final options) => options,
          Failure() => state.exerciseOptions,
          null => state.exerciseOptions,
        };
        emit(
          state.copyWith(
            isLoading: false,
            mode: ProfileStatisticsMode.volume,
            selectedExerciseId: volumeData.exerciseId ?? exerciseId,
            volumeData: volumeData,
            exerciseOptions: nextExerciseOptions,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isLoading: false,
            failure: error,
          ),
        );
    }
  }

  Future<void> _loadTrend({
    required int? workoutId,
    required bool loadWorkouts,
  }) async {
    emit(state.copyWith(isLoading: true, failure: null));

    final trendFuture = _repository.getTrend(workoutId: workoutId);
    final workoutsFuture = loadWorkouts ? _repository.getWorkouts() : null;

    final trendResult = await trendFuture;
    final workoutsResult = await workoutsFuture;
    if (isClosed) return;

    switch (trendResult) {
      case Success(data: final trendData):
        final nextWorkoutOptions = switch (workoutsResult) {
          Success(data: final options) => options,
          Failure() => state.workoutOptions,
          null => state.workoutOptions,
        };
        emit(
          state.copyWith(
            isLoading: false,
            mode: ProfileStatisticsMode.trend,
            selectedWorkoutId: trendData.workoutId ?? workoutId,
            trendData: trendData,
            workoutOptions: nextWorkoutOptions,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isLoading: false,
            failure: error,
          ),
        );
    }
  }

  Future<void> _loadFrequency({
    required FrequencyPeriod period,
    required int offset,
  }) async {
    emit(state.copyWith(isLoading: true, failure: null));

    final result = await _repository.getFrequency(
      period: period,
      offset: offset,
    );
    if (isClosed) return;

    switch (result) {
      case Success(data: final frequencyData):
        emit(
          state.copyWith(
            isLoading: false,
            mode: ProfileStatisticsMode.frequency,
            selectedFrequencyPeriod: frequencyData.period,
            selectedFrequencyOffset: frequencyData.offset,
            frequencyData: frequencyData,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isLoading: false,
            failure: error,
          ),
        );
    }
  }
}
