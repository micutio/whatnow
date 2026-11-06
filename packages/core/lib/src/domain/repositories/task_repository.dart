import 'dart:collection';

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
  UnmodifiableListView<ValidatedTask> prioritizedItems(PriorityMetric priority);

  /// Returns open tasks of a topic in a prioritised order,
  /// determined by the given priority calculation.
  UnmodifiableListView<ValidatedTask> prioritizedItemsForTopic(
    String topicTag,
    PriorityMetric priority,
  );

  /// Returns all closed tasks.
  UnmodifiableListView<ValidatedTask> get closedTasks;

  /// Returns closed tasks for a topic.
  UnmodifiableListView<ValidatedTask> closedTasksForTopic(String topicTag);

  /// Returns the count of open and closed tasks in this repository.
  int get allTaskCount;

  /// Returns the count of open only tasks in this repository.
  int get openTaskCount;

  /// Returns the count of closed only tasks in this repository.
  int get closedTaskCount;
}
