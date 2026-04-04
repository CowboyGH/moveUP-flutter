// ignore_for_file: public_member_api_docs

/// Shared string constants used across the app UI.
abstract final class AppStrings {
  // Common.
  static const sendButton = 'Отправить';
  static const emailLabel = 'Email';
  static const emailHint = 'email@example.com';
  static const codeLabel = 'Код';
  static const codeHint = '******';
  static const retryButton = 'Попробовать снова';

  // No-connection screen.
  static const noConnectionTitle = 'Нет подключения';
  static const noConnectionSubtitle =
      'Проверьте подключение к интернету. Мы продолжим автоматически, когда соединение появится';

  // Sign-in screen.
  static const signInTitle = 'Авторизация';
  static const signInSubtitle = 'Введите email и пароль, чтобы войти в аккаунт';
  static const signInPasswordLabel = 'Пароль';
  static const signInForgotPasswordButton = 'Забыли пароль?';
  static const signInSubmitButton = 'Войти';
  static const signInSwitchTitle = 'Еще нет аккаунта?';
  static const signInSwitchAction = 'Зарегистрироваться';

  // Sign-up screen.
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

  // Forgot-password screen.
  static const forgotPasswordTitle = 'Забыли пароль?';
  static const forgotPasswordSubtitle =
      'Введите email, который вы использовали при регистрации, и мы отправим код для сброса пароля';

  // Verify-email screen.
  static const verifyEmailTitle = 'Регистрация';
  static const verifyEmailSubtitle =
      'Введите код из письма, чтобы подтвердить почту и завершить регистрацию';
  static const verifyEmailResendSuccess = 'Новый код подтверждения отправлен на вашу почту';

  // Verify-reset-code screen.
  static const verifyResetCodeTitle = 'Восстановление\nпароля';
  static const verifyResetCodeSubtitle =
      'Введите код, отправленный на почту, чтобы продолжить восстановление доступа';
  static const verifyResetCodeResendSuccess =
      'Код для сброса пароля повторно отправлен на вашу почту.';

  // Reset-password screen.
  static const resetPasswordTitle = 'Восстановление\nпароля';
  static const resetPasswordSubtitle =
      'Введите новый пароль, чтобы завершить восстановление доступа';
  static const resetPasswordNewPasswordLabel = 'Новый пароль';
  static const resetPasswordPasswordConfirmationLabel = 'Повторите пароль';
  static const resetPasswordPasswordConfirmationRequired = 'Подтвердите пароль';
  static const resetPasswordPasswordMismatch = 'Пароли не совпадают';

  // Legal documents.
  static const legalPrivacyPolicyTitle = 'Политика конфиденциальности';
  static const legalDataProcessingConsentTitle = 'Согласие на обработку персональных данных';
  static const legalPublicOfferTitle = 'Публичная оферта';
  static const legalDocumentLoadError = 'Не удалось загрузить документ.';
  static const legalDataProcessingConsentProfileTitle = 'Пользовательское соглашение';

  // Feedback dialogs.
  static const feedbackErrorTitle = 'Что-то пошло не так';
  static const feedbackConsentRequiredTitle = 'Необходимо Ваше согласие';

  // Auth widgets.
  static const authResendCodeAction = 'Отправить повторно';
  static const authShowPassword = 'Показать пароль';
  static const authHidePassword = 'Скрыть пароль';

  // Auth validators.
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

  // Auth failures.
  static const authInvalidCredentials = 'Неверные учетные данные';
  static const authValidationFailed = 'Проверьте введенные данные и попробуйте снова';
  static const authEmailAlreadyVerified = 'Email уже подтвержден. Войдите в аккаунт';
  static const authEmailNotVerified = 'Подтвердите email, чтобы продолжить';
  static const authRateLimited = 'Слишком много попыток. Попробуйте позже';
  static const authUnknown = 'Не удалось выполнить действие. Попробуйте снова';

  // Network failures.
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

