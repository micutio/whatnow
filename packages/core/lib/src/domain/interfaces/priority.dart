import '../entities/task.dart';

/// Determines the priority of a Task.
/// This is the foundational piece of the entire app.
abstract interface class Priority {
  int getPriority(ValidatedTask task);
}

/// Primary implementation of Priority.
/// For now just returns importance.
class CorePriority implements Priority {
  @override
  int getPriority(ValidatedTask task) {
    return task.task.importance;
  }
}
