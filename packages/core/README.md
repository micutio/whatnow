# whatnow_core

The shared core domain library for the whatnow monorepo. 

## Objective

- Allow users to define tasks including a subjective importance score and optional due date
- Tasks can be grouped into topics
- Core functionality is to present a prioritised list of tasks to decide what to work on next
- Priority will be inferred by a combination of:
  - urgency (via due date or lack thereof)
  - importance
  - waiting time (via task creation time)
- Exact priority metric is TBD, will necessitate experimentation

 ## Ideas Box (To be expanded)

- There is potential for composability here, TODO-Items could be lists themselves, but probably not
- Decied on terminology to use: urgent/important vs effort/impact 
- Examples of typical task routing (app might give recommendations what to do per task) 
  - Urgent & Important: client presentation due tomorrow — do or co-own.
  - Not Urgent & Important: strategic planning, learning goals — schedule focused blocks.
  - Urgent & Not Important: calendar invites or routine approvals — delegate or batch-process.
  - Not Urgent & Not Important: newsletters, trivial errands — defer, automate, or delete.
- look at the remaining 6 habits whether they're worth incorporating.
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
