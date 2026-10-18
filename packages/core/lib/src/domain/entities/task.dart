/// Basic unit of work to do.
/// The core functionality of this application is to properly prioritise it.
/// Priority will be determined by a combination of
/// - importance score
/// - due date
/// - elapsed time between creation and due date
class Task {
  Task({
    required this.id,
    this.topicId,
    required this.title,
    this.description,
    this.dueDate,
    required this.importance,
    DateTime? creationDate,
    this.isClosed = false,
  }) : creationDate = creationDate ?? DateTime.now();

  final String id;
  final String? topicId;
  final String title;
  final String? description;
  final DateTime creationDate;
  final DateTime? dueDate;

  /// Scored between 0 and 100.
  final int importance;
  final bool isClosed;

  Task copyWith({
    String? id,
    String? topicId,
    String? title,
    String? description,
    DateTime? creationDate,
    DateTime? dueDate,
    int? importance = 0,
    bool? isClosed,
  }) {
    return Task(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      description: description ?? this.description,
      creationDate: creationDate ?? this.creationDate,
      dueDate: dueDate ?? this.dueDate,
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
          creationDate == other.creationDate &&
          dueDate == other.dueDate &&
          importance == other.importance &&
          isClosed == other.isClosed;

  @override
  int get hashCode => Object.hash(
    id,
    topicId,
    title,
    description,
    creationDate,
    dueDate,
    importance,
    isClosed,
  );
}
