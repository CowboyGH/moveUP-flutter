import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../../core/result/result.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_user_cubit.freezed.dart';
part 'profile_user_state.dart';

/// Cubit that manages the authenticated profile user section payload.
final class ProfileUserCubit extends Cubit<ProfileUserState> {
  final ProfileRepository _repository;

  /// Creates an instance of [ProfileUserCubit].
  ProfileUserCubit(
    this._repository, {
    User? seedUser,
  }) : super(ProfileUserState(user: seedUser));

  /// Refreshes the canonical profile user payload.
  Future<void> refresh() async {
    if (state.isLoading) return;

    emit(
      state.copyWith(
        isLoading: true,
        failure: null,
      ),
    );

    final result = await _repository.getUser();
    if (isClosed) return;

    switch (result) {
      case Success(data: final user):
        emit(
          state.copyWith(
            isLoading: false,
            user: user,
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

  /// Replaces the current user with a freshly updated payload.
  void replaceUser(User user) {
    if (isClosed) return;

    emit(
      state.copyWith(
        user: user,
        failure: null,
      ),
    );
  }
}
