import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/subscriptions/subscriptions_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/subscription_catalog_item.dart';
import '../../domain/repositories/subscriptions_repository.dart';

part 'subscription_details_cubit.freezed.dart';
part 'subscription_details_state.dart';

/// Cubit that manages loading of a single subscription details screen.
final class SubscriptionDetailsCubit extends Cubit<SubscriptionDetailsState> {
  final SubscriptionsRepository _repository;

  /// Creates an instance of [SubscriptionDetailsCubit].
  SubscriptionDetailsCubit(this._repository) : super(const SubscriptionDetailsState.initial());

  /// Loads subscription details using [seedItem] when available.
  Future<void> loadInitial(
    int subscriptionId, {
    SubscriptionCatalogItem? seedItem,
  }) async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    if (seedItem != null && seedItem.id == subscriptionId) {
      emit(SubscriptionDetailsState.loaded(seedItem));
      return;
    }

    emit(const SubscriptionDetailsState.inProgress());

    final result = await _repository.getSubscriptionById(subscriptionId);
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(SubscriptionDetailsState.loaded(data));
      case Failure(:final error):
        emit(SubscriptionDetailsState.failed(error));
    }
  }
}
