import 'topic_color.dart';

/// Topics are groupings of tasks, such as projects and ideas.
class Topic {
  Topic({
    required this.id,
    required this.name,
    this.description,
    this.color = TopicColor.white,
  });

  final String id;
  final String name;
  final String? description;
  final TopicColor color;
}
