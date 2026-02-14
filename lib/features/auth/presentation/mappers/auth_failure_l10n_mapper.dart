import 'package:flutter/widgets.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/localization/generated/app_localizations.g.dart';

/// Extension to provide localized messages for [AuthFailure]s.
extension AuthFailureL10n on AuthFailure {
  /// Returns a localized message for the given [AuthFailure].
  String? toMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return switch (this) {
      InvalidCredentialFailure() => l10n.auth_error_invalidCredential,
      WeakPasswordFailure() => l10n.auth_error_weakPassword,
      WrongPasswordFailure() => l10n.auth_error_wrongPassword,
      InvalidEmailFailure() => l10n.auth_error_invalidEmail,
      EmailAlreadyInUseFailure() => l10n.auth_error_emailAlreadyInUse,
      UserDisabledFailure() => l10n.auth_error_userDisabled,
      UserTokenExpiredFailure() => l10n.auth_error_userTokenExpired,
      UserNotFoundFailure() => l10n.auth_error_userNotFound,
      OperationNotAllowed() => l10n.auth_error_operationNotAllowed,
      TooManyRequestsFailure() => l10n.auth_error_tooManyRequests,
      NetworkRequestFailedFailure() => l10n.auth_error_networkRequestFailed,
      UnknownAuthFailure() => l10n.auth_error_unknown,
      OperationCancelledFailure() => null,
      OperationInterruptedFailure() => null,
      ClientConfigurationFailure() => null,
      ProviderConfigurationFailure() => null,
      UIUnavailableFailure() => null,
      UserMismatchFailure() => null,
    };
  }
}
