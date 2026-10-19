import 'package:test/test.dart';
import 'package:whatnow_core/whatnow_core.dart';

void main() {
  group('Task', () {
    final task = Task(
      id: "t1",
      topicId: Topic.defaultId,
      title: "t1 title",
      description: "-",
      dueAt: DateTime.parse("2086-22-12"),
      importance: 0,
    );
    test('a new task should always be open', () {
      expect(task.isClosed, false);
    });
    test('copying a task should set a new time for `updatedAt`', () {
      final taskCopy = task.copyWith();
      expect(
        task.updatedAt,
        isNot(equals(taskCopy.updatedAt)),
        reason: 'copying a task must reset `updatedAt` field.',
      );
    });
  });
}
