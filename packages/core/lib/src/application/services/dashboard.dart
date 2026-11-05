import '../../domain/entities/task.dart';
import '../../domain/entities/topic.dart';
import '../../domain/entities/topic_color.dart';
import '../../domain/interfaces/priority.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/repositories/topic_repository.dart';
import '../interfaces/dashboard_service.dart';

class Dashboard implements DashboardService {
  Dashboard({
    required this.taskRepo,
    required this.topicRepo,
    required this.priority,
  });

  TaskRepository taskRepo;
  TopicRepository topicRepo;
  PriorityMetric priority;

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
    topicRepo = topicRepo.addTopic(topic);
  }

  @override
  List<Topic> get allTopics => topicRepo.allTopics().toList();

  @override
  Topic? tryGetTopicById(String id) {
    return topicRepo.getTopic(id);
  }

  @override
  Topic? tryGetTopicByTitle(String title) {
    final candidates = topicRepo.allTopics().where((t) => t.title == title);
    if (candidates.isEmpty) {
      return null;
    }
    return candidates.first;
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
    taskRepo = taskRepo.addTask(validatedTask);
  }

  @override
  List<ValidatedTask> get allTasks => [
    ...taskRepo.prioritizedItems(priority),
    ...taskRepo.closedTasks(),
  ];

  @override
  List<ValidatedTask> get prioritizedTasks =>
      taskRepo.prioritizedItems(priority);

  @override
  List<ValidatedTask> get closedTasks => taskRepo.closedTasks();

  @override
  List<ValidatedTask> getForTopic(String id) {
    return [
      ...taskRepo.prioritizedItemsForTopic(id, priority),
      ...taskRepo.closedTasksForTopic(id),
    ];
  }

  @override
  List<ValidatedTask> getPrioritizedForTopic(String id) {
    return taskRepo.prioritizedItemsForTopic(id, priority);
  }

  @override
  List<ValidatedTask> getClosedForTopic(String id) {
    return taskRepo.closedTasksForTopic(id);
  }
}
