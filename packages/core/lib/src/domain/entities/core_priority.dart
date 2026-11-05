import '../../../whatnow_core.dart';

/// Primary implementation of Priority.
/// For now just returns importance.
class ImportanceOnly implements PriorityMetric {
  @override
  int getPriority(ValidatedTask task, {DateTime? at}) {
    return task.importance;
  }
}