  // Fitness Start.
  static const fitnessStartTitle = 'Ваш фитнес-старт';
  static const fitnessStartGoalStepTitle = 'Выберите Вашу цель тренировок';
  static const fitnessStartAnthropometryStepTitle = 'Введите Ваши параметры';
  static const fitnessStartLevelStepTitle = 'Выберите Ваш уровень подготовки';
  static const fitnessStartGenderLabel = 'Пол';
  static const fitnessStartEquipmentLabel = 'Оборудование';
  static const fitnessStartAgeLabel = 'Возраст';
  static const fitnessStartWeightLabel = 'Вес';
  static const fitnessStartHeightLabel = 'Рост';
  static const fitnessStartAgeHint = 'лет';
  static const fitnessStartWeightHint = 'кг';
  static const fitnessStartHeightHint = 'см';
  static const fitnessStartMaleOption = 'Мужской';
  static const fitnessStartFemaleOption = 'Женский';
  static const fitnessStartContinueButton = 'Далее';
  static const fitnessStartGoalRequired = 'Выберите цель тренировок';
  static const fitnessStartGenderRequired = 'Выберите пол';
  static const fitnessStartEquipmentRequired = 'Выберите оборудование';
  static const fitnessStartLevelRequired = 'Выберите уровень подготовки';
  static const fitnessStartAgeRequired = 'Введите возраст';
  static const fitnessStartAgeInvalid = 'Введите корректный возраст';
  static const fitnessStartAgeRange = '14–90 лет';
  static const fitnessStartWeightRequired = 'Введите вес';
  static const fitnessStartWeightInvalid = 'Введите корректный вес';
  static const fitnessStartWeightRange = '40–130 кг';
  static const fitnessStartHeightRequired = 'Введите рост';
  static const fitnessStartHeightInvalid = 'Введите корректный рост';
  static const fitnessStartHeightRange = '140–210 см';
  static const fitnessStartReferencesLoadFailed = 'Не удалось загрузить данные';
  static const fitnessStartRetryButton = 'Попробовать снова';
  static const fitnessStartCompletedTitle = 'Обнаружены данные';
  static const fitnessStartCompletedMessage =
      'Хотите пройти тест снова или использовать ранее введенную информацию?';
  static const fitnessStartRestartAction = 'Пройти тест снова';
  static const fitnessStartRegisterAction = 'Использовать введенную информацию';
  static const fitnessStartValidationFailed = 'Проверьте введенные данные и попробуйте снова';
  static const fitnessStartUnknown = 'Не удалось выполнить действие. Попробуйте снова';
  static const fitnessStartTestsTitle = 'Персональная программа';
  static const fitnessStartTestsDescription =
      'Всего несколько быстрых тестов помогут подобрать безопасные и эффективные упражнения для Вашего уровня подготовки';

  // Tests catalog.
  static const testsCatalogTitle = 'Тесты';
  static const testsCatalogDescription =
      'Оцените свою физическую подготовку с помощью углубленных диагностик, чтобы составить программу тренировок, которая будет одновременно безопасной и максимально результативной для Вашего уровня';
  static const testsCatalogSearchHint = 'Поиск';
  static const testsCatalogFilterLabel = 'Фильтрация';
  static const testsEmpty = 'Тесты не найдены';
  static const testsSearchEmpty = 'По вашему запросу тесты не найдены';
  static const testsLoadFailed = 'Не удалось загрузить тесты';
  static const testsStartFailed = 'Не удалось начать тест. Попробуйте снова';
  static const testsValidationFailed = 'Проверьте введенные данные и попробуйте снова';
  static const testsUnknown = 'Не удалось выполнить действие. Попробуйте снова';
  static const testsAttemptTitle = 'Тестирование';
  static const testsAttemptDescription = 'Оцените, насколько тяжело было выполнять упражнение';
  static const testsAttemptPulseTitle = 'Введите пульс после завершения теста';
  static const testsAttemptPulseHint = 'Введите получившийся результат';
  static const testsAttemptPulseRequired = 'Введите пульс';
  static const testsAttemptPulseInvalid = 'Введите корректный пульс';
  static const testsAttemptPulseRange = 'Пульс должен быть от 30 до 220';
  static const testsAttemptCompleteButton = 'Сохранить';
  static const testsAttemptResultVeryPoor = 'Очень плохо';
  static const testsAttemptResultPoor = 'Плохо';
  static const testsAttemptResultNormal = 'Нормально';
  static const testsAttemptResultGood = 'Хорошо';

