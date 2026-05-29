import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../../core/result/result.dart';
import '../../domain/entities/profile_phase_snapshot.dart';
import '../../domain/entities/profile_statistics/profile_current_phase_summary.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/profile_statistics_repository.dart';

part 'profile_phase_cubit.freezed.dart';
part 'profile_phase_state.dart';

/// Cubit that manages the profile current phase section payload.
final class ProfilePhaseCubit extends Cubit<ProfilePhaseState> {
  final ProfileRepository _profileRepository;
  final ProfileStatisticsRepository _statisticsRepository;

  /// Creates an instance of [ProfilePhaseCubit].
  ProfilePhaseCubit(
    this._profileRepository,
    this._statisticsRepository,
  ) : super(const ProfilePhaseState());

  /// Loads the phase snapshot together with the current phase summary.
  Future<void> load() async {
    if (state.isLoading) return;

    emit(
      state.copyWith(
        isLoading: true,
        isLoadingSummary: true,
        phaseFailure: null,
        summaryFailure: null,
      ),
    );

    final phaseFuture = _profileRepository.getPhaseSnapshot();
    final summaryFuture = _statisticsRepository.getCurrentPhaseSummary();

    final phaseResult = await phaseFuture;
    final summaryResult = await summaryFuture;
    if (isClosed) return;

    final phaseSnapshot = switch (phaseResult) {
      Success(:final data) => data,
      Failure() => state.phaseSnapshot,
    };
    final phaseFailure = switch (phaseResult) {
      Success() => null,
      Failure(:final error) => error,
    };
    final currentPhaseSummary = switch (summaryResult) {
      Success(:final data) => data,
      Failure() => state.currentPhaseSummary,
    };
    final summaryFailure = switch (summaryResult) {
      Success() => null,
      Failure(:final error) => error,
    };

    emit(
      state.copyWith(
        isLoading: false,
        isLoadingSummary: false,
        phaseSnapshot: phaseSnapshot,
        currentPhaseSummary: currentPhaseSummary,
        phaseFailure: phaseFailure,
        summaryFailure: summaryFailure,
      ),
    );
  }

  /// Reloads only the current phase summary data.
  Future<void> reloadSummary() async {
    if (state.isLoadingSummary) return;

    emit(
      state.copyWith(
        isLoadingSummary: true,
        summaryFailure: null,
      ),
    );

    final result = await _statisticsRepository.getCurrentPhaseSummary();
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            isLoadingSummary: false,
            currentPhaseSummary: data,
            summaryFailure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isLoadingSummary: false,
            summaryFailure: error,
          ),
        );
    }
  }
}
