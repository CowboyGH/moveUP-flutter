import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/buttons/secondary_button.dart';
import '../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../../../profile/presentation/widgets/profile_dialog_shell.dart';
import '../../domain/entities/subscription_catalog_item.dart';
import '../../domain/entities/subscription_payment_payload.dart';
import '../cubits/subscription_payment_cubit.dart';
import '../validators/subscription_payment_validators.dart';
import 'subscription_card.dart';
import 'subscription_payment_text_field.dart';

/// Opens the subscription payment dialog.
Future<bool?> showSubscriptionPaymentDialog(
  BuildContext context, {
  required SubscriptionCatalogItem item,
  required SubscriptionPaymentCubit paymentCubit,
}) {
  return showProfileDialog<bool>(
    context,
    insetPadding: const EdgeInsets.symmetric(horizontal: 24),
    contentPadding: EdgeInsets.zero,
    child: BlocProvider.value(
      value: paymentCubit,
      child: SubscriptionPaymentDialog(item: item),
    ),
  );
}

/// Dialog with manual card form for paying for a subscription.
class SubscriptionPaymentDialog extends StatefulWidget {
  /// Subscription currently being purchased.
  final SubscriptionCatalogItem item;

  /// Creates an instance of [SubscriptionPaymentDialog].
  const SubscriptionPaymentDialog({
    required this.item,
    super.key,
  });

  @override
  State<SubscriptionPaymentDialog> createState() => _SubscriptionPaymentDialogState();
}

