import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'sign_up_cubit.freezed.dart';
part 'sign_up_state.dart';

/// Cubit that manages sign-up flow and emits [SignUpState].
final class SignUpCubit extends Cubit<SignUpState> {
  /// Authentication repository used for sign-up requests.
  final AuthRepository _repository;

  /// Creates an instance of [SignUpCubit].
  SignUpCubit(this._repository) : super(const SignUpState.initial());

  /// Attempts to sign up with [name], [email] and [password].
  Future<void> signUp(String name, String email, String password) async {
    if (state is _InProgress) return;

    emit(const SignUpState.inProgress());

    final result = await _repository.signUp(name, email, password);
    if (isClosed) return;

    switch (result) {
      case Success(data: final user):
        emit(SignUpState.succeed(user));
      case Failure(:final error):
        emit(SignUpState.failed(error));
    }
  }
}
