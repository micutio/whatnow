import 'package:test/test.dart';
import 'package:whatnow_core/whatnow_core.dart';

void main() {
  group('Task', () {
    final futureDate = DateTime.parse('2086-12-22');
    const overlongTitle =
        'This Title Is Too Long As It Exceeds 100 Characters. ---------------------------------------------------';

    final createdTime = DateTime.utc(2026, 10, 27, 10);
    final updatedTime = DateTime.utc(2026, 10, 27, 11);

    final validTask = Task(
      id: 't1',
      topicId: Topic.defaultId,
      title: 't1 title',
      description: '-',
      dueAt: futureDate,
      importance: 42,
      now: createdTime,
    );

    final invalidTask = Task(
      id: 't2',
      topicId: Topic.defaultId,
      title: overlongTitle,
      description: '-',
      dueAt: futureDate,
      importance: 0,
      now: createdTime,
    );

    group('REQ-TA-2 & REQ-DB-1: Task creation and copying', () {
      test(
        'Given a newly created task, '
        'Then it is open and createdAt equals updatedAt in UTC',
        () {
          expect(validTask.isClosed, isFalse);
          expect(validTask.createdAt.isUtc, isTrue);
          expect(validTask.createdAt, equals(createdTime));
          expect(validTask.updatedAt, equals(createdTime));
        },
      );

      test(
        'Given a task with no topicId, Then it defaults to the unnamed topic',
        () {
          final taskWithoutTopic = Task(
            id: 't-default-topic',
            title: 'No topic',
            importance: 10,
          );
          expect(taskWithoutTopic.topicId, equals(Topic.unnamed.id));
        },
      );

      test(
        'Given a task with non-zero importance, '
        'When copyWith is called without importance at a later time, '
        'Then original fields are preserved and updatedAt is updated',
        () {
          final copy = validTask.copyWith(
            title: 'Updated title',
            now: updatedTime,
          );
          expect(copy.title, equals('Updated title'));
          expect(copy.importance, equals(42));
          expect(copy.id, equals(validTask.id));
          expect(copy.topicId, equals(validTask.topicId));
          expect(copy.description, equals(validTask.description));
          expect(copy.createdAt, equals(createdTime));
          expect(copy.updatedAt, equals(updatedTime));
          expect(copy.dueAt, equals(validTask.dueAt));
          expect(copy.isClosed, equals(validTask.isClosed));
        },
      );
    });

    group('REQ-TA-3: Task validation (title 1-100 chars, importance 0-100)', () {
      test(
        'Given a valid task, '
        'When validate is called, '
        'Then ValidatedTask exposes Task members and preserves value equality',
        () {
          final validated = validTask.validate();
          expect(validated, equals(validTask));
          expect(validated.id, equals('t1'));
          expect(validated.importance, equals(42));
        },
      );

      test(
        'Given a task with an empty or whitespace-only title, '
        'When validate is called, Then it throws ArgumentError',
        () {
          final emptyTitleTask = validTask.copyWith(title: '');
          final whitespaceTitleTask = validTask.copyWith(title: '   ');

          expect(emptyTitleTask.validate, throwsArgumentError);
          expect(whitespaceTitleTask.validate, throwsArgumentError);
        },
      );

      test(
        'Given a task with an overlong title (>100 chars), '
        'When validate is called, Then it throws ArgumentError',
        () {
          expect(invalidTask.validate, throwsArgumentError);
        },
      );

      test(
        'Given a task with importance outside [0, 100], '
        'When validate is called, Then it throws ArgumentError',
        () {
          final negativeImportance = validTask.copyWith(importance: -1);
          final excessiveImportance = validTask.copyWith(importance: 101);

          expect(negativeImportance.validate, throwsArgumentError);
          expect(excessiveImportance.validate, throwsArgumentError);
        },
      );
    });
  });
}
