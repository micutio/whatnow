# whatnow_cli

The command-line interface frontend for the whatnow monorepo. It consumes `whatnow_core` and compiles to native AOT binaries across Linux, macOS, and Windows.

---

## Local Development & Execution

```bash
# Run directly from source
dart run bin/whatnow.dart
dart run bin/whatnow.dart --help
dart run bin/whatnow.dart --version

# Run CLI tests
dart test

# Compile to a native AOT binary
dart build cli

# Smoke test the compiled native binary
dart run tool/smoke_cli.dart
```

## Publishing to pub.dev as a Global Tool (Optional)

If publishing `whatnow_cli` to pub.dev so users can install it via `dart pub global activate`:

1. **Remove `publish_to: none`** from `pubspec.yaml`.
2. **Specify Explicit Dependency Versions**:
   In pub workspaces, local sibling dependencies can omit versions. For pub.dev, you must specify an explicit constraint:
   ```yaml
   dependencies:
     myproject_core: ^0.1.0 # Must point to an already-published version on pub.dev
   ```
3. **Choose a Globally Unique Name**: Ensure the package name is available on [pub.dev](https://pub.dev).
4. **Add Pana Metadata**:
   ```yaml
   description: Fast command-line interface for task management using the Eisenhower matrix.
   repository: https://github.com/<your-username>/<your-repo>
   issue_tracker: https://github.com/<your-username>/<your-repo>/issues
   topics:
     - cli
     - productivity
     - developer-tools
   ```
5. **Provide Documentation & License**:
   - Add a `LICENSE` file in this directory (`packages/cli/LICENSE`).
   - Add a `CHANGELOG.md` in this directory (`packages/cli/CHANGELOG.md`).
   - Ensure this `README.md` documents CLI installation and usage flags.
6. **Dry-Run Validation**:
   ```bash
   dart pub publish --dry-run
   ```
7. **End-User Usage Once Published**:
   ```bash
   dart pub global activate <package_name>
   <executable_name> --help
   ```
