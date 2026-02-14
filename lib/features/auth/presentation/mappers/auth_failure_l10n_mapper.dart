import 'package:flutter/widgets.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/localization/generated/app_localizations.g.dart';

/// Extension to provide localized messages for [AuthFailure]s.
extension AuthFailureL10n on AuthFailure {
  /// Returns a localized message for the given [AuthFailure].
  String? toMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return switch (this) {
      UnknownAuthFailure() => l10n.auth_error_unknown,
    };
  }
}
