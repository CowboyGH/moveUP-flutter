# 🧩 Flutter Starter Template

A pragmatic **Flutter Starter Template** for personal and academic projects, built with **Clean Architecture**, **Firebase integration**, and **best practices** out of the box.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.10.0+-blue.svg)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📚 Table of Contents

- [🚀 Highlights](#-highlights)
- [📦 Tech Stack](#-tech-stack)
- [🏗️ Architecture](#️-architecture)
- [📂 Project Structure](#-project-structure)
- [🛠️ Getting Started](#️-getting-started)
- [🧪 Testing](#-testing)
- [🐋 Docker Build](#-docker-build)
- [🧠 Why This Template?](#-why-this-template)
- [📝 Documentation](#-documentation)
- [🤝 Contributing](#-contributing)
- [📜 License](#-license)
- [✨ Author](#-author)

---

## 🚀 Highlights

- 🏛️ **Clean Architecture** (Data → Domain → Presentation)
- 💉 **Dependency Injection** (GetIt + Provider)
- 🔥 **Firebase** integration (Core, Crashlytics, Analytics)
- ⚠️ **Error Handling** (Result pattern + Failure hierarchy)
- 📝 **Logging** with AppLogger abstraction and Mixin for Bloc/Cubit
- 🧭 **Navigation** with GoRouter and automatic screen tracking
- 📦 **Modular Structure** for scalable feature development
- 🎨 **Shared UIKit** (buttons, images, themes)

---

## 📦 Tech Stack

| Category | Technology |
| ---------- | ----------- |
| **Framework** | Flutter 3.10.0+ |
| **State Management** | flutter_bloc |
| **Dependency Injection** | get_it, provider |
| **Backend** | Firebase (Core, Auth, Crashlytics, Analytics, Firestore, Storage) |
| **Navigation** | go_router |
| **Connectivity Tracking** | connectivity_plus |
| **HTTP Client** | dio, retrofit |
| **UI Components** | flutter_svg, cached_network_image |
| **Code Generation** | freezed, json_serializable, build_runner |
| **Logging** | logger |
| **Localization** | intl, flutter_localizations |
| **Testing** | mockito, bloc_test, flutter_test |
| **Local Storage** | shared_preferences |

---

## 🏗️ Architecture

This template follows **Clean Architecture** principles:

```text
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│      (Pages, Widgets, BLoC/Cubit)       │
└───────────────────┬─────────────────────┘
                    │
                    │ uses
┌───────────────────▼─────────────────────┐
│             Domain Layer                │
│   (Entities, UseCases, Repositories*)   │  * interfaces only
└───────────────────▲─────────────────────┘
                    │
                    │ implements
┌───────────────────┴─────────────────────┐
│              Data Layer                 │
│  (DTOs, DataSources, Repositories Impl) │
└─────────────────────────────────────────┘
```

### Dependency Rule

`Presentation → Domain ← Data`

**Domain Layer** does NOT know about:

- Flutter framework (`import 'package:flutter/...'` ❌)
- Firebase, Dio, SharedPreferences
- JSON serialization (`@JsonSerializable` only in Data layer)

---

## 📂 Project Structure

```text
lib/
├── core/                  # Shared infrastructure
│   ├── di/                # Dependency injection setup
│   ├── failures/          # Error handling (Failure)
│   ├── localization/      # Localization files
│   ├── result/            # Result-pattern
│   ├── router/            # Navigation (GoRouter, paths)
│   ├── services/          # Services (Network, etc.)
│   └── utils/             # Utilities (Logger, Analytics)
├── features/              # Feature modules (Clean Architecture)
│   └── [feature_name]/
│       ├── data/          # DTOs, DataSources, Repository Impl
│       ├── domain/        # Entities, UseCases, Repository Interfaces
│       └── presentation/  # Pages, Widgets, BLoC/Cubit
├── uikit/                 # Shared UI components
└── main.dart              # App entry point
```

---

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK: `>=3.10.0`
- Dart SDK: `>=3.10.0`
- Firebase project (for Analytics, Crashlytics)

### Installation

1. **Clone or use this template:**

   ```bash
   # Option 1: Clone
   git clone https://github.com/CowboyGH/flutter_starter_template.git
   
   # Option 2: Use template (on GitHub: "Use this template" button)
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**

   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```

4. **Generate localization files:**

    ```bash
    flutter gen-l10n
    ```

5. **Run code generation:**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app:**

   ```bash
   flutter run
   ```

---

## 🧪 Testing

Run tests:

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/features/*/presentation/

# Coverage (requires lcov)
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## 🐋 Docker Build

Build Android APK using Docker:

```bash
docker build                                                   
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
  --build-arg VCS_REF=$(git rev-parse --short HEAD)
  --progress=plain
  --no-cache
  -t flutter-starter-android:latest .
```

Extract APK files:

```bash
docker create --name temp-flutter flutter-starter-android:latest
docker cp temp-flutter:/artifacts/. ./apk-output/
docker rm temp-flutter
```

---

## 🧠 Why This Template?

This repository is primarily a **personal starter** used to move faster on personal and academic projects.

### Goals

- Provide a stable baseline with **Clean Architecture** and strict layer boundaries.
- Have a ready-to-use infrastructure for **errors**, **logging**, **navigation**, and **CI/CD**.
- Reduce recurring setup work so feature development starts from a consistent foundation.

### Non-goals (at least for now)

- Competing with popular community templates.
- Shipping a complete UI kit/design system out of the box.
- Covering every possible app scenario or advanced product requirements.

If you find it useful — great! If not, treat it as a reference implementation of the patterns listed above.

---

## 📝 Documentation

- [CHANGELOG](CHANGELOG.md) - Version history and release notes
- [CONTRIBUTING](CONTRIBUTING.md) - Development guidelines and coding standards
- [LICENSE](LICENSE) - MIT License

---

## 🤝 Contributing

Issues and PRs are welcome, but the template is primarily maintained for personal use. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---

## ✨ Author

Developed by [Ryan Delaney](https://github.com/CowboyGH)
