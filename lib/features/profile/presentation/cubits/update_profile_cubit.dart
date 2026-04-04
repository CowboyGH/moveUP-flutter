import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../../core/result/result.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';

part 'update_profile_cubit.freezed.dart';
part 'update_profile_state.dart';

/// Cubit that manages edit-profile submit flow.
final class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final ProfileRepository _repository;

  /// Creates an instance of [UpdateProfileCubit].
  UpdateProfileCubit(this._repository) : super(const UpdateProfileState.initial());

  /// Updates the authenticated profile.
  Future<void> updateProfile({
    required User currentUser,
    required String name,
    required String email,
    String? avatarPath,
  }) async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const UpdateProfileState.inProgress());

    final result = await _repository.updateUser(
      currentUser: currentUser,
      name: name,
      email: email,
      avatarPath: avatarPath,
    );
    if (isClosed) return;

    switch (result) {
      case Success(data: final user):
        emit(UpdateProfileState.succeed(user));
      case Failure(:final error):
        emit(UpdateProfileState.failed(error));
    }
  }
}
