# whatnow_core

The shared core domain library for the whatnow monorepo. It contains pure Dart business logic, entities, and priority queue ordering rules with zero dependencies on Flutter or platform-specific I/O.

---

## Publishing to pub.dev (Optional)

If publishing `whatnow_core` to pub.dev as an independent open-source library:

1. **Remove `publish_to: none`** from `pubspec.yaml`.
2. **Choose a Globally Unique Name**: Ensure `name:` is available on [pub.dev](https://pub.dev).
3. **Add Pana Metadata**:
   ```yaml
   description: Core domain logic and task management models for the whatnow monorepo.
   repository: https://github.com/<your-username>/<your-repo>
   issue_tracker: https://github.com/<your-username>/<your-repo>/issues
   topics:
     - productivity
     - task-management
     - eisenhower-matrix
   ```
4. **Provide Documentation & License**:
   - Ensure this `README.md` clearly documents public APIs.
   - Add a `LICENSE` file in this directory (`packages/core/LICENSE`).
   - Add a `CHANGELOG.md` in this directory (`packages/core/CHANGELOG.md`).
5. **Dry-Run Validation**:
   ```bash
   dart pub publish --dry-run
   ```
6. **Publishing Order**: Publish `core` *before* `cli`, since `cli` depends on `core` at publish time.
