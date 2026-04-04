import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../../core/result/result.dart';
import '../../domain/repositories/profile_repository.dart';

part 'delete_profile_cubit.freezed.dart';
part 'delete_profile_state.dart';

/// Cubit that manages the delete-profile flow.
final class DeleteProfileCubit extends Cubit<DeleteProfileState> {
  final ProfileRepository _repository;

  /// Creates an instance of [DeleteProfileCubit].
  DeleteProfileCubit(this._repository) : super(const DeleteProfileState.initial());

  /// Attempts to delete the current authenticated profile.
  Future<void> deleteProfile() async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const DeleteProfileState.inProgress());

    final result = await _repository.deleteProfile();
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const DeleteProfileState.succeed());
      case Failure(:final error):
        emit(DeleteProfileState.failed(error));
    }
  }
}
