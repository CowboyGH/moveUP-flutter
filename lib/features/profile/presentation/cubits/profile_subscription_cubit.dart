import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/app_failure.dart';
import '../../../../../core/failures/feature/subscriptions/subscriptions_failure.dart';
import '../../../../../core/result/result.dart';
import '../../../subscriptions/domain/entities/subscription_catalog_item.dart';
import '../../../subscriptions/domain/repositories/subscriptions_repository.dart';
import '../../domain/entities/profile_stats_history_snapshot.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_subscription_cubit.freezed.dart';
part 'profile_subscription_state.dart';

/// Orchestrates the profile-local active subscription section state.
///
/// `/profile/active-subscription` exposes the active user-subscription record,
/// not the catalog subscription id, so the card is resolved from the active
/// catalog by matching business fields like name and price.
final class ProfileSubscriptionCubit extends Cubit<ProfileSubscriptionState> {
  final ProfileRepository _profileRepository;
  final SubscriptionsRepository _subscriptionsRepository;

  /// Creates an instance of [ProfileSubscriptionCubit].
  ProfileSubscriptionCubit(
    this._profileRepository,
    this._subscriptionsRepository,
  ) : super(const ProfileSubscriptionState());

  /// Loads the active subscription snapshot and matching catalog card.
  Future<void> load() async {
    if (state.isLoading) return;

    emit(
      state.copyWith(
        isLoading: true,
        failure: null,
      ),
    );

    final activeResult = await _profileRepository.getActiveSubscription();
    if (isClosed) return;

    switch (activeResult) {
      case Failure(:final error):
        emit(
          state.copyWith(
            isLoading: false,
            activeSubscription: null,
            item: null,
            failure: error,
          ),
        );
      case Success(:final data):
        if (data == null) {
          emit(const ProfileSubscriptionState());
          return;
        }
        await _loadCatalogItem(data);
    }
  }

  /// Retries loading the active subscription card data.
  Future<void> retry() => load();

  Future<void> _loadCatalogItem(
    ProfileActiveSubscriptionSnapshot activeSubscription,
  ) async {
    final result = await _subscriptionsRepository.getSubscriptions();
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        final item = _findMatchingItem(data, activeSubscription: activeSubscription);
        if (item == null) {
          emit(
            state.copyWith(
              isLoading: false,
              activeSubscription: activeSubscription,
              item: null,
              failure: const SubscriptionsNotFoundFailure(),
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            isLoading: false,
            activeSubscription: activeSubscription,
            item: item,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isLoading: false,
            activeSubscription: activeSubscription,
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
