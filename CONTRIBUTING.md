# 🤝 Contributing Guidelines

Thank you for your interest in contributing to this Flutter project!  
I welcome all contributions that help improve the code, documentation, or overall structure.  
Please take a few minutes to read through these guidelines before submitting your work.

---

## 🧭 Table of Contents

1. [Getting Started](#-getting-started)  
2. [Development Workflow](#-development-workflow)  
3. [Code Style](#-code-style)  
4. [Commit Guidelines](#-commit-guidelines)  
5. [Branching Strategy](#-branching-strategy)  
6. [Pull Request Process](#-pull-request-process)

---

## 🏁 Getting Started

1. **Fork** the repository.  
2. **Clone** your fork locally:

   ```bash
      git clone https://github.com/CowboyGH/flutter-starter-template.git
      cd <repo-name>
   ```

3. Install dependencies:

   ```bash
      flutter pub get
   ```

4. Create a new branch for your feature or fix:

   ```bash
      git checkout -b feature/my-new-feature
   ```

---

## 🧰 Development Workflow

1. Make sure your Flutter SDK and packages are up to date:

   ```bash
      flutter upgrade
      flutter pub upgrade
   ```

2. Run the project:

   ```bash
      flutter run
   ```

3. Before committing, check formatting and analyze code:

   ```bash
      flutter format .
      flutter analyze
   ```

4. Run unit tests (if any):

   ```bash
      flutter test
   ```

---

## 🎨 Code Style

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style) and [Effective Dart](https://dart.dev/guides/language/effective-dart) recommendations.
- Use meaningful names for variables, classes, and functions.
- Keep functions short and pure — avoid side effects where possible.
- Group code logically: prefer feature-first structure (`feature/data`, `feature/domain`, `feature/presentation`).
- Always use `const` constructors when possible for widgets.

---

## 📝 Commit Guidelines

Follow [Conventional Commits](https://www.conventionalcommits.org/) format:

```text
<type>(optional scope): <short summary>
```

**Example:**

```text
feat(auth): add user login with token refresh
fix(router): correct initial route for onboarding
docs(readme): update setup instructions
```

**Types:**

- `feat` — new feature
- `fix` — bug fix
- `docs` — documentation changes
- `refactor` — code restructure
- `style` — formatting, naming, linting
- `test` — adding or fixing tests
- `chore` — maintenance tasks (CI, configs, etc.)

---

## 🌿 Branching Strategy

I use a simple branching model:

- `main` — stable production-ready branch
- `develop` — main development branch
- `feature/*` — new features
- `fix/*` — bug fixes
- `docs/*` — documentation updates

**Example workflow:**

```bash
git checkout -b feature/add-user-profile
# make changes
git commit -m "feat(profile): implement user profile page"
git push origin feature/add-user-profile
```

---

## 🔄 Pull Request Process

1. Make sure your branch is up to date with `develop`.
2. Create a pull request (PR) from your feature branch.
3. Ensure your PR:
   - Describes what was changed and why
   - Passes `flutter analyze` and `flutter test`
   - Contains no merge conflicts
4. Wait for review and address comments if any.
5. Once approved, your PR will be merged!

---

## 💬 Need Help?

If you have questions or run into issues:

- Open a GitHub issue
- Or reach out via Discussions (if enabled)

---

Thank you for contributing and helping make this project better! 🚀
