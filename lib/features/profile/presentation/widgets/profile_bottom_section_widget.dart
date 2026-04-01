import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/router/router_paths.dart';
import '../../../../../uikit/buttons/button_state.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/buttons/secondary_button.dart';
import '../../../../../uikit/dialogs/app_action_dialog.dart';
import '../../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../../auth/presentation/cubits/logout_cubit.dart';
import '../../../auth/presentation/pages/legal_document_type.dart';
import '../cubits/delete_profile_cubit.dart';

/// Bottom profile section with logout/delete actions and legal links.
class ProfileBottomSectionWidget extends StatefulWidget {
  /// Creates an instance of [ProfileBottomSectionWidget].
  const ProfileBottomSectionWidget({super.key});

  @override
  State<ProfileBottomSectionWidget> createState() => _ProfileBottomSectionWidgetState();
}

class _ProfileBottomSectionWidgetState extends State<ProfileBottomSectionWidget> {
  bool _isLogoutDialogOpen = false;
  bool _isDeleteDialogOpen = false;

  Future<void> _openLogoutDialog() async {
    if (_isLogoutDialogOpen) return;
    _isLogoutDialogOpen = true;
    final logoutCubit = context.read<LogoutCubit>();
    await showAppActionDialog(
      context,
      title: AppStrings.profileBottomLogoutTitle,
      primaryAction: BlocProvider.value(
        value: logoutCubit,
        child: BlocBuilder<LogoutCubit, LogoutState>(
          builder: (context, state) {
            final isInProgress = state.maybeWhen(
              inProgress: () => true,
              orElse: () => false,
            );
            return MainButton(
              state: isInProgress ? ButtonState.loading : ButtonState.enabled,
              onPressed: () => context.read<LogoutCubit>().logout(),
              child: const Text(AppStrings.profileBottomLogoutButton),
            );
          },
        ),
      ),
      secondaryAction: BlocProvider.value(
        value: logoutCubit,
        child: BlocBuilder<LogoutCubit, LogoutState>(
          builder: (context, state) {
            final isInProgress = state.maybeWhen(
              inProgress: () => true,
              orElse: () => false,
            );
            return SecondaryButton(
              state: isInProgress ? ButtonState.disabled : ButtonState.enabled,
              onPressed: _closeActiveDialog,
              child: const Text(AppStrings.profileCancelButton),
            );
          },
        ),
      ),
    );
    _isLogoutDialogOpen = false;
  }

  Future<void> _openDeleteDialog() async {
    if (_isDeleteDialogOpen) return;
    _isDeleteDialogOpen = true;
    final deleteProfileCubit = context.read<DeleteProfileCubit>();
    await showAppActionDialog(
      context,
      title: AppStrings.profileBottomDeleteTitle,
      primaryAction: BlocProvider.value(
        value: deleteProfileCubit,
        child: BlocBuilder<DeleteProfileCubit, DeleteProfileState>(
          builder: (context, state) {
            final isInProgress = state.maybeWhen(
              inProgress: () => true,
              orElse: () => false,
            );
            return MainButton(
              state: isInProgress ? ButtonState.loading : ButtonState.enabled,
              onPressed: () => context.read<DeleteProfileCubit>().deleteProfile(),
              child: const Text(AppStrings.profileBottomDeleteConfirm),
            );
          },
        ),
      ),
      secondaryAction: BlocProvider.value(
        value: deleteProfileCubit,
        child: BlocBuilder<DeleteProfileCubit, DeleteProfileState>(
          builder: (context, state) {
            final isInProgress = state.maybeWhen(
              inProgress: () => true,
              orElse: () => false,
            );
            return SecondaryButton(
              state: isInProgress ? ButtonState.disabled : ButtonState.enabled,
              onPressed: _closeActiveDialog,
              child: const Text(AppStrings.profileCancelButton),
            );
          },
        ),
      ),
    );
    _isDeleteDialogOpen = false;
  }

  void _closeActiveDialog() {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (!navigator.canPop()) return;
    navigator.pop();
  }

  void _openLegalDocument(LegalDocumentType type) =>
      unawaited(context.push(AppRoutePaths.legalDocumentPath, extra: type));

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LogoutCubit, LogoutState>(
          listener: (context, state) {
            state.whenOrNull(
              succeed: () {
                _closeActiveDialog();
                unawaited(context.read<AuthSessionCubit>().signOut());
              },
              failed: (failure) {
                _closeActiveDialog();
                if (failure.message.isEmpty) return;
                unawaited(
                  showAppFeedbackDialog(
                    context,
                    title: AppStrings.feedbackErrorTitle,
                    message: failure.message,
                  ),
                );
              },
            );
          },
        ),
        BlocListener<DeleteProfileCubit, DeleteProfileState>(
          listener: (context, state) {
            state.whenOrNull(
              succeed: () {
                _closeActiveDialog();
                unawaited(context.read<AuthSessionCubit>().signOut());
              },
              failed: (failure) {
                _closeActiveDialog();
                if (failure.message.isEmpty) return;
                unawaited(
                  showAppFeedbackDialog(
                    context,
                    title: AppStrings.feedbackErrorTitle,
                    message: failure.message,
                  ),
                );
              },
            );
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainButton(
            onPressed: _openLogoutDialog,
            child: const Text(AppStrings.profileBottomLogoutButton),
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            onPressed: _openDeleteDialog,
            child: const Text(AppStrings.profileBottomDeleteButton),
          ),
          const SizedBox(height: 36),
          _LegalLink(
            label: AppStrings.legalDataProcessingConsentProfileTitle,
            onPressed: () => _openLegalDocument(LegalDocumentType.dataProcessingConsent),
          ),
          const SizedBox(height: 6),
          _LegalLink(
            label: AppStrings.legalPublicOfferTitle,
            onPressed: () => _openLegalDocument(LegalDocumentType.publicOffer),
          ),
          const SizedBox(height: 6),
          _LegalLink(
            label: AppStrings.legalPrivacyPolicyTitle,
            onPressed: () => _openLegalDocument(LegalDocumentType.privacyPolicy),
          ),
        ],
      ),
    );
  }
}

final class _LegalLink extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _LegalLink({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          minimumSize: const WidgetStatePropertyAll(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorTheme.disabled;
            }
            return colorTheme.outline;
          }),
          textStyle: WidgetStatePropertyAll(textTheme.body),
        ),
        child: Text(
          label,
          textAlign: TextAlign.start,
          style: textTheme.body,
        ),
      ),
    );
  }
}
