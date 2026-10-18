import '../entities/task.dart';

/// Determines the priority of a Task.
/// This is the foundational piece of the entire app.
abstract interface class Priority {
  int getPriority(Task task);
}

/// Primary implementation of Priority.
/// For now just returns importance.
class CorePriority implements Priority {
  @override
  int getPriority(Task task) {
    return task.importance;
  }
}
