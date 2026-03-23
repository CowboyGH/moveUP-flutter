# 📘 Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added

- `FitnessStartProgressStorage` with `Hive`-based persistence for completed guest onboarding resume after app restart.
- Persistent guest session cookie storage and cleanup wiring for backend-backed onboarding resume.
- `FitnessStartApiClient`, DTOs, repository contract/implementation, and dedicated `FitnessStartFailure` mapping for `user-parameters` endpoints.
- `PhasesApiClient`, `PhasesRepository`, `PhasesFailure` mapping, and `WeeklyGoalCubit` for the final weekly-goal onboarding step.
- Shared `tests catalog` slice for `GET /api/testings`, including `TestsApiClient`, DTOs, failure mapping, repository, Cubit, and onboarding carousel widgets.
- Shared guest `tests attempt` slice for `/api/guest/tests/{testing}/start`, `/api/guest/test-attempts/{attempt}/result`, and `/api/guest/test-attempts/{attempt}/complete`, including DTOs, repository, Cubit, validators, and onboarding attempt UI.
- Shared UIKit controls for the onboarding quiz: `AppCard`, `OptionButton`, and `AppInputField`.
- Shared UIKit `SecondaryButton` and `AppActionDialog` for onboarding/auth action modals.
- `FitnessStartCubit`, validators, 3-step quiz UI, `/fitness-start/tests` onboarding shell screen, and sign-in resume dialog for the onboarding-first auth entry flow.
- `/fitness-start/weekly-goal` final guest onboarding screen for adjusting weekly training goal before handoff to registration.

### Changed

- Registration is now onboarding-first: `Нет аккаунта? Зарегистрироваться` starts `Fitness Start`, while `sign-up` becomes a post-onboarding screen only.
- Auth `Skip` actions were removed from `sign-in` and `sign-up`.
- Guest onboarding resume is now completed-only: unfinished `Fitness Start` progress is cleared on app restart, while completed guest data shows a resume dialog on `sign-in`.
- `FitnessStartStage` was removed from auth/session routing, and `quiz -> tests` now uses direct page navigation instead of session-driven stage switching.
- Verify-email success now completes authentication directly instead of entering a staged authenticated onboarding flow.
- Dio clients now attach a shared persistent `CookieManager` so guest onboarding progress and backend session can survive app restarts.
- `/fitness-start/tests` now shows the onboarding tests catalog carousel instead of the previous placeholder CTA, remains part of the `fitness_start` shell flow, and its back action exits guest flow to `sign-in`.
- Selecting a testing in the onboarding catalog now pushes a guest test attempt route, saves per-exercise results through guest endpoints, collects pulse after the last exercise, and advances to a final weekly-goal step before completing guest onboarding and redirecting to `sign-up`.
- `Fitness Start` validation feedback now removes duplicate backend field messages before showing them to the user.
- `Fitness Start` quiz selections are now locked while a submit request is in progress.
- `Fitness Start` quiz now keeps initial references loading and retry states inline in the card instead of collapsing to a blank screen.
- `Fitness Start` anthropometry validators now use unified range messages for age, weight, and height instead of duplicated min/max strings.

## [0.2.0] - 2026-03-13

### Added

- Envied-based environment configuration.
- Dio + Retrofit API client foundation.
- Debug-only lightweight Dio logging without body dumps.
- Secure token persistence with `flutter_secure_storage` via `TokenStorage` and `SecureTokenStorage`.
- Core network/auth foundation under `lib/core/network/*`:
  - Dio setup and API paths.
  - Logging and auth interceptors (with access token refresh flow).
  - Typed network error DTOs and `DioException` mapper.
