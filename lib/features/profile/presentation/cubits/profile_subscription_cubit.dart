import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/subscriptions/subscriptions_failure.dart';
import '../../../../../core/result/result.dart';
import '../../../subscriptions/domain/entities/subscription_catalog_item.dart';
import '../../../subscriptions/domain/repositories/subscriptions_repository.dart';
import '../../domain/entities/profile_stats_history_snapshot.dart';

part 'profile_subscription_cubit.freezed.dart';
part 'profile_subscription_state.dart';

/// Orchestrates the profile-local active subscription section state.
///
/// `/profile` exposes the active user-subscription record, not the catalog
/// subscription id, so the card is resolved from the active catalog by
/// matching business fields like name and price.
final class ProfileSubscriptionCubit extends Cubit<ProfileSubscriptionState> {
  final SubscriptionsRepository _repository;

  /// Creates an instance of [ProfileSubscriptionCubit].
  ProfileSubscriptionCubit(this._repository) : super(const ProfileSubscriptionState());

  /// Synchronizes the current profile active subscription snapshot with the section.
  Future<void> syncActiveSubscription(
    ProfileActiveSubscriptionSnapshot? activeSubscription,
  ) async {
    final currentActiveSubscription = state.activeSubscription;
    final currentSubscriptionId = currentActiveSubscription?.id;
    final nextSubscriptionId = activeSubscription?.id;

    if (activeSubscription == null) {
      emit(const ProfileSubscriptionState());
      return;
    }

    if (currentSubscriptionId == nextSubscriptionId) {
      if (currentActiveSubscription != activeSubscription) {
        emit(state.copyWith(activeSubscription: activeSubscription));
      }
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        activeSubscription: activeSubscription,
        item: null,
        failure: null,
      ),
    );

    await _loadSubscription();
  }

  /// Retries loading the active subscription card data.
  Future<void> retry() async {
    final activeSubscription = state.activeSubscription;
    if (activeSubscription == null || state.isLoading) return;

    emit(
      state.copyWith(
        isLoading: true,
        failure: null,
      ),
    );

    await _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    final activeSubscription = state.activeSubscription;
    if (activeSubscription == null) {
      emit(const ProfileSubscriptionState());
      return;
    }

    final result = await _repository.getSubscriptions();
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        final item = _findMatchingItem(
          data,
          activeSubscription: activeSubscription,
        );
        if (item == null) {
          emit(
            state.copyWith(
              isLoading: false,
              item: null,
              failure: const SubscriptionsNotFoundFailure(),
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            isLoading: false,
            item: item,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isLoading: false,
            item: null,
            failure: error,
          ),
        );
    }
  }

  SubscriptionCatalogItem? _findMatchingItem(
    List<SubscriptionCatalogItem> items, {
    required ProfileActiveSubscriptionSnapshot activeSubscription,
  }) {
    final normalizedName = _normalizeName(activeSubscription.name);

    for (final item in items) {
      if (_normalizeName(item.name) != normalizedName) continue;
      if (_pricesEqual(item.price, activeSubscription.price)) return item;
    }

    for (final item in items) {
      if (_normalizeName(item.name) == normalizedName) return item;
    }

    return null;
  }

  String _normalizeName(String value) => value.trim().toLowerCase();

  bool _pricesEqual(String left, String right) {
    final leftValue = num.tryParse(left.trim().replaceAll(',', '.'));
    final rightValue = num.tryParse(right.trim().replaceAll(',', '.'));
    if (leftValue != null && rightValue != null) {
      return leftValue == rightValue;
    }
    return left.trim() == right.trim();
  }
}
