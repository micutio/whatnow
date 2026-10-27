import 'package:test/test.dart';
import 'package:whatnow_core/whatnow_core.dart';

void main() {
  // TODO: Add tests for TopicRepository.

  group('TaskRepository', () {
    test('adds and removes items', () {
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
    });

    test('toggles item completion', () {
      final taskRepo = CoreTaskRepository();
      final task = Task(id: 't1', title: 'Task 1', importance: 0).validate();
      final filledRepo = taskRepo.addTask(task);
      expect(filledRepo.openTaskCount(), equals(1));
      expect(filledRepo.closedTaskCount(), equals(0));

      final toggled = filledRepo.toggleTask('t1');
      expect(toggled.openTaskCount(), equals(0));
      expect(toggled.closedTaskCount(), equals(1));
      expect(toggled.closedTasks().first.task.isClosed, isTrue);

      final untoggled = toggled.toggleTask('t1');
      expect(untoggled.openTaskCount(), equals(1));
      expect(untoggled.closedTaskCount(), equals(0));
    });
  });
}
