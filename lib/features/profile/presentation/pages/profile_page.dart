import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/router/router_paths.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/buttons/secondary_button.dart';
import '../../../../../uikit/images/svg_picture_widget.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../cubits/profile_parameters_cubit.dart';
import '../cubits/profile_refresh_cubit.dart';
import '../cubits/profile_statistics_cubit.dart';
import '../cubits/profile_user_cubit.dart';
import '../widgets/change_password_dialog.dart';
import '../widgets/current_phase_section_widget.dart';
import '../widgets/edit_profile_dialog.dart';
import '../widgets/profile_bottom_section_widget.dart';
import '../widgets/profile_parameters_section_widget.dart';
import '../widgets/profile_subscription_section_widget.dart';
import '../widgets/stats/profile_history_dialog.dart';
import '../widgets/stats/stats_section_widget.dart';
import '../widgets/user_section_widget.dart';

/// Authenticated profile page with the user section only.
class ProfilePage extends StatelessWidget {
  /// Creates an instance of [ProfilePage].
  const ProfilePage({super.key});

  Future<void> _openEditProfileDialog(BuildContext context, User user) async {
    final updatedUser = await showEditProfileDialog(context, user: user);
    if (!context.mounted || updatedUser == null) return;

    context.read<ProfileUserCubit>().replaceUser(updatedUser);
    context.read<AuthSessionCubit>().updateAuthenticatedUser(updatedUser);
  }

  Future<void> _openChangePasswordDialog(BuildContext context) async {
    final result = await showChangePasswordDialog(context);
    if (!context.mounted || result != ChangePasswordDialogResult.forgotPassword) return;

    unawaited(context.push(AppRoutePaths.forgotPasswordPath));
  }

  Future<void> _openHistoryDialog(BuildContext context) async {
    await showProfileHistoryDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.profileTab,
          style: textTheme.appBarTitle,
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 24),
            child: Center(
              child: ExcludeSemantics(
                child: SvgPictureWidget.icon(AppAssets.iconNotification),
              ),
            ),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileRefreshCubit, ProfileRefreshState>(
            listenWhen: (previous, current) => previous.shouldRefresh != current.shouldRefresh,
            listener: (context, state) {
              if (!state.shouldRefresh) return;
              context.read<ProfileRefreshCubit>().consumeRefreshRequest();
              unawaited(context.read<ProfileUserCubit>().refresh());
            },
          ),
          BlocListener<ProfileUserCubit, ProfileUserState>(
            listenWhen: (previous, current) =>
                previous.historySnapshot != current.historySnapshot ||
                previous.parametersSnapshot != current.parametersSnapshot,
            listener: (context, state) {
              final historySnapshot = state.historySnapshot;
              if (historySnapshot != null) {
                context.read<ProfileStatisticsCubit>().setHistorySnapshot(historySnapshot);
              }

              context.read<ProfileParametersCubit>().setBootstrapSnapshot(state.parametersSnapshot);
            },
          ),
        ],
        child: BlocBuilder<ProfileUserCubit, ProfileUserState>(
          builder: (context, state) {
            final user = state.user;
            if (user == null) {
              return _ProfileUserFallbackState(
                isLoading: state.isLoading,
                onRetryPressed: () => context.read<ProfileUserCubit>().refresh(),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 132),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.profileGreeting(user.name),
                    style: textTheme.bodyMedium.copyWith(
                      fontSize: 18,
                      height: 27 / 18,
                      fontWeight: FontWeight.w500,
                      color: colorTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  UserSectionWidget(
                    user: user,
                    onEditPressed: () => _openEditProfileDialog(context, user),
                    onChangePasswordPressed: () => _openChangePasswordDialog(context),
                  ),
                  const SizedBox(height: 36),
                  const StatsSectionWidget(),
                  const SizedBox(height: 20),
                  SecondaryButton(
                    onPressed: () => _openHistoryDialog(context),
                    child: const Text(AppStrings.profileStatsHistoryButton),
                  ),
                  const SizedBox(height: 36),
                  ProfileSubscriptionSectionWidget(
                    activeSubscription: state.historySnapshot?.activeSubscription,
                  ),
                  const SizedBox(height: 36),
                  const CurrentPhaseSectionWidget(),
                  const SizedBox(height: 36),
                  const ProfileParametersSectionWidget(),
                  const SizedBox(height: 36),
                  const ProfileBottomSectionWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

final class _ProfileUserFallbackState extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRetryPressed;

  const _ProfileUserFallbackState({
    required this.isLoading,
    required this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    const contentPadding = EdgeInsets.fromLTRB(24, 28, 24, 132);

    if (isLoading) {
      return const Center(
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator.adaptive(strokeWidth: 2),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: contentPadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - contentPadding.vertical,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.profileLoadFailed,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
                      ),
                      const SizedBox(height: 16),
                      MainButton(
                        onPressed: onRetryPressed,
                        child: const Text(AppStrings.retryButton),
                      ),
                    ],
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16),
                    ProfileBottomSectionWidget(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
