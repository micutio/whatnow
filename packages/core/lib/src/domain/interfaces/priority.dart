import '../entities/task.dart';

/// Determines the priority of a Task.
/// This is the foundational piece of the entire app.
abstract interface class Priority {
  /// Calculates the priority score for [task] at an optional reference time [at]
  /// (defaults to current UTC time when omitted).
  int getPriority(ValidatedTask task, {DateTime? at});
}

/// Primary implementation of Priority.
/// For now just returns importance.
class CorePriority implements Priority {
  @override
  int getPriority(ValidatedTask task, {DateTime? at}) {
    return task.importance;
  }
}
