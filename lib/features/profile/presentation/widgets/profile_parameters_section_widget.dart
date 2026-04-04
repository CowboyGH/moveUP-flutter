import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../uikit/buttons/button_size.dart';
import '../../../../../uikit/buttons/button_state.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/buttons/option_button.dart';
import '../../../../../uikit/cards/app_card.dart';
import '../../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../../uikit/menus/app_selection_dropdown.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../fitness_start/presentation/validators/fitness_start_validators.dart';
import '../../../workouts/overview/presentation/cubits/workouts_overview_cubit.dart';
import '../../domain/entities/profile_parameters/profile_parameters_data.dart';
import '../../domain/entities/profile_parameters/profile_parameters_gender.dart';
import '../../domain/entities/profile_parameters/profile_parameters_option.dart';
import '../../domain/entities/profile_parameters/profile_parameters_references.dart';
import '../../domain/entities/profile_parameters/profile_parameters_submit_payload.dart';
import '../cubits/profile_parameters_cubit.dart';
import '../cubits/profile_statistics_cubit.dart';
import '../cubits/profile_user_cubit.dart';

enum _ProfileParametersDropdown {
  goal,
  level,
}

/// Editable card with the authenticated profile parameters form.
class ProfileParametersSectionWidget extends StatefulWidget {
  /// Creates an instance of [ProfileParametersSectionWidget].
  const ProfileParametersSectionWidget({super.key});

  @override
  State<ProfileParametersSectionWidget> createState() => _ProfileParametersSectionWidgetState();
}

class _ProfileParametersSectionWidgetState extends State<ProfileParametersSectionWidget> {
  final _formKey = GlobalKey<FormState>();
  final _goalLayerLink = LayerLink();
  final _levelLayerLink = LayerLink();
  final _dropdownTapRegionGroupId = Object();
  final _dropdownOverlayController = OverlayPortalController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _weeklyGoalController = TextEditingController();

