import 'package:whatnow_core/whatnow_core.dart';

/// Basic unit of work to do.
/// The core functionality of this application is to properly prioritise it.
/// Priority will be determined by a combination of
/// - importance score
/// - due date
/// - elapsed time between creation and due date
class Task {
  /// Standard constructor allows to set everything,
  /// except [createdAt] and [updatedAt].
  /// If [topicId] is not given, it will be assigned to the generic topic.
  Task({
    required this.id,
    String? topicId,
    required this.title,
    this.description,
    this.dueAt,
    required this.importance,
  }) : topicId = topicId ?? Topic.unnamed.id,
       createdAt = DateTime.now(),
       updatedAt = DateTime.now(),
       isClosed = false;

  /// Private cloning constructor allows to set everything,
  /// except [updatedAt].
  Task._clone({
    required this.id,
    required this.topicId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.dueAt,
    required this.importance,
    required this.isClosed,
  }) : updatedAt = DateTime.now();

  static const int titleLength = 100;

  final String id;
  final String topicId;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Null indicates undefined deadline.
  final DateTime? dueAt;

  /// Scored between 0 and 100.
  final int importance;
  final bool isClosed;

  ValidatedTask validate() {
    if (title.length > titleLength) {
      throw ArgumentError('Title cannot be longer than 100 characters');
    }

    if (importance < 0 || importance > 100) {
      throw ArgumentError('Importance must be within [1, 100]');
    }

    return ValidatedTask._fromTask(this);
  }

  Task copyWith({
    String? id,
    String? topicId,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueAt,
    int? importance = 0,
    bool? isClosed,
  }) {
    return Task._clone(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueAt: dueAt ?? this.dueAt,
      importance: importance ?? this.importance,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          topicId == other.topicId &&
          title == other.title &&
          description == other.description &&
          createdAt == other.createdAt &&
          dueAt == other.dueAt &&
          importance == other.importance &&
          isClosed == other.isClosed;

  @override
  int get hashCode => Object.hash(
    id,
    topicId,
    title,
    description,
    createdAt,
    dueAt,
    importance,
    isClosed,
  );
}

class ValidatedTask {
  ValidatedTask._fromTask(this.task);

  final Task task;
}
