import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/di.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../../auth/presentation/cubits/logout_cubit.dart';
import '../../../subscriptions/domain/repositories/subscriptions_repository.dart';
import '../../../subscriptions/presentation/cubits/cancel_subscription_cubit.dart';
import '../../domain/repositories/profile_parameters_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/profile_statistics_repository.dart';
import '../cubits/delete_profile_cubit.dart';
import '../cubits/profile_parameters_cubit.dart';
import '../cubits/profile_refresh_cubit.dart';
import '../cubits/profile_subscription_cubit.dart';
import '../cubits/profile_statistics_cubit.dart';
import '../cubits/profile_user_cubit.dart';
import 'profile_page.dart';

/// Builder for the authenticated profile page.
class ProfilePageBuilder extends StatelessWidget {
  /// Creates an instance of [ProfilePageBuilder].
  const ProfilePageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final initialUser = context.select<AuthSessionCubit, User?>(
      (cubit) => cubit.state.maybeWhen(
        authenticated: (user) => user,
        orElse: () => null,
      ),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileUserCubit(
            di<ProfileRepository>(),
            seedUser: initialUser,
          )..refresh(),
        ),
        BlocProvider(
          create: (_) => ProfileStatisticsCubit(
            di<ProfileStatisticsRepository>(),
          )..loadInitial(),
        ),
        BlocProvider(
          create: (_) => ProfileParametersCubit(
            di<ProfileParametersRepository>(),
          )..loadInitial(),
        ),
        BlocProvider(
          create: (_) => ProfileSubscriptionCubit(
            di<SubscriptionsRepository>(),
          ),
        ),
        BlocProvider.value(
          value: di<ProfileRefreshCubit>(),
        ),
        BlocProvider(
          create: (_) => LogoutCubit(di<AuthRepository>()),
        ),
        BlocProvider(
          create: (_) => DeleteProfileCubit(di<ProfileRepository>()),
        ),
        BlocProvider(
          create: (_) => CancelSubscriptionCubit(di<SubscriptionsRepository>()),
        ),
      ],
      child: const ProfilePage(),
    );
  }
}
