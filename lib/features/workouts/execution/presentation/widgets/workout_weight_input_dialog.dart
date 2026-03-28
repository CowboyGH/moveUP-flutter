import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/buttons/secondary_button.dart';
import '../../../../../uikit/dialogs/app_action_dialog.dart';
import '../../../../../uikit/inputs/app_input_field.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';

/// Dialog content that allows the user to optionally enter used exercise weight.
class WorkoutWeightInputDialog extends StatefulWidget {
  /// Initial weight value suggested by backend, if any.
  final double? initialWeight;

  /// Creates an instance of [WorkoutWeightInputDialog].
  const WorkoutWeightInputDialog({super.key, required this.initialWeight});

  @override
  State<WorkoutWeightInputDialog> createState() => _WorkoutWeightInputDialogState();
}

class _WorkoutWeightInputDialogState extends State<WorkoutWeightInputDialog> {
  late final TextEditingController _controller;
  String? _validationMessage;

  String _formatWorkoutWeight(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  double? _parseWorkoutWeight(String rawValue) {
    final normalizedValue = rawValue.trim().replaceAll(',', '.');
    if (normalizedValue.isEmpty) return null;

    final parsedValue = double.tryParse(normalizedValue);
    if (parsedValue == null || parsedValue <= 0) {
      return null;
    }
    return parsedValue;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialWeight == null ? '' : _formatWorkoutWeight(widget.initialWeight!),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final parsedWeight = _parseWorkoutWeight(_controller.text);
    if (parsedWeight == null) {
      setState(() => _validationMessage = AppStrings.workoutExecutionWeightInvalid);
      return;
    }
    Navigator.of(context).pop(parsedWeight);
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return AppActionDialog(
      title: AppStrings.workoutExecutionWeightTitle,
      description: AppStrings.workoutExecutionWeightDescription,
      primaryAction: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInputField(
            controller: _controller,
            labelText: AppStrings.workoutExecutionWeightLabel,
            hintText: AppStrings.workoutExecutionWeightHint,
            enabled: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
          ),
          if (_validationMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _validationMessage!,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall.copyWith(color: colorTheme.error),
            ),
          ],
          const SizedBox(height: 24),
          MainButton(
            onPressed: _submit,
            child: const Text(AppStrings.workoutExecutionWeightPrimary),
          ),
        ],
      ),
      secondaryAction: SecondaryButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(AppStrings.workoutExecutionWeightSecondary),
      ),
    );
  }
}
