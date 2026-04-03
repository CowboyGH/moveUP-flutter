import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/cards/cards_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/saved_card.dart';
import '../../domain/repositories/cards_repository.dart';

part 'cards_cubit.freezed.dart';
part 'cards_state.dart';

/// Cubit that manages loading and refreshing saved cards.
final class CardsCubit extends Cubit<CardsState> {
  final CardsRepository _repository;

  /// Creates an instance of [CardsCubit].
  CardsCubit(this._repository) : super(const CardsState());

  /// Loads saved cards.
  Future<void> loadCards() async {
    if (state.isLoading) return;

    emit(
      state.copyWith(
        isLoading: true,
        failure: null,
      ),
    );

    final result = await _repository.getCards();
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            isLoading: false,
            cards: data,
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
}
