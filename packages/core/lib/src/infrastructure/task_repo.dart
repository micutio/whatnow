import '../domain/entities/task.dart';
import '../domain/interfaces/priority.dart';
import '../domain/repositories/task_repository.dart';

/// Topics are groupings of tasks, such as projects and ideas.
class CoreTaskRepository implements TaskRepository {
  CoreTaskRepository({List<Task>? items})
    : _items = List<Task>.unmodifiable(items ?? const []);

  final List<Task> _items;

  @override
  TaskRepository addTask(Task task) {
    return CoreTaskRepository(items: [..._items, task]);
  }

  @override
  TaskRepository removeTask(String taskId) {
    return CoreTaskRepository(
      items: _items.where((item) => item.id != taskId).toList(),
    );
  }

  @override
  TaskRepository toggleTask(String taskId) {
    return CoreTaskRepository(
      items: _items.map((item) {
        if (item.id == taskId) {
          return item.copyWith(isClosed: !item.isClosed);
        }
        return item;
      }).toList(),
    );
  }

  @override
  List<Task> prioritizedItems(Priority priority) =>
      _prioritize(_items, priority);

  @override
  List<Task> prioritizedItemsByTopic(String topicTag, Priority priority) =>
      _prioritize(_items.where((t) => t.topicId == topicTag), priority);

  List<Task> _prioritize(Iterable<Task> tasks, Priority priority) {
    final items = tasks.toList()
      ..sort(
        (a, b) => priority.getPriority(a).compareTo(priority.getPriority(b)),
      );
    return List.unmodifiable(items);
  }

  @override
  List<Task> closedTasks() {
    final items = _items.where((t) => t.isClosed).toList();
    return List.unmodifiable(items);
  }

  @override
  List<Task> closedTasksForTopic(String topicTag) {
    final items = _items
        .where((t) => t.topicId == topicTag && t.isClosed)
        .toList();
    return List.unmodifiable(items);
  }

  @override
  int allTaskCount() => _items.length;

  @override
  int openTaskCount() {
    var count = 0;
    for (final task in _items) {
      if (!task.isClosed) count++;
    }
    return count;
  }

  @override
  int closedTaskCount() {
    var count = 0;
    for (final task in _items) {
      if (task.isClosed) count++;
    }
    return count;
  }
}
