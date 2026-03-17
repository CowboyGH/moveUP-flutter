import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'sign_in_cubit.freezed.dart';
part 'sign_in_state.dart';

/// Cubit that manages sign-in flow and emits [SignInState].
final class SignInCubit extends Cubit<SignInState> {
  /// Authentication repository used for sign-in requests.
  final AuthRepository _repository;

  /// Creates an instance of [SignInCubit].
  SignInCubit(this._repository) : super(const SignInState.initial());

  /// Attempts to sign in with [email] and [password].
  Future<void> signIn(String email, String password) async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const SignInState.inProgress());

    final result = await _repository.signIn(email, password);
    if (isClosed) return;

    switch (result) {
      case Success(data: final user):
        emit(SignInState.succeed(user));
      case Failure(:final error):
        emit(SignInState.failed(error));
    }
  }
}
