import 'package:test/test.dart';
import 'package:whatnow_core/whatnow_core.dart';

void main() {
  group('CoreTaskRepository', () {
    group('REQ-TA-2: Adding, removing, and toggling tasks', () {
      test(
        'Given an empty repository, '
        'When a validated task is added and then removed, '
        'Then the task count reflects each change',
        () {
          final taskRepo = CoreTaskRepository();
          expect(taskRepo.allTaskCount(), equals(0));

          final item = Task(
            id: 't1',
            title: 'Finish docs',
            importance: 100,
          ).validate();
          final updated = taskRepo.addTask(item);
          expect(updated.allTaskCount(), equals(1));

          final removed = updated.removeTask('t1');
          expect(removed.allTaskCount(), equals(0));
        },
      );

      test(
        'Given an open task with importance, '
        'When toggled closed and reopened, '
        'Then open/closed counts update and importance is preserved',
        () {
          final taskRepo = CoreTaskRepository();
          final task = Task(
            id: 't1',
            title: 'Task 1',
            importance: 75,
          ).validate();
          final filledRepo = taskRepo.addTask(task);
          expect(filledRepo.openTaskCount(), equals(1));
          expect(filledRepo.closedTaskCount(), equals(0));

          final toggled = filledRepo.toggleTask('t1');
          expect(toggled.openTaskCount(), equals(0));
          expect(toggled.closedTaskCount(), equals(1));
          expect(toggled.closedTasks().first.isClosed, isTrue);
          expect(toggled.closedTasks().first.importance, equals(75));

          final untoggled = toggled.toggleTask('t1');
          expect(untoggled.openTaskCount(), equals(1));
          expect(untoggled.closedTaskCount(), equals(0));
        },
      );
    });

    group('REQ-DB-3: Prioritised open task listing (all and by topic)', () {
      final priority = CorePriority();
      final lowTask = Task(
        id: 't-low',
        topicId: 'work',
        title: 'Low priority task',
        importance: 20,
      ).validate();
      final highTask = Task(
        id: 't-high',
        topicId: 'work',
        title: 'High priority task',
        importance: 90,
      ).validate();
      final homeTask = Task(
        id: 't-home',
        topicId: 'home',
        title: 'Medium home task',
        importance: 50,
      ).validate();

      test(
        'Given open and closed tasks across topics, '
        'When prioritizedItems is queried, '
        'Then only open tasks are returned in descending priority order',
        () {
          final repo = CoreTaskRepository()
              .addTask(lowTask)
              .addTask(highTask)
              .addTask(homeTask)
              .toggleTask('t-home'); // close 't-home'

          final openPrioritized = repo.prioritizedItems(priority);
          expect(
            openPrioritized.map((v) => v.id).toList(),
            equals(['t-high', 't-low']),
          );
        },
      );

      test(
        'Given open and closed tasks across topics, '
        'When prioritizedItemsByTopic is queried for a specific topic, '
        'Then only open tasks for that topic are returned in descending order',
        () {
          final extraWorkTask = Task(
            id: 't-closed-work',
            topicId: 'work',
            title: 'Closed work task',
            importance: 100,
          ).validate();

          final repo = CoreTaskRepository()
              .addTask(lowTask)
              .addTask(highTask)
              .addTask(homeTask)
              .addTask(extraWorkTask)
              .toggleTask('t-closed-work');

          final workPrioritized = repo.prioritizedItemsByTopic(
            'work',
            priority,
          );
          expect(
            workPrioritized.map((v) => v.id).toList(),
            equals(['t-high', 't-low']),
          );
          expect(
            repo.closedTasksForTopic('work').map((v) => v.id).toList(),
            equals(['t-closed-work']),
          );
        },
      );
    });
  });

  group('CoreTopicRepository', () {
    test(
      'Given an empty topic repository, '
      'When topics are added and removed, '
      'Then getTopic reflects the repository state',
      () {
        const topic = Topic(id: 'work', name: 'Work Projects');
        final repo = CoreTopicRepository();
        expect(repo.getTopic('work'), isNull);

        final withTopic = repo.addTopic(topic);
        expect(withTopic.getTopic('work'), equals(topic));

        final withoutTopic = withTopic.removeTopic(topic);
        expect(withoutTopic.getTopic('work'), isNull);
      },
    );
  });
}
