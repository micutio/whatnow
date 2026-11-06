import 'dart:collection';

import '../domain/entities/task.dart';
import '../domain/interfaces/priority.dart';
import '../domain/repositories/task_repository.dart';

/// Topics are groupings of tasks, such as projects and ideas.
class CoreTaskRepository implements TaskRepository {
  CoreTaskRepository({List<ValidatedTask>? items})
    : _items = UnmodifiableListView(items ?? const []);

  final UnmodifiableListView<ValidatedTask> _items;

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
  UnmodifiableListView<ValidatedTask> prioritizedItems(
    PriorityMetric priority,
  ) => _prioritize(_items.where((t) => !t.isClosed), priority);

  @override
  UnmodifiableListView<ValidatedTask> prioritizedItemsForTopic(
    String topicTag,
    PriorityMetric priority,
  ) => _prioritize(
    _items.where((t) => !t.isClosed && t.topicId == topicTag),
    priority,
  );

  UnmodifiableListView<ValidatedTask> _prioritize(
    Iterable<ValidatedTask> tasks,
    PriorityMetric priority,
  ) {
    final now = DateTime.now().toUtc();
    final items = tasks.toList()
      ..sort(
        (a, b) => priority
            .getPriority(b, at: now)
            .compareTo(priority.getPriority(a, at: now)),
      );
    return UnmodifiableListView(items);
  }

  @override
  UnmodifiableListView<ValidatedTask> get closedTasks {
    final items = _items.where((v) => v.isClosed).toList(growable: false);
    return UnmodifiableListView(items);
  }

  @override
  UnmodifiableListView<ValidatedTask> closedTasksForTopic(String topicTag) {
    final items = _items
        .where((v) => v.topicId == topicTag && v.isClosed)
        .toList(growable: false);
    return UnmodifiableListView(items);
  }

  @override
  int get allTaskCount => _items.length;

  @override
  int get openTaskCount {
    var count = 0;
    for (final validated in _items) {
      if (!validated.isClosed) count++;
    }
    return count;
  }

  @override
  int get closedTaskCount {
    var count = 0;
    for (final validated in _items) {
      if (validated.isClosed) count++;
    }
    return count;
  }
}