  // Workouts overview.
  static const workoutsOverviewTitle = 'Тренировки';
  static const workoutsOverviewDescriptionPrimary =
      'Тренировки, которые были подобраны специально под Вас.';
  static const workoutsOverviewDescriptionSecondary =
      'Больше упражнений для ваших тренировок можно найти в нашей подписке';
  static const workoutsOverviewSearchHint = 'Поиск';
  static const workoutsOverviewOpenButton = 'Перейти';
  static const workoutsOverviewContinueButton = 'Продолжить';
  static const workoutsOverviewActiveWorkoutTitle = 'У вас уже есть начатая тренировка';
  static const workoutsOverviewActiveWorkoutDescription =
      'Сначала завершите текущую тренировку, чтобы начать новую';
  static const workoutsOverviewOpenActiveButton = 'Перейти к тренировке';
  static const workoutsOverviewDismissButton = 'Понятно';
  static const workoutsEmpty = 'Тренировки не найдены';
  static const workoutsSearchEmpty = 'По вашему запросу тренировки не найдены';
  static const workoutsLoadFailed = 'Не удалось загрузить тренировки';
  static const workoutsActiveWorkoutExists =
      'У вас уже есть начатая тренировка. Сначала завершите её, чтобы начать новую';
  static const workoutsUnknown = 'Не удалось выполнить действие. Попробуйте снова';

  // Cards.
  static const cardsValidationFailed = 'Проверьте введенные данные и попробуйте снова';
  static const cardsUnknown = 'Не удалось выполнить действие. Попробуйте снова';
  static const cardsSectionTitle = 'Мои карты';
  static const cardsLoadFailed = 'Не удалось загрузить карты';
  static const cardsAddButton = 'Добавить карту';
  static const cardsDefaultButton = 'Основная карта';
  static const cardsMakeDefaultButton = 'Сделать карту основной';
  static const cardsDeleteTitle = 'Удалить карту';
  static const cardsDeleteDescription = 'Вы действительно хотите удалить карту?';
  static const cardsDeleteConfirmButton = 'Подтвердить';
  static const cardsAddLimitTitle = 'Нельзя добавить карту';
  static const cardsAddLimitMessage = 'Можно сохранить не более 3 карт';