- Typed `NetworkFailure` and `AuthFailure` mapping.
- Auth data scaffolding: `AuthApiClient`, base `UserDto`, and auth failure mapper.
- Sign-in API contract and DTOs (`LoginRequestDto`, `LoginResponseDto`, `LoginSessionDto`) plus `AuthApiClient.login`.
- Auth domain/data sign-in flow through `AuthRepository.signIn` and `AuthRepositoryImpl` with token persistence.
- Sign-in presentation flow through `SignInCubit`, `SignInPageBuilder`, and `SignInPage`.
- Unit tests for user entity mapping, sign-in repository flow, and `SignInCubit`.
- `/me` auth API integration through `AuthApiClient.me` and `MeResponseDto`.
- Auth session foundation through `AuthSessionCubit` (`initial/checking/guest/authenticated/unauthenticated`) with startup session restore.
- Session-aware router refresh integration via `GoRouterCubitRefreshStream`.
- Unit tests for `AuthRepositoryImpl.getCurrentUser` and `AuthSessionCubit`.
- Sign-up API contract and DTOs (`RegisterRequestDto`, `RegisterResponseDto`) plus `AuthApiClient.register`.
- Auth domain/data sign-up flow through `AuthRepository.signUp` and `AuthRepositoryImpl`.
- Sign-up presentation flow through `SignUpCubit`, `SignUpPageBuilder`, and `SignUpPage`.
- Unit tests for `AuthRepositoryImpl.signUp` and `SignUpCubit`.
- Shared auth UI primitives: `AuthFlowShell`, `AuthTextField`, `AuthPasswordField`, and `AuthSwitchSection`.
- Verify-email API contract and DTOs (`VerifyEmailRequestDto`, `VerifyEmailResponseDto`) plus `AuthApiClient.verifyEmail`.
- Auth domain/data verify-email flow through `AuthRepository.verifyEmail` and `AuthRepositoryImpl` with token persistence.
- Verify-email presentation flow through `VerifyEmailCubit`, `VerifyEmailPageBuilder`, and `VerifyEmailPage`.
- OTP verification route at `/auth/verify-email`.
- Unit tests for `AuthRepositoryImpl.verifyEmail` and `VerifyEmailCubit`.
- Shared OTP validator and validator test coverage.
- Resend verification code API contract (`ResendVerificationCodeRequestDto`) plus `AuthApiClient.resendVerificationCode`.
- Password recovery resend API contract plus `AuthApiClient.resendResetCode`.
- Shared OTP resend domain/data flow through `AuthRepository.resendOtpCode` and `AuthRepositoryImpl`.
- Shared `OtpResendCubit` with built-in cooldown support for OTP resend use cases.
- Unit tests for `AuthRepositoryImpl.resendOtpCode` and `OtpResendCubit`.
- Forgot-password API contract (`ForgotPasswordRequestDto`) plus `AuthApiClient.forgotPassword`.
- Auth domain/data forgot-password flow through `AuthRepository.forgotPassword` and `AuthRepositoryImpl`.
- Forgot-password presentation flow through `ForgotPasswordCubit`, `ForgotPasswordPageBuilder`, and `ForgotPasswordPage`.
- Password recovery request route at `/auth/forgot-password`.
- Unit tests for `AuthRepositoryImpl.forgotPassword` and `ForgotPasswordCubit`.
- Verify-reset-code API contract (`VerifyResetCodeRequestDto`) plus `AuthApiClient.verifyResetCode`.
- Auth domain/data verify-reset-code flow through `AuthRepository.verifyResetCode` and `AuthRepositoryImpl`.
- Verify-reset-code presentation flow through `VerifyResetCodeCubit`, `VerifyResetCodePageBuilder`, and `VerifyResetCodePage`.
- Password recovery OTP verification route at `/auth/forgot-password/verify-code`.
- Unit tests for `AuthRepositoryImpl.verifyResetCode` and `VerifyResetCodeCubit`.
- Reset-password API contract (`ResetPasswordRequestDto`) plus `AuthApiClient.resetPassword`.
- Auth domain/data reset-password flow through `AuthRepository.resetPassword` and `AuthRepositoryImpl`.
- Reset-password presentation flow through `ResetPasswordCubit`, `ResetPasswordPageBuilder`, and `ResetPasswordPage`.
- Final password recovery route at `/auth/forgot-password/reset`.
- Unit tests for `AuthRepositoryImpl.resetPassword` and `ResetPasswordCubit`.
- Logout API contract through `AuthApiClient.logout`.
- Auth domain/data logout flow through `AuthRepository.logout` and `AuthRepositoryImpl`.
- Logout presentation flow through `LogoutCubit` and debug-screen logout wiring.
- Unit tests for `AuthRepositoryImpl.logout`, `LogoutCubit`, and `AuthSessionCubit.clearSession`.
- UIKit color and gradient tokens via `AppColorTheme`, `AppColors`, and `AppGradients`.
- Montserrat font kit and shared text theming via `AppTextStyle` and `AppTextTheme`.
- Shared UIKit theme foundation via `AppThemeData`.
- Shared UIKit widgets: `MainButton`, `SvgPictureWidget`, `NetworkImageWidget`, and `AppDecorativeFigure`.
- Auth UI visual assets for the updated auth flow layout: `arrow_back`, password visibility icons, and the decorative auth figure.
- Shared inline resend widget for OTP screens: `AuthResendCodeText`.
- Shared UIKit `AppBackButton` for auth-style back navigation.
- Shared UIKit `AppTextAction` for lightweight auth text links.
- Shared UIKit `AppFeedbackDialog` for auth-style alert feedback plus the bundled `exclamation_point` icon asset.
- Bundled legal text assets for privacy policy, personal data processing consent, and public offer.
- Shared legal-document flow through `LegalDocumentType`, `LegalDocumentPage`, and auth route wiring for document viewing.
- Shared core constants: `AppStrings` for app copy and `AppAssets` for UI asset references.

