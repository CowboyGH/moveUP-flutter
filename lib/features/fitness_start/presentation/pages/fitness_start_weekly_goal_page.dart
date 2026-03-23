import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../../phases/presentation/cubits/weekly_goal_cubit.dart';
import '../widgets/fitness_start_flow_app_bar.dart';

/// Final guest onboarding page for editing weekly training goal.
class FitnessStartWeeklyGoalPage extends StatefulWidget {
  /// Creates an instance of [FitnessStartWeeklyGoalPage].
  const FitnessStartWeeklyGoalPage({super.key});

  @override
  State<FitnessStartWeeklyGoalPage> createState() => _FitnessStartWeeklyGoalPageState();
}

class _FitnessStartWeeklyGoalPageState extends State<FitnessStartWeeklyGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _weeklyGoalController = TextEditingController();

  @override
  void dispose() {
    _weeklyGoalController.dispose();
    super.dispose();
  }

  String? _validateWeeklyGoal(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) return AppStrings.fitnessStartWeeklyGoalRequired;

    final weeklyGoal = int.tryParse(trimmedValue);
    if (weeklyGoal == null) return AppStrings.fitnessStartWeeklyGoalInvalid;
    if (weeklyGoal < 1 || weeklyGoal > 7) return AppStrings.fitnessStartWeeklyGoalRange;

    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final trimmedValue = _weeklyGoalController.text.trim();
    // empty input means the user keeps the recommended default goal (4),
    // so we skip a redundant update request and finish onboarding immediately.
    if (trimmedValue.isEmpty) {
      await context.read<AuthSessionCubit>().completeGuestFitnessStart();
      return;
    }

    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    await context.read<WeeklyGoalCubit>().updateWeeklyGoal(int.parse(trimmedValue));
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    return BlocConsumer<WeeklyGoalCubit, WeeklyGoalState>(
      listener: (context, state) {
        state.whenOrNull(
          succeed: () {
            unawaited(context.read<AuthSessionCubit>().completeGuestFitnessStart());
          },
          failed: (failure) {
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
        return Scaffold(
          appBar: FitnessStartFlowAppBar(
            progress: 1.0,
            showBackButton: true,
            onBackPressed: () => unawaited(context.read<AuthSessionCubit>().cancelGuestFlow()),
          ),
          body: Stack(
            children: [
              Positioned(
                left: -140,
                top: 10,
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: Transform.rotate(
                      angle: -200 * (math.pi / 180),
                      child: Transform.scale(
                        scaleY: -1,
                        child: SvgPictureWidget.frame(
                          AppAssets.imageFigure,
                          color: colorTheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -85,
                bottom: -110,
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: SvgPictureWidget.frame(
                      AppAssets.imageFigure,
                      color: colorTheme.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 64),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: _buildContent(context, isInProgress),
                        ),
                      ),
                      const SizedBox(height: 24),
                      MainButton(
                        state: isInProgress ? ButtonState.loading : ButtonState.enabled,
                        onPressed: _submit,
                        child: const Text(AppStrings.fitnessStartWeeklyGoalButton),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, bool isInProgress) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.fitnessStartWeeklyGoalHeading,
          textAlign: TextAlign.center,
          style: textTheme.title.copyWith(
            fontSize: 20,
            height: 24 / 20,
            color: colorTheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppStrings.fitnessStartWeeklyGoalSubtitle,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: colorTheme.hint,
          ),
        ),
        const SizedBox(height: 64),
        Text(
          AppStrings.fitnessStartWeeklyGoalPrompt,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.fitnessStartWeeklyGoalDescription,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _weeklyGoalController,
          enabled: !isInProgress,
          keyboardType: TextInputType.number,
          validator: _validateWeeklyGoal,
          textInputAction: TextInputAction.done,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: textTheme.body.copyWith(color: colorTheme.onSurface),
          decoration: const InputDecoration(
            hintText: AppStrings.fitnessStartWeeklyGoalHint,
          ),
        ),
      ],
    );
  }
}