  // Subscriptions catalog.
  static const subscriptionsCatalogTitle = 'Подписки';
  static const subscriptionsCatalogEmpty = 'Подписки не найдены';
  static const subscriptionsCatalogLoadFailed = 'Не удалось загрузить подписки';
  static const subscriptionsCatalogBenefitTests =
      'Расширенный набор тестов для качественной адаптации';
  static const subscriptionsCatalogBenefitExercises = 'Расширенный набор упражнений';
  static const subscriptionsCatalogRubles = 'рублей';
  static const subscriptionsValidationFailed = 'Проверьте введенные данные и попробуйте снова';
  static const subscriptionsNotFound = 'Подписка не найдена';
  static const subscriptionsUnknown = 'Не удалось выполнить действие. Попробуйте снова';
  static const subscriptionsDetailsLoadFailed = 'Не удалось загрузить подписку';
  static const subscriptionsDetailsInfoPrefix = 'Подписка';
  static const subscriptionsDetailsAccessDescription =
      'Полный доступ к персональной системе тренировок';
  static const subscriptionsDetailsBuyButton = 'Оформить подписку';
  static const subscriptionsDetailsAdvantagesTitle = 'Наши преимущества';
  static const subscriptionsDetailsAdvantagesDescriptionPrefix = 'Не просто доступ к функциям, а ';
  static const subscriptionsDetailsAdvantagesDescriptionHighlighted = 'индивидуальный';
  static const subscriptionsDetailsAdvantagesDescriptionSuffix =
      ' фитнес-маршрут, который строится на ваших уникальных данных и целях. Получите максимум от каждой тренировки.';
  static const subscriptionsDetailsAdvantageLoadTitle = 'Умное управление нагрузкой';
  static const subscriptionsDetailsAdvantageLoadSubtitle =
      'Технология, которая помогает повысить эффективность силовых упражнений и ускорить восстановление мышц';
  static const subscriptionsDetailsAdvantageInjuryTitle = 'Профилактика травм';
  static const subscriptionsDetailsAdvantageInjurySubtitle =
      'Рекомендации по разминке и заминке, подобранные под Ваш тип тренировок';
  static const subscriptionsDetailsAdvantageDiagnosticsTitle = 'Расширенная диагностика';
  static const subscriptionsDetailsAdvantageDiagnosticsSubtitle =
      'Набор из специализированных тестов (сила, выносливость, мобильность, тип телосложения) для точного определения Вашего уровня';
  static const subscriptionsDetailsAdvantagePlanTitle = 'Персональный план';
  static const subscriptionsDetailsAdvantagePlanSubtitle =
      'Автоматически сформированная программа тренировок, которая адаптируется по мере Вашего прогресса';
  static const subscriptionsPaymentCardNumberLabel = 'Номер карты';
  static const subscriptionsPaymentCardNumberHint = '#### #### #### ####';
  static const subscriptionsPaymentCardNumberRequired = 'Введите номер карты';
  static const subscriptionsPaymentCardNumberInvalid = 'Номер карты должен состоять из 16 цифр';
  static const subscriptionsPaymentCardHolderLabel = 'Держатель карты';
  static const subscriptionsPaymentCardHolderHint = 'IVAN IVANOV';
  static const subscriptionsPaymentCardHolderRequired = 'Введите имя держателя карты';
  static const subscriptionsPaymentCardHolderInvalid =
      'Имя держателя карты должно содержать только заглавные латинские буквы и пробелы';
  static const subscriptionsPaymentExpiryLabel = 'Срок действия';
  static const subscriptionsPaymentExpiryMonthHint = 'Месяц';
  static const subscriptionsPaymentExpiryYearHint = 'Год';
  static const subscriptionsPaymentYearLabel = 'Год';
  static const subscriptionsPaymentCvvLabel = 'CVV';
  static const subscriptionsPaymentCvvHint = '***';
  static const subscriptionsPaymentRememberData = 'Запомнить мои данные';
  static const subscriptionsPaymentPayButton = 'Оплатить';
  static const subscriptionsPaymentPreviewExpiryLabel = 'Истекает';
  static const subscriptionsPaymentPreviewExpiryMonthLabel = 'MM';
  static const subscriptionsPaymentPreviewExpiryYearLabel = 'YY';

  // Workout details.
  static const workoutDetailsTitle = 'Тренировка';
  static const workoutDetailsStartWarmupButton = 'Начать разминку';
  static const workoutDetailsStartWorkoutButton = 'Начать тренировку';
  static const workoutDetailsLoadFailed = 'Не удалось загрузить тренировку';

  // Workout execution.
  static const workoutExecutionWarmupTitle = 'Разминка';
  static const workoutExecutionTitle = 'Тренировка';
  static const workoutExecutionLoadFailed = 'Не удалось запустить тренировку';
  static const workoutExecutionRestPrefix = 'Отдохните перед подходом';
  static const workoutExecutionReactionPrompt = 'Как ощущался данный подход?';
  static const workoutExecutionNextWarmupButton = 'Далее';
  static const workoutExecutionFinishWarmupButton = 'Завершить разминку';
  static const workoutExecutionExitTitle = 'Сбросить тренировку';
  static const workoutExecutionExitDescription =
      'Вы действительно хотите сбросить активную тренировку? Если Вы захотите ее продолжить, придется начать сначала';
  static const workoutExecutionExitPrimary = 'Сбросить';
  static const workoutExecutionExitSecondary = 'Отменить';
  static const workoutExecutionCompletedTitle = 'Тренировка завершена';
  static const workoutExecutionCompletedDescription =
      'Поздравляем!\nВы завершили тренировку!\n\nВаша статистика тренировок обновлена';
  static const workoutExecutionCompletedPrimary = 'Завершить';
  static const workoutExecutionAdjustmentTitle = 'Рекомендация по нагрузке';
  static const workoutExecutionAdjustmentFallback =
      'Скорректируйте рабочий вес в следующем подходе';
  static const workoutExecutionWeightTitle = 'Укажите использованный вес';
  static const workoutExecutionWeightDescription =
      'Если Вы выполняли упражнение с нагрузкой, введите вес в килограммах. Если вес не использовался, можно пропустить этот шаг';
  static const workoutExecutionWeightLabel = 'Вес';
  static const workoutExecutionWeightHint = 'кг';
  static const workoutExecutionWeightPrimary = 'Сохранить';
  static const workoutExecutionWeightSecondary = 'Пропустить';
  static const workoutExecutionWeightInvalid = 'Введите корректный вес в килограммах';

