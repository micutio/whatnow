import 'package:test/test.dart';
import 'package:whatnow_core/whatnow_core.dart';

void main() {
  group('CoreTaskRepository', () {
    group('REQ-TA-2: Adding, removing, and toggling tasks', () {
      test('Given an empty repository, '
          'When a validated task is added and then removed, '
          'Then the task count reflects each change', () {
        final taskRepo = CoreTaskRepository();
        expect(taskRepo.allTaskCount(), equals(0));

        final item = Task(title: 'Finish docs', importance: 100).validate();
        final updated = taskRepo.addTask(item);
        expect(updated.allTaskCount(), equals(1));

        final removed = updated.removeTask(item.id);
        expect(removed.allTaskCount(), equals(0));
      });

      test('Given an open task with importance, '
          'When toggled closed and reopened, '
          'Then open/closed counts update and importance is preserved', () {
        final taskRepo = CoreTaskRepository();
        final task = Task(title: 'Task 1', importance: 75).validate();
        final filledRepo = taskRepo.addTask(task);
        expect(filledRepo.openTaskCount(), equals(1));
        expect(filledRepo.closedTaskCount(), equals(0));

        final closed = filledRepo.closeTask(task.id);
        expect(closed.openTaskCount(), equals(0));
        expect(closed.closedTaskCount(), equals(1));
        expect(closed.closedTasks().first.isClosed, isTrue);
        expect(closed.closedTasks().first.importance, equals(75));

        final reopened = closed.reopenTask(task.id);
        expect(reopened.openTaskCount(), equals(1));
        expect(reopened.closedTaskCount(), equals(0));
      });
    });

    group('REQ-DB-3: Prioritised open task listing (all and by topic)', () {
      final priority = CorePriority();
      final lowTask = Task(
        topicId: 'work',
        title: 'Low priority task',
        importance: 20,
      ).validate();
      final highTask = Task(
        topicId: 'work',
        title: 'High priority task',
        importance: 90,
      ).validate();
      final homeTask = Task(
        topicId: 'home',
        title: 'Medium home task',
        importance: 50,
      ).validate();

      test('Given open and closed tasks across topics, '
          'When prioritizedItems is queried, '
          'Then only open tasks are returned in descending priority order', () {
        final repo = CoreTaskRepository()
            .addTask(lowTask)
            .addTask(highTask)
            .addTask(homeTask)
            .closeTask(homeTask.id);

        final openPrioritized = repo.prioritizedItems(priority);
        expect(
          openPrioritized.map((v) => v.id).toList(),
          equals([highTask.id, lowTask.id]),
        );
      });

      test(
        'Given open and closed tasks across topics, '
        'When prioritizedItemsByTopic is queried for a specific topic, '
        'Then only open tasks for that topic are returned in descending order',
        () {
          final extraWorkTask = Task(
            topicId: 'work',
            title: 'Closed work task',
            importance: 100,
          ).validate();

          final repo = CoreTaskRepository()
              .addTask(lowTask)
              .addTask(highTask)
              .addTask(homeTask)
              .addTask(extraWorkTask)
              .closeTask(extraWorkTask.id);

          final workPrioritized = repo.prioritizedItemsByTopic(
            'work',
            priority,
          );
          expect(
            workPrioritized.map((v) => v.id).toList(),
            equals([highTask.id, lowTask.id]),
          );
          expect(
            repo.closedTasksForTopic('work').map((v) => v.id).toList(),
            equals([extraWorkTask.id]),
          );
        },
      );
    });
  });

  group('CoreTopicRepository', () {
    test('Given an empty topic repository, '
        'When topics are added and removed, '
        'Then getTopic reflects the repository state', () {
      final topic = Topic(title: 'Work Projects');
      final repo = CoreTopicRepository();
      expect(repo.getTopic(topic.id), isNull);

      final withTopic = repo.addTopic(topic);
      expect(withTopic.getTopic(topic.id), equals(topic));

      final withoutTopic = withTopic.removeTopic(topic);
      expect(withoutTopic.getTopic(topic.id), isNull);
    });
  });
}
