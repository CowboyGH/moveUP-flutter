import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/entities/subscription_catalog_item.dart';
import '../../domain/repositories/subscriptions_repository.dart';
import '../cubits/subscription_details_cubit.dart';
import '../cubits/subscription_payment_cubit.dart';
import 'subscriptions_details_page.dart';

/// Builder for the subscription details page.
class SubscriptionsDetailsPageBuilder extends StatelessWidget {
  /// Requested subscription identifier.
  final int subscriptionId;

  /// Optional seeded item passed from the catalog route.
  final SubscriptionCatalogItem? seedItem;

  /// Creates an instance of [SubscriptionsDetailsPageBuilder].
  const SubscriptionsDetailsPageBuilder({
    required this.subscriptionId,
    this.seedItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SubscriptionDetailsCubit(
            di<SubscriptionsRepository>(),
          )..loadInitial(subscriptionId, seedItem: seedItem),
        ),
        BlocProvider(
          create: (_) => SubscriptionPaymentCubit(di<SubscriptionsRepository>()),
        ),
      ],
      child: SubscriptionsDetailsPage(subscriptionId: subscriptionId),
    );
  }
}
