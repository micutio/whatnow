# Contributing to whatnow

Thank you for your interest in contributing to **whatnow**!
This document outlines everything you need to know for getting started. 

---

## Table of Contents

- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Development Workflow & Task Runner](#development-workflow--task-runner)
- [Architecture & Coding Standards](#architecture--coding-standards)
- [Requirements & Test-Driven Development (TDD)](#requirements--test-driven-development-tdd)
- [Submitting Changes (Pull Requests)](#submitting-changes-pull-requests)
- [Versioning & Releases](#versioning--releases)
- [License](#license)

---

## Repository Structure

`whatnow` is a Dart and Flutter monorepo managed with native [Dart pub workspaces](https://dart.dev/tools/pub/workspaces):

```text
whatnow/
├── packages/
│   ├── core/          # whatnow_core: Shared domain entities, repositories, and prioritization logic
│   ├── cli/           # whatnow_cli: Command-line interface frontend (compiles to native AOT binaries)
│   └── app/           # whatnow_app: Flutter Android application frontend
├── tool/
│   └── dev.dart       # Cross-platform developer task runner
├── analysis_options.yaml
├── pubspec.yaml       # Root workspace configuration
└── CHANGELOG.md
```

- **`packages/core`** (`whatnow_core`): Contains pure Dart domain models, repository interfaces, prioritization metrics, and infrastructure implementations.
- **`packages/cli`** (`whatnow_cli`): Consumes `whatnow_core` to provide a command-line interface. Includes a binary smoke test suite in `packages/cli/tool/smoke_cli.dart`.
- **`packages/app`** (`whatnow_app`): Consumes `whatnow_core` to provide a Flutter Android app.

Each workspace package maintains its own `REQUIREMENTS.md` documenting functional and non-functional requirements.

---

## Prerequisites

- **[Flutter SDK](https://docs.flutter.dev/get-started/install)** (stable channel, including Dart SDK with pub workspace support)
- **Git**
- **Java 17 & Android SDK** *(required only when building the Android APK or running `packages/app` on an emulator/device)*

---

## Getting Started

1. **Clone the repository**

2. **Resolve dependencies for all workspace packages:**
   ```bash
   flutter pub get
   ```

3. **Verify workspace packages are linked:**
   ```bash
   dart pub workspace list
   ```

4. **Run the full verification suite to confirm your environment is working:**
   ```bash
   dart run tool/dev.dart verify
   ```

---

## Development Workflow & Task Runner

To avoid platform-specific shell scripts or `make` discrepancies across Windows, macOS, and Linux, use the cross-platform Dart task runner at `tool/dev.dart`:

| Command | Description |
| :--- | :--- |
| `dart run tool/dev.dart help` | Print all available runner commands |
| `dart run tool/dev.dart format` | Format all Dart files across the workspace |
| `dart run tool/dev.dart format --check` | Verify formatting without modifying files |
| `dart run tool/dev.dart analyze` | Run `dart analyze --fatal-infos` across all packages |
| `dart run tool/dev.dart fix` | Apply automated `dart fix` suggestions |
| `dart run tool/dev.dart fix --check` | Check for pending automated fixes (dry-run) |
| `dart run tool/dev.dart test` | Run all tests (`core`, `cli`, and `app`) |
| `dart run tool/dev.dart test:core` | Run `packages/core` unit tests |
| `dart run tool/dev.dart test:cli` | Run `packages/cli` unit tests |
| `dart run tool/dev.dart test:app` | Run `packages/app` Flutter widget tests |
| `dart run tool/dev.dart build:cli` | Compile the native CLI bundle (`dart build cli`) |
| `dart run tool/dev.dart smoke:cli` | Run smoke tests against the compiled CLI executable |
| `dart run tool/dev.dart build:app` | Build the debug Android APK (`flutter build apk --debug`) |
| `dart run tool/dev.dart verify` | Run the complete local CI check suite |

---

## Architecture & Coding Standards

### Separation of Concerns

- Keep domain logic and prioritization rules inside `packages/core` with zero Flutter or CLI-specific dependencies.
- Within `packages/core`, maintain a clean boundary between `lib/src/domain/` (entities, value objects, interfaces, repository contracts) and `lib/src/infrastructure/` (concrete repository implementations and persistence).
- Keep `packages/cli` and `packages/app` focused on presentation, user input, and platform integration.

### Static Analysis & Linting

The repository enforces strict type checks and lint rules configured in the root `analysis_options.yaml` and `packages/app/analysis_options.yaml.

If a lint rule must be suppressed with `// ignore:`, include a brief comment explaining why (`document_ignores`).

All code must pass `dart analyze --fatal-infos`, `dart format --output=none --set-exit-if-changed .`, and `dart fix --dry-run` ("Nothing to fix!").

---

## Requirements & Test-Driven Development (TDD)

This project uses **Test-Driven Development (TDD)** paired with requirements engineering as the default development workflow.

### Package-Level Requirements (`REQUIREMENTS.md`)

Every workspace package maintains its own `REQUIREMENTS.md` describing:
- **Functional Requirements**: Discrete, testable behaviors assigned unique identifiers (e.g., `REQ-TA-1`, `REQ-PR-1`).
- **Non-Functional Requirements**: Constraints on performance, security, usability, and external interfaces.

### Feature Workflow (Spec -> Red -> Green -> Refactor)

When implementing a new feature or changing behavior:

1. **Specify the Requirement**: Add or update the requirement in the relevant package's `REQUIREMENTS.md` with a clear identifier before writing any application or test code.
2. **Red (Write a Failing Test)**: Write an automated test that verifies the requirement and reference the requirement ID in the test description or comments (e.g., `test('REQ-TA-3: Task title must be between 1 and 255 characters', ...)`). Run the test suite to confirm the new test fails for the expected reason.
3. **Green (Make It Pass)**: Write the minimum production code necessary to make the failing test pass.
4. **Refactor**: Clean up duplication, improve naming, and refine the design while keeping all tests green and adhering to static analysis rules.

### Defect / Bugfix Workflow

When fixing a defect, the workflow depends on whether the existing requirements already cover the expected behavior:

1. **Assess `REQUIREMENTS.md`**:
   - **Implementation bug** (the requirement is already clearly specified, but the code violates it): Leave `REQUIREMENTS.md` unchanged.
   - **Specification gap** (the bug exposed a missing, ambiguous, or contradictory edge case): Update or add a requirement in the package's `REQUIREMENTS.md` first.
2. **Red (Reproduce the Bug)**: Write a failing regression test that reproduces the defect and references the relevant requirement ID.
3. **Green (Fix the Bug)**: Fix the production code so the regression test and all existing tests pass.
4. **Refactor**: Clean up the implementation while keeping the test suite green.

### Test Organization & Coverage

- **Core tests (`packages/core/test/`)**: Mirror the `lib/src/` directory structure (e.g., `test/domain/`, `test/infrastructure/`).
- **CLI tests (`packages/cli/test/`)**: Test CLI argument parsing, output streams (`out` and `err` sinks in `runCli`), exit codes, and end-to-end binary execution via `packages/cli/tool/smoke_cli.dart`.
- **App tests (`packages/app/test/`)**: Write Flutter widget and integration tests for UI components.

To generate test coverage locally (matching CI on Linux):

```bash
# Core coverage
dart test --coverage=packages/core/coverage packages/core
dart run coverage:format_coverage --lcov --in=packages/core/coverage --out=packages/core/coverage/lcov.info --report-on=packages/core/lib --base-directory=.

# Flutter app coverage
flutter test --coverage --coverage-path=packages/app/coverage/lcov.info packages/app
```

---

## Submitting Changes (Pull Requests)

1. **Create a branch** from `main`. Follow the branch naming conventions recognized by CI (`.github/workflows/dart.yml`):
   - `feature/<short-description>` for new features or enhancements
   - `bugfix/<short-description>` for bug fixes
2. **Follow the TDD workflow** (update `REQUIREMENTS.md` when applicable, then Red $\rightarrow$ Green $\rightarrow$ Refactor) in small, focused commits with clear commit messages.
3. **Update documentation** if your change alters CLI flags (`packages/cli/README.md`) or user-facing behavior (`CHANGELOG.md`).
4. **Run the verification suite locally** before pushing:
   ```bash
   dart run tool/dev.dart verify
   ```
5. **Open a Pull Request** against `main`:
   - Summarize the motivation and changes made.
   - Reference any related issues or requirement IDs (e.g., `REQ-TA-1`, `REQ-PR-1`).
   - Ensure all GitHub Actions CI jobs (`Format`, `Analyze`, `Fix`, `Test` on Ubuntu/Windows/macOS, `Build CLI`, and `Build Android`) pass.

---

## Versioning & Releases

Releases are automated through `.github/workflows/release.yml` when a version tag (`v*.*.*`) is pushed or triggered manually. When preparing a release:

1. Ensure the version in `pubspec.yaml` (and package `pubspec.yaml` files / `cliVersion` in `packages/cli/lib/whatnow_cli.dart`) matches the target release version (e.g., `0.2.0`).
2. Add a corresponding section header (`## 0.2.0`) and release notes in `CHANGELOG.md`.
3. Tag the commit as `v<version>` (e.g., `v0.2.0`) and push the tag.

---

## License

By contributing to `whatnow`, you agree that your contributions will be licensed under the [GNU Lesser General Public License v2.1 (LGPL-2.1)](LICENSE).
