import 'topic_color.dart';

/// Topics are groupings of tasks, such as projects and ideas.
class Topic {
  const Topic({
    required this.id,
    required this.name,
    this.description,
    this.color = TopicColor.white,
  });

  final String id;
  final String name;
  final String? description;
  final TopicColor color;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Topic &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          color == other.color;

  @override
  int get hashCode => Object.hash(id, name, description, color);

  static const String defaultId = "none";
  static const Topic unnamed = Topic(id: defaultId, name: "");
}
