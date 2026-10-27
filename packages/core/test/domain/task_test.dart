import 'package:test/test.dart';
import 'package:whatnow_core/whatnow_core.dart';

void main() {
  group('Task', () {
    final futureDate = DateTime.parse("2086-22-12");
    const overlongTitle =
        'This Title Is Too Long As It Exceeds 100 Characters. ---------------------------------------------------';

    final validTask = Task(
      id: 't1',
      topicId: Topic.defaultId,
      title: 't1 title',
      description: '-',
      dueAt: futureDate,
      importance: 0,
    );

    final invalidTask = Task(
      id: 't2',
      topicId: Topic.defaultId,
      title: overlongTitle,
      description: '-',
      dueAt: futureDate,
      importance: 0,
    );

    test('a new task should always be open', () {
      expect(validTask.isClosed, false);
    });

    test('copying a task should set a new time for `updatedAt`', () {
      final taskCopy = validTask.copyWith();
      expect(
        validTask.updatedAt,
        isNot(equals(taskCopy.updatedAt)),
        reason: 'copying a task must reset `updatedAt` field.',
      );
    });

    test('a task with overlong title (>100) must not validate', () {
      expect(() => invalidTask.validate(), throwsArgumentError);
    });

    final anotherInvalidTask = invalidTask.copyWith(
      title: 'valid title',
      importance: -100,
    );

    test('a task with negative importance (-100) must not validate', () {
      expect(() => anotherInvalidTask.validate(), throwsArgumentError);
    });
  });
}