  // Profile.
  static String profileGreeting(String name) => 'Здравствуйте, $name';
  static const profileEditButton = 'Редактировать профиль';
  static const profileChangePasswordButton = 'Сменить пароль';
  static const profileChangePasswordTitle = 'Смена пароля';
  static const profileOldPasswordLabel = 'Старый пароль';
  static const profileNewPasswordLabel = 'Новый пароль';
  static const profilePasswordConfirmationLabel = 'Подтверждение пароля';
  static const profileUploadFileLabel = 'Загрузить файл:';
  static const profileUploadFormat = 'формат';
  static const profileUploadFormatPlaceholder = 'jpg формат';
  static const profileEditEmailLabel = 'Введите email';
  static const profileEditNameLabel = 'Введите имя';
  static const profileSaveButton = 'Сохранить';
  static const profileCancelButton = 'Отменить';
  static const profileLoadFailed = 'Не удалось загрузить профиль';
  static const profileValidationFailed = 'Проверьте введенные данные и попробуйте снова';
  static const profileUpdateFailed = 'Не удалось обновить профиль. Попробуйте снова';
  static const profileChangePasswordFailed = 'Не удалось сменить пароль. Попробуйте снова';
  static const profileImagePickFailed = 'Не удалось выбрать изображение. Попробуйте снова';
  static const profileCurrentPhaseTitle = 'Текущая фаза';
  static const profileCurrentPhaseRecommendation = 'Вам рекомендуется тренироваться в неделю';
  static const profileCurrentPhaseEmpty = 'У вас пока нет активной фазы';
  static const profileCurrentPhaseLoadFailed = 'Не удалось загрузить текущую фазу';
  static const profileParametersGoalLabel = 'Цель тренировок';
  static const profileParametersLevelLabel = 'Уровень подготовки';
  static const profileParametersWeeklyGoalLabel = 'Количество тренировок в неделю';
  static const profileParametersSubmitButton = 'Подтвердить';
  static const profileParametersLoadFailed = 'Не удалось загрузить параметры профиля';
  static const profileParametersEquipmentUnavailable = 'Нет доступных вариантов';
  static const profileParametersWeeklyGoalRequired = 'Введите количество тренировок в неделю';
  static const profileParametersWeeklyGoalInvalid =
      'Введите корректное количество тренировок в неделю';
  static const profileParametersWeeklyGoalRange = 'Допустимо от 1 до 7 тренировок в неделю';
  static const profileBottomLogoutButton = 'Выйти';
  static const profileBottomDeleteButton = 'Удалить профиль';
  static const profileBottomLogoutTitle = 'Вы уверены, что хотите выйти?';
  static const profileBottomDeleteTitle = 'Вы уверены, что хотите удалить профиль?';
  static const profileBottomDeleteConfirm = 'Удалить';
  static const profileSubscriptionsButton = 'Выбрать подписку';
  static const profileSubscriptionActiveTitleAccent = 'Срок действия';
  static const profileSubscriptionActiveTitleSuffix = ' вашей подписки';
  static const profileSubscriptionExpiryPrefix = 'до';
  static const profileSubscriptionRenewButton = 'Продлить подписку';
  static const profileSubscriptionCancelButton = 'Отменить подписку';
  static const profileSubscriptionCancelTitle = 'Отменить подписку?';
  static const profileSubscriptionCancelDescription = 'Вы действительно хотите отменить подписку?';
  static const profileSubscriptionCancelConfirm = 'Подтвердить';
  static const profileSubscriptionEmptyTitle = 'У Вас нет активной подписки';
  static const profileSubscriptionEmptySubtitle = 'Оформите подписку и получите:';
  static const profileSubscriptionBenefitTrainings = 'Полный доступ к персональным тренировкам';
  static const profileSubscriptionBenefitTestsAndExercises =
      'Расширенный набор тестов и упражнений';
  static const profileSubscriptionCardLoadFailed = 'Не удалось загрузить подписку';
  static const profileSubscriptionCardRetryButton = 'Повторить';
  static const profileStatsTitle = 'Статистика тренировок пользователя';
  static const profileStatsHistoryButton = 'История';
  static const profileStatsVolumeMode = 'Объём';
  static const profileStatsFrequencyMode = 'Частота';
  static const profileStatsTrendMode = 'Тренд';
  static const profileStatsCategoriesButton = 'Категории';
  static const profileStatsExercisesButton = 'Упражнения';
  static const profileStatsWorkoutsButton = 'Тренировки';
  static const profileStatsVolumeChartTitle = 'Объём (кг)';
  static const profileStatsFrequencyChartTitle = 'Частота тренировок';
  static const profileStatsTrendChartTitle = 'Тренд по упражнениям';
  static const profileStatsLoadFailed = 'Не удалось загрузить статистику';
  static const profileStatsEmpty = 'Пока недостаточно данных для отображения статистики';
  static const profileStatsHistoryTitle = 'История';
  static const profileStatsHistoryCloseButton = 'Закрыть';
  static const profileStatsHistorySubscriptionsTab = 'Подписки';
  static const profileStatsHistoryWorkoutsTab = 'Тренировки';
  static const profileStatsHistoryTestsTab = 'Тесты';
  static const profileStatsHistorySubscriptionEmpty = 'Активная подписка отсутствует';
  static const profileStatsHistoryWorkoutEmpty = 'Тренировки пока не завершены';
  static const profileStatsHistoryTestEmpty = 'Тесты пока не пройдены';
  static const profileStatsHistoryNameLabel = 'Название';
  static const profileStatsHistoryPriceLabel = 'Стоимость';
  static const profileStatsHistoryPeriodLabel = 'Активность';
  static const profileStatsHistoryCompletedLabel = 'Завершено';
  static const profileUnknown = 'Не удалось выполнить действие. Попробуйте снова';

