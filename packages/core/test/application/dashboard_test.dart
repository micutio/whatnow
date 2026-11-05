import 'package:test/test.dart';
import 'package:whatnow_core/whatnow_core.dart';

void main() {
  // Dashboard lifecycle tests

  final PriorityMetric priorityMetric = ImportanceOnly();
  final dashboard = Dashboard(
    priority: priorityMetric,
    topicRepo: CoreTopicRepository(),
    taskRepo: CoreTaskRepository(),
  );

  group('RQ-DB-1: A new task must belong to a topic, or unnamed', () {
    test('An empty dashboard contains only the unnamed topic', () {
      final allTopics = dashboard.getAllTopics();
      expect(allTopics.length, equals(1));
    });

    test('The unnamed topic should be available through its ID.', () {
      final unnamedTopic = dashboard.tryGetTopicById(Topic.defaultId);
      expect(unnamedTopic, isNotNull);

      final invalidTopic = dashboard.tryGetTopicById('invalid Id');
      expect(invalidTopic, isNull);
    });

    test('A new topic should be able to be found after creating it.', () {
      dashboard.createNewTopic(title: 'newTopic', description: 'none');
      final allTopics = dashboard.getAllTopics();
      expect(allTopics.length, equals(2));

      final newTopic = dashboard.tryGetTopicByTitle('newTopic');
      expect(newTopic, isNotNull);

      final invalidTopic = dashboard.tryGetTopicByTitle('invalidTopic');
      expect(invalidTopic, isNull);
    });

    test('A new valid task can be created from/for the unnamed topic.', () {
      dashboard.createTask(
        topicId: Topic.defaultId,
        title: 'New Task',
        importance: 50,
      );
      final unnamedTopicTasks = dashboard.getForTopic(Topic.defaultId);
      expect(unnamedTopicTasks.length, equals(1));
    });

    test('A new task cannot be created from an invalid topic', () {
      expect(
        () => dashboard.createTask(
          topicId: 'invalid title',
          title: 'New Task',
          importance: 50,
        ),
        throwsArgumentError,
      );
    });
  });
}
