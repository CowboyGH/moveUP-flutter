import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/subscriptions/subscriptions_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/subscription_payment_payload.dart';
import '../../domain/repositories/subscriptions_repository.dart';

part 'subscription_payment_cubit.freezed.dart';
part 'subscription_payment_state.dart';

/// Cubit that manages the subscription payment submit flow.
final class SubscriptionPaymentCubit extends Cubit<SubscriptionPaymentState> {
  final SubscriptionsRepository _repository;

  /// Creates an instance of [SubscriptionPaymentCubit].
  SubscriptionPaymentCubit(this._repository) : super(const SubscriptionPaymentState.initial());

  /// Attempts to pay for the currently selected subscription.
  Future<void> pay({
    required SubscriptionPaymentPayload payload,
  }) async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const SubscriptionPaymentState.inProgress());

    final result = await _repository.paySubscription(payload: payload);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const SubscriptionPaymentState.succeed());
      case Failure(:final error):
        emit(SubscriptionPaymentState.failed(error));
    }
  }
}
