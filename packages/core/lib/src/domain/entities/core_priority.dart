import '../interfaces/priority.dart';
import 'task.dart';

/// Primary implementation of Priority.
/// For now just returns importance.
class ImportanceOnly implements PriorityMetric {
  @override
  int getPriority(ValidatedTask task, {DateTime? at}) {
    return task.importance;
  }
}
