import '../entities/task.dart';
import '../interfaces/priority.dart';

/// Holds all tasks of the application.
abstract interface class TaskRepository {
  TaskRepository addTask(ValidatedTask t);
  TaskRepository removeTask(String taskId);

  /// Closes a given open task.
  TaskRepository closeTask(String taskId);

  /// Re-opens a given task.
  TaskRepository reopenTask(String taskId);

  /// Returns open tasks in a prioritised order,
  /// determined by the given priority calculation.
  List<ValidatedTask> prioritizedItems(Priority priority);

  /// Returns open tasks of a topic in a prioritised order,
  /// determined by the given priority calculation.
  List<ValidatedTask> prioritizedItemsByTopic(
    String topicTag,
    Priority priority,
  );

  /// Returns all closed tasks.
  List<ValidatedTask> closedTasks();

  /// Returns closed tasks for a topic.
  List<ValidatedTask> closedTasksForTopic(String topicTag);

  /// Returns the count of open and closed tasks in this repository.
  int allTaskCount();

  /// Returns the count of open only tasks in this repository.
  int openTaskCount();

  /// Returns the count of closed only tasks in this repository.
  int closedTaskCount();
}
