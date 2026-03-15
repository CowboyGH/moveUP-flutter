// ignore_for_file: public_member_api_docs

/// Shared string constants used across the app UI.
abstract final class AppStrings {
  /// Common.
  static const skipButton = 'Пропустить';
  static const sendButton = 'Отправить';
  static const emailLabel = 'Email';
  static const emailHint = 'email@example.com';
  static const codeLabel = 'Код';
  static const codeHint = '******';

  /// Sign-in screen.
  static const signInTitle = 'Авторизация';
  static const signInSubtitle = 'Введите email и пароль, чтобы войти в аккаунт';
  static const signInPasswordLabel = 'Пароль';
  static const signInForgotPasswordButton = 'Забыли пароль?';
  static const signInSubmitButton = 'Войти';
  static const signInSwitchTitle = 'Еще нет аккаунта?';
  static const signInSwitchAction = 'Зарегистрироваться';

  /// Sign-up screen.
  static const signUpTitle = 'Регистрация';
  static const signUpSubtitle =
      'Создайте аккаунт, чтобы сохранить прогресс и получить персональную программу';
  static const signUpNameLabel = 'Имя';
  static const signUpNameHint = 'Иван';
  static const signUpPasswordLabel = 'Пароль';
  static const signUpSubmitButton = 'Зарегистрироваться';
  static const signUpSwitchTitle = 'Уже есть аккаунт?';
  static const signUpSwitchAction = 'Войти';
  static const signUpConsentSnack =
      'Подтвердите согласие с условиями обработки персональных данных';
  static const signUpConsentCheckboxLabel = 'Согласие на обработку персональных данных';
  static const signUpConsentPrefix = 'Я согласен с ';
  static const signUpConsentPrivacyPolicy = 'Политикой конфиденциальности';
  static const signUpConsentMiddle = ' и даю ';
  static const signUpConsentDataProcessing = 'Согласие на обработку персональных данных';

  /// Forgot-password screen.
  static const forgotPasswordTitle = 'Забыли пароль?';
  static const forgotPasswordSubtitle =
      'Введите email, который вы использовали при регистрации, и мы отправим код для сброса пароля';

  /// Verify-email screen.
  static const verifyEmailTitle = 'Регистрация';
  static const verifyEmailSubtitle =
      'Введите код из письма, чтобы подтвердить почту и завершить регистрацию';
  static const verifyEmailResendSuccess = 'Новый код подтверждения отправлен на вашу почту';

  /// Verify-reset-code screen.
  static const verifyResetCodeTitle = 'Восстановление\nпароля';
  static const verifyResetCodeSubtitle =
      'Введите код, отправленный на почту, чтобы продолжить восстановление доступа';
  static const verifyResetCodeResendSuccess =
      'Код для сброса пароля повторно отправлен на вашу почту.';

  /// Reset-password screen.
  static const resetPasswordTitle = 'Восстановление\nпароля';
  static const resetPasswordSubtitle =
      'Введите новый пароль, чтобы завершить восстановление доступа';
  static const resetPasswordNewPasswordLabel = 'Новый пароль';
  static const resetPasswordPasswordConfirmationLabel = 'Повторите пароль';
  static const resetPasswordPasswordConfirmationRequired = 'Подтвердите пароль';
  static const resetPasswordPasswordMismatch = 'Пароли не совпадают';

  /// Legal documents.
  static const legalPrivacyPolicyTitle = 'Политика конфиденциальности';
  static const legalDataProcessingConsentTitle = 'Согласие на обработку персональных данных';
  static const legalPublicOfferTitle = 'Публичная оферта';
  static const legalDocumentLoadError = 'Не удалось загрузить документ.';

  /// Feedback dialogs.
  static const feedbackErrorTitle = 'Что-то пошло не так';
  static const feedbackConsentRequiredTitle = 'Необходимо Ваше согласие';

  /// Auth widgets.
  static const authResendCodeAction = 'Отправить повторно';
  static const authShowPassword = 'Показать пароль';
  static const authHidePassword = 'Скрыть пароль';

  /// Auth validators.
  static const authNameRequired = 'Введите имя';
  static const authNameMinLength = 'Длина имени должна быть не менее 2 символов';
  static const authNameMaxLength = 'Длина имени должна быть не более 20 символов';
  static const authEmailRequired = 'Введите email';
  static const authEmailFormat = 'Неверный формат email';
  static const authPasswordRequired = 'Введите пароль';
  static const authPasswordMinLength = 'Пароль должен содержать минимум 8 символов';
  static const authPasswordMaxLength = 'Пароль должен быть не длиннее 64 символов';
  static const authPasswordAllowedChars = 'Пароль должен содержать только латинские буквы и цифры';
  static const authPasswordLetterAndDigit = 'Пароль должен содержать буквы и цифры';
  static const authOtpCodeRequired = 'Введите код';
  static const authOtpCodeFormat = 'Код должен состоять из 6 цифр';

  /// Auth failures.
  static const authInvalidCredentials = 'Неверные учетные данные';
  static const authValidationFailed = 'Проверьте введенные данные и попробуйте снова';
  static const authEmailAlreadyVerified = 'Email уже подтвержден. Войдите в аккаунт';
  static const authEmailNotVerified = 'Подтвердите email, чтобы продолжить';
  static const authRateLimited = 'Слишком много попыток. Попробуйте позже';
  static const authUnknown = 'Не удалось выполнить действие. Попробуйте снова';

  /// Network failures.
  static const networkNoConnection = 'Отсутствует интернет-соединение';
  static const networkTimeout = 'Сервер не отвечает. Попробуйте позже';
  static const networkBadRequest = 'Некорректный запрос';
  static const networkUnauthorized = 'Не авторизован';
  static const networkForbidden = 'Доступ запрещен';
  static const networkNotFound = 'Ресурс не найден';
  static const networkConflict = 'Конфликт данных';
  static const networkValidation = 'Ошибка валидации';
  static const networkRateLimited = 'Слишком много запросов';
  static const networkServerError = 'Ошибка сервера. Попробуйте позже';
  static const networkUnknown = 'Неизвестная ошибка сети';

  /// Debug screen.
  static const debugLogoutButton = 'Выйти';
}
