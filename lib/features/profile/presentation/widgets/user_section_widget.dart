import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/buttons/secondary_button.dart';
import '../../../../../uikit/cards/app_card.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../../auth/domain/entities/user.dart';
import 'profile_avatar_image.dart';

/// The first profile section with the basic authenticated user data.
class UserSectionWidget extends StatelessWidget {
  /// Current authenticated user.
  final User user;

  /// Callback for the edit-profile action.
  final VoidCallback onEditPressed;

  /// Callback for the change-password action.
  final VoidCallback onChangePasswordPressed;

  /// Creates an instance of [UserSectionWidget].
  const UserSectionWidget({
    required this.user,
    required this.onEditPressed,
    required this.onChangePasswordPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return AppCard(
      contentPadding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 14),
          Center(
            child: ClipOval(
              child: SizedBox.square(
                dimension: 140,
                child: ProfileAvatarImage(
                  imageUrl: user.avatar ?? '',
                  height: 140,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            user.name,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium.copyWith(
              fontSize: 14,
              height: 21 / 14,
              fontWeight: FontWeight.w500,
              color: colorTheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            user.email,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium.copyWith(
              fontSize: 14,
              height: 21 / 14,
              color: colorTheme.darkHint,
            ),
          ),
          const SizedBox(height: 24),
          MainButton(
            onPressed: onEditPressed,
            child: const Text(AppStrings.profileEditButton),
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            onPressed: onChangePasswordPressed,
            child: const Text(AppStrings.profileChangePasswordButton),
          ),
        ],
      ),
    );
  }
}
