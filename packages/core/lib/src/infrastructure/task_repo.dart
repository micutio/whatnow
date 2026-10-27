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
      items: _items.where((item) => item.task.id != taskId).toList(),
    );
  }

  @override
  TaskRepository toggleTask(String taskId) {
    return CoreTaskRepository(
      items: _items.map((item) {
        if (item.task.id == taskId) {
          return item.task.copyWith(isClosed: !item.task.isClosed).validate();
        }
        return item;
      }).toList(),
    );
  }

  @override
  List<ValidatedTask> prioritizedItems(Priority priority) =>
      _prioritize(_items.where((t) => !t.task.isClosed), priority);

  @override
  List<ValidatedTask> prioritizedItemsByTopic(
    String topicTag,
    Priority priority,
  ) => _prioritize(
    _items.where((t) => !t.task.isClosed && t.task.topicId == topicTag),
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
    final items = _items.where((v) => v.task.isClosed).toList();
    return List.unmodifiable(items);
  }

  @override
  List<ValidatedTask> closedTasksForTopic(String topicTag) {
    final items = _items
        .where((v) => v.task.topicId == topicTag && v.task.isClosed)
        .toList();
    return List.unmodifiable(items);
  }

  @override
  int allTaskCount() => _items.length;

  @override
  int openTaskCount() {
    var count = 0;
    for (final validated in _items) {
      if (!validated.task.isClosed) count++;
    }
    return count;
  }

  @override
  int closedTaskCount() {
    var count = 0;
    for (final validated in _items) {
      if (validated.task.isClosed) count++;
    }
    return count;
  }
}
