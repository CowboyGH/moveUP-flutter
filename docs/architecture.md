# Architecture

## Overview
moveUP is a Flutter mobile client for the moveUP fitness platform (iOS + Android).
The codebase is organized **feature-first with Clean Architecture** inside each feature: `data → domain → presentation` layers. Cross-cutting concerns (DI, router, network, storage, errors) live in `lib/core/`.

## Project structure
```text
lib/
├── core/
│   ├── constants/     # shared strings + asset references
│   ├── di/            # get_it container setup
│   ├── env/           # envied-based config (.env)
│   ├── failures/      # network + feature Failure hierarchies (freezed)
│   ├── network/       # dio setup, interceptors, mappers, error DTOs
│   ├── result/        # Result<T, F> sealed type
│   ├── router/        # go_router config + AppRoutePaths
│   ├── services/      # cross-feature services (token storage, network status, hive boxes)
│   └── utils/         # logger, analytics
├── features/
│   └── <feature>/
│       ├── data/          # *_dto.dart, *_api.dart (retrofit), repositories/, mappers/
│       ├── domain/        # entities, repository contracts
│       ├── presentation/  # pages/, cubits/, widgets/, validators/
│       └── support/       # feature-internal helpers
├── uikit/
│   ├── buttons/ dialogs/ images/ inputs/ cards/ menus/ themes/
└── main.dart → runner.dart  (single entrypoint, no flavors)
```

## Layers

Each feature has three layers; each layer only knows about what is below it:

```text
Presentation  →  Domain  ←  Data
 (Cubit, Page)   (Entity,    (DTO, ApiClient,
                  Repo iface) RepoImpl, Mapper)
```

- **Domain** — pure entities and abstract repository interfaces. No knowledge of Dio, DI, or Cubit.
- **Data** — repository implementations. Depends on a retrofit client and the domain interface. Maps DTO ↔ Entity and `DioException` → `Failure`.
- **Presentation** — Cubit + Page/Widget. The Cubit calls `repository.method()`, receives `Result<Entity, Failure>`, and switches state via `switch`.
- There is no Use Case layer — the Cubit calls the repository directly. If logic grows complex, extract it into a separate class in `domain/` manually.

## State management

Uses **Cubit** from `flutter_bloc`. Not Bloc, not Riverpod, not ChangeNotifier.

```dart
// typical pattern (see sign_in_cubit.dart as a reference)
emit(const State.inProgress());
final result = await _repository.call();
if (isClosed) return;
switch (result) {
  case Success(:final data): emit(State.succeed(data));
  case Failure(:final error): emit(State.failed(error));
}
```

- State — `@freezed` sealed class in a separate file `<name>_state.dart` (`part of '<name>_cubit.dart'`).
- Before async: guard against re-entrancy via `state.maybeWhen(inProgress: () => true, orElse: () => false)`.
- After `await`: always `if (isClosed) return;` before `emit`.
- Navigation, snackbars, and dialogs happen in the UI layer only; the Cubit only emits state.

**Global singletons in DI** (alive for the entire app lifetime):
- `AuthSessionCubit` — manages session state: `initial → checking → authenticated | unauthenticated | guestResumeAvailable | guest | guestCompletedOnboarding | restoreFailed`.
- `NetworkCubit` — listens to `NetworkService` (connectivity_plus), emits `initial | connected | disconnected`.
- `ProfileRefreshCubit` — workaround: the shared `/profile` endpoint is used by multiple features; this cubit acts as a refresh signal without creating direct dependencies between features.

All other cubits are created in `*_page_builder.dart` via `BlocProvider` and live as long as the widget tree.

## Navigation

Router — **GoRouter 17**, config in `lib/core/router/router.dart`, paths in `AppRoutePaths`.

Redirect runs on every emission from `AuthSessionCubit.stream` or `NetworkCubit.stream` (`CombinedRouterRefreshListenable`). Logic is two-tiered:

