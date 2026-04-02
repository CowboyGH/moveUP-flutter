import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/repositories/subscriptions_repository.dart';
import '../cubits/subscriptions_cubit.dart';
import 'subscriptions_catalog_page.dart';

/// Builder for the subscriptions catalog page.
class SubscriptionsCatalogPageBuilder extends StatelessWidget {
  /// Creates an instance of [SubscriptionsCatalogPageBuilder].
  const SubscriptionsCatalogPageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionsCubit(
        di<SubscriptionsRepository>(),
      )..loadSubscriptions(),
      child: const SubscriptionsCatalogPage(),
    );
  }
}
