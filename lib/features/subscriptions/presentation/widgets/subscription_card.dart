import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/cards/app_card.dart';
import '../../../../uikit/images/network_image_widget.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/subscription_catalog_item.dart';

/// Visual card for a single subscriptions catalog item.
class SubscriptionCard extends StatelessWidget {
  /// Catalog item displayed by this card.
  final SubscriptionCatalogItem item;

  /// Creates an instance of [SubscriptionCard].
  const SubscriptionCard({
    required this.item,
    super.key,
  });

  static const double _cardHeight = 276;

  static int _monthsFromDuration(int durationDays) {
    final months = durationDays ~/ 30;
    return months < 1 ? 1 : months;
  }

  static String _monthsLabel(int value) {
    final mod100 = value % 100;
    if (mod100 >= 11 && mod100 <= 14) {
      return 'месяцев';
    }

    return switch (value % 10) {
      1 => 'месяц',
      2 || 3 || 4 => 'месяца',
      _ => 'месяцев',
    };
  }

  static String _formatPrice(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    final parsed = num.tryParse(normalized);
    if (parsed == null) return value;
    if (parsed == parsed.roundToDouble()) return parsed.toInt().toString();
    return parsed.toString().replaceAll('.', ',');
  }

  static const List<String> _benefits = [
    AppStrings.subscriptionsCatalogBenefitTests,
    AppStrings.subscriptionsCatalogBenefitExercises,
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final months = _monthsFromDuration(item.durationDays);

    return SizedBox(
      height: 306,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: AppCard(
              height: _cardHeight,
              contentPadding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${_formatPrice(item.price)} рублей',
                    style: textTheme.bodyMedium.copyWith(
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
                      color: colorTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _benefits
                        .map(
                          (benefit) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '•',
                                  style: textTheme.body.copyWith(
                                    color: colorTheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    benefit,
                                    style: textTheme.body.copyWith(
                                      color: colorTheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 0,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$months',
                    style: textTheme.bodyMedium.copyWith(
                      fontSize: 96,
                      height: 0.85,
                      fontWeight: FontWeight.w100,
                      color: colorTheme.darkHint,
                    ),
                  ),
                  TextSpan(
                    text: ' ${_monthsLabel(months)}',
                    style: textTheme.bodyMedium.copyWith(
                      fontSize: 20,
                      height: 30 / 20,
                      fontWeight: FontWeight.w300,
                      color: colorTheme.darkHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: NetworkImageWidget(
              imageUrl: item.imageUrl,
              height: 230,
            ),
          ),
        ],
      ),
    );
  }
}
