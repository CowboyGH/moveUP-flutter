import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/cards/cards_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/save_card_payload.dart';
import '../../domain/repositories/cards_repository.dart';

part 'save_card_cubit.freezed.dart';
part 'save_card_state.dart';

/// Cubit that manages save-card submit flow.
final class SaveCardCubit extends Cubit<SaveCardState> {
  final CardsRepository _repository;

  /// Creates an instance of [SaveCardCubit].
  SaveCardCubit(this._repository) : super(const SaveCardState.initial());

  /// Saves a new card.
  Future<void> saveCard({
    required SaveCardPayload payload,
  }) async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const SaveCardState.inProgress());

    final result = await _repository.saveCard(payload: payload);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const SaveCardState.succeed());
      case Failure(:final error):
        emit(SaveCardState.failed(error));
    }
  }
}