  static const profileStatsAverageScoreLabel = 'Средняя оценка:';

  static String profileStatsAveragePerWeek(String value) => 'В среднем: $value / нед';

  static String profileCurrentPhaseTrainingsPerWeek(int value) =>
      'Вы тренируетесь $value ${_profileCurrentPhaseTimesLabel(value)} в неделю.';

  static String _profileCurrentPhaseTimesLabel(int value) {
    final mod100 = value % 100;
    if (mod100 >= 11 && mod100 <= 14) {
      return 'раз';
    }

    return switch (value % 10) {
      1 => 'раз',
      2 || 3 || 4 => 'раза',
      _ => 'раз',
    };
  }

  /// Builds the increase-adjustment message for a new absolute weight value.
  static String workoutExecutionAdjustmentIncrease(String weight) =>
      'На следующем подходе увеличьте вес до $weight $workoutExecutionWeightHint';

  /// Builds the decrease-adjustment message for a new absolute weight value.
  static String workoutExecutionAdjustmentDecrease(String weight) =>
      'На следующем подходе уменьшите вес до $weight $workoutExecutionWeightHint';

  /// Builds the exercise instruction with optional weight information.
  static String workoutExecutionInstruction({
    required int sets,
    required String setsLabel,
    required int reps,
    String? weight,
  }) {
    final instruction = 'Выполняйте данное упражнение $sets $setsLabel по $reps раз';
    if (weight == null) return instruction;
    return '$instruction с весом $weight $workoutExecutionWeightHint';
  }

  // Debug screen.
  static const debugScreenTitle = 'Debug Screen';

  /// Root tabs.
  static const testsTab = testsCatalogTitle;
  static const trainingsTab = 'Тренировки';
  static const profileTab = 'Профиль';
}
