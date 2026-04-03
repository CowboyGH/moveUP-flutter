import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/cards/cards_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/cards_repository.dart';

part 'set_default_card_cubit.freezed.dart';
part 'set_default_card_state.dart';

/// Cubit that manages the default-card command flow.
final class SetDefaultCardCubit extends Cubit<SetDefaultCardState> {
  final CardsRepository _repository;

  /// Creates an instance of [SetDefaultCardCubit].
  SetDefaultCardCubit(this._repository) : super(const SetDefaultCardState.initial());

  /// Marks [cardId] as default.
  Future<void> setDefaultCard(int cardId) async {
    final isInProgress = state.maybeWhen(
      inProgress: (_) => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(SetDefaultCardState.inProgress(cardId));

    final result = await _repository.setDefaultCard(cardId);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const SetDefaultCardState.succeed());
      case Failure(:final error):
        emit(SetDefaultCardState.failed(error));
    }
  }
}