**1. Startup splash lock** — no redirects until `startupSplashDuration` (1500 ms) elapses. `completeStartupSplash()` is called from `runner.dart` via `addPostFrameCallback`.

**2. Network gate** — if `disconnected`, any path → `/offline`. On reconnect, redirect is determined by session state.

**3. Auth gate** by `AuthSessionState`:

| AuthState | Redirects to |
|---|---|
| `initial` / `checking` | `/splash` |
| `unauthenticated` / `restoreFailed` / `guestResumeAvailable` | `/auth/sign-in` |
| `guest` | `/fitness-start/quiz` |
| `guestCompletedOnboarding` | `/auth/sign-up` |
| `authenticated` | `/workouts` (or stays if the path is allowed) |

The root shell (`StatefulShellRoute.indexedStack`) has three tabs: `/tests`, `/workouts`, `/profile`.

Adding a new route:
1. Add a constant in `AppRoutePaths`.
2. Add a `GoRoute` in `router.dart`.
3. If it needs guarding, add a condition in `_redirectByAuth` / `_redirectFromOffline`.

## Data / API

**Network layer:**
- One `Dio` instance for all requests; `refreshDio` is a separate instance used only for `/auth/refresh` (avoids interceptor loop).
- `AuthInterceptor` — attaches `Authorization: Bearer <token>`, automatically refreshes on 401.
- `CookieManager` — manages guest cookies via `PersistCookieJar`.
- `LoggingInterceptor` — debug mode only.
- Timeouts: connect 10 s, receive 15 s, send 10 s.

**Retrofit clients** (`*_api_client.dart`) — one client per feature (exception: `profile` is split into three clients — profile, parameters, statistics).

**Error mapping** (`DioException` → `NetworkFailure`):

| HTTP | Failure |
|---|---|
| 400 | `BadRequestFailure` |
| 401 | `UnauthorizedFailure` |
| 403 | `ForbiddenFailure` |
| 404 | `NotFoundFailure` |
| 409 | `ConflictFailure` |
| 422 | `ValidationFailure` (+ `errors: Map<String, List<String>>`) |
| 429 | `RateLimitedFailure` |
| 5xx | `ServerErrorFailure` |
| timeout | `ConnectionTimeoutFailure` |
| no connection | `NoNetworkFailure` |
| else | `UnknownNetworkFailure` |

Feature-specific failures (`AuthFailure`, …) add typed business-logic semantics on top of `NetworkFailure` where needed (e.g. `UnauthorizedAuthFailure` in `AuthSessionCubit`).

## Dependency injection

Single container — `GetIt.instance` (`di`), configured in `setupDI()` before `runApp`.

Registration order in `di.dart`:
1. Hive box (opened async before registrations)
2. Logger → AppLogger
3. Analytics
4. Connectivity → NetworkService → **NetworkCubit** (singleton)
5. TokenStorage, FitnessStartProgressStorage (Hive), CookieJar, GuestSessionStorage
6. Dio (AuthInterceptor + CookieManager + LoggingInterceptor)
7. ApiClients → Repositories (per feature)
8. **ProfileRefreshCubit** (singleton — workaround for profile refresh via shared endpoint)
9. **AuthSessionCubit** (singleton; depends on AuthRepository, TokenStorage, FitnessStartProgressStorage, GuestSessionStorage)
10. Tests, Workouts ApiClients → repositories

Page-level cubits are created in `*_page_builder.dart`:
```dart
BlocProvider(create: (_) => MyFeatureCubit(di<MyRepo>()))
```

## Storage

| What | Storage | Implementation |
|---|---|---|
| Access token | `flutter_secure_storage` | `SecureTokenStorage` |
| Guest onboarding progress | `hive_ce_flutter` (named box) | `HiveFitnessStartProgressStorage` |
| Guest backend session cookies | `PersistCookieJar` (file-based, app support dir) | `CookieJarGuestSessionStorage` |

- Token is cleared on logout and when a 401 cannot be recovered after a refresh attempt.
- Guest data (Hive + cookies) is cleared on successful authentication and on explicit progress reset.
