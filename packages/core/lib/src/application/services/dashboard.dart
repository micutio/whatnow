import 'dart:collection';

import '../../domain/entities/task.dart';
import '../../domain/entities/topic.dart';
import '../../domain/entities/topic_color.dart';
import '../../domain/interfaces/priority.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/repositories/topic_repository.dart';
import '../interfaces/dashboard_service.dart';

class Dashboard implements DashboardService {
  Dashboard({
    required this._taskRepo,
    required this._topicRepo,
    required this._priority,
  });

  TaskRepository _taskRepo;
  TopicRepository _topicRepo;
  final PriorityMetric _priority;

  @override
  void createNewTopic({
    required String title,
    String? description,
    TopicColor? color,
  }) {
    final topic = Topic(
      title: title,
      description: description,
      color: color ?? TopicColor.white,
    );
    _topicRepo = _topicRepo.addTopic(topic);
  }

  @override
  UnmodifiableListView<Topic> get allTopics => _topicRepo.allTopics;

  @override
  Topic? tryGetTopicById(String id) {
    return _topicRepo.getTopic(id);
  }

  @override
  Topic? tryGetTopicByTitle(String title) {
    for (final topic in _topicRepo.allTopics) {
      if (topic.title == title) return topic;
    }
    return null;
  }

  @override
  void createTask({
    required String topicId,
    required String title,
    String? description,
    required int importance,
    DateTime? dueAt,
  }) {
    if (tryGetTopicById(topicId) == null) {
      throw ArgumentError('topic with id $topicId does not exist');
    }

    final task = Task(
      topicId: topicId,
      title: title,
      importance: importance,
      description: description,
      dueAt: dueAt,
    );
    final validatedTask = task.validate();
    _taskRepo = _taskRepo.addTask(validatedTask);
  }

  @override
  UnmodifiableListView<ValidatedTask> get allTasks => UnmodifiableListView([
    ..._taskRepo.prioritizedItems(_priority),
    ..._taskRepo.closedTasks,
  ]);

  @override
  UnmodifiableListView<ValidatedTask> get prioritizedTasks =>
      _taskRepo.prioritizedItems(_priority);

  @override
  UnmodifiableListView<ValidatedTask> get closedTasks => _taskRepo.closedTasks;

  @override
  UnmodifiableListView<ValidatedTask> getForTopic(String id) {
    return UnmodifiableListView([
      ..._taskRepo.prioritizedItemsForTopic(id, _priority),
      ..._taskRepo.closedTasksForTopic(id),
    ]);
  }

  @override
  UnmodifiableListView<ValidatedTask> getPrioritizedForTopic(String id) {
    return _taskRepo.prioritizedItemsForTopic(id, _priority);
  }

  @override
  UnmodifiableListView<ValidatedTask> getClosedForTopic(String id) {
    return _taskRepo.closedTasksForTopic(id);
  }
}
