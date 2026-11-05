import '../entities/task.dart';

/// Determines the priority of a Task.
/// This is the foundational piece of the entire app.
abstract interface class PriorityMetric {
  /// Calculates the priority score for [task] at an optional reference time [at]
  /// (defaults to current UTC time when omitted).
  int getPriority(ValidatedTask task, {DateTime? at});
}
