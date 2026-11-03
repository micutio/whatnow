import 'package:test/test.dart';
import 'package:whatnow_core/whatnow_core.dart';

void main() {
  // Dashboard lifecycle tests

  final dashboard = Dashboard();

  group('RQ-DB-1: A new task must belong to a topic, or unnamed', () {
    test('An empty dashboard contains only the unnamed topic', () {
      final allTopics = dashboard.getAllTopics();
      expect(allTopics.length, equals(1));
    });

    test('The unnamed topic should be available through its ID.', () {
      final Topic? unnamedTopic = dashboard.tryGetTopicById(Topic.unnamed);
      expect(unnamedTopic, isNotNull);

      final Topic? invalidTopic = dashboard.tryGetTopicById('invalid Id');
      expect(invalidTopic, isNull);
    });

    test('A new topic should be able to be found after creating it.', () {
      dashboard.createNewTopic(name: 'newTopic', description: 'none');
      final allTopics = dashboard.getAllTopics();
      expect(allTopics.length, equals(2));

      final Topic? newTopic = dashboard.tryGetTopicByName('newTopic');
      expect(newTopic, isNotNull);

      final Topic? invalidTopic = dashboard.tryGetTopicByName('invalidTopic');
      expect(invalidTopic, isNull);
    });

    test('A new valid task can be created from/for the unnamed topic.', () {
      dashboard.createTask(title: 'New Task', importance: 50);
      final unnamedTopicTasks = dashboard.tryGetTasksForTopic(Topic.unnamed);
      expect(unnamedTopicTasks.length, equals(1));
    });

    test('A new task cannot be created from an invalid topic', () {
      expect(
        dashboard.createTask(
          title: 'New Task',
          importance: 50,
          topicTitle: 'invalidTitle',
        ),
        throwsArgumentError,
      );
    });
  });
}
