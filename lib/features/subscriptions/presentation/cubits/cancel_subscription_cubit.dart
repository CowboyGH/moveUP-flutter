import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/subscriptions/subscriptions_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/subscriptions_repository.dart';

part 'cancel_subscription_cubit.freezed.dart';
part 'cancel_subscription_state.dart';

/// Cubit that manages the active subscription cancel flow.
final class CancelSubscriptionCubit extends Cubit<CancelSubscriptionState> {
  final SubscriptionsRepository _repository;

  /// Creates an instance of [CancelSubscriptionCubit].
  CancelSubscriptionCubit(this._repository) : super(const CancelSubscriptionState.initial());

  /// Cancels the currently active subscription.
  Future<void> cancelSubscription() async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const CancelSubscriptionState.inProgress());

    final result = await _repository.cancelSubscription();
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const CancelSubscriptionState.succeed());
      case Failure(:final error):
        emit(CancelSubscriptionState.failed(error));
    }
  }
}
