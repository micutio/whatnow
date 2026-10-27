import 'topic.dart';

/// Basic unit of work to do.
/// The core functionality of this application is to properly prioritise it.
/// Priority will be determined by a combination of
/// - importance score
/// - due date
/// - elapsed time between creation and due date
class Task {
  /// Standard constructor allows to set everything,
  /// except [createdAt] and [updatedAt] (which default to current UTC time
  /// unless [now] is provided for deterministic testing).
  /// If [topicId] is not given, it will be assigned to the generic topic.
  Task({
    required String id,
    String? topicId,
    required String title,
    String? description,
    DateTime? dueAt,
    required int importance,
    DateTime? now,
  }) : this._init(
         id: id,
         topicId: topicId ?? Topic.unnamed.id,
         title: title,
         description: description,
         dueAt: dueAt,
         importance: importance,
         timestamp: (now ?? DateTime.now()).toUtc(),
       );

  Task._init({
    required this.id,
    required this.topicId,
    required this.title,
    required this.description,
    required this.dueAt,
    required this.importance,
    required DateTime timestamp,
  }) : createdAt = timestamp,
       updatedAt = timestamp,
       isClosed = false;

  /// Private cloning constructor allows to set everything,
  /// except [updatedAt] (which defaults to current UTC time unless [now] is provided).
  Task._clone({
    required this.id,
    required this.topicId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.dueAt,
    required this.importance,
    required this.isClosed,
    DateTime? now,
  }) : updatedAt = (now ?? DateTime.now()).toUtc();

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
    if (title.trim().isEmpty || title.length > titleLength) {
      throw ArgumentError('Title must be between 1 and 100 characters');
    }

    if (importance < 0 || importance > 100) {
      throw ArgumentError('Importance must be within [0, 100]');
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
    int? importance,
    bool? isClosed,
    DateTime? now,
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
      now: now,
    );
  }

  /// Value equality compares all task domain state (excluding [updatedAt]
  /// metadata so copies with identical state remain equal).
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

/// Zero-cost wrapper proving that a [Task] has passed [Task.validate].
/// Implements [Task] so all task fields and value equality are directly
/// accessible without runtime wrapper allocation.
extension type const ValidatedTask._fromTask(Task task) implements Task {}
