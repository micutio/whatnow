import '../entities/task.dart';
import '../interfaces/priority.dart';

/// Holds all tasks of the application.
abstract interface class TaskRepository {
  TaskRepository addTask(Task t);
  TaskRepository removeTask(String taskId);

  /// Toggles a given task between open and closed.
  TaskRepository toggleTask(String taskId);

  /// Returns open tasks in a prioritised order,
  /// determined by the given priority calculation.
  List<Task> prioritizedItems(Priority priority);

  /// Returns open tasks of a topic in a prioritised order,
  /// determined by the given priority calculation.
  List<Task> prioritizedItemsByTopic(String topicTag, Priority priority);

  /// Returns all closed tasks.
  List<Task> closedTasks();

  /// Returns closed tasks for a topic.
  List<Task> closedTasksForTopic(String topicTag);

  /// Returns the count of open and closed tasks in this repository.
  int allTaskCount();

  /// Returns the count of open only tasks in this repository.
  int openTaskCount();

  /// Returns the count of closed only tasks in this repository.
  int closedTaskCount();
}
