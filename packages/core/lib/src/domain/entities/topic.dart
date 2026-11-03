import 'package:uuid/uuid.dart';

import 'topic_color.dart';

const _uuid = Uuid();

/// Topics are groupings of tasks, such as projects and ideas.
class Topic {
  /// Default constructor, generates UUID
  Topic({required this.title, this.description, this.color = TopicColor.white})
    : id = _uuid.v5(Namespace.dns.value, title);

  /// Private constructor for cloning/updating
  Topic._clone({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
  });

  final String id;
  final String title;
  final String? description;
  final TopicColor color;

  Topic copyWith({String? title, String? description, TopicColor? color}) {
    return Topic._clone(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Topic &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          color == other.color;

  @override
  int get hashCode => Object.hash(id, title, description, color);

  static final String defaultId = _uuid.v5(Namespace.dns.value, "");
  static final Topic unnamed = Topic(title: "");
}
