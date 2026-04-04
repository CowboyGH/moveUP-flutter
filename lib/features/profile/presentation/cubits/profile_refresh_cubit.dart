import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_refresh_cubit.freezed.dart';
part 'profile_refresh_state.dart';

/// Shared trigger for refreshing `/profile` after external flows mutate its data.
final class ProfileRefreshCubit extends Cubit<ProfileRefreshState> {
  /// Creates an instance of [ProfileRefreshCubit].
  ProfileRefreshCubit() : super(const ProfileRefreshState());

  /// Marks the profile as needing a refresh.
  void requestRefresh() {
    if (state.shouldRefresh) return;
    emit(const ProfileRefreshState(shouldRefresh: true));
  }

  /// Clears the pending refresh request after the UI handled it.
  void consumeRefreshRequest() {
    if (!state.shouldRefresh) return;
    emit(const ProfileRefreshState());
  }
}
