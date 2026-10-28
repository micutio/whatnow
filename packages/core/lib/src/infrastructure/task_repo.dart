import '../domain/entities/task.dart';
import '../domain/interfaces/priority.dart';
import '../domain/repositories/task_repository.dart';

/// Topics are groupings of tasks, such as projects and ideas.
class CoreTaskRepository implements TaskRepository {
  CoreTaskRepository({List<ValidatedTask>? items})
    : _items = List<ValidatedTask>.unmodifiable(items ?? const []);

  final List<ValidatedTask> _items;

  @override
  TaskRepository addTask(ValidatedTask task) {
    return CoreTaskRepository(items: [..._items, task]);
  }

  @override
  TaskRepository removeTask(String taskId) {
    return CoreTaskRepository(
      items: _items.where((item) => item.id != taskId).toList(),
    );
  }

  @override
  TaskRepository closeTask(String taskId) {
    return CoreTaskRepository(
      items: _items.map((item) {
        if (item.id == taskId) {
          return item.copyWith(isClosed: true).validate();
        }
        return item;
      }).toList(),
    );
  }

  @override
  TaskRepository reopenTask(String taskId) {
    return CoreTaskRepository(
      items: _items.map((item) {
        if (item.id == taskId) {
          return item.copyWith(isClosed: false).validate();
        }
        return item;
      }).toList(),
    );
  }

  @override
  List<ValidatedTask> prioritizedItems(Priority priority) =>
      _prioritize(_items.where((t) => !t.isClosed), priority);

  @override
  List<ValidatedTask> prioritizedItemsByTopic(
    String topicTag,
    Priority priority,
  ) => _prioritize(
    _items.where((t) => !t.isClosed && t.topicId == topicTag),
    priority,
  );

  List<ValidatedTask> _prioritize(
    Iterable<ValidatedTask> tasks,
    Priority priority,
  ) {
    final items = tasks.toList()
      ..sort(
        (a, b) => priority.getPriority(b).compareTo(priority.getPriority(a)),
      );
    return List.unmodifiable(items);
  }

  @override
  List<ValidatedTask> closedTasks() {
    final items = _items.where((v) => v.isClosed).toList();
    return List.unmodifiable(items);
  }

  @override
  List<ValidatedTask> closedTasksForTopic(String topicTag) {
    final items = _items
        .where((v) => v.topicId == topicTag && v.isClosed)
        .toList();
    return List.unmodifiable(items);
  }

  @override
  int allTaskCount() => _items.length;

  @override
  int openTaskCount() {
    var count = 0;
    for (final validated in _items) {
      if (!validated.isClosed) count++;
    }
    return count;
  }

  @override
  int closedTaskCount() {
    var count = 0;
    for (final validated in _items) {
      if (validated.isClosed) count++;
    }
    return count;
  }
}
