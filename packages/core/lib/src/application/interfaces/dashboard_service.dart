import '../../../whatnow_core.dart';

/// Dashboard Service is the boundary between user input and verified objects.
abstract interface class DashboardService {
  /// Creates a new topic with optional description and color.
  void createNewTopic({
    required String title,
    String? description,
    TopicColor? color,
  });

  /// Always contains _at least_ one element: the unnamed topic.
  List<Topic> getAllTopics();

  /// Returns the topic matching [id] or null if it does not exist.
  Topic? tryGetTopicById(String id);

  /// Returns the topic matching [title] or null if it does not exist.
  Topic? tryGetTopicByTitle(String title);

  /// Creates a task with optional description and due date.
  ///
  /// Throws an [ArgumentError] if the task cannot be created or validation fails.
  void createTask({
    required String topicId,
    required String title,
    String? description,
    required int importance,
    DateTime? dueAt,
  });

  /// Returns open and closed tasks for all topics.
  List<ValidatedTask> getAll();

  /// Returns only open tasks, sorted descending by priority.
  List<ValidatedTask> getPrioritized();

  /// Returns all closed Tasks;
  List<ValidatedTask> getClosed();

  /// Returns open and closed tasks for a topic.
  ///
  /// List is empty if the topic does not exist. // TODO: Or should it be null?
  List<ValidatedTask> getForTopic(String id);

  /// Returns only open tasks, sorted descending by priority.
  /// List is empty if the topic does not exist. // TODO: Or should it be null?
  List<ValidatedTask> getPrioritizedForTopic(String id);

  /// Returns closed tasks for a topic.
  /// List is empty if the topic does not exist.
  List<ValidatedTask> getClosedForTopic(String id);
}
