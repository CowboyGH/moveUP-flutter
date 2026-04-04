import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/cards/cards_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/cards_repository.dart';

part 'delete_card_cubit.freezed.dart';
part 'delete_card_state.dart';

/// Cubit that manages the delete-card command flow.
final class DeleteCardCubit extends Cubit<DeleteCardState> {
  final CardsRepository _repository;

  /// Creates an instance of [DeleteCardCubit].
  DeleteCardCubit(this._repository) : super(const DeleteCardState.initial());

  /// Deletes [cardId].
  Future<void> deleteCard(int cardId) async {
    final isInProgress = state.maybeWhen(
      inProgress: (_) => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(DeleteCardState.inProgress(cardId));

    final result = await _repository.deleteCard(cardId);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const DeleteCardState.succeed());
      case Failure(:final error):
        emit(DeleteCardState.failed(error));
    }
  }
}