class _SubscriptionPaymentDialogState extends State<SubscriptionPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _previewCardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _rememberData = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_syncPreviewCardNumber);
    _cardNumberController.addListener(_handlePreviewChanged);
    _cardHolderController.addListener(_handlePreviewChanged);
    _expiryMonthController.addListener(_handlePreviewChanged);
    _expiryYearController.addListener(_handlePreviewChanged);
  }

  @override
  void dispose() {
    _cardNumberController
      ..removeListener(_syncPreviewCardNumber)
      ..removeListener(_handlePreviewChanged)
      ..dispose();
    _cardHolderController.removeListener(_handlePreviewChanged);
    _previewCardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryMonthController.removeListener(_handlePreviewChanged);
    _expiryMonthController.dispose();
    _expiryYearController.removeListener(_handlePreviewChanged);
    _expiryYearController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _handlePreviewChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _syncPreviewCardNumber() {
    final digits = _cardNumberController.text.replaceAll(RegExp(r'\D'), '');
    final chunks = <String>[];
    for (var index = 0; index < digits.length; index += 4) {
      final end = (index + 4).clamp(0, digits.length);
      chunks.add(digits.substring(index, end));
    }
    _previewCardNumberController.text = chunks.join(' ');
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    context.read<SubscriptionPaymentCubit>().pay(
      payload: SubscriptionPaymentPayload(
        subscriptionId: widget.item.id,
        saveCard: _rememberData,
        cardNumber: _cardNumberController.text.replaceAll(RegExp(r'\D'), ''),
        cardHolder: _cardHolderController.text.trim(),
        expiryMonth: _expiryMonthController.text.trim(),
        expiryYear: _expiryYearController.text.trim(),
        cvv: _cvvController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionPaymentCubit, SubscriptionPaymentState>(
      listener: (context, state) {
        state.whenOrNull(
          succeed: () => Navigator.of(context).pop(true),
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
        final colorTheme = AppColorTheme.of(context);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 83, 28, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SubscriptionPaymentTextField(
                      controller: _cardNumberController,
                      labelText: AppStrings.subscriptionsPaymentCardNumberLabel,
                      labelColor: colorTheme.hint,
                      hintText: AppStrings.subscriptionsPaymentCardNumberHint,
                      enabled: !isInProgress,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [const _CardNumberTextInputFormatter()],
                      validator: SubscriptionPaymentValidators.cardNumber,
                    ),
                    const SizedBox(height: 12),
                    SubscriptionPaymentTextField(
                      controller: _cardHolderController,
                      labelText: AppStrings.subscriptionsPaymentCardHolderLabel,
                      labelColor: colorTheme.hint,
                      hintText: AppStrings.subscriptionsPaymentCardHolderHint,
                      enabled: !isInProgress,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: SubscriptionPaymentValidators.cardHolder,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExcludeSemantics(
                                child: Text(
                                  AppStrings.subscriptionsPaymentExpiryLabel,
                                  style: AppTextTheme.of(context).label.copyWith(
                                    color: colorTheme.hint,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: SubscriptionPaymentTextField(
                                      controller: _expiryMonthController,
                                      labelText: AppStrings.subscriptionsPaymentExpiryLabel,
                                      semanticsLabel: AppStrings.subscriptionsPaymentExpiryLabel,
                                      hintText: AppStrings.subscriptionsPaymentExpiryMonthHint,
                                      showErrorText: false,
                                      enabled: !isInProgress,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      showLabel: false,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                      validator: (value) =>
                                          SubscriptionPaymentValidators.expiryMonth(
                                            value,
                                            yearValue: _expiryYearController.text,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SubscriptionPaymentTextField(
                                      controller: _expiryYearController,
                                      labelText: AppStrings.subscriptionsPaymentYearLabel,
                                      semanticsLabel: AppStrings.subscriptionsPaymentYearLabel,
                                      hintText: AppStrings.subscriptionsPaymentExpiryYearHint,
                                      showErrorText: false,
                                      enabled: !isInProgress,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      showLabel: false,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      validator: (value) =>
                                          SubscriptionPaymentValidators.expiryYear(
                                            value,
                                            monthValue: _expiryMonthController.text,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SubscriptionPaymentTextField(
                            controller: _cvvController,
                            labelText: AppStrings.subscriptionsPaymentCvvLabel,
                            labelColor: colorTheme.hint,
                            hintText: AppStrings.subscriptionsPaymentCvvHint,
                            showErrorText: false,
                            enabled: !isInProgress,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: SubscriptionPaymentValidators.cvv,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _RememberDataRow(
                      value: _rememberData,
                      enabled: !isInProgress,
                      onChanged: () => setState(() => _rememberData = !_rememberData),
                    ),
                    const SizedBox(height: 36),
                    MainButton(
                      state: isInProgress ? ButtonState.loading : ButtonState.enabled,
                      onPressed: _submit,
                      child: Text(
                        '${AppStrings.subscriptionsPaymentPayButton} '
                        '${SubscriptionCard.formatPrice(widget.item.price)}₽',
                      ),
                    ),
                    const SizedBox(height: 8),
                    SecondaryButton(
                      state: isInProgress ? ButtonState.disabled : ButtonState.enabled,
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(AppStrings.profileCancelButton),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -100,
              left: 0,
              right: 0,
              child: _PaymentPreviewCard(
                previewCardNumber: _previewCardNumberController.text,
                cardHolder: _cardHolderController.text,
                expiryMonth: _expiryMonthController.text.trim(),
                expiryYear: _expiryYearController.text.trim(),
              ),
            ),
          ],
        );
      },
    );
  }
}

final class _PaymentPreviewCard extends StatelessWidget {
  final String previewCardNumber;
  final String cardHolder;
  final String expiryMonth;
  final String expiryYear;

  const _PaymentPreviewCard({
    required this.previewCardNumber,
    required this.cardHolder,
    required this.expiryMonth,
    required this.expiryYear,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);

    return SizedBox(
      child: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: SvgPictureWidget.icon(AppAssets.iconCardBig),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 52, 24, 12),
            child: Column(
              children: [
                SizedBox(
                  width: 224,
                  child: _PaymentPreviewNumberField(
                    value: previewCardNumber,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.subscriptionsPaymentCardHolderLabel,
                              style: textTheme.label.copyWith(color: colorTheme.onPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cardHolder.isEmpty
                                  ? AppStrings.subscriptionsPaymentCardHolderHint
                                  : cardHolder,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.label.copyWith(color: colorTheme.onPrimary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppStrings.subscriptionsPaymentPreviewExpiryLabel,
                            style: textTheme.label.copyWith(color: colorTheme.onPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            [expiryMonth, expiryYear]
                                .where((value) => value.isNotEmpty)
                                .join('/')
                                .ifEmpty(
                                  '${AppStrings.subscriptionsPaymentPreviewExpiryMonthLabel}/'
                                  '${AppStrings.subscriptionsPaymentPreviewExpiryYearLabel}',
                                ),
                            style: textTheme.label.copyWith(color: colorTheme.onPrimary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _PaymentPreviewNumberField extends StatelessWidget {
  final String value;

  const _PaymentPreviewNumberField({
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final displayText = value.isEmpty ? AppStrings.subscriptionsPaymentCardNumberHint : value;
    final textColor = value.isEmpty ? colorTheme.outline : colorTheme.onSurface;

    return Semantics(
      label: AppStrings.subscriptionsPaymentCardNumberLabel,
      textField: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorTheme.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            displayText,
            style: textTheme.body.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

final class _RememberDataRow extends StatelessWidget {
  final bool value;
  final bool enabled;
  final VoidCallback onChanged;

  const _RememberDataRow({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return Row(
      children: [
        Semantics(
          label: AppStrings.subscriptionsPaymentRememberData,
          checked: value,
          enabled: enabled,
          onTap: enabled ? onChanged : null,
          child: InkWell(
            onTap: enabled ? onChanged : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: value ? colorTheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: value ? colorTheme.primary : colorTheme.darkHint,
                ),
              ),
              child: value
                  ? Icon(
                      Icons.check_rounded,
                      size: 12,
                      color: colorTheme.onPrimary,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          AppStrings.subscriptionsPaymentRememberData,
          style: textTheme.bodySmall.copyWith(
            fontSize: 10,
            height: 15 / 10,
            fontWeight: FontWeight.w400,
            color: colorTheme.onSurface,
          ),
        ),
      ],
    );
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}

String _formatCardNumber(String value) {
  final digits = value.replaceAll(RegExp(r'\D'), '');
  final limitedDigits = digits.length > 16 ? digits.substring(0, 16) : digits;
  final chunks = <String>[];

  for (var index = 0; index < limitedDigits.length; index += 4) {
    final end = (index + 4).clamp(0, limitedDigits.length);
    chunks.add(limitedDigits.substring(index, end));
  }

  return chunks.join(' ');
}

final class _CardNumberTextInputFormatter extends TextInputFormatter {
  const _CardNumberTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = _formatCardNumber(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