### Changed

- Dockerfile and CI now inject `API_URL` through GitHub Secrets.
- CI is split by target branch: PRs to `main` run the release workflow, while PRs to `develop` run analysis-only checks.
- CI workflows now fall back to a placeholder `API_URL` when the secret is missing, verify formatting on tracked Dart sources before code generation, and format generated outputs after `build_runner`.
- Legacy `lib/api/service/*` networking was replaced with `lib/core/network/*` and `lib/features/auth/data/*`.
- Auth API and refresh endpoints are now centralized in `ApiPaths` behind a shared `apiPrefix`.
- DI registrations now use the new network stack, token storage, and feature-scoped auth API client.
- `TokenStorage` was narrowed to read, write, and delete operations only.
- DI now provides sign-in dependencies through the registered `AuthRepository` implementation, `AppLogger`, `AuthApiClient`, and `TokenStorage`.
- Auth routing now resolves sign-in dependencies through `SignInPageBuilder`.
- `SignInCubit` now focuses strictly on auth state transitions without logger injection.
- Debug logging was reduced by removing duplicate sign-in logs, downgrading analytics logs to debug level, and setting debug logger `methodCount` to `0`.
- Sign-in validation and debug behavior were tightened: password validation was simplified, email regex TLD bounds were relaxed, and `/debug` routes are now debug-only.
- `AuthRepository` now includes `getCurrentUser`, with the mapping flow implemented in `AuthRepositoryImpl`.
- Sign-in success now flows through `AuthSessionCubit` (`onSignInSuccess` / `continueAsGuest`) instead of direct navigation.
- `SignInPageBuilder` now provides the shared `AuthSessionCubit` instance from DI for router/session consistency.
- App bootstrap now restores the session asynchronously on startup.
- Auth repository tests now reuse shared Dio exception fixtures.
- `AuthSessionCubit` now has an explicit DI dispose callback, and startup session restore is triggered after global error handlers are configured.
- `UserDto.emailVerifiedAt` is now nullable to match the `/register` payload.
- Sign-in and sign-up pages were rebuilt on shared auth widgets and a unified auth layout.
- Sign-up consent UX now uses a local `_ConsentRow` widget with inline pressed-state handling for legal links and a clearer validation feedback message.
- Sign-up success now navigates to verify-email and passes the email through route `extra`.
- Forgot-password success now navigates to verify-reset-code and passes the email through route `extra`.
- Verify-reset-code success now navigates to reset-password and passes typed recovery args through route `extra`.
- Verify-email, verify-reset-code, and reset-password routes now guard missing or invalid `extra` values with redirects.
- Verify-email now delegates resend requests, cooldown timing, and feedback handling to `OtpResendCubit` instead of local placeholder logic.
- Verify-reset-code now reuses `OtpResendCubit` for resend requests, cooldown timing, and feedback handling.
- Shared OTP resend routing now switches by `OtpResendFlow`, using `/resend-verification-code` for email verification and `/resend-reset-code` for password recovery.
- Password recovery now finishes with `go(signInPath)` after a successful password reset.
- The sign-in forgot-password action now opens the dedicated password recovery request screen.
- `AuthSessionCubit.clearSession` now completes only the local session transition, while backend logout happens in the dedicated logout flow first.
- The shared `AuthSessionCubit` is now provided from the app root instead of feature-local builders.
- Auth cubits now use the public Freezed state API for in-progress guards instead of generated private classes.
- `auth_mapper.dart` was renamed to `auth_failure_mapper.dart` to reflect its actual responsibility.
- Auth repository tests now inline feature-specific DTO fixtures, share consistent `UserDto` defaults, and align `TokenStorage` assertions.
- Verify-email repository coverage now checks `EmailAlreadyVerifiedFailure` (`400`) instead of the previous validation-failure case.
- Default button theming in `AppThemeData` was aligned with the UIKit baseline.
- `AuthFlowShell` was redesigned around the new mobile layout, including the decorative figure, top action slot, optional back button, and revised paddings.
- Shared auth form widgets now use labeled inputs, themed icons, password hint dots, and UIKit-based typography/colors.
- Sign-in, sign-up, verify-email, forgot-password, verify-reset-code, and reset-password screens were aligned to the new auth layout and `MainButton` usage.
- OTP verification screens now share a unified resend/timer presentation widget.
- Sign-in, sign-up, and OTP resend text actions now share the lightweight `AppTextAction` widget.
- `AuthResendCodeText` now uses a unified resend-availability state for both interaction and styling.
- App bootstrap now locks the app to portrait mode.
- Sign-up consent text now opens the relevant legal documents through underlined inline links.
- `AppBackButton` now resolves pressed and disabled icon colors through shared `IconButtonTheme` state styling.
- Transport-only auth response DTOs were removed from `logout`, `forgot-password`, `resend-verification-code`, `verify-reset-code`, and `reset-password`.
- Remaining auth response DTOs were trimmed to remove unused `success` and `message` transport fields where the client only consumes the payload.
- Hardcoded auth UI copy, validator messages, auth/network failure texts, and legal-document titles were centralized in `AppStrings`.
- Hardcoded auth asset names and legal document asset paths were centralized in `AppAssets`.
- Auth flows now preserve normalized network error messages through `AuthRequestFailure` instead of collapsing them into a generic unknown auth error.
- Auth/debug error and consent snackbars were replaced with shared feedback dialogs.
- Redundant success feedback modals were removed from OTP resend and code-verification flows where UI state or navigation already confirms success.
- The UIKit app background was set to white to match the finalized auth mockup.
- The decorative auth figure accent was moved to the secondary palette.
- The auth card outline now uses a full 1px gradient border around the full contour.