  _ProfileParametersDropdown? _openDropdown;
  int? _lastSyncedGoalId;
  int? _lastSyncedLevelId;
  int? _lastSyncedEquipmentId;
  ProfileParametersGender? _lastSyncedGender;
  int? _lastSyncedAge;
  double? _lastSyncedWeight;
  int? _lastSyncedHeight;
  int? _lastSyncedWeeklyGoal;

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _weeklyGoalController.dispose();
    super.dispose();
  }

  void _toggleDropdown(_ProfileParametersDropdown dropdown) {
    setState(() {
      _openDropdown = _openDropdown == dropdown ? null : dropdown;
    });
    if (_openDropdown == null) {
      _dropdownOverlayController.hide();
      return;
    }
    _dropdownOverlayController.show();
  }

  void _closeDropdown() {
    if (_openDropdown == null) return;
    setState(() => _openDropdown = null);
    _dropdownOverlayController.hide();
  }

  void _syncForm(ProfileParametersState state, int weeklyGoal) {
    final currentParameters = state.currentParameters;
    if (currentParameters != null) {
      if (_lastSyncedGoalId != currentParameters.goalId) {
        _lastSyncedGoalId = currentParameters.goalId;
      }
      if (_lastSyncedLevelId != currentParameters.levelId) {
        _lastSyncedLevelId = currentParameters.levelId;
      }
      if (_lastSyncedEquipmentId != currentParameters.equipmentId) {
        _lastSyncedEquipmentId = currentParameters.equipmentId;
      }
      if (_lastSyncedGender != currentParameters.gender) {
        _lastSyncedGender = currentParameters.gender;
      }
      if (_lastSyncedAge != currentParameters.age) {
        _ageController.text = '${currentParameters.age}';
        _lastSyncedAge = currentParameters.age;
      }
      if (_lastSyncedWeight != currentParameters.weight) {
        _weightController.text = _formatWeight(currentParameters.weight);
        _lastSyncedWeight = currentParameters.weight;
      }
      if (_lastSyncedHeight != currentParameters.height) {
        _heightController.text = '${currentParameters.height}';
        _lastSyncedHeight = currentParameters.height;
      }
    }

    if (_lastSyncedWeeklyGoal != weeklyGoal) {
      _weeklyGoalController.text = '$weeklyGoal';
      _lastSyncedWeeklyGoal = weeklyGoal;
    }
  }

  Future<void> _submit(
    ProfileParametersState state, {
    required int currentWeeklyGoal,
  }) async {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final selectedGoalId = state.selectedGoalId ?? state.currentParameters?.goalId;
    if (selectedGoalId == null) {
      await _showFeedback(AppStrings.fitnessStartGoalRequired);
      return;
    }

    final selectedGender = state.selectedGender ?? state.currentParameters?.gender;
    if (selectedGender == null) {
      await _showFeedback(AppStrings.fitnessStartGenderRequired);
      return;
    }

    final selectedEquipmentId = state.selectedEquipmentId ?? state.currentParameters?.equipmentId;
    if (selectedEquipmentId == null) {
      await _showFeedback(AppStrings.fitnessStartEquipmentRequired);
      return;
    }

    final selectedLevelId = state.selectedLevelId ?? state.currentParameters?.levelId;
    if (selectedLevelId == null) {
      await _showFeedback(AppStrings.fitnessStartLevelRequired);
      return;
    }

    final age = int.tryParse(_ageController.text.trim());
    if (age == null) {
      await _showFeedback(AppStrings.fitnessStartAgeInvalid);
      return;
    }

    final weight = double.tryParse(_weightController.text.trim().replaceAll(',', '.'));
    if (weight == null) {
      await _showFeedback(AppStrings.fitnessStartWeightInvalid);
      return;
    }

    final height = int.tryParse(_heightController.text.trim());
    if (height == null) {
      await _showFeedback(AppStrings.fitnessStartHeightInvalid);
      return;
    }

    final weeklyGoal = int.tryParse(_weeklyGoalController.text.trim());
    if (weeklyGoal == null) {
      await _showFeedback(AppStrings.profileParametersWeeklyGoalInvalid);
      return;
    }

    await context.read<ProfileParametersCubit>().submit(
      payload: ProfileParametersSubmitPayload(
        goalId: selectedGoalId,
        gender: selectedGender,
        age: age,
        weight: weight,
        height: height,
        equipmentId: selectedEquipmentId,
        levelId: selectedLevelId,
        weeklyGoal: weeklyGoal,
      ),
      currentWeeklyGoal: currentWeeklyGoal,
    );
  }

  Future<void> _showFeedback(String message) {
    return showAppFeedbackDialog(
      context,
      title: AppStrings.feedbackErrorTitle,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWeeklyGoal = context.select<ProfileStatisticsCubit, int?>(
      (cubit) => cubit.state.currentPhaseSummary?.weeklyGoal,
    );
    final isLoadingWeeklyGoal = context.select<ProfileStatisticsCubit, bool>(
      (cubit) => cubit.state.isLoadingCurrentPhaseSummary,
    );
    final currentWeeklyGoalFailure = context.select<ProfileStatisticsCubit, bool>(
      (cubit) =>
          cubit.state.currentPhaseSummary == null && cubit.state.currentPhaseSummaryFailure != null,
    );

    return BlocConsumer<ProfileParametersCubit, ProfileParametersState>(
      listenWhen: (previous, current) =>
          (previous.failure != current.failure &&
              current.failure != null &&
              current.currentParameters != null &&
              current.references != null) ||
          (previous.isSubmitting && !current.isSubmitting && current.failure == null),
      listener: (context, state) {
        if (state.failure != null) {
          _showFeedback(state.failure!.message);
          context.read<ProfileParametersCubit>().clearFailure();
          return;
        }

        if (!state.isSubmitting) {
          _closeDropdown();
          if (state.shouldReloadWorkouts) {
            unawaited(context.read<WorkoutsOverviewCubit>().loadWorkouts());
            context.read<ProfileParametersCubit>().consumeWorkoutsReloadRequest();
          }
          unawaited(context.read<ProfileStatisticsCubit>().reloadCurrentPhaseSummary());
          unawaited(context.read<ProfileUserCubit>().refresh());
        }
      },
      builder: (context, state) {
        final references = state.references;
        final currentParameters = state.currentParameters;
        final isLoadingCard =
            (state.isLoading && (references == null || currentParameters == null)) ||
            (isLoadingWeeklyGoal && currentWeeklyGoal == null);
        final hasLoadFailure =
            references == null ||
            currentParameters == null ||
            currentWeeklyGoal == null ||
            currentWeeklyGoalFailure;

        if (isLoadingCard) {
          return const AppCard(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: _ProfileParametersLoadingState(),
          );
        }

        if (hasLoadFailure) {
          return AppCard(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: _ProfileParametersErrorState(
              onRetryPressed: () {
                _closeDropdown();
                context.read<ProfileParametersCubit>().reload();
                context.read<ProfileStatisticsCubit>().reloadCurrentPhaseSummary();
              },
            ),
          );
        }

        _syncForm(state, currentWeeklyGoal);

        return OverlayPortal(
          controller: _dropdownOverlayController,
          overlayChildBuilder: (context) => Stack(
            clipBehavior: Clip.none,
            children: [
              if (_openDropdown == _ProfileParametersDropdown.goal)
                _DropdownFollower<int>(
                  link: _goalLayerLink,
                  groupId: _dropdownTapRegionGroupId,
                  onTapOutside: _closeDropdown,
                  child: AppSelectionDropdown<int>(
                    mode: AppSelectionDropdownMode.single,
                    constraints: const BoxConstraints(
                      maxHeight: 220,
                      minWidth: 240,
                      maxWidth: 280,
                    ),
                    items: references.goals
                        .map(
                          (option) => AppSelectionDropdownItem<int>(
                            value: option.id,
                            label: option.name,
                          ),
                        )
                        .toList(growable: false),
                    selectedValues: {
                      state.selectedGoalId ?? currentParameters.goalId,
                    },
                    onChanged: (selectedValues) {
                      if (selectedValues.isEmpty) return;
                      context.read<ProfileParametersCubit>().selectGoal(selectedValues.first);
                      _closeDropdown();
                    },
                  ),
                ),
              if (_openDropdown == _ProfileParametersDropdown.level)
                _DropdownFollower<int>(
                  link: _levelLayerLink,
                  groupId: _dropdownTapRegionGroupId,
                  onTapOutside: _closeDropdown,
                  child: AppSelectionDropdown<int>(
                    mode: AppSelectionDropdownMode.single,
                    constraints: const BoxConstraints(
                      maxHeight: 220,
                      minWidth: 240,
                      maxWidth: 280,
                    ),
                    items: references.levels
                        .map(
                          (option) => AppSelectionDropdownItem<int>(
                            value: option.id,
                            label: option.name,
                          ),
                        )
                        .toList(growable: false),
                    selectedValues: {
                      state.selectedLevelId ?? currentParameters.levelId,
                    },
                    onChanged: (selectedValues) {
                      if (selectedValues.isEmpty) return;
                      context.read<ProfileParametersCubit>().selectLevel(selectedValues.first);
                      _closeDropdown();
                    },
                  ),
                ),
            ],
          ),
          child: TapRegion(
            groupId: _dropdownTapRegionGroupId,
            onTapOutside: (_) => _closeDropdown(),
            child: AppCard(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CompositedTransformTarget(
                      link: _goalLayerLink,
                      child: _SelectField(
                        label: AppStrings.profileParametersGoalLabel,
                        value: _selectedLabel(
                          references.goals,
                          state.selectedGoalId ?? currentParameters.goalId,
                        ),
                        onPressed: state.isSubmitting
                            ? null
                            : () => _toggleDropdown(_ProfileParametersDropdown.goal),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SegmentedOptionsField<ProfileParametersGender>(
                      label: AppStrings.fitnessStartGenderLabel,
                      firstValue: ProfileParametersGender.male,
                      firstLabel: AppStrings.fitnessStartMaleOption,
                      secondValue: ProfileParametersGender.female,
                      secondLabel: AppStrings.fitnessStartFemaleOption,
                      selectedValue: state.selectedGender ?? currentParameters.gender,
                      onSelected: state.isSubmitting
                          ? null
                          : (value) => context.read<ProfileParametersCubit>().selectGender(value),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _LabeledTextField(
                            controller: _ageController,
                            label: AppStrings.fitnessStartAgeLabel,
                            enabled: !state.isSubmitting,
                            validator: FitnessStartValidators.age,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LabeledTextField(
                            controller: _weightController,
                            label: AppStrings.fitnessStartWeightLabel,
                            enabled: !state.isSubmitting,
                            validator: FitnessStartValidators.weight,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LabeledTextField(
                            controller: _heightController,
                            label: AppStrings.fitnessStartHeightLabel,
                            enabled: !state.isSubmitting,
                            validator: FitnessStartValidators.height,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildEquipmentField(
                      context,
                      state: state,
                      references: references,
                      currentParameters: currentParameters,
                    ),
                    const SizedBox(height: 12),
                    CompositedTransformTarget(
                      link: _levelLayerLink,
                      child: _SelectField(
                        label: AppStrings.profileParametersLevelLabel,
                        value: _selectedLabel(
                          references.levels,
                          state.selectedLevelId ?? currentParameters.levelId,
                        ),
                        onPressed: state.isSubmitting
                            ? null
                            : () => _toggleDropdown(_ProfileParametersDropdown.level),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _LabeledTextField(
                      controller: _weeklyGoalController,
                      label: AppStrings.profileParametersWeeklyGoalLabel,
                      enabled: !state.isSubmitting,
                      validator: _weeklyGoalValidator,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 24),
                    MainButton(
                      state: state.isSubmitting ? ButtonState.loading : ButtonState.enabled,
                      onPressed: () => _submit(
                        state,
                        currentWeeklyGoal: currentWeeklyGoal,
                      ),
                      child: const Text(AppStrings.profileParametersSubmitButton),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildEquipmentField(
  BuildContext context, {
  required ProfileParametersState state,
  required ProfileParametersReferences references,
  required ProfileParametersData currentParameters,
}) {
  final options = references.equipment;
  if (options.isEmpty) {
    return const _SelectField(
      label: AppStrings.fitnessStartEquipmentLabel,
      value: AppStrings.profileParametersEquipmentUnavailable,
      onPressed: null,
    );
  }

  if (options.length == 1) {
    return _SelectField(
      label: AppStrings.fitnessStartEquipmentLabel,
      value: options.first.name,
      onPressed: null,
    );
  }

  final selectedEquipmentId = state.selectedEquipmentId ?? currentParameters.equipmentId;
  final firstOption = options.first;
  final secondOption = options[1];

  return _SegmentedOptionsField<int>(
    label: AppStrings.fitnessStartEquipmentLabel,
    firstValue: firstOption.id,
    firstLabel: firstOption.name,
    secondValue: secondOption.id,
    secondLabel: secondOption.name,
    selectedValue: selectedEquipmentId,
    onSelected: state.isSubmitting
        ? null
        : (value) => context.read<ProfileParametersCubit>().selectEquipment(value),
  );
}

final class _DropdownFollower<T extends Object> extends StatelessWidget {
  final LayerLink link;
  final Object groupId;
  final VoidCallback onTapOutside;
  final Widget child;

  const _DropdownFollower({
    required this.link,
    required this.groupId,
    required this.onTapOutside,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      link: link,
      showWhenUnlinked: false,
      targetAnchor: Alignment.bottomLeft,
      offset: const Offset(0, 8),
      child: TapRegion(
        groupId: groupId,
        onTapOutside: (_) => onTapOutside(),
        child: child,
      ),
    );
  }
}

final class _ProfileParametersLoadingState extends StatelessWidget {
  const _ProfileParametersLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator.adaptive(strokeWidth: 2),
      ),
    );
  }
}

final class _ProfileParametersErrorState extends StatelessWidget {
  final VoidCallback onRetryPressed;

  const _ProfileParametersErrorState({
    required this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.profileParametersLoadFailed,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
        ),
        const SizedBox(height: 16),
        MainButton(
          onPressed: onRetryPressed,
          child: const Text(AppStrings.retryButton),
        ),
      ],
    );
  }
}

final class _SelectField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onPressed;

  const _SelectField({
    required this.label,
    required this.value,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final isEnabled = onPressed != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.label.copyWith(color: colorTheme.hint),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsetsGeometry.only(right: 13),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isEnabled ? colorTheme.outline : colorTheme.disabled,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: textTheme.body.copyWith(
                          color: colorTheme.hint,
                        ),
                      ),
                    ),
                    const SvgPictureWidget.icon(AppAssets.iconArrowDown),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final class _SegmentedOptionsField<T extends Object> extends StatelessWidget {
  final String label;
  final T firstValue;
  final String firstLabel;
  final T secondValue;
  final String secondLabel;
  final T selectedValue;
  final ValueChanged<T>? onSelected;

  const _SegmentedOptionsField({
    required this.label,
    required this.firstValue,
    required this.firstLabel,
    required this.secondValue,
    required this.secondLabel,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final buttonState = onSelected == null ? ButtonState.disabled : ButtonState.enabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.label.copyWith(color: colorTheme.hint),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: OptionButton(
                size: ButtonSize.small,
                state: buttonState,
                isSelected: selectedValue == firstValue,
                onPressed: () => onSelected?.call(firstValue),
                child: Text(firstLabel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OptionButton(
                size: ButtonSize.small,
                state: buttonState,
                isSelected: selectedValue == secondValue,
                onPressed: () => onSelected?.call(secondValue),
                child: Text(secondLabel),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final class _LabeledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool enabled;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;

  const _LabeledTextField({
    required this.controller,
    required this.label,
    required this.enabled,
    required this.validator,
    required this.keyboardType,
    this.textAlign = TextAlign.center,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: colorTheme.disabled.withValues(alpha: 0.6)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.label.copyWith(color: colorTheme.hint),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          enabled: enabled,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textAlign: textAlign,
          style: textTheme.body.copyWith(color: colorTheme.onSurface),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(12),
            border: border,
            enabledBorder: border,
            disabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: colorTheme.disabled),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: colorTheme.primary.withValues(alpha: 0.8)),
            ),
          ),
        ),
      ],
    );
  }
}

String _selectedLabel(List<ProfileParametersOption> options, int selectedId) {
  for (final option in options) {
    if (option.id == selectedId) return option.name;
  }
  return options.first.name;
}

String _formatWeight(double weight) {
  if (weight == weight.roundToDouble()) {
    return '${weight.toInt()}';
  }
  return weight.toString().replaceAll('.', ',');
}

String? _weeklyGoalValidator(String? value) {
  final trimmedValue = value?.trim() ?? '';
  if (trimmedValue.isEmpty) {
    return AppStrings.profileParametersWeeklyGoalRequired;
  }

  final parsedValue = int.tryParse(trimmedValue);
  if (parsedValue == null) {
    return AppStrings.profileParametersWeeklyGoalInvalid;
  }
  if (parsedValue < 1 || parsedValue > 7) {
    return AppStrings.profileParametersWeeklyGoalRange;
  }

  return null;
}
