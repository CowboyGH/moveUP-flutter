import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/subscriptions/subscriptions_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/subscription_catalog_item.dart';
import '../../domain/repositories/subscriptions_repository.dart';

part 'subscriptions_cubit.freezed.dart';
part 'subscriptions_state.dart';

/// Cubit that manages subscriptions catalog loading flow and emits [SubscriptionsState].
final class SubscriptionsCubit extends Cubit<SubscriptionsState> {
  /// Repository used for subscriptions catalog requests.
  final SubscriptionsRepository _repository;

  /// Creates an instance of [SubscriptionsCubit].
  SubscriptionsCubit(this._repository) : super(const SubscriptionsState.initial());

  /// Loads all subscriptions available for the catalog screen.
  Future<void> loadSubscriptions() async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const SubscriptionsState.inProgress());

    final result = await _repository.getSubscriptions();
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(SubscriptionsState.loaded(data));
      case Failure(:final error):
        emit(SubscriptionsState.failed(error));
    }
  }
}