### Fixed

- `ErrorResponseDto` no longer generates unused `toJson`.
- `SignInCubit` now guards against emit-after-close after awaiting repository responses.
- Sign-in debug shortcuts are now truly disabled in release, and email validation now accepts common addresses such as `+` aliases.
- `LoginRequestDto` no longer generates redundant `fromJson`.
- Cancelled Dio requests are now mapped to `UnknownNetworkFailure` instead of `NoNetworkFailure`.
- Auth back-button accessibility now uses a full-size tap target in `AuthFlowShell`.
- Custom labeled auth inputs now expose semantic labels correctly.
- The sign-up consent checkbox now exposes semantics to assistive technologies while preserving the custom visual style.
- The password visibility toggle now uses explicit semantics instead of tooltip-only labeling.
- Auth password validation now matches the finalized requirements, including the missing password rule copy and test coverage.
- Session restore now clears persisted tokens only for invalid-session failures, keeps retryable restore failures recoverable, and still exits `checking` even if token cleanup fails.
- Repository test coverage now includes failure paths for password-recovery OTP resend.
- Validation failures now flatten backend field errors into multiline feedback dialog content instead of showing a generic auth error.

### Removed

- Legacy API client scaffold at `lib/api/service/api_client.dart`.
- Unused `AppLoggerMixin`.
- Unused auth response DTOs that only carried transport-level success/message payloads.

## [0.1.0] - 2026-02-16

### Added

- Added API documentation generation and local preview instructions to `README.md`.

### Changed

- Clarified documentation comments in bootstrap, DI, network, and auth-related files.
- Rebranded the project from template naming to `moveUP` for the initial baseline.
- Aligned Android and iOS identifiers to the new project identity (com.sibcode.moveup).
- Updated project/build configuration files to match the new app identity (platform configs, CI/CD, service files).
- Simplified CI to Android-only: removed iOS job and redundant steps, switched Docker build to a single APK (`app-release.apk`), and tightened formatting/test checks.

### Removed

- Removed legacy `flutter_starter_template` references and leftover template scaffolding from the codebase.
- Removed Firebase integration from the baseline (runtime initialization, Firebase dependencies, platform plugins/config references, and CI mock Firebase file generation).

### Fixed

- Fixed configuration mismatches introduced during template cleanup and project rebranding.

### Breaking

- Android Application ID / Namespace and iOS Bundle Identifier changed to `com.sibcode.moveup`.
- App root widget rename: `FlutterStarterTemplate` -> `MoveUpApp`.
