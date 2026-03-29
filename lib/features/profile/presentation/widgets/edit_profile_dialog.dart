import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/di/di.dart';
import '../../../../../uikit/buttons/button_state.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/buttons/secondary_button.dart';
import '../../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../../uikit/images/network_image_widget.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/validators/auth_validators.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../../domain/repositories/profile_repository.dart';
import '../cubits/update_profile_cubit.dart';
import 'profile_dialog_shell.dart';

/// Opens the edit-profile dialog and returns the refreshed user on success.
Future<User?> showEditProfileDialog(
  BuildContext context, {
  required User user,
}) {
  return showProfileDialog<User>(
    context,
    insetPadding: const EdgeInsets.symmetric(horizontal: 11.5),
    child: BlocProvider(
      create: (_) => UpdateProfileCubit(di<ProfileRepository>()),
      child: EditProfileDialog(user: user),
    ),
  );
}

/// Dialog for editing the authenticated profile.
class EditProfileDialog extends StatefulWidget {
  /// Current authenticated user.
  final User user;

  /// Creates an instance of [EditProfileDialog].
  const EditProfileDialog({
    required this.user,
    super.key,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _picker = ImagePicker();

  String? _selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user.email;
    _nameController.text = widget.user.name;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (file == null || !mounted) return;

      setState(() {
        _selectedAvatarPath = file.path;
      });
    } catch (_) {
      if (!mounted) return;
      await showAppFeedbackDialog(
        context,
        title: AppStrings.feedbackErrorTitle,
        message: AppStrings.profileImagePickFailed,
      );
    }
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    context.read<UpdateProfileCubit>().updateProfile(
      currentUser: widget.user,
      name: _nameController.text,
      email: _emailController.text,
      avatarPath: _selectedAvatarPath,
    );
  }

  String get _formatLabel {
    final avatarPath = _selectedAvatarPath;
    if (avatarPath == null || avatarPath.isEmpty) {
      return AppStrings.profileUploadFormatPlaceholder;
    }

    final fileName = avatarPath.split(Platform.pathSeparator).last;
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex <= 0 || dotIndex == fileName.length - 1) {
      return AppStrings.profileUploadFormatPlaceholder;
    }

    final extension = fileName.substring(dotIndex + 1).toLowerCase();
    return '$extension ${AppStrings.profileUploadFormat}';
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
      listener: (context, state) {
        state.whenOrNull(
          succeed: (user) => Navigator.of(context).pop(user),
          failed: (failure) {
            if (failure.message.isEmpty) return;
            showAppFeedbackDialog(
              context,
              title: AppStrings.feedbackErrorTitle,
              message: failure.message,
            );
          },
        );
      },
      builder: (context, state) {
        final isInProgress = state.maybeWhen(
          inProgress: () => true,
          orElse: () => false,
        );
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: _AvatarPreview(
                  imageUrl: widget.user.avatar,
                  localAvatarPath: _selectedAvatarPath,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.profileUploadFileLabel,
                      style: textTheme.body.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorTheme.onSurface,
                      ),
                    ),
                  ),
                  _AvatarPickButton(
                    onPressed: isInProgress ? null : _pickAvatar,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colorTheme.outline),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    _formatLabel,
                    textAlign: TextAlign.center,
                    style: textTheme.button.copyWith(
                      color: colorTheme.hint,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              AuthTextField(
                controller: _emailController,
                enabled: !isInProgress,
                labelText: AppStrings.profileEditEmailLabel,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: AuthValidators.email,
              ),
              const SizedBox(height: 12),
              AuthTextField(
                controller: _nameController,
                enabled: !isInProgress,
                labelText: AppStrings.profileEditNameLabel,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: AuthValidators.name,
              ),
              const SizedBox(height: 36),
              MainButton(
                state: isInProgress ? ButtonState.loading : ButtonState.enabled,
                onPressed: _submit,
                child: const Text(AppStrings.profileSaveButton),
              ),
              const SizedBox(height: 8),
              SecondaryButton(
                state: isInProgress ? ButtonState.disabled : ButtonState.enabled,
                onPressed: () => context.pop(),
                child: const Text(AppStrings.profileCancelButton),
              ),
            ],
          ),
        );
      },
    );
  }
}

final class _AvatarPreview extends StatelessWidget {
  final String? imageUrl;
  final String? localAvatarPath;

  const _AvatarPreview({
    required this.imageUrl,
    required this.localAvatarPath,
  });

  @override
  Widget build(BuildContext context) {
    final localAvatarPath = this.localAvatarPath;
    if (localAvatarPath != null && localAvatarPath.isNotEmpty) {
      return Image.file(
        File(localAvatarPath),
        height: 296,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return NetworkImageWidget(
      imageUrl: imageUrl ?? '',
      height: 296,
    );
  }
}

final class _AvatarPickButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _AvatarPickButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return Semantics(
      button: true,
      label: AppStrings.profileUploadFileLabel,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: onPressed == null ? colorTheme.disabled : colorTheme.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '+',
                textAlign: TextAlign.center,
                style: textTheme.button.copyWith(color: colorTheme.onPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
